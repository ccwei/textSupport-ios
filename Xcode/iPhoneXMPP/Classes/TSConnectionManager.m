//
//  TSConnectionManager.m
//  TextSupport
//
//  Created by Chih-Chiang Wei on 6/24/13.
//
//

#import "TSConnectionManager.h"

@implementation TSConnectionManager

NSString * const TS_SERVER_ADDR = @"http://text-support.org:1234/";
static TSConnectionManager *sharedInstance = nil;

+ (TSConnectionManager *)sharedInstance {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[TSConnectionManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)sendRequestWithOptions:(NSDictionary *)options completionHandler: (void (^)(NSURLResponse *response, NSData *data, NSError *error)) completionHandler{
    
    NSString *path = [options valueForKey:@"path"];
    NSURL *aUrl = [NSURL URLWithString:TS_SERVER_ADDR];
    if (path) {
        aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TS_SERVER_ADDR, path]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLCacheStorageNotAllowed
                                                       timeoutInterval:60.0];
    
    NSString *httpMethod = [options valueForKey:@"httpMethod"];
    if (httpMethod) {
        [request setHTTPMethod:httpMethod];
    } else {
        //default method is GET
        [request setHTTPMethod:@"GET"];
    }
    
    NSString *httpBody = [options valueForKey:@"httpBody"];
    if (httpBody) {
        [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSString *accept = [options valueForKey:@"accept"];
    if (accept) {
        [request setValue:accept forHTTPHeaderField:@"Accept"];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completionHandler];
}

@end
