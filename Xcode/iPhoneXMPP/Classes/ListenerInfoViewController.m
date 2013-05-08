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
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface ListenerInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (strong, nonatomic) NSString *listenerJID;
@property (strong, nonatomic) MBProgressHUD *HUD;
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
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://text-support.org:1234/chatusers/chat_random_user?user=%@", userid]] cachePolicy: NSURLCacheStorageNotAllowed timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];

    //AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:self.HUD];
	self.HUD.labelText = @"Loading";
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"listenerJid: %@", [JSON valueForKeyPath:@"listenerJid"]);
        self.nameLabel.text = [JSON valueForKeyPath:@"nickname"];
        self.genderLabel.text = [JSON valueForKeyPath:@"gender"];
        self.descTextView.text = [JSON valueForKeyPath:@"desc"];
        
        NSLog(@"set listener");
        self.listenerJID = [JSON valueForKeyPath:@"listenerJid"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Fail to get listener, maybe server error!");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        NSLog(@"set listener's jidstr = %@", self.listenerJID);
        [segue.destinationViewController performSelector:@selector(setUserName:) withObject:self.listenerJID];
        [segue.destinationViewController performSelector:@selector(setNickName:) withObject:self.nameLabel.text];
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}
- (void)viewDidUnload {
    [self setNameLabel:nil];
    [self setGenderLabel:nil];
    [self setDescTextView:nil];
    [super viewDidUnload];
}
@end
