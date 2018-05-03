//
//  DSWebView.m
//  testApp
//
//  Created by Sanghong Han on 2016. 10. 23..
//  Copyright © 2016년 directionsoft. All rights reserved.
//

#import "DSWebView.h"

#import "CommonShop.h"
#import "NSString+Shop.h"
#import "AppInit.h"

@interface DSWebView()  <UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate>
{
    BOOL                bLoaded;
    //LoadingView         *loading;
}
@end

@implementation DSWebView

@synthesize webView = _webView;

#pragma mark - Public

- (void)callJavaScript:(NSString *)aScript
{
    [_webView evaluateJavaScript:aScript completionHandler:nil];
}

- (void)loadRequest:(NSURLRequest *)request
{
    [_webView loadRequest:request];
}

#pragma mark - default

- (void)registerUserFunction:(NSString *)aQuery
{
    NSDictionary *dictParam = [aQuery parseURLParams];
    
    NSString *sKey = dictParam[@"event"];
    NSString *sValue = dictParam[@"func"];
    
    if (sValue && ([sValue isEqualToString:@""] == NO)) {
        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(registerEventWithKey:value:)] ) {
            [self.DSWebViewDelegate registerEventWithKey:sKey value:sValue];
        }
    }
}

- (void)appinterface:(NSString *)aQuery
{
    NSDictionary *dictQuery = [aQuery parseURLParams];
    
    NSString *sFuncName = dictQuery[@"func"];
    NSString *sParam = dictQuery[@"params"];
    sParam = [sParam stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *callback = dictQuery[@"callback"];
    
    sFuncName = [sFuncName isEqualToString:@""] ? @"" : [sFuncName lowercaseString];
    
    NSLog(@"aQuery is %@", aQuery);
    
    //
    // 로그인
    //
    if ([sFuncName isEqualToString:@"login"]) {
        NSDictionary *dictParam = [sParam parseURLParams];
        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(afterLogin:)]) {
            [self.DSWebViewDelegate afterLogin:dictParam];
        }
    }
    else if ([sFuncName isEqualToString:@"autologin"]) {
        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(checkAutoLogin:)]) {
            [self.DSWebViewDelegate checkAutoLogin:sParam];
        }
    }
    //
    // 로그아웃
    //
    else if ([sFuncName isEqualToString:@"logout"]) {
        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(logout)]) {
            [self.DSWebViewDelegate logout];
        }
    }
    //
    // Push Token 요청
    //
    else if ([sFuncName isEqualToString:@"getpushtoken"]) {
        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(getPushToken)]) {
            [self.DSWebViewDelegate getPushToken];
        }
    }
    // ------------------------------------------------------------------------------------------------
    //  2. 어플리케이션 API
    //  - 앱 종료 : xFrame5.web2app('appExit', '', '');
    //  - 이벤트 Lock : xFrame5.web2app('eventLock', '', '');
    //  - 이벤트 UnLock : xFrame5.web2app('eventUnLock', '', '');
    // ------------------------------------------------------------------------------------------------
    
    // 앱 종료
    else if ([sFuncName isEqualToString:@"appexit"]) {
        [AppInit AppExit];
    }
    // 이벤트 Lock
    else if ([sFuncName isEqualToString:@"applock"]) {
        NSDictionary *dictParam = [sParam parseURLParams];
        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(eventLock:)]) {
            [self.DSWebViewDelegate eventLock:dictParam];
        }
    }
    // 이벤트 UnLock
    else if ([sFuncName isEqualToString:@"appunlock"]) {
        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(eventUnLock)]) {
            [self.DSWebViewDelegate eventUnLock];
        }
    }
    //
    // 설정화면 표시하기
    //
    else if ([sFuncName isEqualToString:@"setup"]) {
        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(openSettingView)]) {
            [self.DSWebViewDelegate openSettingView];
        }
    }
    
    else if ([sFuncName isEqualToString:@"outlink"]) {
        NSDictionary *dictParam = [sParam parseURLParams];
        if ([[dictParam allKeys] count] == 0) {
            dictParam = [dictParam mutableCopy];
            [dictParam setValue:sParam forKey:@"url"];
        }
        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(outlink:)]) {
            [self.DSWebViewDelegate outlink:dictParam];
        }
    }
    
    // ------------------------------------------------------------------------------------------------
    //  4. Play API
    //  - 전화걸기 : xFrame5.web2app('phonecall', 'phoneno=01012345678', '');
    //  - 카메라구동 : xFrame5.web2app('openCamera', '', '');
    //  - 사운드재생 : xFrame5.web2app('playSound', 'file=test.mp3', '');
    //  - 진동 : xFrame5.web2app('vibrate', '', '');
    //  - SMS 전송 : xFrame5.web2app('sendSMS', 'to=01012345678&message=메시지전송테스트입니다.', '');
    //  - Email 전송 : xFrame5.web2app('sendEmail', 'to=test@test.com&subject=제목입니다.&message=메일 내용입니다...', '');
    //  - 주소록 : xFrame5.web2app('openContacts', '', '');
    //  - 갤러리열기 : xFrame5.web2app('openAlbum', '', '');
    //  - 타앱열기 : xFrame5.web2app('executeApp', 'app=kakaotalk://', ''); // for iOS
    // ------------------------------------------------------------------------------------------------
    
    // 전화걸기
    if ([sFuncName isEqualToString:@"sendcall"]) {
        NSDictionary *dictParam = [sParam parseURLParams];
        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(phonecall:)]) {
            [self.DSWebViewDelegate phonecall:dictParam];
        }
    }
    // 카메라 동작하기
    else if ([sFuncName isEqualToString:@"playcamera"]) {
        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(openCamera)]) {
            [self.DSWebViewDelegate openCamera];
        }
    }
    // Vibrate
    else if ([sFuncName isEqualToString:@"playvibrate"]) {
        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(vibrate)]) {
            [self.DSWebViewDelegate vibrate];
        }
    }
    // send SMS
    else if ([sFuncName isEqualToString:@"sendsms"]) {
        NSDictionary *dictParam = [sParam parseURLParams];
        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(sendSMS:)]) {
            [self.DSWebViewDelegate sendSMS:dictParam];
        }
    }
    // send Email
    else if ([sFuncName isEqualToString:@"sendemail"]) {
        NSDictionary *dictParam = [sParam parseURLParams];
        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(sendEmail:)]) {
            [self.DSWebViewDelegate sendEmail:dictParam];
        }
    }
    // 앨범 선택하기
    else if ([sFuncName isEqualToString:@"openalbum"]) {
        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(openAlbum)]) {
            [self.DSWebViewDelegate openAlbum];
        }
    }
    // 타앱 실행하기
    else if ([sFuncName isEqualToString:@"openapp"]) {
        NSDictionary *dictParam = [sParam parseURLParams];
        if (dictParam && dictParam[@"app"]) {
            NSString *sAppScheme = dictParam[@"app"];
            BOOL bExist = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sAppScheme]];
            
            NSString *response = bExist ? @"{\"code\":200, \"result\":\"성공\"}" : @"{\"code\":-100, \"result\":\"앱이 존재하지 않습니다.\"}";
            NSString *sJavaScript = [NSString stringWithFormat:@"%@('openapp', '%@')", callback, response];
            
            [_webView evaluateJavaScript:sJavaScript completionHandler:nil];
        }
    }
}

