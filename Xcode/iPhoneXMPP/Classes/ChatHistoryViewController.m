//
//  ChatHistoryViewController.m
//  TextSupport
//
//  Created by Chih-Chiang Wei on 4/23/13.
//
//

#import "ChatHistoryViewController.h"
#import "SettingsViewController.h"
#import "iPhoneXMPPAppDelegate.h"

@interface ChatHistoryViewController ()
@property (strong, nonatomic) NSString *jid;
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr=%@", self.jid];
    //NSLog(@"Username = %@", self.userName);
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"bareJidStr" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
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


- (void) configureUnSeenMessagesForCell:(UITableViewCell *)cell jidStr:(NSString *)jidStr
{
    XMPPMessageArchivingCoreDataStorage *macds = [[self appDelegate] xmppMessageArchivingCoreDataStorage];
    NSManagedObjectContext *moc = [[self appDelegate] managedObjectContext_messageArchiving];
    NSEntityDescription *entity = [macds messageEntity:moc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr=%@ and seen=nil", jidStr];
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSUInteger count = [moc countForFetchRequest:fetchRequest error:nil];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary *msg = (NSDictionary *)self.messages[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatHistory"];
    
    XMPPMessageArchiving_Message_CoreDataObject *contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSRange range = [contact.bareJidStr rangeOfString:@"@"];
    cell.textLabel.text = [NSString stringWithFormat:@"User# %@", [contact.bareJidStr substringToIndex:range.location]];
    [self configureUnSeenMessagesForCell:cell jidStr:contact.bareJidStr];
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Messages"]) {
        XMPPMessageArchiving_Message_CoreDataObject *contact = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
        NSLog(@"set listener's jidstr = %@", contact.bareJidStr);
        NSRange range = [contact.bareJidStr rangeOfString:@"@"];
        NSString* nickName = [NSString stringWithFormat:@"User# %@", [contact.bareJidStr substringToIndex:range.location]];
        [segue.destinationViewController performSelector:@selector(setUserName:) withObject:contact.bareJidStr];
        [segue.destinationViewController performSelector:@selector(setNickName:) withObject:nickName];
        [segue.destinationViewController hidesBottomBarWhenPushed];
        //[segue.destinationViewController performSelector:@selector(setDelegate:) withObject:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.jid = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
    [self setupFetchResultController];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
