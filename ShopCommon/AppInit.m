//
//  AppInit.m
//  ShopCommon
//
//  Created by HanSanghong on 2016. 7. 24..
//  Copyright © 2016년 pionnet. All rights reserved.
//

#import "AppInit.h"
#import "Reachability.h"

@implementation AppInit

+ (void)AppInitialize
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
}

+ (void)setCookie:(NSString *)cookieName value:(NSString *)cookieValue domain:(NSString *)cookieDomain
{
    NSDictionary *properties;
    
    properties = [NSDictionary dictionaryWithObjectsAndKeys:
                  cookieValue, NSHTTPCookieValue,
                  cookieName, NSHTTPCookieName,
                  @"/", NSHTTPCookiePath,
                  cookieDomain, NSHTTPCookieDomain,
                  nil];
    NSHTTPCookie *myCookie = [[NSHTTPCookie alloc] initWithProperties:properties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:myCookie];
}

+ (BOOL)checkNetwork
{
    NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    return (netStatus != NotReachable);
}

+ (void)AppExit
{
    [[UIApplication sharedApplication] performSelector:@selector(suspend)];
    [NSThread sleepForTimeInterval:1.0];
    exit(0);
}

+ (void)registerPushToken
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        // Xcode5.x 이하에서 빌드 안됨
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

@end
