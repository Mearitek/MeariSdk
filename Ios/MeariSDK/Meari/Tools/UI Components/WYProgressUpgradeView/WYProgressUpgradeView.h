//
//  WYProgressUpgradeView.h
//  ProgressGourpView
//
//  Created by 李兵 on 2016/12/8.
//  Copyright © 2016年 李兵. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYProgressUpgradeView;
@protocol WYProgressUpgradeViewDelegate <NSObject>

@optional
- (void)WYProgressUpgradeViewWillUpgrade:(WYProgressUpgradeView *)upgradeView;
- (void)WYProgressUpgradeViewBeginUpgrade:(WYProgressUpgradeView *)upgradeView;
- (void)WYProgressUpgradeViewUpdgradeSuccess:(WYProgressUpgradeView *)upgradeView;
- (void)WYProgressUpgradeViewUpdgradeSuccess:(WYProgressUpgradeView *)upgradeView lajibuding:(BOOL)lajibuding;
- (void)WYProgressUpgradeViewDidDoneUpgrade:(WYProgressUpgradeView *)upgradeView;

@end

@interface WYProgressUpgradeView : WYBaseView
@property (nonatomic, weak)id<WYProgressUpgradeViewDelegate> delegate;

@property (nonatomic, assign)CGFloat progress;
@property (nonatomic, assign)NSInteger progressWidth;

+ (instancetype)upgradeViewWithBeginText:(NSString *)beginText prepareText:(NSString *)prepareText endText:(NSString *)endText;
- (void)prepareToUpdate;
- (void)reset;
- (void)setDone;
@end
