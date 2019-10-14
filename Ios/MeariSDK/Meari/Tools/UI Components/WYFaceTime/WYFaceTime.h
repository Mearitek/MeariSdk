//
//  WYFaceTime.h
//  Meari
//
//  Created by FMG on 2017/8/21.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WY_FaceTime [WYFaceTime shareFaceTime]

static int const TotalNum = 20;

typedef NS_ENUM(NSInteger, WYFaceTimeType) {
    WYFaceTimeType_jpush  = 0,
    WYFaceTimeType_mqtt,
};
@interface WYFaceTime : UIView
@property (nonatomic, assign) BOOL answering;
@property (nonatomic, assign) BOOL disableOperation;
@property (nonatomic, assign) BOOL resetHideTime;
@property (nonatomic, assign) BOOL clickAPPLaunch;
@property (nonatomic, strong) WYPushModel *pushModel;
@property (nonatomic, assign) NSInteger MQTTID;
@property (nonatomic,   copy) NSString *visitorImg;

+ (instancetype)shareFaceTime;
- (void)showWithType:(WYFaceTimeType)type;
- (void)stopPreview;
- (void)dismiss;
- (void)playDoorbellSound;
- (void)stopDoorbellSound;
@end
