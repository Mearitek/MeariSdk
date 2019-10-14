//
//  SVProgressHUD+Add.h
//  Meari
//
//  Created by 李兵 on 2016/12/9.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#define WY_HUD_SHOW_SUCCESS_STATUS_VC(string, vc) \
[SVProgressHUD showSuccessString:string toast:NO inVC:vc];

#define WY_HUD_SHOW_FAILURE_STATUS_VC(string, vc) \
[SVProgressHUD showFailureString:string toast:NO inVC:vc];

#define WY_HUD_SHOW_Toast_VC(string, vc) \
[SVProgressHUD showSuccessString:string toast:YES inVC:vc];

#define WY_HUD_SHOW_TOAST(arg)              [SVProgressHUD wy_showToast:arg];

#define WY_HUD_SHOW_Loading(arg)            [SVProgressHUD wy_showLoading:arg];
#define WY_HUD_SHOW_WAITING                 WY_HUD_SHOW_Loading(WYLocalString(@"status_wait"))
#define WY_HUD_SHOW_STATUS(arg)             [SVProgressHUD wy_showStatus:arg];
#define WY_HUD_SHOW_NOEMOJI                 WY_HUD_SHOW_STATUS(WYLocalString(@"error_notSupportEmoji"))

#define WY_HUD_SHOW_SUCCESS_STATUS(arg)     [SVProgressHUD wy_showSuccess:arg];
#define WY_HUD_SHOW_SUCCESS                 WY_HUD_SHOW_SUCCESS_STATUS(WYLocalString(@"status_Success"))

#define WY_HUD_SHOW_ERROR(err)              [SVProgressHUD wy_showErrorWithError:err];
#define WY_HUD_SHOW_ERROR_STATUS(arg)       [SVProgressHUD wy_showError:arg];
#define WY_HUD_SHOW_Failure                 WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"status_networkError"))
#define WY_HUD_SHOW_ServerError             WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"status_serverAbnormal"))

#define WY_HUD_DISMISS                      [SVProgressHUD dismiss];


@interface SVProgressHUD (Add)
@property (nonatomic, copy)UIControl *wy_assistOverlay;

+ (void)showSuccessString:(NSString *)successString toast:(BOOL)toast inVC:(UIViewController *)vc;
+ (void)showFailureString:(NSString *)failureString toast:(BOOL)toast inVC:(UIViewController *)vc;

+ (void)wy_showToast:(NSString *)text;
+ (void)wy_showStatus:(NSString *)text;
+ (void)wy_showSuccess:(NSString *)text;
+ (void)wy_showError:(NSString *)text;
+ (void)wy_showLoading:(NSString *)text;
+ (void)wy_showErrorWithError:(NSError *)error;



@end
