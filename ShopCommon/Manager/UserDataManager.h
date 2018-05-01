//
//  UserDataManager.h
//  OSEBaseApp
//
//  Created by Sanghong Han on 2018. 3. 17..
//  Copyright © 2018년 directionsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NSUserDefault 클래스로 앱에서 사용되는 데이터를 저장 & 불러오기 위한 클래스
 
 Usage
 - [IUserDataManagrer setUserData:@"James" key:@"name"];
 - NSString *aName = [IUserDataManager getString:@"name"];
 
*/
#define IUserDataManager [UserDataManager sharedInstance]

@interface UserDataManager : NSObject

//UserDataManager 인스탄스를 한 번만 생성되도록 하는 함수
+ (UserDataManager *)sharedInstance;

#pragma mark - Set Function

- (void)setUserData:(nullable id)data key:(NSString *)keyValue;

#pragma mark - Get Function

- (BOOL)getBool:(NSString *)aKey;
- (NSString *)getString:(NSString *)aKey;
- (NSDictionary *)getDictionary:(NSString *)aKey;
- (NSArray *)getArray:(NSString *)aKey;

@end
