//
//  WYFriendListSearchView.h
//  Meari
//
//  Created by 李兵 on 2017/9/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBaseView.h"

@interface WYFriendListSearchView : WYBaseView
@property (nonatomic, copy)NSString *text;
@property (nonatomic, assign)BOOL enabled;
- (void)addTarget:(id)target action:(SEL)action;
@end
