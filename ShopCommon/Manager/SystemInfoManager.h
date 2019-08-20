//
//  SystemInfoManager.h
//  OSEBaseApp
//
//  Created by Sanghong Han on 2018. 3. 21..
//  Copyright © 2018년 directionsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 DeviceName, model 등 System의 정보를 얻기 위한 클래스
 
 Usage
 - [ISystemInfoManager deviceName];
*/

NS_ASSUME_NONNULL_BEGIN

#define ISystemInfoManager [SystemInfoManager sharedInstance]

@interface SystemInfoManager : NSObject

//SystemInfoManager 인스탄스를 한 번만 생성되도록 하는 함수
+ (SystemInfoManager *)sharedInstance;

#pragma mark - Public Method

//디바이스명 : iPhone, iPad 등
- (NSString *)deviceName;
//OS유형 : iOS, tvOS 등
- (NSString *)osType;
//OS버전 : 11.2
- (NSString *)osVersion;
//현재 설정된 로케일 값을 기반으로 국가코드를 얻어온다.KR
- (NSString *)country;
//앱의 버전정보
- (NSString *)appVersion;

@end

NS_ASSUME_NONNULL_END
