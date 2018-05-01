//
//  NSString+Shop.m
//  ShopCommon
//
//  Created by HanSanghong on 2016. 8. 2..
//  Copyright © 2016년 pionnet. All rights reserved.
//

#import "NSString+Shop.h"

@implementation NSString (Shop)

- (BOOL)isMatch:(NSString *)url pattern:(NSString *)pattern {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) {
        return NO;
    }
    
    NSTextCheckingResult *res = [regex firstMatchInString:url options:0 range:NSMakeRange(0, url.length)];
    return res != nil;
}

- (NSDictionary *)parseURLParams
{
    if ([self isEqualToString:@""]) {
        return nil;
    }
    
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByRemovingPercentEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (BOOL)iTunesURL
{
    return [self isMatch:self pattern:@"\\/\\/itunes\\.apple\\.com\\/"];
}

- (void)openSafari
{
    @try {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self]];
    }
    @catch (NSException *exception) {
        NSLog(@"");
    }
}

- (BOOL)isNillOrEmpty
{
    return ((self == nil) || [self isEqualToString:@""]);
}

- (BOOL)isAppScheme
{
    NSString *sUrl = [self lowercaseString];
    
    return !([sUrl hasPrefix:@"http"] ||
             [sUrl hasPrefix:@"https"] ||
             [sUrl isEqualToString:@"about:none"] ||
             [sUrl isEqualToString:@"itms-apps"] ||
             [sUrl isEqualToString:@"itms-appss"] );
}

- (NSString *)trim
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}


@end
