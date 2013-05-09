//
//  TSHttpClient.h
//  TextSupport
//
//  Created by Chih-Chiang Wei on 5/8/13.
//
//

#import "AFHTTPClient.h"

@interface TSHttpClient : AFHTTPClient
+ (TSHttpClient *)sharedClient;
@end
