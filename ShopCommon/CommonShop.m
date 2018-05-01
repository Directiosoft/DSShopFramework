//
//  CommonShop.m
//  ShopCommon
//
//  Created by HanSanghong on 2016. 8. 2..
//  Copyright © 2016년 pionnet. All rights reserved.
//

#import "CommonShop.h"

@implementation CommonShop

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dFormat;
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)intNumberFormat:(int)nValue
{
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *sResult = [nFormat stringFromNumber:[NSNumber numberWithInt:nValue]];
    return sResult;
}



@end
