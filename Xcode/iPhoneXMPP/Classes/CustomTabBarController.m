//
//  CustomTabBarController.m
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 3/11/13.
//
//

#import "CustomTabBarController.h"

@interface CustomTabBarController ()
@property (nonatomic, retain) UIButton *settingsButton;
@property (nonatomic, retain) UIButton *infoButton;

-(void) addCustomElements;
-(void) selectTab:(int)tabID;
@end

@implementation CustomTabBarController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self addCustomElements];
    self.selectedIndex = 101;
}

-(void)addCustomElements
{
    // Background
    UIImageView* bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBarBackground.png"]];
    bgView.frame = CGRectMake(0, 420, 320, 60);
    [self.view addSubview:bgView];
    
    // Initialise our two images
    UIImage *btnImage = [UIImage imageNamed:@"settings.png"];
    UIImage *btnImageSelected = [UIImage imageNamed:@"settingsSelected.png"];
    
    self.settingsButton = [UIButton buttonWithType:UIButtonTypeCustom]; //Setup the button
    self.settingsButton.frame = CGRectMake(10, 426, 100, 54); // Set the frame (size and position) of the button)
    [self.settingsButton setBackgroundImage:btnImage forState:UIControlStateNormal]; // Set the image for the normal state of the button
    [self.settingsButton setBackgroundImage:btnImageSelected forState:UIControlStateHighlighted]; // Set the image for the selected state of the button
    [self.settingsButton setBackgroundImage:btnImageSelected forState:UIControlStateSelected]; // Set the image for the selected state of the button
    [self.settingsButton setBackgroundImage:btnImageSelected forState:UIControlStateDisabled];
    [self.settingsButton setImage:btnImageSelected forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [self.settingsButton setTag:101]; // Assign the button a "tag" so when our "click" event is called we know which button was pressed.
    [self.settingsButton setSelected:true]; // Set this button as selected (we will select the others to false as we only want Tab 1 to be selected initially
    
    // Now we repeat the process for the other buttons
    btnImage = [UIImage imageNamed:@"info.png"];
    btnImageSelected = [UIImage imageNamed:@"infoSelected.png"];
    self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.infoButton.frame = CGRectMake(110, 426, 100, 54);
    [self.infoButton setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.infoButton setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [self.infoButton setBackgroundImage:btnImageSelected forState:UIControlStateHighlighted];
    [self.infoButton setImage:btnImageSelected forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [self.infoButton setTag:102];
    

    // Add my new buttons to the view
    [self.view addSubview:self.settingsButton];
    //[self.view addSubview:self.infoButton];
    
    // Setup event handlers so that the buttonClicked method will respond to the touch up inside event.
    [self.settingsButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[self.infoButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClicked:(id)sender
{
    int tagNum = [sender tag];
    [self selectTab:tagNum];
}

- (void)selectTab:(int)tabID
{
    switch(tabID)
    {
        case 101:
            [self.settingsButton setSelected:true];
            [self.infoButton setSelected:false];
            break;
        case 102:
            [self.settingsButton setSelected:false];
            [self.infoButton setSelected:true];
            break;
    }
    self.selectedIndex = tabID;
}

@end
