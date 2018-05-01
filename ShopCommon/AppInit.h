//
//  AppInit.h
//  ShopCommon
//
//  Created by HanSanghong on 2016. 7. 24..
//  Copyright © 2016년 pionnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppInit : NSObject

//
// 캐쉬 삭제 및 결제를 위한 쿠키 허용
//
+ (void)AppInitialize;
//
// 쿠키 설정
//
+ (void)setCookie:(NSString *)cookieName value:(NSString *)cookieValue domain:(NSString *)cookieDomain;
//
// 네트웍 연결 여부 확인 YES or NO
//
+ (BOOL)checkNetwork;
//
// 앱 종료
//
+ (void)AppExit;
//
// 푸시토큰 등록 요청
//
+ (void)registerPushToken;

@end
