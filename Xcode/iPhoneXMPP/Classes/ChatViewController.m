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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) NSMutableArray* messages;
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
    [self.messageTextField becomeFirstResponder];
	// Do any additional setup after loading the view.
}
- (IBAction)sendMessage:(id)sender {
    NSString *msgStr = self.messageTextField.text;
    if ([msgStr length] > 0) {
        
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:msgStr];
		
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:self.userName];
        [message addChild:body];
		
        [self.xmppStream sendElement:message];
        
        self.messageTextField.text = @"";
        [self.messages addObject:@{@"msg": msgStr, @"sender": @"you", @"time": [NSString getCurrentTime]}];
        [self.messageTextField resignFirstResponder];
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark Message delegates


- (void)newMessageReceived:(NSDictionary *)messageContent {
	
	NSString *m = [messageContent objectForKey:@"msg"];
	
	//[messageContent setObject:m forKey:@"msg"];
	//[messageContent setObject:[NSString getCurrentTime] forKey:@"time"];
	[self.messages addObject:@{@"msg": m, @"time": [NSString getCurrentTime]}];
	[self.tableView reloadData];
    
	NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:self.messages.count-1
												   inSection:0];
	
	[self.tableView scrollToRowAtIndexPath:topIndexPath
					  atScrollPosition:UITableViewScrollPositionMiddle
							  animated:YES];
}


#pragma mark -
#pragma mark Table view delegates

#define MESSAGE_BALLON_PADDING 20.0

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *msg = (NSDictionary *)self.messages[indexPath.row];
    MessageViewTableCell *cell = (MessageViewTableCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCellIdentifier" forIndexPath:indexPath];
    NSString *sender = [msg objectForKey:@"sender"];
    NSString *message = [msg objectForKey:@"msg"];
    NSString *time = [msg objectForKey:@"time"];
    CGSize  textSize = { 260.0, 10000.0 };
    CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:13]
                      constrainedToSize:textSize
                          lineBreakMode:UILineBreakModeWordWrap];
    cell.messageContentView.text = message;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = NO;

    UIImage *bgImage = nil;
    if ([sender isEqualToString:@"you"]) { // left aligned
        bgImage = [[UIImage imageNamed:@"ballon1.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
        [cell.messageContentView setFrame:CGRectMake(0, MESSAGE_BALLON_PADDING*2, 100, size.height)];
        [cell.bgImageView setFrame:CGRectMake( 0,
                                              cell.messageContentView.frame.origin.y - MESSAGE_BALLON_PADDING/2,
                                              size.width + MESSAGE_BALLON_PADDING,
                                              size.height + MESSAGE_BALLON_PADDING)];
        NSLog(@"frame = %g, %g", cell.bgImageView.frame.size.width, cell.bgImageView.frame.size.height);
    } else {
        bgImage = [[UIImage imageNamed:@"ballon2.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
        [cell.messageContentView setFrame:CGRectMake(0,
                                                     MESSAGE_BALLON_PADDING*2,
                                                     100.0,
                                                     size.height)];
        [cell.bgImageView setFrame:CGRectMake(0,
                                              cell.messageContentView.frame.origin.y - MESSAGE_BALLON_PADDING/2,
                                              size.width+MESSAGE_BALLON_PADDING,
                                              size.height+MESSAGE_BALLON_PADDING)];
    }
    cell.bgImageView.image = bgImage;
    cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", sender, time];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = (NSDictionary *)[self.messages objectAtIndex:indexPath.row];
    NSString *msg = [dict objectForKey:@"msg"];
    CGSize  textSize = { 260.0, 10000.0 };
    CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13]
                  constrainedToSize:textSize
                      lineBreakMode:UILineBreakModeWordWrap];
    size.height += MESSAGE_BALLON_PADDING*2;
    CGFloat height = size.height < 65 ? 65 : size.height;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
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
