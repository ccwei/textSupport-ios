//
//  MoodRatingViewController.m
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 3/2/13.
//
//

#import "MoodRatingViewController.h"
#import "FaceView.h"
#import "WEPopoverController.h"
#import "UIPlaceHolderTextView.h"

@interface MoodRatingViewController ()<PopoverControllerDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *faceviewCollection;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;
@property (strong, nonatomic) WEPopoverController *moodPopover;
@property (strong, nonatomic) UIPlaceHolderTextView *textView;
@property (strong, nonatomic) UIButton *saveButton;
@end

@implementation MoodRatingViewController

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
    
    for (UIImageView *face in self.faceviewCollection) {
        face.alpha = 0.3;
    }
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveHeart:)];
    
    [self.heartImageView addGestureRecognizer:gestureRecognizer];
    
}

-(int)distanceFrom:(CGPoint)point1 to:(CGPoint)point2{
    CGFloat xDist = ((point2.x) - (point1.x));
    CGFloat yDist = ((point2.y) - (point1.y));
    return (sqrt((xDist * xDist) + (yDist * yDist)));
}

- (void)moveHeart:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged){
        [self hidePopover];
        CGPoint location = [gestureRecognizer translationInView:self.view];
        self.heartImageView.center = CGPointMake(self.heartImageView.center.x + translation.x,
                                       self.heartImageView.center.y + translation.y);
        NSLog(@"%@", NSStringFromCGPoint(location));
         [gestureRecognizer setTranslation:CGPointZero inView:self.view];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint p = [gestureRecognizer locationInView:self.view];
        [self addPopOverAt:CGRectMake(p.x, p.y - 20, 1, 1)];
    }
    
    for (UIImageView *face in self.faceviewCollection) {
        int distance = [self distanceFrom:face.center to:self.heartImageView.center];

        face.alpha = distance * (-0.00625) + 1;
        //NSLog(@"distance = %f", face.alpha);
    }
    
}
     
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFaceviewCollection:nil];
    [self setHeartImageView:nil];
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

@end
