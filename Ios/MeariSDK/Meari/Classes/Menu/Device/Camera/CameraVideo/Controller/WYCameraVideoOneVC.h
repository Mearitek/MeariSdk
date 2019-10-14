//
//  WYCameraVideoOneVC.h
//  Meari
//
//  Created by 李兵 on 2016/11/26.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYCameraVideoView.h"
@interface WYCameraVideoOneVC : WYBaseVC

@property (nonatomic, weak)WYCameraVideoView *videoView;
@property (nonatomic, weak)UIImageView *deviceTypeImageView;
@property (nonatomic, assign)WYVideoType videoType;

@end
