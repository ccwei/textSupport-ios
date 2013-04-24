//
//  Utilities.h
//  iPhoneXMPP
//
//  Created by Chih-Chiang Wei on 4/14/13.
//
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject
+ (void)setUserDefaultString:(NSString *)string forKey:(NSString *)key;
+ (void)setUserDefaultBOOL:(BOOL)b forKey:(NSString *)key;
@end
