//
//  WYVideo.m
//  Meari
//
//  Created by 李兵 on 2016/11/28.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYVideo.h"

@implementation WYVideo
+ (instancetype)videoWithCamera:(MeariDevice *)camera videoType:(WYVideoType)videoType dateComponets:(NSDateComponents *)dateComponents {
    WYVideo *video = [[WYVideo alloc] init];
    video.camera = camera;
    video.videoType = videoType;
    video.dateComponets = dateComponents ? dateComponents : [NSDateComponents todayZero];
    return video;
}

@end
