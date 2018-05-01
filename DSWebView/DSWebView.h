//
//  DSWebView.h
//  testApp
//
//  Created by Sanghong Han on 2016. 10. 23..
//  Copyright © 2016년 directionsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "FLWebViewProvider.h"
#import "UIWebView+FLUIWebView.h"
#import "WKWebView+FLWKWebView.h"

@protocol DSWebViewDelegate <NSObject>

@optional

/**
 - URL로딩 시작
 */
- (void)webViewStart:(NSString *)aUrl;
/**
 - URL로딩 실패
 */
- (void)webViewError:(NSString *)aUrl error:(NSError *)error;
/**
 - URL로딩 완료
 */
- (void)webViewLoadCompleted:(NSString *)aUrl;

/**
    - shouldStartLoadWithRequest
 */
- (void)shouldStartLoadWithRequest:(NSURLRequest *)reqeust;

/**
 - 로그인 후 호출되는 메쏘드
 
 - Params : userid=xxxxx&gubun=1
 * userid : 로그인한 사용자 아이디
 * gubun : 회원(1)/심사임원(2)
 */
- (void)afterLogin:(NSDictionary *)dict;

/**
 - 자동로그인 여부 체크
 - value
 - On : 1
 - Off : 0
 */
- (void)checkAutoLogin:(NSString *)value;

/**
 - 로그아웃이 발생한 경우에 호출되는 메쏘드
 */
- (void)logout;

/**
    웹에서 푸시토큰을 요청하는 경우에 발생하는 메쏘드
 */
- (void)getPushToken;

/**
 - Native 설정화면을 호출하는 메쏘드
 */
- (void)openSettingView;

/**
 - 사파리 브라우저 호출
 
 - Params : url=xxxxxx
 */
- (void)outlink:(NSDictionary *)dict;


- (void)registerEventWithKey:(NSString *)aKey value:(NSString *)aValue;
/**
 - 전화걸기
 - Params
 - telno : 전화번호
 */
- (void)phonecall:(NSDictionary *)aDict;

/**
 - 카메라 호출하기
 */
- (void)openCamera;
/**
 - 앨범호출하기
 */
- (void)openAlbum;
/**
 - 휴대폰 진동시키기
 */
- (void)vibrate;
/**
 - 메시지 보내기
 - Params
 - telno : 휴대폰번호, 여러개인 경우 콤마로 구분 01012345678,01022223333
 - message : 보낼내용
 */
- (void)sendSMS:(NSDictionary *)dict;
/**
 - 이메일 보내기
 - Params
 - mailaddr : 이메일주소, 여러개인 경우 콤마로 구분 a@mail.com, b@mail.com
 - subject : 메일 제목
 - message : 이메일 내용
 */
- (void)sendEmail:(NSDictionary *)dict;
/**
 - 화면 dimmed 처리
 - params
 - timeout : 이 값이 있으면 특정 시간동안 dimmed 처리함
 */
- (void)eventLock:(NSDictionary *)dict;
/**
 - dimmed 화면 제거
 - eventLock에 파라미터 없이 호출한 경우에는 반드시 eventUnLock을 호출해 주어야 한다.
 */
- (void)eventUnLock;


@end

@interface DSWebView : UIView

@property (nonatomic, assign) id<DSWebViewDelegate> DSWebViewDelegate;
@property (nonatomic) UIView <FLWebViewProvider> *webView;

- (id)initWithFrame:(CGRect)frame isWKWebView:(BOOL)bWKWebView;
- (void)callJavaScript:(NSString *)aScript;
- (void)loadRequest:(NSURLRequest *)request;
- (BOOL)canGoBack;
- (void)goBack;

@end
