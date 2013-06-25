//
//  TSConnectionManager.h
//  TextSupport
//
//  Created by Chih-Chiang Wei on 6/24/13.
//
//

#import <Foundation/Foundation.h>

extern NSString* const TS_SERVER_ADDR;

@interface TSConnectionManager : NSObject
+ (TSConnectionManager *)sharedInstance;
- (void)sendRequestWithOptions:(NSDictionary *)options completionHandler: (void (^)(NSURLResponse *response, NSData *data, NSError *error)) completionHandler;
@end
