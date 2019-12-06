//
//  WYAppDelegate.m
//  Meari
//
//  Created by 李兵 on 15/12/23.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import "WYAppDelegate.h"

@implementation WYAppDelegate
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [WYPushManager resetBadgeNumber];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self wy_initWithOption:launchOptions];
    [self wy_loadApp];
    return YES;
}


#pragma mark -- Push
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    [WYPushManager registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
    
    if (!WY_UserM.isLogined) return;
    [WYPushManager dealPushInfo:userInfo userClicked:application.applicationState != UIApplicationStateActive];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //MeariKit will mute when the iphone in mute status. Use this code the iphone's mute status not effect MeariKit play sound.
    AVAudioSessionRouteDescription *currentRount = [AVAudioSession sharedInstance].currentRoute;
    for (AVAudioSessionPortDescription* outputPortDesc in [currentRount outputs]) {
        if([outputPortDesc.portType isEqualToString:AVAudioSessionPortBluetoothA2DP] || [outputPortDesc.portType isEqualToString:AVAudioSessionPortHeadphones]){
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
        } else {
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        }
    }
    if ([AVAudioSession sharedInstance].category == AVAudioSessionCategorySoloAmbient) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
}

@end
