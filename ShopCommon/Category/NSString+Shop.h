//
//  NSString+Shop.h
//  ShopCommon
//
//  Created by HanSanghong on 2016. 8. 2..
//  Copyright © 2016년 pionnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Shop)

/**
    request.URL.query의 값이 a=b&c=d 인 경우 이를 NSDictionary로 만들어 준다.
 */
- (NSDictionary *)parseURLParams;
/**
    AppStore URL인지를 체크해준다.
 */
- (BOOL)iTunesURL;
/**
    사파리 브라우저로 해당 URL을 호출한다.
 */
- (void)openSafari;

/**
    NSString이 nil 이거나 ""인 경우
 */
- (BOOL)isNillOrEmpty;

/**
    if urls doesn't have followings scheme then return YES;
    - http, https, about:none, itms-apps, itms-appss
 */
- (BOOL)isAppScheme;

- (NSString *)trim;

@end
