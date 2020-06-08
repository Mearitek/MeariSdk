//
//  AppDelegate.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/4.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "AppDelegate.h"
#import <MeariKit/MeariKit.h>
#import <AVFoundation/AVFoundation.h>
static  NSString *app_key = @"8a48b2105058489aba0c08b79325ef3f";
static  NSString *app_secret = @"f6c33593133c44f98372f67213568411";
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     [[MeariSDK sharedInstance] startWithAppKey:app_key secretKey:app_secret];
     MearEnvironment env;
     env = MearEnvironmentRelease;
     [[MeariSDK sharedInstance] configEnvironment:env];
     [[MeariSDK sharedInstance] setLogLevel:MeariLogLevelVerbose];
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
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
#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
