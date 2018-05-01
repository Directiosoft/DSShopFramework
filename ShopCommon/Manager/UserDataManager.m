//
//  UserDataManager.m
//  OSEBaseApp
//
//  Created by Sanghong Han on 2018. 3. 17..
//  Copyright © 2018년 directionsoft. All rights reserved.
//

#import "UserDataManager.h"

@implementation UserDataManager

#pragma mark - Create Singletone

+ (UserDataManager *)sharedInstance{
    static UserDataManager *userDataManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        userDataManager = [[super alloc] init];
        
    });
    
    return userDataManager;
}

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

#pragma mark - Public Method

// Set data
- (void)setUserData:(nullable id)data key:(NSString *)keyValue
{
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:keyValue];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Get boolean value
- (BOOL)getBool:(NSString *)aKey
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:aKey];
}

// Get String value
- (NSString *)getString:(NSString *)aKey
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:aKey];
}

// Get Dictionary value
- (NSDictionary *)getDictionary:(NSString *)aKey
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:aKey];
}

// Get Array value
- (NSArray *)getArray:(NSString *)aKey
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:aKey];
}

@end
