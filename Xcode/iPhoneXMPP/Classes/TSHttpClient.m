//
//  TSHttpClient.m
//  TextSupport
//
//  Created by Chih-Chiang Wei on 5/8/13.
//
//

#import "TSHttpClient.h"
#import "TSAFJSONRequestOperation.h"

@implementation TSHttpClient

+ (TSHttpClient *)sharedClient {
    static TSHttpClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://text-support.org:1234/"]];
    });
    
    return _sharedClient;
}



- (id) initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self){
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        //[self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}
@end
