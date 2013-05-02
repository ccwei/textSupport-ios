//
//  ChatViewController.h
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 2/14/13.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataTableViewController.h"

@interface ChatViewController : CoreDataTableViewController
@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* nickName;
@end
