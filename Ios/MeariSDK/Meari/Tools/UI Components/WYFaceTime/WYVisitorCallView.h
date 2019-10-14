//
//  WYVisitorCallView.h
//  Meari
//
//  Created by FMG on 2017/8/22.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYVisitorCallView : UIView
@property (nonatomic,   copy) void(^receiveCall)();
@property (nonatomic,   copy) void(^refuseCall)();
@property (nonatomic, strong) MeariDevice *camera;
@property (nonatomic,   copy) NSString *visitorImg;

@end
