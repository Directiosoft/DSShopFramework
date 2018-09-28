//
//  NSString+Shop.m
//  ShopCommon
//
//  Created by HanSanghong on 2016. 8. 2..
//  Copyright © 2016년 Directionsoft. All rights reserved.
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
    NSMutableDictionary *dictResult = [NSMutableDictionary dictionary];
    
    if ([self isEqualToString:@""]) {
        return dictResult;
    }
    
    NSArray *array = [self componentsSeparatedByString:@"&"];
    for (NSString *s in array) {
        NSRange range = [s rangeOfString:@"="];
        if (range.location != NSNotFound) {
            NSString *key = [s substringToIndex:range.location];
            NSString *value = [s substringFromIndex:range.location+1];
            
            [dictResult setValue:value forKey:key];
        }
    }
    return dictResult;
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

- (UIColor *)colorFromHexString
{
    NSString *cleanString = [self stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 6) {
        cleanString = [@"ff" stringByAppendingString:cleanString];
    }
    
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)],
                       [cleanString substringWithRange:NSMakeRange(3, 1)],[cleanString substringWithRange:NSMakeRange(3, 1)]];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 16) & 0xFF)/255.0f;
    float green = ((baseValue >> 8) & 0xFF)/255.0f;
    float blue = ((baseValue >> 0) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 24) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSString *)commaString
{
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *sResult = [nFormat stringFromNumber:[NSNumber numberWithInt:[self intValue]]];
    return sResult;
}



@end
