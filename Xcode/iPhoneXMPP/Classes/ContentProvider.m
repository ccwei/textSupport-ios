//
//  ContentProvider.m
//  TextSupport
//
//  Created by Chih-Chiang Wei on 4/24/13.
//
//

#import "ContentProvider.h"


@implementation ContentProvider
+ (int) GetUIDByEmail:(NSString *)email
{
 /*   NSURL *aUrl = [NSURL URLWithString:@"http://textsupport.no-ip.org:1234/registrations/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLCacheStorageNotAllowed
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"member[email]=%@&member[password]=%@", jidField.text, passwordField.text];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"JSON = %@", JSON);
        NSLog(@"%@", [JSON valueForKeyPath:@"isListener"]);
        self.isListener = [[JSON valueForKeyPath:@"isListener"] boolValue];
        
        [Utilities setUserDefaultBOOL:self.isListener forKey:kIsListener];
        [[self appDelegate] connect];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure");
    }];
    
    [operation start];
*/
}
@end
