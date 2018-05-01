//
//  NSData+Shop.m
//  ShopCommon
//
//  Created by HanSanghong on 2016. 8. 2..
//  Copyright © 2016년 pionnet. All rights reserved.
//

#import "NSData+Shop.h"

@implementation NSData (Shop)

- (NSString *)makeDeviceToken
{
    NSString *tokenString = [[self description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return tokenString;
}

- (NSString *)string
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

@end
