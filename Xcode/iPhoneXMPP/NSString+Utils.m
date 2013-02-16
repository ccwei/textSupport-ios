//
//  NSString+Utils.m
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 2/16/13.
//
//

#import "NSString+Utils.h"

@implementation NSString (Utils)
+ (NSString *) getCurrentTime {
    NSDate *nowUTC = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:nowUTC];
}
@end
