//
//  WYAlertView+Add.m
//  Meari
//
//  Created by 李兵 on 2017/1/18.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYAlertView+Add.h"

@implementation WYAlertView (Add)

#pragma mark -- Private
// 提示：无权限
+ (void)_showNeedAuthorityWithTitle:(NSString *)title description:(NSString *)description setAction:(WYBlock_Void)setAction {
    [WYAlertView showWithTitle:title message:description cancelButton:WYLocal_Cancel otherButton:WYLocal_Set alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            WYDo_Block_Safe(setAction)
        }
    }];
}

//升级
+ (void)showAppNeedUpdateWithForced:(BOOL)forced content:(NSString *)content updateAction:(WYBlock_Void)updateAction {
    if (forced) {
        [self forceShowWithTitle:WYLocalString(@"New version!") message:content cancelButton:nil otherButton:WYLocalString(@"UPDATE") alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == alertView.firstOtherButtonIndex) {
                WYDo_Block_Safe(updateAction)
            }
        }];
        return;
    }
    
    [self showWithTitle:WYLocalString(@"New version!") message:content cancelButton:WYLocalString(@"Not Now") otherButton:WYLocalString(@"UPDATE") alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            WYDo_Block_Safe(updateAction)
        }
    }];
}
+ (void)showDeviceNeedUpdateWithDescription:(NSString *)description stytle:(WYUIStytle)stytle cancelAction:(WYBlock_Void)cancelAction updateAction:(WYBlock_Void)updateAction {
    [self showWithTitle:WYLocalString(@"New version!") message:description.wy_attributedString cancelButton:WYLocal_Cancel otherButton:WYLocalString(@"UPDATE") alignment:NSTextAlignmentCenter stytle:stytle alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            WYDo_Block_Safe(updateAction)
        }else {
            WYDo_Block_Safe(cancelAction)
        }
    }];
}
+ (void)showSharedDeviceNeedUpdate:(WYBlock_Void)updateAction {
    [self showWithTitle:WYLocalString(@"New version!") message:WYLocalString(@"alert_deviceVersionLow_must") cancelButton:nil otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        WYDo_Block_Safe(updateAction)
    }];
}

//删除
+ (void)showDeleteFriend:(WYBlock_Void)deleteAction {
    [self showWithTitle:WYLocalString(@"Delete")
                message:WYLocalString(@"friend_del_des")
           cancelButton:WYLocal_Cancel
            otherButton:WYLocalString(@"Delete")
            alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == alertView.firstOtherButtonIndex) {
                    WYDo_Block_Safe_Main(deleteAction)
                }
            }];
}
+ (void)showMsg_DeleteWithOtherAction:(WYBlock_Void)otherAction {
    [self showWithTitle:WYLocalString(@"Delete") message:WYLocalString(@"DeleteAllMessages") cancelButton:WYLocal_Cancel otherButton:WYLocalString(@"Delete") alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            WYDo_Block_Safe(otherAction)
        }
    }];
}
+ (void)showMsg_AgreeRefuseWithDescription:(NSString *)description cancelAction:(WYBlock_Void)cancelAction otherAction:(WYBlock_Void)otherAction {
    [self softShowWithTitle:WYLocal_Tips message:description cancelButton:WYLocalString(@"Refuse") otherButton:WYLocalString(@"Agree") alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            WYDo_Block_Safe(cancelAction)
        }else {
            WYDo_Block_Safe(otherAction)
        }
    }];
}
//Mine
+ (void)showLogout:(WYBlock_Void)logoutAction {
    [self showWithTitle:WYLocalString(@"me_logout_alert")
                message:WYLocalString(@"me_logout_alert_des").wy_attributedString
           cancelButton:WYLocal_Cancel
            otherButton:WYLocal_OK
              alignment:NSTextAlignmentCenter
                 stytle:WYUIStytleCyan
            alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == alertView.firstOtherButtonIndex) {
                    WYDo_Block_Safe_Main(logoutAction)
                }
            }];
}


