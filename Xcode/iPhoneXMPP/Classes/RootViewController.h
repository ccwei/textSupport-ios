#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SettingsViewController.h"



@interface RootViewController : UIViewController <NSFetchedResultsControllerDelegate, SettingProtocol>
{
	NSFetchedResultsController *fetchedResultsController;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
