//
//  RegistrationViewController.m
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 4/14/13.
//
//

#import "RegistrationViewController.h"
#import "iPhoneXMPPAppDelegate.h"
#import "Utilities.h"
#import "MBProgressHUD.h"

@interface RegistrationViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation RegistrationViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validateEmail:(NSString *)email
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)displayErrorMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        sleep(1);
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            self.infoLabel.text = message;
            self.emailTextField.text = @"";
            self.passwordTextField.text = @"";
            self.confirmPasswordTextField.text = @"";
        });
    });
    
}

- (void)registerFailWithReason:(NSString *)reason{
    dispatch_async(dispatch_get_main_queue(), ^{
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     [self displayErrorMessage:reason];
     });
     [Utilities setUserDefaultString:nil forKey:kXMPPmyJID];
     [Utilities setUserDefaultString:nil forKey:kXMPPmyPassword];
}

- (IBAction)signup:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (![self validateEmail:self.emailTextField.text]) {
        [self displayErrorMessage:@"Please enter valid email."];
    }
    
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [self displayErrorMessage:@"Two passwords don't match."];
    }
    
    if([self validateEmail:self.emailTextField.text] && [self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [Utilities setUserDefaultString:self.emailTextField.text forKey:kEmail];
        [Utilities setUserDefaultString:self.passwordTextField.text forKey:kXMPPmyPassword];
        
        NSURL *aUrl = [NSURL URLWithString:@"http://text-support.org:1234/members"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                               cachePolicy:NSURLCacheStorageNotAllowed
                                                           timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        NSString *postString = [NSString stringWithFormat:@"member[email]=%@&member[password]=%@", self.emailTextField.text, self.passwordTextField.text];
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if (data) {
                 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
                 NSString *err = [dic valueForKey:@"error"];
                 NSLog(@"dic = %@", dic);
                 if (err) {
                     NSLog(@"Log in fail!");
                     [self registerFailWithReason:@"Something went wrong, try again later."];
                 } else {
                     
                     NSLog(@"%@", dic);
                     if ([dic valueForKey:@"id"] == [NSNull null]) {
                         NSLog(@"Register error");
                         [self registerFailWithReason:@"The email has been taken."];
                     } else {
                         NSLog(@"Register success");
                         NSString *realJID = [NSString stringWithFormat:@"%@@%@",[dic valueForKeyPath:@"id"], kHostname];
                         [Utilities setUserDefaultString:realJID forKey:kXMPPmyJID];
                         NSLog(@"Log in using myJID:%@", realJID);
                         [Utilities setUserDefaultBOOL:NO forKey:kIsListener];
                         [[self appDelegate] connect];
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                             [self displayErrorMessage:@""];
                             [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 4] animated:YES];
                         });
                     }
                 }
             }
             
         }];
    }
}

- (void)viewDidUnload {
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
    [self setConfirmPasswordTextField:nil];
    [self setInfoLabel:nil];
    [super viewDidUnload];
}
@end
