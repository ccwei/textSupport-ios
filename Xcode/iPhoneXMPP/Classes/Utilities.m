//
//  Utilities.m
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 4/14/13.
//
//

#import "Utilities.h"

NSString *const kDeviceToken = @"kDeviceToken";

@implementation Utilities

+ (void)setUserDefaultString:(NSString *)string forKey:(NSString *)key
{
    if (string != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setUserDefaultBOOL:(BOOL)b forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:b forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
