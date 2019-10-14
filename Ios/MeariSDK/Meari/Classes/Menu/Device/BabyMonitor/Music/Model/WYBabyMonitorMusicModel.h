//
//  WYBabyMonitorMusicModel.h
//  Meari
//
//  Created by 李兵 on 2017/3/13.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MeariDevice;
@interface WYBabyMonitorMusicModel : NSObject

@property (nonatomic, copy)MeariMusicInfo *info;

@property (nonatomic, assign) WYBabyMonitorMusicStatus status;
@property (nonatomic, assign)NSInteger download_percent;

@end