- (void)webStartLoad
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(webViewStart:)]) {
        [self.DSWebViewDelegate webViewStart:_webView.request.URL.absoluteString];
    }
}

- (void)webDidFinished:(NSString *)sUrl
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(webViewLoadCompleted:)]) {
        [self.DSWebViewDelegate webViewLoadCompleted:_webView.request.URL.absoluteString];
    }
}

- (void)webLoadError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(webViewError:error:)]) {
        [self.DSWebViewDelegate webViewError:_webView.request.URL.absoluteString error:error];
    }
}


#pragma mark - init

- (id)initWithFrame:(CGRect)frame isWKWebView:(BOOL)bWKWebView
{
    self = [super initWithFrame:frame];
    if (self) {
        if (bWKWebView) {
            _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        } else {
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        }
        [_webView setDelegateViews:self];
        [self addSubview:_webView];
    }
    
    return self;
}

#pragma mark - UIWebView Delegate Methods

/*
 * Called on iOS devices that do not have WKWebView when the UIWebView requests to start loading a URL request.
 * Note that it just calls shouldStartDecidePolicy, which is a shared delegate method.
 * Returning YES here would allow the request to complete, returning NO would stop it.
 */
- (BOOL) webView: (UIWebView *) webView shouldStartLoadWithRequest: (NSURLRequest *) request navigationType: (UIWebViewNavigationType) navigationType
{
    return [self shouldStartDecidePolicy: request];
}

/*
 * Called on iOS devices that do not have WKWebView when the UIWebView starts loading a URL request.
 * Note that it just calls didStartNavigation, which is a shared delegate method.
 */
- (void) webViewDidStartLoad: (UIWebView *) webView
{
    [self didStartNavigation];
}

/*
 * Called on iOS devices that do not have WKWebView when a URL request load failed.
 * Note that it just calls failLoadOrNavigation, which is a shared delegate method.
 */
- (void) webView: (UIWebView *) webView didFailLoadWithError: (NSError *) error
{
    [self failLoadOrNavigation: [webView request] withError: error];
}

