#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SettingsViewController.h"



@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate, SettingProtocol>
{
	NSFetchedResultsController *fetchedResultsController;
}

@end
