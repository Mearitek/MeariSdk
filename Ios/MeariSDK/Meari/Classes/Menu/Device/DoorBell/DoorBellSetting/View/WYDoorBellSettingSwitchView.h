//
//  WYDoorBellSettingSwitchView.h
//  Meari
//
//  Created by FMG on 2017/7/26.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYDoorBellSettingSwitchView;
@protocol WYDoorBellSettingSwitchViewDelegate <NSObject>

@optional
- (void)doorBellSettingSwitchView:(WYDoorBellSettingSwitchView *)view switchOpen:(BOOL)open;

@end

@interface WYDoorBellSettingSwitchView : UIView
@property (nonatomic, weak) id<WYDoorBellSettingSwitchViewDelegate>delegate;
- (instancetype)initWithSwTitle:(NSString *)swTitle description:(NSString *)description;
- (BOOL)isOpen ;
- (void)setSwitchOpen:(BOOL)open;
- (NSInteger)viewHeight ;
@end
