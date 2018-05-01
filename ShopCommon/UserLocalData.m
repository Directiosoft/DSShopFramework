//
//  UserLocalData.m
//  ShopCommon
//
//  Created by HanSanghong on 2016. 8. 3..
//  Copyright © 2016년 pionnet. All rights reserved.
//

#import "UserLocalData.h"

@implementation UserLocalData

+ (void)setObject:(nullable id)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (nullable id)objectForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

+ (BOOL)boolForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}

@end