+ (void)showOKWithMessage:(NSString *)message{
    [self showWithTitle:nil message:message cancelButton:nil otherButton:WYLocal_OK alertAction:nil];
}
+ (void)showOKWithTitle:(NSString *)title message:(NSString *)message{
    [self showWithTitle:title message:message cancelButton:nil otherButton:WYLocal_OK alertAction:nil];
}

+ (void)showNoNetwork {
    [self showOKWithTitle:WYLocal_Tips message:WYLocalString(@"status_networkAbnormal")];
}
+ (void)showNoWifi {
    [self showOKWithTitle:WYLocal_Tips message:WYLocalString(@"error_notConnectWiFi")];
}
+ (void)showNoWifiPasswordWithCancelAction:(WYBlock_Void)cancelAction otherAction:(WYBlock_Void)otherAction {
    [self showWithTitle:WYLocal_Tips message:WYLocalString(@"warn_configureWifi") cancelButton:WYLocal_Cancel otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            WYDo_Block_Safe(cancelAction)
        }else {
            WYDo_Block_Safe(otherAction)
        }
    }];
}
+ (void)showAPWifiError {
    [self showWithTitle:WYLocalString(@"alert_noAPWIFI_t") message:[NSAttributedString attributedNoAPWIFI] cancelButton:WYLocalString(@"Get it") otherButton:nil alignment:NSTextAlignmentCenter alertAction:nil];
}
+ (void)showAPFailureWithCancelAction:(WYBlock_Void)cancelAction otherAction:(WYBlock_Void)otherAction {
    [self showWithTitle:WYLocalString(@"alert_apFail_deviceNoFound")  message:[NSAttributedString attributedAPFailure] cancelButton:WYLocal_Cancel otherButton:WYLocalString(@"Try again") alignment:NSTextAlignmentLeft alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
       if (buttonIndex == alertView.cancelButtonIndex) {
           WYDo_Block_Safe(cancelAction)
       }else {
           WYDo_Block_Safe(otherAction)
       }
   }];
}
+ (void)showSearchNullWithCancelAction:(WYBlock_Void)cancelAction otherAction:(WYBlock_Void)otherAction {
    [self showWithTitle:WYLocalString(@"alert_apFail_deviceNoFound") message:[NSAttributedString attributedSearchNull_nvr] cancelButton:WYLocal_Cancel otherButton:WYLocalString(@"Try again") alignment:NSTextAlignmentLeft alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            WYDo_Block_Safe(cancelAction)
        }else {
            WYDo_Block_Safe(otherAction)
        }
    }];
}
+ (void)showSearchCameraNullWithCancelAction:(WYBlock_Void)cancelAction qrAction:(WYBlock_Void)qrAction {
    [self softShowWithTitle:WYLocalString(@"ADD DEVICES") message:[NSAttributedString attributedSearchNull_qr] cancelButton:WYLocalString(@"Try again") otherButton:WYLocalString(@"CODE ADD") alignment:NSTextAlignmentLeft alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            WYDo_Block_Safe(cancelAction)
        }else {
            WYDo_Block_Safe(qrAction)
        }
    }];
}
+ (void)showSearchCameraNullWithCancelAction:(WYBlock_Void)cancelAction apAction:(WYBlock_Void)apAction {
    [self softShowWithTitle:WYLocalString(@"ADD DEVICES") message:[NSAttributedString attributedSearchNull_ap] cancelButton:WYLocalString(@"Try again") otherButton:WYLocalString(@"Manually Add") alignment:NSTextAlignmentLeft alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            WYDo_Block_Safe(cancelAction)
        }else {
            WYDo_Block_Safe(apAction)
        }
    }];
}
+ (void)showDeviceLowVersionWithStytle:(WYUIStytle)stytle {
    [self showWithTitle:WYLocal_Tips message:WYLocalString(@"alert_deviceVersionLow_m").wy_attributedString cancelButton:WYLocalString(@"Get it") otherButton:nil alignment:NSTextAlignmentCenter stytle:stytle alertAction:nil];
}
+ (void)showNoSDCardWithStytle:(WYUIStytle)stytle {
    [self showWithTitle:WYLocalString(@"alert_noSDCard_t") message:WYLocalString(@"alert_noSDCard_m").wy_attributedString cancelButton:nil otherButton:WYLocal_OK alignment:NSTextAlignmentCenter stytle:stytle alertAction:nil];
}

