//
//  MoodRatingViewController.m
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 3/2/13.
//
//

#import "MoodRatingViewController.h"
#import "FaceView.h"

@interface MoodRatingViewController () <FaceViewDataSource>
@property (weak, nonatomic) IBOutlet FaceView *faceView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *faceviewCollection;
@property (nonatomic) int happiness;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;
@end

@implementation MoodRatingViewController

- (IBAction)moodChanged:(UISlider *)sender {
    self.happiness = sender.value;
}

- (void)setFaceView:(FaceView *)faceview{
    _faceView = faceview;
    self.faceView.dataSource = self;
}

- (void)setHappiness:(int)happiness{
    _happiness = happiness;
    [self.faceView setNeedsDisplay];
}

- (float) smileForFaceView:(FaceView *)sender{
    return (self.happiness - 50.0) / 50.0;
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
        CGPoint location = [gestureRecognizer translationInView:self.view];
        self.heartImageView.center = CGPointMake(self.heartImageView.center.x + translation.x,
                                       self.heartImageView.center.y + translation.y);
        NSLog(@"%@", NSStringFromCGPoint(location));
         [gestureRecognizer setTranslation:CGPointZero inView:self.view];
    }
    
    for (UIImageView *face in self.faceviewCollection) {
        int distance = [self distanceFrom:face.center to:self.heartImageView.center];

        face.alpha = distance * (-0.00625) + 1;
        NSLog(@"distance = %f", face.alpha);
    }
    
}
     
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFaceView:nil];
    [self setFaceviewCollection:nil];
    [self setHeartImageView:nil];
    [super viewDidUnload];
}
@end
