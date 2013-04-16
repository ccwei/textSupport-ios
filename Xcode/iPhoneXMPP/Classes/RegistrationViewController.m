//
//  RegistrationViewController.m
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 4/14/13.
//
//

#import "RegistrationViewController.h"
#import "AFNetworking.h"
#import "iPhoneXMPPAppDelegate.h"
#import "Utilities.h"

@interface RegistrationViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

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

- (IBAction)signup:(UIButton *)sender {
    if([self validateEmail:self.emailTextField.text] && [self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        NSString *realJID = [NSString stringWithFormat:@"%@@%@", [self.emailTextField.text stringByReplacingOccurrencesOfString:@"@" withString:@"_"], kHostname];
        [Utilities setUserDefaultString:realJID forKey:kXMPPmyJID];
        [Utilities setUserDefaultString:self.emailTextField.text forKey:kEmail];
        [Utilities setUserDefaultString:self.passwordTextField.text forKey:kXMPPmyPassword];
        
        NSURL *aUrl = [NSURL URLWithString:@"http://textsupport.no-ip.org:1234/members"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                               cachePolicy:NSURLCacheStorageNotAllowed
                                                           timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        NSString *postString = [NSString stringWithFormat:@"member[email]=%@&member[password]=%@", self.emailTextField.text, self.passwordTextField.text];
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success");
            [[self appDelegate] connect];
            [self performSegueWithIdentifier:@"AfterSignUp" sender:self];
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failure");
        }];
        
        [operation start];

    }
}

- (void)viewDidUnload {
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
    [self setConfirmPasswordTextField:nil];
    [super viewDidUnload];
}
@end