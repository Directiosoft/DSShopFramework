//
//  ShopCommon.h
//  ShopCommon
//
//  Created by HanSanghong on 2016. 7. 24..
//  Copyright © 2016년 pionnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShopCommon/AppInit.h>
#import <ShopCommon/CommonShop.h>
#import <ShopCommon/NSString+Shop.h>
#import <ShopCommon/NSData+Shop.h>
#import <ShopCommon/DSWebView.h>

#define DocumentPath        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//
// Kinds of Device
//
#define IS_IPAD                         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE                       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_6PLUS                 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && kScreenBoundsHeight == 736)
#define IS_IPHONE_6                     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && kScreenBoundsHeight == 667)
#define IS_IPHONE_5                     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && kScreenBoundsHeight == 568)
#define IS_IPHONE_4                     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && kScreenBoundsHeight == 480)

//
// info
//
#define APP_BUNDLE_ID                   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define APP_BUNDLE_NAME                 [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define APP_VERSION                     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//
// Device Width & Height
//
#define kScreenBoundsWidth              [[UIScreen mainScreen] bounds].size.width
#define kScreenBoundsHeight             [[UIScreen mainScreen] bounds].size.height

//
#define StatusBarHeight                 (([[UIDevice currentDevice].systemVersion floatValue] < 7) ? 0 : 20)

//
// Color Function Define
//
#define UIColorFromRGB(rgbValue)        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue, a)	[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#define RGB(r, g, b)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)                [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


