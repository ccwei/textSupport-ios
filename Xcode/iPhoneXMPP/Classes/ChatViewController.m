//
//  ChatViewController.m
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 2/14/13.
//
//

#import "ChatViewController.h"
#import "iPhoneXMPPAppDelegate.h"
#import "NSString+Utils.h"
#import "MessageViewTableCell.h"

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate, MessageDelegate>

@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) NSMutableArray* messages;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (iPhoneXMPPAppDelegate *)appDelegate {
	return (iPhoneXMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (XMPPStream *)xmppStream {
	return [[self appDelegate] xmppStream];
}

- (XMPPMessageArchivingCoreDataStorage *)xmppMessageArchivingCoreDataStorage
{
    return [[self appDelegate] xmppMessageArchivingCoreDataStorage];
}

- (NSMutableArray *)messages
{
    if (!_messages) {
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self appDelegate].messageDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupFetchResultController];
    [self.tableView reloadData];
    [self scrollToBottom];
    //[self.messageTextField becomeFirstResponder];
	// Do any additional setup after loading the view.
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupFetchResultController
{
    XMPPMessageArchivingCoreDataStorage *macds = [[self appDelegate] xmppMessageArchivingCoreDataStorage];
    NSManagedObjectContext *moc = [[self appDelegate] managedObjectContext_messageArchiving];
    NSEntityDescription *entity = [macds messageEntity:moc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr=%@", self.userName];
    NSLog(@"Username = %@", self.userName);
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchBatchSize:10];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:moc
                                                                          sectionNameKeyPath:nil
                                                                               cacheName:nil];

    for (XMPPMessageArchiving_Message_CoreDataObject *message in [self.fetchedResultsController fetchedObjects]) {
        message.seen = YES;
    }
    NSLog(@"%@", [self.fetchedResultsController fetchedObjects]);
    NSError *error = nil;
    if (error) {
        NSLog(@"error: %@", error);
    }
}


- (IBAction)sendMessage:(id)sender {
    NSString *msgStr = self.messageTextField.text;
    if ([msgStr length] > 0) {
        
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:msgStr];
		
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        NSLog(@"self.userName = %@", self.userName);
        //[message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@textsupport.no-ip.org", self.userName]];
        [message addAttributeWithName:@"to" stringValue: self.userName];
        [message addChild:body];
		
        [self.xmppStream sendElement:message];
        
        self.messageTextField.text = @"";
        [self.messages addObject:@{@"msg": [msgStr substituteEmoticons], @"sender": @"you", @"time": [NSString getCurrentTime]}];
        [self.messageTextField resignFirstResponder];
    }
}



#pragma mark -
#pragma mark Message delegates


- (void)newMessageReceived:(NSDictionary *)messageContent {
	
	NSString *m = [messageContent objectForKey:@"msg"];
	m = [m substituteEmoticons];
	//[messageContent setObject:m forKey:@"msg"];
	//[messageContent setObject:[NSString getCurrentTime] forKey:@"time"];
	[self.messages addObject:@{@"msg": m, @"sender": @"", @"time": [NSString getCurrentTime]}];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view delegates

static CGFloat padding = 20.0;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary *msg = (NSDictionary *)self.messages[indexPath.row];
    MessageViewTableCell *cell = (MessageViewTableCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCellIdentifier" forIndexPath:indexPath];
    
    XMPPMessageArchiving_Message_CoreDataObject *msg = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *sender = [msg.message.from bare];
    NSString *message = msg.body;
    NSString *time = [msg.timestamp description];
    CGSize  textSize = { 260.0, 10000.0 };
    CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:13]
                      constrainedToSize:textSize
                          lineBreakMode:UILineBreakModeWordWrap];
    cell.messageContentView.text = message;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = NO;
    UIImage *bgImage = nil;
    if (!sender) { // left aligned
        bgImage = [[UIImage imageNamed:@"ballon1.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
        [cell.messageContentView setFrame:CGRectMake(padding, padding, size.width + padding, size.height)];
        [cell.bgImageView setFrame:CGRectMake(padding/2,
                                              cell.messageContentView.frame.origin.y - padding/2,
                                              size.width + padding*2,
                                              size.height + padding)];
    } else {
        bgImage = [[UIImage imageNamed:@"ballon2.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
        [cell.messageContentView setFrame:CGRectMake(self.view.bounds.size.width - size.width - padding*3,
                                                     padding*2,
                                                     size.width + padding,
                                                     size.height)];
        [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2,
                                              cell.messageContentView.frame.origin.y - padding/2,
                                              size.width + padding*2,
                                              size.height+padding)];
    }
    cell.bgImageView.image = bgImage;
    cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", sender, time];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPMessageArchiving_Message_CoreDataObject *mesage = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *msg = mesage.body;
    CGSize  textSize = { 260.0, 10000.0 };
    CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13]
                  constrainedToSize:textSize
                      lineBreakMode:UILineBreakModeWordWrap];
    size.height += padding*2;
    CGFloat height = size.height < 65 ? 65 : size.height;
    return height;
}

- (void)viewWillDisappear:(BOOL)animated
{
    for (XMPPMessageArchiving_Message_CoreDataObject *message in [self.fetchedResultsController fetchedObjects]) {
        message.seen = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setMessageTextField:nil];
    [super viewDidUnload];
}
@end
