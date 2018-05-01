//
//  CommonShop.h
//  ShopCommon
//
//  Created by HanSanghong on 2016. 8. 2..
//  Copyright © 2016년 pionnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonShop : NSObject

/**
 convert NSDate to a NSString using the given format
*/
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dFormat;
/**
 convert int to NSString : 1000 ==> 1,000
 */
+ (NSString *)intNumberFormat:(int)nValue;

@end
