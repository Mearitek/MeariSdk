//
//  LeftModel.m
//  Meari
//
//  Created by 李兵 on 16/2/27.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYMenuModel.h"

@implementation WYMenuModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showReddot = NO;
    }
    return self;
}

+ (instancetype)deviceMenu {
    return [WYMenuModel menuWithMenuType:WYMenuTypeCamera
                                   title:WYLocalString(@"MY DEVICE")
                             normalImage:@"img_menu_mydevice_normal"
                        highlightedImage:@"img_menu_mydevice_highlighted"
                              showReddot:NO];
}
+ (instancetype)msgMenu {
    return [WYMenuModel menuWithMenuType:WYMenuTypeMsg
                                   title:WYLocalString(@"MESSAGE")
                             normalImage:@"img_menu_message_normal"
                        highlightedImage:@"img_menu_message_highlighted"
                              showReddot:NO];
}
+ (instancetype)friendMenu {
    return [WYMenuModel menuWithMenuType:WYMenuTypeFriend
                                   title:WYLocalString(@"friend_title")
                             normalImage:@"img_menu_friend_normal"
                        highlightedImage:@"img_menu_friend_highlighted"
                              showReddot:NO];
}
+ (instancetype)menuWithMenuType:(WYMenuType)type
                           title:(NSString *)title
                     normalImage:(NSString *)normalImageName
                highlightedImage:(NSString *)highlightedImageName
                      showReddot:(BOOL)showReddot{
    WYMenuModel *model = [WYMenuModel new];
    model.menuType = type;
    model.title = title;
    model.normalImage = normalImageName;
    model.highlightedImage = highlightedImageName;
    model.highlighted      = NO;
    model.showReddot = showReddot;
    return model;
}
@end
