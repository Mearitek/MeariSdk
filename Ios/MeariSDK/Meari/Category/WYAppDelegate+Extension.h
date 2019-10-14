//
//  WYAppDelegate+Extension.h
//  Meari
//
//  Created by 李兵 on 16/7/18.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYAppDelegate.h"

#define WY_Appdelegate  ((WYAppDelegate *)[WY_Application delegate])
#define WY_SlideVC   ((SlideViewController *)([WY_Appdelegate.window.rootViewController isKindOfClass:[SlideViewController class]] ? WY_Appdelegate.window.rootViewController : nil))

@interface WYAppDelegate (Extension)

- (void)wy_initWithOption:(NSDictionary *)options;
- (void)wy_loadApp;
- (void)wy_loadLoginVC;
- (void)wy_loadCameraVC;
- (void)wy_loadMsgVC;
- (void)wy_loadFriendVC;
- (void)wy_loadMineVC;

@end

