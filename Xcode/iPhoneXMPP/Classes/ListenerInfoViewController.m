//
//  ListenerInfoViewController.m
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 4/3/13.
//
//

#import "ListenerInfoViewController.h"
#import "iPhoneXMPPAppDelegate.h"
#import "AFNetworking.h"

@interface ListenerInfoViewController ()
@property (strong, nonatomic) XMPPUserCoreDataStorageObject *listener;
@end

@implementation ListenerInfoViewController

- (iPhoneXMPPAppDelegate *)appDelegate
{
	return (iPhoneXMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)getRandomUser
{
    NSString *userJid = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
    NSString *userid = [userJid substringToIndex:[userJid rangeOfString:@"@"].location];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://textsupport.no-ip.org:1234/chatusers/chat_random_user?user=%@", userid]] cachePolicy: NSURLCacheStorageNotAllowed timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];

    //AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    

    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"listenerJid: %@", [JSON valueForKeyPath:@"listenerJid"]);
        
        
    self.listener = [[[self appDelegate] xmppRosterStorage] userForJID:[XMPPJID jidWithString:[JSON valueForKeyPath:@"listenerJid"]] xmppStream:[[self appDelegate] xmppStream] managedObjectContext:[[self appDelegate] managedObjectContext_roster]];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"IP Address: %@", [JSON valueForKeyPath:@"origin"]);
    }];

    /*
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success");
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure");
    }];*/
    
    [operation start];
     
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getRandomUser];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Messages"]) {
        NSLog(@"set listener's jidstr = %@", [self.listener jidStr]);
        [segue.destinationViewController performSelector:@selector(setUserName:) withObject:[self.listener jidStr]];
        //[segue.destinationViewController performSelector:@selector(setDelegate:) withObject:self];
    }
}
@end