/*
 * Called on iOS devices that do not have WKWebView when the UIWebView finishes loading a URL request.
 * Note that it just calls finishLoadOrNavigation, which is a shared delegate method.
 */
- (void) webViewDidFinishLoad: (UIWebView *) webView
{
    [self finishLoadOrNavigation: [webView request]];
}

#pragma mark - WKWebView Delegate Methods

/*
 * Called on iOS devices that have WKWebView when the web view wants to start navigation.
 * Note that it calls shouldStartDecidePolicy, which is a shared delegate method,
 * but it's essentially passing the result of that method into decisionHandler, which is a block.
 */
- (void) webView: (WKWebView *) webView decidePolicyForNavigationAction: (WKNavigationAction *) navigationAction decisionHandler: (void (^)(WKNavigationActionPolicy)) decisionHandler
{
    decisionHandler([self shouldStartDecidePolicy: [navigationAction request]]);
}

/*
 * Called on iOS devices that have WKWebView when the web view starts loading a URL request.
 * Note that it just calls didStartNavigation, which is a shared delegate method.
 */
- (void) webView: (WKWebView *) webView didStartProvisionalNavigation: (WKNavigation *) navigation
{
    [self didStartNavigation];
}

/*
 * Called on iOS devices that have WKWebView when the web view fails to load a URL request.
 * Note that it just calls failLoadOrNavigation, which is a shared delegate method,
 * but it has to retrieve the active request from the web view as WKNavigation doesn't contain a reference to it.
 */
- (void) webView:(WKWebView *) webView didFailProvisionalNavigation: (WKNavigation *) navigation withError: (NSError *) error
{
    [self failLoadOrNavigation: [webView request] withError: error];
}

/*
 * Called on iOS devices that have WKWebView when the web view begins loading a URL request.
 * This could call some sort of shared delegate method, but is unused currently.
 */
- (void) webView: (WKWebView *) webView didCommitNavigation: (WKNavigation *) navigation
{
    NSLog(@"didCommitNavigation .... ");
    // do nothing
}

/*
 * Called on iOS devices that have WKWebView when the web view fails to load a URL request.
 * Note that it just calls failLoadOrNavigation, which is a shared delegate method.
 */
- (void) webView: (WKWebView *) webView didFailNavigation: (WKNavigation *) navigation withError: (NSError *) error
{
    [self failLoadOrNavigation: [webView request] withError: error];
}

/*
 * Called on iOS devices that have WKWebView when the web view finishes loading a URL request.
 * Note that it just calls finishLoadOrNavigation, which is a shared delegate method.
 */
- (void) webView: (WKWebView *) webView didFinishNavigation: (WKNavigation *) navigation
{
    [self finishLoadOrNavigation: [webView request]];
}

#pragma mark - Shared Delegate Methods

/*
 * This is called whenever the web view wants to navigate.
 */
