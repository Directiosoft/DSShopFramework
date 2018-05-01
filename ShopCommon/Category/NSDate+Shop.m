//
//  NSDate+Shop.m
//  ShopCommon
//
//  Created by HanSanghong on 2016. 8. 26..
//  Copyright © 2016년 pionnet. All rights reserved.
//

#import "NSDate+Shop.h"

@implementation NSDate (Shop)

- (NSString *)yyyymmdd
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    return [dateFormatter stringFromDate:self];
}

- (NSString *)strWithFormat:(NSString *)dFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dFormat;
    return [dateFormatter stringFromDate:self];
}

@end
