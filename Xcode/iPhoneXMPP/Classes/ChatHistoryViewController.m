//
//  ChatHistoryViewController.m
//  TextSupport
//
//  Created by Chih-Chiang Wei on 4/23/13.
//
//

#import "ChatHistoryViewController.h"
#import "iPhoneXMPPAppDelegate.h"

@interface ChatHistoryViewController ()

@end

@implementation ChatHistoryViewController

- (iPhoneXMPPAppDelegate *)appDelegate {
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

- (void)setupFetchResultController
{
    XMPPMessageArchivingCoreDataStorage *macds = [[self appDelegate] xmppMessageArchivingCoreDataStorage];
    NSManagedObjectContext *moc = [[self appDelegate] managedObjectContext_messageArchiving];
    NSEntityDescription *entity = [macds contactEntity:moc];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr=%@", self.userName];
    //NSLog(@"Username = %@", self.userName);
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"bareJidStr" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    //[fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchBatchSize:10];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:moc
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
    NSLog(@"%@", [self.fetchedResultsController fetchedObjects]);
    NSError *error = nil;
    if (error) {
        NSLog(@"error: %@", error);
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary *msg = (NSDictionary *)self.messages[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatHistory" forIndexPath:indexPath];
    
    XMPPMessageArchiving_Message_CoreDataObject *contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = contact.bareJidStr;
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Messages"]) {
        XMPPMessageArchiving_Message_CoreDataObject *contact = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
        NSLog(@"set listener's jidstr = %@", contact.bareJidStr);
        [segue.destinationViewController performSelector:@selector(setUserName:) withObject:contact.bareJidStr];
        //[segue.destinationViewController performSelector:@selector(setDelegate:) withObject:self];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchResultController];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
