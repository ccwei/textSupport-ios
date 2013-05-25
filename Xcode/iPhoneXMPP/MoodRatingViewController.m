//
//  MoodRatingViewController.m
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 3/2/13.
//
//

#import "MoodRatingViewController.h"
#import "UIPlaceHolderTextView.h"
#import "SettingsViewController.h"



@interface MoodRatingViewController ()<UITextViewDelegate>
@property (strong, nonatomic) UIPlaceHolderTextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *cloudImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sunImageView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rainyImageView;
@end

@implementation MoodRatingViewController

- (UIPlaceHolderTextView *)textView
{
    if (!_textView) {
        _textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
        _textView.placeholder = @"What's on your mind?";
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.delegate = self;
    }
    return _textView;
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
    
    UIImage *bgImage = [UIImage imageNamed:@"navigation_bar.png"];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                UITextAttributeTextColor: [UIColor greenColor],
                          UITextAttributeTextShadowColor: [UIColor redColor],
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
                                     UITextAttributeFont: [UIFont fontWithName:@"Gill Sans" size:20.0f]
     }];
    
    /*Before iOS5
     UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)];
     label.backgroundColor = [UIColor clearColor];
     label.font = [UIFont boldSystemFontOfSize:20.0];
     label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
     label.textAlignment = UITextAlignmentCenter;
     label.textColor =[UIColor whiteColor];
     label.text=self.title;
     self.navigationItem.titleView = label;
     [label release];
     */
    //[self.view addSubview:self.heartView];
    
}


- (IBAction)valueChanged:(UISlider *)sender {
    self.rainyImageView.alpha = sender.value * -2 + 1;
    self.sunImageView.alpha = sender.value * 2 - 1;
    self.saveBtn.alpha = 1;
}
     
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setRainyImageView:nil];
    [self setCloudImageView:nil];
    [self setSunImageView:nil];
    [self setSaveBtn:nil];
    [super viewDidUnload];
}

//Move UITextView up when keyboard is presented

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
    if (!myJID) {
        [self performSegueWithIdentifier:@"Show Login" sender:self];
    } else {
        NSLog(@"isListener = %d", [[NSUserDefaults standardUserDefaults] boolForKey:kIsListener]);
        [self performSegueWithIdentifier:@"Show ChatHistory" sender:self];
    }
}

- (IBAction)unwindFromLogin:(UIStoryboardSegue *)unwindSegue
{
    //[self performSegueWithIdentifier:@"Show Listener" sender:self];
}

- (IBAction)unwindFromRegistration:(UIStoryboardSegue *)unwindSegue
{
    //[self performSegueWithIdentifier:@"Show Listener" sender:self];
}
@end
