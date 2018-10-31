//
//  NSDate+Shop.h
//  ShopCommon
//
//  Created by HanSanghong on 2016. 8. 26..
//  Copyright © 2016년 Directionsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Shop)

//NSDate를 yymmdd 형식의 NSString으로 변환
- (NSString *)yyyymmdd;
//NSDate를 지정된 포맷(dFormat)의 NSString으로 변환
- (NSString *)strWithFormat:(NSString *)dFormat;

@end
