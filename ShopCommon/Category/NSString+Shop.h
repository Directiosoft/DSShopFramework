//
//  NSString+Shop.h
//  ShopCommon
//
//  Created by HanSanghong on 2016. 8. 2..
//  Copyright © 2016년 Directionsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Shop)

//request.URL.query의 값이 a=b&c=d 인 경우 이를 NSDictionary로 만들어 준다.
- (NSDictionary *)parseURLParams;

//check to url is appstore url.
- (BOOL)iTunesURL;

// Open url via safari
- (void)openSafari;

// whether NSString is nil or empty
- (BOOL)isNillOrEmpty;

// if urls doesn't have followings scheme then return YES;
//   - http, https, about:none, itms-apps, itms-appss
- (BOOL)isAppScheme;

- (BOOL)isBasicProtocol;
- (BOOL)isAppstoreProtocol;
//
- (NSString *)trim;

//conert #F3F3F3 to UIColor
- (UIColor *)colorFromHexString;

//123456 -> 123,456
- (NSString *)commaString;

@end