#pragma mark -- Need Authority
+ (void)showNeedAuthorityOfPhoto {
    [self _showNeedAuthorityWithTitle:WYLocalString(@"unauthorized_photo")
                          description:WYLocalString(@"unauthorized_photoDetail")
                            setAction:^{
        [WY_Application wy_jumpToAPPSetting];
    }];
}
+ (void)showNeedAuthorityOfMicrophone {
    [self _showNeedAuthorityWithTitle:WYLocalString(@"unauthorized_microPhone")
                          description:WYLocalString(@"unauthorized_microPhoneDetail")
                            setAction:^{
        [WY_Application wy_jumpToAPPSetting];
    }];
}
+ (void)showNeedAuthorityOfCamera {
    [self _showNeedAuthorityWithTitle:WYLocalString(@"unauthorized_camera")
                          description:WYLocalString(@"unauthorized_cameraDetail")
                            setAction:^{
        [WY_Application wy_jumpToAPPSetting];
    }];
}

#pragma mark -- mqtt
+ (void)show_Device_CancelShare:(NSString *)deviceName {
    NSString *msg = [NSString stringWithFormat:@"%@ %@ %@",WYLocalString(@"status_cancelDeviceSharedDesPrefix"),deviceName,WYLocalString(@"status_cancelDeviceSharedDesSuffix")];
    [WYAlertView showWithTitle:WYLocalString(@"status_cancelDeviceShared") message:msg cancelButton:nil otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
    }];
}
+ (void)show_Device_Online {
    [WYAlertView showWithTitle:WYLocalString(@"status_deviceStatus") message:WYLocalString(@"status_deviceOnline") cancelButton:WYLocal_OK otherButton:nil alertAction:nil];
}
+ (void)show_Device_Offline {
    [WYAlertView showWithTitle:WYLocalString(@"status_deviceStatus") message:WYLocalString(@"status_deviceOffline") cancelButton:WYLocal_OK otherButton:nil alertAction:nil];
}
+ (void)show_Device_OnlineTimeout:(WYBlock_Void)timeoutAction {
    [WYAlertView showWithTitle:WYLocalString(@"Warning!") message:WYLocalString(@"门铃已进入休眠状态！") cancelButton:nil otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        WYDo_Block_Safe(timeoutAction)
    }];
}
+ (void)show_User_LandInOtherPlaceWithOtherAction:(WYBlock_Void)otherAction {
    [WYAlertView showWithTitle:WYLocalString(@"Warning!") message:WYLocalString(@"status_landedOtherPlace") cancelButton:nil otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        WYDo_Block_Safe(otherAction)
    }];
}
+ (void)show_User_LoginInvalidWithOtherAction:(WYBlock_Void)otherAction {
    [WYAlertView showWithTitle:WYLocalString(@"Warning!") message:WYLocalString(@"status_loginInvalid") cancelButton:nil otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        WYDo_Block_Safe(otherAction)
    }];
}


+ (void)showNeedAuthorityOfLocationServices {
    [self _showNeedAuthorityWithTitle:WYLocalString(@"需要定位权限")
                          description:WYLocalString(@"在App设置页面进行设置")
                            setAction:^{
                                [WY_Application wy_jumpToAPPLocationServeSetting];
                            }];
}

@end
