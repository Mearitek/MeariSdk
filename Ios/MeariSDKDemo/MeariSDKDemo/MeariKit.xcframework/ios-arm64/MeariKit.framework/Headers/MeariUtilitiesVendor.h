//
//  MeariUtilitiesVendor.h
//  MeariKit
//
//  Created by Meari on 2017/12/18.
//  Copyright © 2017年 Meari. All rights reserved.
//

#ifndef MeariUtilitiesVendor_h
#define MeariUtilitiesVendor_h

static MeariDDLogLevel ddLogLevel = MeariDDLogLevelVerbose;

#define MRLog(fmt, ...)              BaseLogVerbose(fmt, ##__VA_ARGS__)
#define MRLogStart(arg, fmt, ...)    MRLog(@"⌛️ <*%@*> start..." fmt, arg, ##__VA_ARGS__)
#define MRLogSuc(arg, fmt, ...)      MRLog(@"✅ <*%@*> success!--" fmt, arg, ##__VA_ARGS__)
#define MRLogFail(arg, fmt, ...)     BaseLogError(@"❌ <*%@*> failed!--" fmt, arg, ##__VA_ARGS__)
#define MRLogWarn(arg, fmt, ...)     BaseLogWarn(@"⚠️ <*%@*> failed!--" fmt, arg, ##__VA_ARGS__)


#define MRLogUser(user,fmt, ...)              BaseLogUserVerbose(user,fmt, ##__VA_ARGS__)
#define MRLogUserStart(user,arg, fmt, ...)    MRLogUser(user,@"⌛️ <*%@*> start..." fmt, arg, ##__VA_ARGS__)
#define MRLogUserSuc(user,arg, fmt, ...)      MRLogUser(user,@"✅ <*%@*> success!--" fmt, arg, ##__VA_ARGS__)
#define MRLogUserFail(user,arg, fmt, ...)     BaseLogUserError(user,@"❌ <*%@*> failed!--" fmt, arg, ##__VA_ARGS__)
#define MRLogUserWarn(user,fmt, ...)          BaseLogUserWarn(user,@"⚠️ <*%@*> warning!--" fmt, arg, ##__VA_ARGS__)


#define MRLogDevice(dev, fmt, ...)              BaseLogDeviceVerbose(dev, fmt, ##__VA_ARGS__)
#define MRLogDeviceStart(dev, arg, fmt, ...)    MRLogDevice(dev, @"⌛️ <*%@*> start..." fmt, arg, ##__VA_ARGS__)
#define MRLogDeviceSuc(dev, arg, fmt, ...)      MRLogDevice(dev, @"✅ <*%@*> success!--" fmt, arg, ##__VA_ARGS__)
#define MRLogDeviceFail(dev, arg, fmt, ...)     BaseLogDeviceError(dev, @"❌ <*%@*> failed!--" fmt, arg, ##__VA_ARGS__)
#define MRLogDeviceWarn(dev, arg, fmt, ...)     BaseLogDeviceError(dev, @"⚠️ <*%@*> warning!--" fmt, arg, ##__VA_ARGS__)

#pragma mark - Base
#pragma mark -- com
#define BaseLogVerbose(fmt, ...)     MeariDDLogVerbose(@"[MeariKit]" fmt, ##__VA_ARGS__)
#define BaseLogError(fmt, ...)       MeariDDLogError(@"[MeariKit]" fmt, ##__VA_ARGS__)
#define BaseLogWarn(fmt, ...)        MeariDDLogWarn(@"[MeariKit]" fmt, ##__VA_ARGS__)
#define MR_Bool(boolV,yesV,noV)      ((boolV) ? (yesV) : (noV))

#pragma mark -- user
#define BaseLogUserVerbose(user,fmt, ...)                MeariDDLogVerbose(@"[MeariKit][User:%p]" fmt,user, ##__VA_ARGS__)
#define BaseLogUserError(user,fmt, ...)              MeariDDLogVerbose(@"[MeariKit][User:%p]" fmt,user, ##__VA_ARGS__)
#define BaseLogUserWarn(user,fmt, ...)              MeariDDLogVerbose(@"[MeariKit][User:%p]" fmt,user, ##__VA_ARGS__)

#pragma mark -- device
#define BaseLogDeviceError(dev,fmt, ...)        MeariDDLogError(@"[MeariKit][Device:%p]" fmt,dev, ##__VA_ARGS__)
#define BaseLogDeviceWarn(dev,fmt, ...)     MeariDDLogWarn(@"[MeariKit][Device:%p]" fmt,dev, ##__VA_ARGS__)
#define BaseLogDeviceVerbose(dev,fmt, ...)  MeariDDLogVerbose(@"[MeariKit][Device:%p]" fmt,dev, ##__VA_ARGS__)

#endif /* MeariUtilitiesVendor_h */
