//
//  SettingsViewController.m
//  iPhoneXMPP
//
//  Created by Eric Chamberlain on 3/18/11.
//  Copyright 2011 RF.com. All rights reserved.
//

#import "SettingsViewController.h"
#import "iPhoneXMPPAppDelegate.h"
#import "AFNetworking.h"
#import "Utilities.h"

NSString *const kXMPPmyJID = @"kXMPPmyJID";
NSString *const kEmail = @"kEmail";
NSString *const kXMPPmyPassword = @"kXMPPmyPassword";
NSString *const kHostname = @"textsupport.no-ip.org";


@implementation SettingsViewController

- (iPhoneXMPPAppDelegate *)appDelegate
{
	return (iPhoneXMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Init/dealloc methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)awakeFromNib {
  self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark View lifecycle
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  jidField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kEmail];
  passwordField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Actions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)login
{
  NSString *realJID = [NSString stringWithFormat:@"%@@%@", [jidField.text stringByReplacingOccurrencesOfString:@"@" withString:@"_"], kHostname];
  [Utilities setUserDefaultString:realJID forKey:kXMPPmyJID];
  [Utilities setUserDefaultString:jidField.text forKey:kEmail];
  [Utilities setUserDefaultString:passwordField.text forKey:kXMPPmyPassword];
    
    NSURL *aUrl = [NSURL URLWithString:@"http://textsupport.no-ip.org:1234/members"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLCacheStorageNotAllowed
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"member[email]=%@&member[password]=%@", jidField.text, passwordField.text];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success");
        [[self appDelegate] connect];
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure");
    }];
    
    [operation start];

  //[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)hideKeyboard:(id)sender {
  [sender resignFirstResponder];
  [self done:sender];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Getter/setter methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@synthesize jidField;
@synthesize passwordField;

@end
