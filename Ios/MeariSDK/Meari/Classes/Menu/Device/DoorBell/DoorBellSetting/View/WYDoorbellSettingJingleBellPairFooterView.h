//
//  WYDoorbellSettingJingleBellPairFooterView.h
//  Meari
//
//  Created by FMG on 2017/11/6.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYDoorbellSettingJingleBellPairFooterView;
@protocol WYDoorbellSettingJingleBellPairDelegate <NSObject>
@optional
- (void)doorbellSettingJingleBellPairFooterView:(WYDoorbellSettingJingleBellPairFooterView *)footerView didClickPairButton:(UIButton *)btn;
- (void)doorbellSettingJingleBellPairFooterView:(WYDoorbellSettingJingleBellPairFooterView *)footerView didClickUnbindButton:(UIButton *)btn;

@end

@interface WYDoorbellSettingJingleBellPairFooterView : UIView
@property (nonatomic,   weak) id<WYDoorbellSettingJingleBellPairDelegate>delegate;
@property (nonatomic,   copy) WYBlock_Void timeout;
- (void)startPairing;
- (void)failuredPairing;
- (void)successdPairing;
@end
