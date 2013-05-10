//
//  SettingsViewController.m
//  iPhoneXMPP
//
//  Created by Eric Chamberlain on 3/18/11.
//  Copyright 2011 RF.com. All rights reserved.
//

#import "SettingsViewController.h"
#import "iPhoneXMPPAppDelegate.h"
#import "Utilities.h"
#import "MBProgressHUD.h"

NSString *const kXMPPmyJID = @"kXMPPmyJID";
NSString *const kEmail = @"kEmail";
NSString *const kXMPPmyPassword = @"kXMPPmyPassword";
NSString *const kHostname = @"text-support.org";
NSString *const kIsListener = @"kIsListener";
NSString *const kUID = @"kUID";

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

- (void)displayErrorMessage:(NSString *)message
{
    self.infoLabel.text = message;
    self.passwordField.text = @"";
    /*
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        sleep(1);
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            self.infoLabel.text = message;
            self.passwordField.text = @"";
        });
    });*/
    
}

- (IBAction)login
{
    [self.view endEditing:YES];
    [Utilities setUserDefaultString:jidField.text forKey:kEmail];
    [Utilities setUserDefaultString:passwordField.text forKey:kXMPPmyPassword];
    
    NSURL *aUrl = [NSURL URLWithString:@"http://text-support.org:1234/members/sign_in"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"member[email]=%@&member[password]=%@", jidField.text, passwordField.text];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (data) {
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
             NSString *err = [dic valueForKey:@"error"];
             if (err) {
                 NSLog(@"Log in fail!");
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     [self displayErrorMessage:@"Email or password is wrong."];
                 });
                 [Utilities setUserDefaultString:nil forKey:kXMPPmyJID];
                 [Utilities setUserDefaultString:nil forKey:kXMPPmyPassword];
             } else {
                 NSLog(@"Log in success");
                 self.isListener = [[dic valueForKeyPath:@"is_listener"] boolValue];
                 NSLog(@"%@", dic);
                 NSString *realJID = [NSString stringWithFormat:@"%@@%@",[dic valueForKeyPath:@"id"], kHostname];
                 [Utilities setUserDefaultString:realJID forKey:kXMPPmyJID];
                 NSLog(@"Log in using myJID:%@", realJID);
                 [Utilities setUserDefaultBOOL:self.isListener forKey:kIsListener];
                 [[self appDelegate] connect];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     [self displayErrorMessage:@""];
                     [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
                });
            }
         }

     }];
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

- (void)viewDidUnload {
    [self setInfoLabel:nil];
    [super viewDidUnload];
}
@end
