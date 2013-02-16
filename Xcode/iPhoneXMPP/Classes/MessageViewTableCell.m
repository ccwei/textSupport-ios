//
//  MessageViewCell.m
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 2/16/13.
//
//

#import "MessageViewTableCell.h"

@interface MessageViewTableCell()

@end

@implementation MessageViewTableCell

- (void)setup
{
    self.senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
    self.senderAndTimeLabel.textAlignment = UITextAlignmentCenter;
    self.senderAndTimeLabel.font = [UIFont systemFontOfSize:11.0];
    self.senderAndTimeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview: self.senderAndTimeLabel];
    
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.bgImageView];
    self.messageContentView = [[UITextView alloc] init];
    self.messageContentView.backgroundColor = [UIColor clearColor];
    self.messageContentView.editable = NO;
    self.messageContentView.scrollEnabled = NO;
    [self.messageContentView sizeToFit];
    [self.contentView addSubview:self.messageContentView];

}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
