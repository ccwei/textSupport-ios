//
//  MessageViewCell.h
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 2/16/13.
//
//

#import <UIKit/UIKit.h>

@interface MessageViewTableCell : UITableViewCell
@property (strong, nonatomic) UILabel *senderAndTimeLabel;
@property (strong, nonatomic) UITextView *messageContentView;
@property (strong, nonatomic) UIImageView *bgImageView;
@end
