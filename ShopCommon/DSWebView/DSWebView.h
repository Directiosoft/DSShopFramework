//
//  DSWebView.h
//  testApp
//
//  Created by Sanghong Han on 2016. 10. 23..
//  Copyright © 2016년 directionsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef NS_ENUM(NSInteger, DSWKWebNavigationType) {
    DSWKWebNavigationTypeNone = -1,
    DSWKWebNavigationTypeStart,
    DSWKWebNavigationTypeNavigation,
    DSWKWebNavigationTypeFailed,
    DSWKWebNavigationTypeFinish
};

@protocol DSWebViewDelegate <NSObject>

@optional


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

- (void)webView:(NSString *)url type:(DSWKWebNavigationType)navigationType error:(NSError *)error;

@end



@interface WKWebViewPoolHandler : NSObject
{
}
+ (WKProcessPool *)pool;
@end

@interface DSWebView : UIView

@property (nonatomic, assign) id<DSWebViewDelegate> DSWebViewDelegate;
@property (nonatomic) WKWebView *webView;

- (void)callJavaScript:(NSString *)aScript;
- (void)loadRequest:(NSURLRequest *)request;
- (BOOL)canGoBack;
- (void)goBack;

@end
