//
//  NSData+Shop.h
//  ShopCommon
//
//  Created by HanSanghong on 2016. 8. 2..
//  Copyright © 2016년 Directionsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Shop)

//NSData형식의 Push token을 NSString으로 변환
- (NSString *)makeDeviceToken;
//NSUTFEncoding 방식으로 NSStirng으로 변환
- (NSString *)string;

@end
