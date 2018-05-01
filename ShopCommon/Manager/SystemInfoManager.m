//
//  SystemInfoManager.m
//  OSEBaseApp
//
//  Created by Sanghong Han on 2018. 3. 21..
//  Copyright © 2018년 directionsoft. All rights reserved.
//

#import "SystemInfoManager.h"
#import <UIKit/UIKit.h>

@implementation SystemInfoManager

#pragma mark - Create Singletone

+ (SystemInfoManager *)sharedInstance{
    static SystemInfoManager *sysInfoManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sysInfoManager = [[super alloc] init];
    });
    
    return sysInfoManager;
}

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}


- (NSString *)deviceName
{
    return [[UIDevice currentDevice] model];
}

- (NSString *)osType
{
    return [[UIDevice currentDevice] systemName];
}

- (NSString *)osVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString *)country
{
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    return [currentLocale objectForKey:NSLocaleCountryCode];
}

- (NSString *)appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
