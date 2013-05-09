//
//  TOUViewController.m
//  TextSupport
//
//  Created by Chih-Chiang Wei on 5/9/13.
//
//

#import "TOUViewController.h"

@interface TOUViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TOUViewController
- (IBAction)declineBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    self.title = @"Terms of Use";
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
