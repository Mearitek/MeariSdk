//
//  WYVoiceCallView.h
//  Meari
//
//  Created by MJ2009 on 2018/7/9.
//  Copyright © 2018年 Meari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYVoiceCallView : UIView
@property (nonatomic, strong) MeariDevice *camera;
@property (nonatomic, strong) void(^hangUp)(void);
@property (nonatomic, strong) void(^receive)(void);
@property (nonatomic, strong) void(^mute)(BOOL isDisable);
@property (nonatomic, strong) void(^speak)(BOOL isDisable);
@end
