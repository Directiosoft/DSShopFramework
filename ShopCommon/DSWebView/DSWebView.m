//
//  DSWebView.m
//  testApp
//
//  Created by Sanghong Han on 2016. 10. 23..
//  Copyright © 2016년 directionsoft. All rights reserved.
//

#import "DSWebView.h"

#import "ShopCommon.h"

@interface DSWebView()  <
                        WKUIDelegate,
                        WKNavigationDelegate,
                        WKScriptMessageHandler,
                        UIScrollViewDelegate
                        >
{
    BOOL                bLoaded;
    //LoadingView         *loading;
}
@end

@implementation WKWebViewPoolHandler

+ (WKProcessPool *) pool
{
    static dispatch_once_t onceToken;
    static WKProcessPool *_pool;
    dispatch_once(&onceToken, ^{
        _pool = [[WKProcessPool alloc] init];
    });
    return _pool;
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

- (void)appinterface:(NSString *)aQuery
{
    NSDictionary *dictQuery = [aQuery parseURLParams];
    
    NSString *sFuncName = dictQuery[@"func"];
    NSString *sParam = dictQuery[@"params"];
    sParam = [sParam stringByRemovingPercentEncoding];
    
    NSString *callback = dictQuery[@"callback"];
    sFuncName = [sFuncName isEqualToString:@""] ? @"" : [sFuncName lowercaseString];
    
    NSLog(@"aQuery is %@", aQuery);
    
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

#pragma mark - init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil) {
        return self;
    }
    
    WKPreferences *thisPref = [[WKPreferences alloc] init];
    thisPref.javaScriptCanOpenWindowsAutomatically = YES;
    thisPref.javaScriptEnabled = YES;
    
    NSString *source = @"var meta = document.createElement('meta'); meta.name = 'viewport';meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; var head = document.getElementsByTagName('head')[0]; head.appendChild(meta);";
    
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKWebViewConfiguration* configuration = WKWebViewConfiguration.new;
    configuration.processPool = [WKWebViewPoolHandler pool];
    configuration.allowsInlineMediaPlayback = YES;
    configuration.mediaTypesRequiringUserActionForPlayback = NO;
    configuration.allowsPictureInPictureMediaPlayback = YES;
    configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    configuration.preferences = thisPref;
    [configuration.userContentController addUserScript:userScript];
    
    _webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:configuration];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.scrollView.delegate = self;
    _webView.multipleTouchEnabled = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_webView];
    
    return self;
}

#pragma mark - alert, prompt, confirm

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        @try {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:webView.URL.host
                                                                                     message:message preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"")
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction *action) {
                                                                  completionHandler();
                                                              }]];
            
            [[self parentViewController] presentViewController:alertController animated:YES completion:nil];
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    });
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    dispatch_async(dispatch_get_main_queue(),^{
        // TODO We have to think message to confirm "YES"
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:webView.URL.host
                                                                                 message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              completionHandler(YES);
                                                          }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"")
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction *action) {
                                                              completionHandler(NO);
                                                          }]];
        
        [alertController.view setNeedsLayout];
        
        [[self parentViewController] presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt
                                                                             message:webView.URL.host preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = defaultText;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *input = ((UITextField *)alertController.textFields.firstObject).text;
        completionHandler(input);
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(nil);
    }]];
    
    [[self parentViewController] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - New Window

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
}

//TODO:새창에 대한 처리를 어떻게 할 것인지 정의 필요.
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    return nil;
}

- (void)webViewDidClose:(WKWebView *)webView
{

}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    [webView reload];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(webView:type:error:)]) {
        NSString *sUrl = webView.URL.absoluteString;
        [self.DSWebViewDelegate webView:sUrl type:DSWKWebNavigationTypeStart error:nil];
    }
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *scheme = navigationAction.request.URL.scheme.lowercaseString;
    NSURL *url = navigationAction.request.URL;
    
    if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(webView:type:error:)]) {
        NSString *sUrl = navigationAction.request.URL.absoluteString;
        [self.DSWebViewDelegate webView:sUrl type:DSWKWebNavigationTypeNavigation error:nil];
    }
    
    if ([scheme isBasicProtocol]) {
        //scheme이 http, https, about인 경우는 그냥 실행
        decisionHandler(WKNavigationActionPolicyAllow);
        return ;
    }
    else if ([scheme isAppstoreProtocol]) {
        //appstore로 이동하기 위한 scheme인 경우 외부 브라우저 호출
        [[UIApplication sharedApplication] openURL:url options:@{}
                                 completionHandler:^(BOOL success) {}
         ];
        decisionHandler(WKNavigationActionPolicyCancel);
        return ;
    }
//    else if ([scheme isEqualToString:@"ose"]) {
//
//        NSString *host = [url.host lowercaseString];
//        NSString *query = url.query; //[url.query stringByRemovingPercentEncoding];
//        NSDictionary *dictParam = [query toDictionary];
//        
//        if ([host isEqualToString:@"status"]) {
//            query = [query stringByRemovingPercentEncoding];
//            UIColor *color = [query colorFromHex];
//            if (self.delegate && [self.delegate respondsToSelector:@selector(changeStatusColor:)]) {
//                [self.delegate changeStatusColor:color];
//            }
//        }
//        else if ([host isEqualToString:@"reload"]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"MainRefreshNotification" object:nil];
//        }
//        else {
//            [self doAppSchemeProcess:host dict:dictParam];
//        }
//
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return ;
//    }
    else {
        [[UIApplication sharedApplication] openURL:url options:@{}
                                 completionHandler:^(BOOL success) {}
         ];
        decisionHandler(WKNavigationActionPolicyCancel);
        
        return ;
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    //Cookie 동기화...
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
    
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"cookie is %@", cookie);
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(webView:type:error:)]) {
        [self.DSWebViewDelegate webView:webView.URL.absoluteString type:DSWKWebNavigationTypeFinish error:nil];
    }
    
    //    if (_popupHeaderView) {
    //        [webView evaluateJavaScript:@"document.title"
    //                  completionHandler:^(id result, NSError *error) {
    //                      self->_popupHeaderView.titleLabel.text = result;
    //                  }];
    //    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(webView:type:error:)]) {
        NSString *sUrl = webView.URL.absoluteString;
        [self.DSWebViewDelegate webView:sUrl type:DSWKWebNavigationTypeFailed error:error];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"[1]error is %@", error);
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
        if ([request.URL.host isEqualToString:@"appinterface"]) {
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

//        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(shouldStartLoadWithRequest:)]) {
//            [self.DSWebViewDelegate shouldStartLoadWithRequest:request];
//        }
        
        return YES;
    }
    else { // 결제관련
        
//        if (self.DSWebViewDelegate && [self.DSWebViewDelegate respondsToSelector:@selector(shouldStartLoadWithRequest:)]) {
//            [self.DSWebViewDelegate shouldStartLoadWithRequest:request];
//        }
        
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

- (BOOL)canGoBack
{
    return [_webView canGoBack];
}

- (void)goBack
{
    [_webView goBack];
}

@end