- (BOOL) shouldStartDecidePolicy: (NSURLRequest *) request
{
    NSString *scheme = request.URL.scheme;
    
    // 프레임워크 스킴
    if ([scheme isEqualToString:@"dsapp"]) {
        if ([request.URL.host isEqualToString:@"register"]) {
            [self registerUserFunction:request.URL.query];
        }
        else if ([request.URL.host isEqualToString:@"appinterface"]) {
            [self appinterface:request.URL.query];
        }
        
        return NO;
    }
    // 서비스로 이동 전화/메일/메시지
    else if ([scheme isEqualToString:@"tel"] ||
             [scheme isEqualToString:@"mailto"] ||
             [scheme isEqualToString:@"sms"] ) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    // Store로 이동
    else if ([request.URL.absoluteString hasPrefix:@"https://itunes.apple.com"] ||
             [request.URL.absoluteString hasPrefix:@"https://itunes.com"] ||
             [scheme isEqualToString:@"itms"] ||
             [scheme isEqualToString:@"itms-apps"] ||
             [scheme isEqualToString:@"itms-appss"] ) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    else if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"] || [request.URL.absoluteString isEqualToString:@"about:blank"]) {

        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(shouldStartLoadWithRequest:)]) {
            [self.DSWebViewDelegate shouldStartLoadWithRequest:request];
        }
        
        return YES;
    }
    else { // 결제관련
        
        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(shouldStartLoadWithRequest:)]) {
            [self.DSWebViewDelegate shouldStartLoadWithRequest:request];
        }
        
        if ([scheme isEqualToString:@"ispmobile"]){
            if([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
            else {
                NSURL *downloadUrl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id369125087?mt=8"];
                [[UIApplication sharedApplication] openURL:downloadUrl];
            }
        }
        //현대앱카드
        else if([scheme isEqualToString:@"hdcardappcardansimclick"]){
            if([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
            else {
                NSURL *downloadUrl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id702653088?mt=8"];
                [[UIApplication sharedApplication] openURL:downloadUrl];
            }
        }
        //삼성앱카드
        else if ([scheme isEqualToString:@"mpocket.online.ansimclick"]){
            if([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
            else {
                NSURL *downloadUrl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id535125356?mt=8"];
                [[UIApplication sharedApplication] openURL:downloadUrl];
            }
        }
        //신한앱카드
        else if([scheme isEqualToString:@"shinhan-sr-ansimclick"]){
            if([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
            else {
                NSURL *downloadUrl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id572462317?mt=8"];
                [[UIApplication sharedApplication] openURL:downloadUrl];
            }
        }
        //롯데앱카드
        else if([scheme isEqualToString:@"lotteappcard"]){
            if([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
            else {
                NSURL *downloadUrl = [NSURL URLWithString:@"itms-appss://itunes.apple.com/app/id688047200?mt=8"];
                [[UIApplication sharedApplication] openURL:downloadUrl];
            }
        }
        //롯데모바일결제
        else if ([scheme isEqualToString:@"lottesmartpay"]) {
            if([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
            else {
                NSURL *downloadUrl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/kr/app/id668497947?mt=8"];
                [[UIApplication sharedApplication] openURL:downloadUrl];
            }
        }
        //국민앱카드
        else if([scheme isEqualToString:@"kb-acp"]){
            if([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
            else {
                NSURL *downloadUrl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id695436326?mt=8"];
                [[UIApplication sharedApplication] openURL:downloadUrl];
            }
        }
        else if ([scheme isEqualToString:@"tswansimclick"]) {
            if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
            else {
                NSURL *downloadUrl = [NSURL URLWithString:@"itms-appss://itunes.apple.com/kr/app/id430282710?mt=8"];
                [[UIApplication sharedApplication] openURL:downloadUrl];
            }
        }
        // 하나카드
        else if ([scheme isEqualToString:@"cloudpay"]){
            if([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
            else {
                NSURL *downloadUrl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id847268987?mt=8"];
                [[UIApplication sharedApplication] openURL:downloadUrl];
            }
        }
        // kpay
        else if ([scheme isEqualToString:@"kpay"]){
            if([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
            else {
                NSURL *downloadUrl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id911636268?mt=8"];
                [[UIApplication sharedApplication] openURL:downloadUrl];
            }
        }
        // payco
        else if ([scheme isEqualToString:@"payco"]){
            if([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
            else {
                NSURL *downloadUrl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id924292102?mt=8"];
                [[UIApplication sharedApplication] openURL:downloadUrl];
            }
        }
        // payco 앱 로그인
        else if ([scheme isEqualToString:@"paycoapplogin"]){
            if([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
            else {
                NSURL *downloadUrl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id924292102?mt=8"];
                [[UIApplication sharedApplication] openURL:downloadUrl];
            }
        }
        // kftc-bankpay
        else if ([scheme isEqualToString:@"kftc-bankpay"]){
            if([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
            else {
                NSURL *downloadUrl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id398456030?mt=8"];
                [[UIApplication sharedApplication] openURL:downloadUrl];
            }
        }
        // citispay
        else if ([scheme isEqualToString:@"citispay"]){
            if([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
            else {
                NSURL *downloadUrl = [NSURL URLWithString:@"itms-appss://itunes.apple.com/kr/app/id373559493?mt=8"];
                [[UIApplication sharedApplication] openURL:downloadUrl];
            }
        }
        // 농협카드
        else if ([scheme isEqualToString:@"nhappcardansimclick"]){
            if([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
            else {
                NSURL *downloadUrl = [NSURL URLWithString:@"itms-appss://itunes.apple.com/kr/app/id698023004?mt=8"];
                [[UIApplication sharedApplication] openURL:downloadUrl];
            }
        }
    }
    
    return YES;
}

/*
 * This is called whenever the web view has started navigating.
 */
- (void) didStartNavigation
{
    [self webStartLoad];
}

/*
 * This is called when navigation failed.
 */
- (void) failLoadOrNavigation: (NSURLRequest *) request withError: (NSError *) error
{
    [self webLoadError:error];
}

/*
 * This is called when navigation succeeds and is complete.
 */
- (void) finishLoadOrNavigation: (NSURLRequest *) request
{
    bLoaded = YES;
    
    if (_webView && ([_webView isKindOfClass:[UIWebView class]] || [_webView isKindOfClass:[WKWebView class]])) {
        NSString *sUrl = _webView.request.URL.absoluteString;
        if (sUrl && [sUrl isKindOfClass:[NSString class]]) {
            [self webDidFinished:sUrl];
        }
    }
}

- (BOOL)canGoBack
{
    return [_webView canGoBack];
}

- (void)goBack
{
    [_webView goBack];
}


@end
