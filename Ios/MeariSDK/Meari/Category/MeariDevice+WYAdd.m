//
//  MeariDevice+WYAdd.m
//  Meari
//
//  Created by 李兵 on 2017/12/22.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "MeariDevice+WYAdd.h"
#import <objc/runtime.h>
@implementation MeariDevice (WYAdd)
#pragma mark - Private
- (NSString *)description {
    return [NSString stringWithFormat:@"%@:%p id:%ld sn:%@, tp:%@, uuid:%@, name:%@", self.class,self, self.info.ID, self.info.sn, self.info.tp, self.info.uuid, self.info.nickname];
}

#pragma mark - Public
- (NSString *)wy_wifiSSID {
    return objc_getAssociatedObject(self, @selector(wy_wifiSSID));
}
- (void)setWy_wifiSSID:(NSString *)wy_wifiSSID {
    objc_setAssociatedObject(self, @selector(wy_wifiSSID), wy_wifiSSID, OBJC_ASSOCIATION_COPY);
}

- (WYUIStytle)wy_uiStytle {
   return self.isIpcBaby ? WYUIStytleOrange : WYUIStytleDefault;
}

#pragma mark - SDK
- (void)wy_startConnectSuccess:(WYBlock_Void)success failure:(WYBlock_Error)failure {
    WY_WeakSelf
    void (^notificationConnectSuccess)(BOOL suc, NSString *description) = ^(BOOL suc, NSString *description){
        [WY_NotificationCenter wy_post_Device_ConnectCompleted:^(WYObj_Device *device) {
            device.deviceID = weakSelf.info.ID;
            device.deviceType = weakSelf.info.type;
            device.connectSuccess = suc;
            device.connectDescription = description;
            device.camerap = [NSString stringWithFormat:@"%p",self];
        }];
    };
    [self startConnectSuccess:^{
        notificationConnectSuccess(YES, nil);
    } abnormalDisconnect:^{
        NSError *error = [[NSError alloc]initWithDomain:@"abnormal Disconnect" code:-1014 userInfo:nil];
        notificationConnectSuccess(YES, nil);
    } failure:^(NSError *error) {
        notificationConnectSuccess(NO, @"打洞失败");
    }];
}
- (void)wy_getMusicStateSuccess:(void(^)(WYBabymonitorMusicStateModel *musicState))success failure:(WYBlock_Error)failure {
    [self getMusicStateSuccess:^(NSDictionary *allMusicState) {
        WYBabymonitorMusicStateModel *model = [WYBabymonitorMusicStateModel mj_objectWithKeyValues:allMusicState];
        WYDo_Block_Safe_Main1(success, model)
    } failure:failure];
}
- (void)wy_getPlaybackVideoTimesWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day success:(MeariDeviceSucess_PlaybackTimes)success failure:(MeariDeviceFailure)failure; {
    [self getPlaybackVideoTimesWithYear:year month:month day:day success:^(NSArray *times) {
        NSMutableArray *res = [NSMutableArray arrayWithCapacity:times.count];
        for (NSDictionary *dic in times) {
            
            WYCameraTime *time = [WYCameraTime timeWithTimesDictionary:dic];
            if (time) {
                [res addObject:time];
            }
        }
        WYDo_Block_Safe_Main1(success, res)
    } failure:failure];
    
}
- (void)wy_getPlaybackVideoDaysWithYear:(NSInteger)year month:(NSInteger)month success:(MeariDeviceSucess_PlaybackDays)success failure:(MeariDeviceFailure)failure {
    [self getPlaybackVideoDaysWithYear:year month:month success:^(NSArray *days) {
        NSMutableArray *res = [NSMutableArray arrayWithCapacity:days.count];
        for (NSDictionary *dic in days) {
            WYCameraTime *time = [WYCameraTime timeWithVideoDaysDictionary:dic];
            if (time) {
                [res addObject:time];
            }
        }
        WYDo_Block_Safe_Main1(success, res)
    } failure:failure];
    
    
}

@end
