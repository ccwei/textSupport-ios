//
//  UIPlaceHolderTextView.h
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 4/15/13.
//
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@end
