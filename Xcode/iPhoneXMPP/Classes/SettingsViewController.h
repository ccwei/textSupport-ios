//
//  SettingsViewController.h
//  iPhoneXMPP
//
//  Created by Eric Chamberlain on 3/18/11.
//  Copyright 2011 RF.com. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const kXMPPmyJID;
extern NSString *const kXMPPmyPassword;
extern NSString *const kHostname;
extern NSString *const kEmail;
extern NSString *const kIsListener;
extern NSString *const kUID;

@protocol SettingProtocol <NSObject>

- (void)removeUserData;

@end
@interface SettingsViewController : UIViewController 
{
  UITextField *jidField;
  UITextField *passwordField;
}
@property (nonatomic,assign) id<SettingProtocol> delegate;
@property (nonatomic,strong) IBOutlet UITextField *jidField;
@property (nonatomic,strong) IBOutlet UITextField *passwordField;
@property BOOL isListener;

- (IBAction)done:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

@end
