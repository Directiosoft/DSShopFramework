//
//  UserLocalData.h
//  ShopCommon
//
//  Created by HanSanghong on 2016. 8. 3..
//  Copyright © 2016년 pionnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLocalData : NSObject

NS_ASSUME_NONNULL_BEGIN

+ (void)setObject:(nullable id)value forKey:(NSString *)defaultName;
+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;

+ (nullable id)objectForKey:(NSString *)defaultName;
+ (BOOL)boolForKey:(NSString *)defaultName;

NS_ASSUME_NONNULL_END

@end
