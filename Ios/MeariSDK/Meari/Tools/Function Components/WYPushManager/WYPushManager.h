//
//  WYPushManager.h
//  Meari
//
//  Created by 李兵 on 2017/5/18.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WYPushModel;
typedef void(^WYPushBlock)(WYPushModel *pushModel);

@interface WYPushManager : NSObject

/** 单俐 **/
//WY_Singleton_Interface(PushManager)
- (instancetype)init NS_UNAVAILABLE;

/** 注册推送 **/
+ (void)registerPushWithOptions:(NSDictionary *)options;
+ (void)registerDeviceToken:(NSData *)deviceToken;
+ (void)signInMeariPush:(NSData *)deviceToken;

/** 登入登出 **/
+ (void)signInWithIdentifier:(NSString *)identifier callback:(WYBlock_Str)callback;
+ (void)signOut;

/** 内容 **/
+ (void)customHandleWithPushModel:(WYPushBlock)handle;

/** 处理角标 **/
+ (void)resetBadgeNumber ;
+ (void)decrementBadgeNumber;

/** 处理推送 **/
+ (void)dealAlarmShown:(WYPushBlock)block;
+ (void)dealAlarmClicked:(WYPushBlock)block;
+ (void)dealVisitiorCallClicked:(WYPushBlock)block;
+ (void)dealVisitiorCallShow:(WYPushBlock)block;
+ (void)dealVoiceCallShow:(WYPushBlock)block;
+ (void)dealVoiceCallClicked:(WYPushBlock)block;
+ (void)dealSystemShown:(WYPushBlock)block;
+ (void)dealSystemClicked:(WYPushBlock)block;
+ (void)dealPushInfo:(NSDictionary *)pushInfo userClicked:(BOOL)clicked;

/** 声音 **/
+ (void)playSound;
+ (void)playShake;
+ (void)playSoundAndShake;

@end

//APP推送类型
typedef NS_ENUM(NSInteger, WYPushType) {
    WYPushTypeNone,
    WYPushTypeAlarm,
    WYPushTypeSystem,
    WYPushTypeVisitorCall,
    WYPushTypeVoiceCall
};

@interface WYPushModel : NSObject
@property (nonatomic, copy)NSString *deviceName;
@property (nonatomic, copy)NSString *uuid;
@property (nonatomic, copy)NSString *connectName;
@property (nonatomic, copy)NSString *hostKey;
@property (nonatomic, copy)NSString *deviceUUID;
@property (nonatomic, copy)NSString *msgID;
@property (nonatomic, copy)NSString *imgUrl;
@property (nonatomic, copy)NSString *bellVoice;
@property (nonatomic, copy)NSString *deviceP2P;
@property (nonatomic, copy)NSString *p2pInit;
@property (nonatomic, assign)NSInteger deviceID;
@property (nonatomic, assign)NSInteger msgType;
@property (nonatomic, assign)double msgTime;
@property (nonatomic, assign) NSInteger devTypeID;

@property (nonatomic, assign) MeariDeviceType type;
@property (nonatomic, assign) MeariDeviceSubType subType;
@property (nonatomic, assign) WYPushType pushType;


@end
