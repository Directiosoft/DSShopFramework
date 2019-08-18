//
//  AppInit.h
//  ShopCommon
//
//  Created by HanSanghong on 2016. 7. 24..
//  Copyright © 2016년 Directionsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppInit : NSObject

// 캐쉬 삭제 및 결제를 위한 쿠키 허용
+ (void)AppInitialize;

// 쿠키 설정
// 이 함수는 UIWebView인 경우에만 가능
+ (void)setCookie:(NSString *)cookieName value:(NSString *)cookieValue domain:(NSString *)cookieDomain;


// 앱 종료
+ (void)AppExit;

// 푸시토큰 등록 요청
+ (void)registerPushToken;

@end
