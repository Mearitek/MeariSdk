//
//  MeariDevice+WYAdd.h
//  Meari
//
//  Created by 李兵 on 2017/12/22.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <MeariKit/MeariKit.h>
#import "WYBabymonitorMusicStateModel.h"
#import "WYCameraTime.h"


@interface MeariDevice (WYAdd)

@property (nonatomic, copy)NSString *wy_wifiSSID;

- (WYUIStytle)wy_uiStytle;

#pragma mark - SDK
//连接
- (void)wy_startConnectSuccess:(WYBlock_Void)success failure:(WYBlock_Error)failure;


- (void)wy_getMusicStateSuccess:(void(^)(WYBabymonitorMusicStateModel *musicState))success failure:(WYBlock_Error)failure;

//回放
- (void)wy_getPlaybackVideoTimesWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day success:(MeariDeviceSucess_PlaybackTimes)success failure:(MeariDeviceFailure)failure;
- (void)wy_getPlaybackVideoDaysWithYear:(NSInteger)year month:(NSInteger)month success:(MeariDeviceSucess_PlaybackDays)success failure:(MeariDeviceFailure)failure;
@end
