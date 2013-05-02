//
//  MoodRatingViewController.m
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 3/2/13.
//
//

#import "MoodRatingViewController.h"
#import "SaturationView.h"
#import "WEPopoverController.h"
#import "UIPlaceHolderTextView.h"
#import "SettingsViewController.h"

@interface MoodRatingViewController ()<PopoverControllerDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *faceviewCollection;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;
@property (strong, nonatomic) WEPopoverController *moodPopover;
@property (strong, nonatomic) UIPlaceHolderTextView *textView;
@property (strong, nonatomic) UIButton *saveButton;
@property (nonatomic) float saturation;
@property (weak, nonatomic) IBOutlet UIImageView *cloudImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sunImageView;
@property (strong, nonatomic) SaturationView *heartView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rainyImageView;
@end

@implementation MoodRatingViewController

- (SaturationView *)heartView
{
    if (!_heartView) {
        _heartView = [[SaturationView alloc] initWithFrame:CGRectZero];
        _heartView.image = [UIImage imageNamed:@"heart.png"];
        _heartView.frame = CGRectMake(0, 0, _heartView.image.size.width, _heartView.image.size.height);
        _heartView.center = CGPointMake(160, 180); // put it mid-screen
        _heartView.saturation = 0.5; // desaturate by 20%,
    }
    return _heartView;
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    }
    return _saveButton;
}

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

- (void)addPopOverAt:(CGRect)rect
{
    if(!self.moodPopover) {
        UIViewController *viewCon = [[UIViewController alloc] init];
        
        [viewCon.view addSubview:self.textView];
        [viewCon.view addSubview:self.saveButton];
        [viewCon.view bringSubviewToFront:self.saveButton];
        viewCon.contentSizeForViewInPopover = self.textView.frame.size;
        
        self.moodPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        
        
        [self.moodPopover setDelegate:self];
    }
    
    if([self.moodPopover isPopoverVisible]) {
        [self.moodPopover dismissPopoverAnimated:NO];
    }
    
    [self.moodPopover presentPopoverFromRect:rect
                  inView:self.view
                  permittedArrowDirections:UIPopoverArrowDirectionDown
                                  animated:YES];

}

- (void)hidePopover
{
    if([self.moodPopover isPopoverVisible]) {
        [self.moodPopover dismissPopoverAnimated:NO];
    }
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
    self.heartView.saturation = sender.value;
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
    [self setFaceviewCollection:nil];
    [self setHeartImageView:nil];
    [self setRainyImageView:nil];
    [self setCloudImageView:nil];
    [self setSunImageView:nil];
    [self setSaveBtn:nil];
    [super viewDidUnload];
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
    
    NSLog(@"Did dismiss");
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Should dismiss");
    return NO;
}


//Move UITextView up when keyboard is presented

- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#define kOFFSET_FOR_KEYBOARD 80.0

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


-(void)keyboardWillShow {
    // Animate the current view out of the way
    NSLog(@"%f",  self.moodPopover.view.frame.origin.y);
    if (self.view.frame.origin.y >= 0 && self.moodPopover.view.frame.origin.y > 100)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0  && self.moodPopover.view.frame.origin.y > 100)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

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
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsListener]) {
            [self performSegueWithIdentifier:@"Show ChatHistory" sender:self];
        } else {
            [self performSegueWithIdentifier:@"Show Listener" sender:self];
        }
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
