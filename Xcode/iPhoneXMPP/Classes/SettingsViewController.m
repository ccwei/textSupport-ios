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

NSString *const kXMPPmyJID = @"kXMPPmyJID";
NSString *const kEmail = @"kEmail";
NSString *const kXMPPmyPassword = @"kXMPPmyPassword";
NSString *const hostname = @"textsupport.no-ip.org";


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
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setUserDefaultString:(NSString *)string forKey:(NSString *)key
{
  if (string != nil)
  {
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:key];
  } else {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
  }
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearUserDefaultFieldForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Actions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)done:(id)sender
{
  NSString *realJID = [NSString stringWithFormat:@"%@@%@", [jidField.text stringByReplacingOccurrencesOfString:@"@" withString:@"_"], hostname];
  [self setUserDefaultString:realJID forKey:kXMPPmyJID];
  [self setUserDefaultString:jidField.text forKey:kEmail];
  [self setUserDefaultString:passwordField.text forKey:kXMPPmyPassword];
    
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
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure");
    }];
    
    [operation start];
    
    /*
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"response:%@, result: %@", response, JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"response:%d, result: %@", [response statusCode], [error description]);
    }];
    
    [operation start];*/

  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)logOut:(id)sender
{
    [self.delegate removeUserData];
    [self clearUserDefaultFieldForKey:kXMPPmyJID];
    [self clearUserDefaultFieldForKey:kXMPPmyPassword];
    [[self appDelegate] disconnect];

    [self dismissModalViewControllerAnimated:YES];
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
