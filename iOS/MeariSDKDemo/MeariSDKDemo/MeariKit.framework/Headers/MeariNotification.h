//
//  MeariNotification.h
//  MeariKit
//
//  Created by duan on 2023/8/8.
//  Copyright © 2023 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>


UIKIT_EXTERN  NSString *const MeariUserLoginInvalidNotification;    //User login information is invalid, need to log in again (用户登录信息失效，需要重新登录)

UIKIT_EXTERN  NSString *const MeariDeviceOnlineNotification;        //Device online (设备上线)
UIKIT_EXTERN  NSString *const MeariDeviceOfflineNotification;       //Device offline(设备离线)


UIKIT_EXTERN  NSString *const MeariDeviceCancelSharedNotification;  //Device is unshared(设备被取消分享)
UIKIT_EXTERN  NSString *const MeariDeviceFriendSharedDeviceNotification;        //Friend sharing device(好友分享设备)
UIKIT_EXTERN  NSString *const MeariDeviceHasVisitorNotification;    //Device (doorbell) has visitors (设备(门铃)有访客)
UIKIT_EXTERN  NSString *const MeariDeviceHasBeenAnswerCallNotification;    //Device (doorbell) has be answered (设备(门铃)已经被接听)
UIKIT_EXTERN  NSString *const MeariDeviceVoiceBellHasVisitorNotification;    //Device (voice doorbell) has visitors (设备(门铃)有访客)
UIKIT_EXTERN  NSString *const MeariDeviceUnbundlingNotification;    //The device is unbundled (设备被解绑)


UIKIT_EXTERN  NSString *const MeariDeviceCloudPromotionNotification; // The device's Cloud Promotion is open (设备云存储促销活动开启)
UIKIT_EXTERN NSString *const MeariDeviceAIPromotionNotification;  // The device's AI Promotion is open (设备AI促销活动开启)
UIKIT_EXTERN NSString *const MeariDeviceCloudSubscriptionNotification; // The device's Cloud Subscription succeed (设备云存储订阅成功)
UIKIT_EXTERN NSString *const MeariDeviceAISubscriptionNotification; // The device's AI Subscription succeed (设备AI订阅成功)

UIKIT_EXTERN  NSString *const MeariDeviceAutoAddNotification; //Automatic device add (设备自动添加)
UIKIT_EXTERN  NSString *const MeariDeviceAutoAddFailureNotification; //Automatic device add failure (设备自动添加失败)

UIKIT_EXTERN  NSString *const MeariDeviceConnectMqttNotification; // mqtt connect (mqtt连接)
UIKIT_EXTERN  NSString *const MeariDeviceBindToChimeNotification; // bind chime success (chime 绑定成功)

UIKIT_EXTERN  NSString *const MeariDeviceNewShareToMeNotification; //New share notification (新版分享发送通知)
UIKIT_EXTERN  NSString *const MeariDeviceNewShareToHimNotification; //New share notification (新版分享发送通知)
UIKIT_EXTERN  NSString *const MeariDeviceSharePermissionChangeNotification; //device share premisson change (分享设备权限发生改变)

UIKIT_EXTERN  NSString *const MeariDeviceFloodCameraStatusNotification; // the status of the floot camera (灯具摄像机的开关状态)

UIKIT_EXTERN  NSString *const MeariUserNoticeNotification; // app receive a notice message (接收到通知公告消息)
UIKIT_EXTERN  NSString *const MeariUserMqttAliConnectedNotification; // Ali mqtt connected
UIKIT_EXTERN  NSString *const MeariUserMqttAliDisconnectedNotification ; // Ali mqtt disconnected
UIKIT_EXTERN  NSString *const MeariUserMqttAWSConnectedNotification; // Amazon mqtt connected
UIKIT_EXTERN  NSString *const MeariUserMqttAWSDisconnectedNotification ; // Amazon mqtt disconnected disconnected
UIKIT_EXTERN NSString *const MeariIotLoginNotification; // Meari Iot 登录
UIKIT_EXTERN NSString *const MeariIotLogoutNotification ; // Meari Iot 登出
UIKIT_EXTERN NSString *const MeariIotDeviceOnlineNotification; //Meari iot device online 设备iot上下线通知



UIKIT_EXTERN NSString *const MeariIotCustomerServerMessageAccept ; //Customer Service Message Accept new message （客服消息接收）
UIKIT_EXTERN NSString *const MeariIotCustomerServerMessageRead ; //Customer Service Message read（客服消息已读）

UIKIT_EXTERN NSString *const MeariIotCustomerServerFeedBackRemind ; //Customer service feedback message reminder（客服反馈消息提醒）
UIKIT_EXTERN NSString *const MeariIotCustomerServerRemind ; //Customer service message reminder（客服聊天消息提醒）

UIKIT_EXTERN NSString *const MeariIotCustomerServerChange ; //Customer service change（客服聊天切换客服）



UIKIT_EXTERN NSString *const MeariIotDeviceAlarmFrequentNotification ; //device alarm frequent （设备报警频繁）
UIKIT_EXTERN NSString *const MeariIotDeviceAlarmDistortNotification ;//device alarm distort （设备报警误报频繁）
UIKIT_EXTERN NSString *const MeariIotDeviceSimTrafficNotification ;//device flow reminder （设备流量提醒）
UIKIT_EXTERN NSString *const MeariIotDeviceCheckPasswordNotification ;//设备密码校验
UIKIT_EXTERN NSString *const MeariIotDeviceAutoReducePirLevelNotification ;//device auto reduce pir Level （设备自动降低pir灵敏度）

UIKIT_EXTERN NSString *const MeariPrtpDeviceConnectChange;//prtp device connect change （prtp设备连接变化）

UIKIT_EXTERN NSString *const MeariDeviceStreamAutoChange; //Device Preview Stream Auto change (设备自适应码流变化)
