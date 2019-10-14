//
//  WYMeLoginView.h
//  Meari
//
//  Created by 李兵 on 2017/9/18.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBaseView.h"
@class WYMeLoginView;
@class WYCountryView;
@protocol WYMeLoginViewDelegate <NSObject>
- (NSArray <NSString *>*)WYMeLoginViewRecordedUsers:(WYMeLoginView *)loginView;
@optional
- (void)WYMeLoginView:(WYMeLoginView *)loginView deleteUser:(NSString *)userAccount;
- (void)WYMeLoginView:(WYMeLoginView *)loginView chooseUser:(NSString *)userAccount;
- (void)WYMeLoginView:(WYMeLoginView *)loginView didTapForgotBtn:(UIButton *)btn;
- (void)WYMeLoginView:(WYMeLoginView *)loginView didTapLoginBtn:(UIButton *)btn;
- (void)WYMeLoginView:(WYMeLoginView *)loginView didTapSignupBtn:(UIButton *)btn;
- (void)WYMeLoginView:(WYMeLoginView *)loginView didTapDropdownBtn:(UIButton *)btn;
- (void)WYMeLoginView:(WYMeLoginView *)loginView didTapCountry:(WYCountryView *)countryView;

@end

@interface WYMeLoginView : WYBaseView
@property (nonatomic, weak)id<WYMeLoginViewDelegate>delegate;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign, readonly, getter=isUidLogined) BOOL uidLogined;
- (void)showWithMask:(BOOL)mask;
- (void)setAccountPlaceholder:(NSString *)placeholder;
@end
