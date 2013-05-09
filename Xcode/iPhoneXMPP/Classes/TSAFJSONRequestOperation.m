//
//  T_AFJSONRequestOperation.m
//  TextSupport
//
//  Created by Chih-Chiang Wei on 5/8/13.
//
//

#import "TSAFJSONRequestOperation.h"

@implementation TSAFJSONRequestOperation

+ (NSSet *)acceptableContentTypes
{
    return [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
}

@end
