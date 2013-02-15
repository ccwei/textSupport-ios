//
//  ChatViewController.m
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 2/14/13.
//
//

#import "ChatViewController.h"
#import "iPhoneXMPPAppDelegate.h"

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
        [self.messages addObject:@{@"msg": msgStr, @"sender": @"you"}];
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark Message delegates


- (void)newMessageReceived:(NSDictionary *)messageContent {
	
	NSString *m = [messageContent objectForKey:@"msg"];
	
	//[messageContent setObject:m forKey:@"msg"];
	//[messageContent setObject:[NSString getCurrentTime] forKey:@"time"];
	[self.messages addObject:@{@"msg": m}];
	[self.tableView reloadData];
    
	NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:self.messages.count-1
												   inSection:0];
	
	[self.tableView scrollToRowAtIndexPath:topIndexPath
					  atScrollPosition:UITableViewScrollPositionMiddle
							  animated:YES];
}


#pragma mark -
#pragma mark Table view delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = (NSDictionary *)self.messages[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCellIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = dic[@"msg"];
    cell.detailTextLabel.text = dic[@"sender"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = NO;
    return cell;
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
