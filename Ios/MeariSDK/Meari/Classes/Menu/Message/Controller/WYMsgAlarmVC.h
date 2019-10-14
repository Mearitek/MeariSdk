//
//  WYMsgAlarmVC.h
//  Meari
//
//  Created by 李兵 on 15/12/28.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface WYMsgAlarmVC : WYBaseSubVC<WYEditManagerDelegate>

@property (nonatomic, copy)void(^didSelectCellBlock)(NSString *, NSInteger);

- (void)networkRequestFromPush;


@end
NS_ASSUME_NONNULL_END
