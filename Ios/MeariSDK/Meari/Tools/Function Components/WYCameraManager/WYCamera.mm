//
//  WYCamera.m
//  Meari
//
//  Created by 李兵 on 2016/11/25.
//  Copyright © 2016年 PPStrong. All rights reserved.
//
//
//	WYCamera.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "WYCamera.h"
#import <objc/message.h>
#import "WYNVRModel.h"
#import "WYBabyMonitorMusicModel.h"


#define WYCameraInStatus(arg)   (([self cameraPlayStatus] & arg) == arg)
#define WYLogCamSuc(format, ...) NSLog(@"✅ camera--" format, ##__VA_ARGS__);
#define WYLogCamFail(format, ...) NSLog(@"❌ camera--" format, ##__VA_ARGS__);
#define WYLogCamSelf(format, ...) NSLog(@"🔮--camera:%@--🔮" format, self, ##__VA_ARGS__);
#define WYLogCam(format, ...) NSLog(@"🔮🔮" format, ##__VA_ARGS__);
#define WYLogCamP(format, ...) NSLog(@"🔮获取参数:" format, ##__VA_ARGS__);
#define WYLogCamS(format, ...) NSLog(@"🔮获取状态:" format, ##__VA_ARGS__);

@interface WYCamera ()

@property (nonatomic, copy)NSString *recordPath;
@property (nonatomic, strong)PPSPlayer *player;
@property (nonatomic, weak)PPSGLView *playView;
@property (nonatomic, weak)PPSGLView *playbackView;
@end

@implementation WYCamera
#pragma mark - 归档
WY_CoderAndCopy

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p>---%@", self.class, self, @{@"uuid" : WY_SafeStringValue(self.deviceUUID),
                                               @"sn" : WY_SafeStringValue(self.snNum),
                                               @"tp" : WY_SafeStringValue(self.tp),
                                               @"name" : WY_SafeStringValue(self.deviceName),
                                               @"hostkey" : WY_SafeStringValue(self.hostKey),
                                               @"nvruuid" : WY_SafeStringValue(self.nvrUUID),
                                               @"nvrnum" : WY_SafeStringValue(self.nvrNum),
                                               @"nvrkey" : WY_SafeStringValue(self.nvrKey),
                                               @"nvrID" : WY_SafeStringValue(@(self.nvrID)),
                                               @"deviceType":self.deviceTypeString
                                               }];
}
- (NSString *)searchModeDescription:(WYCameraSearchMode)mode {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    if (WY_ContainOption(mode, WYCameraSearchModeLan)) [arr addObject:@"局域网"];
    if (WY_ContainOption(mode, WYCameraSearchModeCloud_Smartwifi)) [arr addObject:@"云(smartwifi)"];
    if (WY_ContainOption(mode, WYCameraSearchModeCloud_AP)) [arr addObject:@"云(ap)"];
    if (WY_ContainOption(mode, WYCameraSearchModeCloud_QRCode)) [arr addObject:@"云(qrcode)"];
    NSString *str = [arr componentsJoinedByString:@"+"];
    return str;
}
- (NSString *)tokenModeDescription:(WYCameraTokenType)mode {
    if (mode == WYCameraTokenTypeSmartwifi) return @"smartwifi";
    if (mode == WYCameraTokenTypeAP) return @"ap";
    if (mode == WYCameraTokenTypeQRCode) return @"qrcode";
    return nil;
}

#pragma mark - Add
- (NSString *)deviceTypeString {
    switch (self.deviceType) {
        case WYDeviceTypeCamera:
            return @"This is Camera";
        case WYDeviceTypeNVR:
            return @"This is NVR";
        case WYDeviceTypeBabyMonitor:
            return @"This is BabyMonitor";
        default:
            return @"未知设备";
    }
}
- (BOOL)usableNVR {
    BOOL usable = self.nvrID > 0 && self.nvrUUID.length > 0;
    WYLogCamS(@"NVR状态:%@", usable ? @"可用" : @"不可用")
    return usable;
}
- (void)setUsableNVR:(BOOL)usableNVR {
    if (!usableNVR) {
        self.nvrID = 0;
        self.nvrUUID = nil;
    }
}
- (BOOL)babyMonitor {
    _babyMonitor = self.deviceType == WYDeviceTypeBabyMonitor;
    return _babyMonitor;
}
- (BOOL)doorBell {
    _doorBell = self.deviceType == WYDeviceTypeDoorBell;
    return _doorBell;
}
- (BOOL)versionIsOld {
    _versionIsOld = self.protocolVersion < 2;
    WYLogCamS(@"设备版本:%ld=%@ deviceID:%ld sn:%@", (long)_protocolVersion, _versionIsOld ? @"老版本" : @"新版本", (long)self.deviceID, self.snNum)
    return _versionIsOld;
}
- (BOOL)sdkLogined {
    _sdkLogined = WYCameraInStatus(CameraStatusLogin);
    WYLogCamS(@"是否已登录: %d", _sdkLogined)
    return _sdkLogined;
}
- (BOOL)sdkLogining {
    _sdkLogining = WYCameraInStatus(CameraStatusLogining);
    WYLogCamS(@"是否正在登录: %d", _sdkLogining)
    return _sdkLogining;
}
- (BOOL)sdkPlaying {
    _sdkPlaying = WYCameraInStatus(CameraStatusPlay);
    WYLogCamS(@"是否正在播放: %d", _sdkPlaying)
    return _sdkPlaying;
}
- (BOOL)sdkPlayRecord {
    _sdkPlayRecord = WYCameraInStatus(CameraStatusPlayRecord);
    WYLogCamS(@"是否正在回放: %d", _sdkPlaying)
    return _sdkPlayRecord;
}
- (NSInteger)videoid {
    _videoid = self.usableNVR ? self.snNum.integerValue : 0;
    WYLog(@"videoID:%ld", (long)_videoid);
    return _videoid;
}
- (UIImage *)thumbImage {
    _thumbImage = nil;
    NSString *thumbFile = [NSFileManager thumbFile:self.snNum];
    if ([[NSFileManager defaultManager] fileExistsAtPath:thumbFile]) {
        _thumbImage = [UIImage imageWithContentsOfFile:thumbFile];
    }
    return _thumbImage;
}
- (PPSPlayer *)player {
    if (!_player) {
//        _player = [[PPSPlayer alloc] init];
        _player = [PPSPlayer playerWithSearchBaseUrl:[NSString stringWithFormat:@"%@/", WY_URLJAVA_PATH]];
    }
    return _player;
}
- (NSString *)connectName {
    if (!_connectName) {
        _connectName = @"admin";
    }
    return _connectName;
}
- (WYUIStytle)uistytle {
    _uistytle = self.babyMonitor ? WYUIStytleOrange : WYUIStytleDefault;
    return _uistytle;
}
- (instancetype)initWithNVRModel:(WYNVRModel *)model {
    self = [super init];
    if (self) {
        self.deviceType = WYDeviceTypeNVR;
        self.deviceID = self.nvrID = model.nvrID;
        self.hostKey = self.nvrKey = model.nvrKey;
        self.deviceName = model.nvrName;
        self.snNum = self.nvrNum = model.nvrNum;
        self.deviceP2P = model.nvrP2P;
//        self.deviceTypeName = model.nvrTypeName;
        self.deviceUUID = self.nvrUUID = model.nvrUUID;
        self.deviceVersionID = model.nvrVersionID;
        self.updateVersion = model.updateVersion;
        self.userAccount = model.userAccount;
        self.asFriend = model.shared;
    }
    return self;
}




+ (instancetype)instanceWithMeariIPC:(MeariIpc *)ipc {
    WYCamera *camera = [WYCamera new];
    camera.isBindingTY = ipc.isBindingTY;
    camera.userFlag = ipc.userFlag;
    camera.longitude = ipc.longitude;
    camera.timeZone2 = ipc.timeZone2;
    camera.bellVoice = ipc.bellVoice;
    camera.deviceTypeName = ipc.deviceTypeName;
    camera.deviceP2P = ipc.deviceP2P;
    camera.deviceUUID = ipc.deviceUUID;
    camera.deviceName = ipc.deviceName;
    camera.devUid = ipc.devUid;
    camera.closePush = ipc.closePush;
    camera.deviceVersionID = ipc.deviceVersionID;
    camera.nvrNum = ipc.nvrNum;
    camera.userID = ipc.userID;
    camera.devTypeID = ipc.devTypeID;
    camera.userAccount = ipc.userAccount;
    camera.deviceImg = ipc.deviceImg;
    camera.devStatus = ipc.devStatus;
    camera.nvrKey = ipc.nvrKey;
    camera.timeZone = ipc.timeZone;
    camera.radius = ipc.radius;
    camera.asFriend = ipc.asFriend;
    camera.nvrID = ipc.nvrID;
    camera.hasAlertMsg = ipc.hasAlertMsg;
    camera.nvrPort = ipc.nvrPort;
    camera.updateVersion = ipc.updateVersion;
    camera.updatePersion = ipc.updatePersion;
    camera.deviceID = ipc.deviceID;
    camera.sleep = ipc.sleep;
    camera.nvrUUID = ipc.nvrUUID;
    camera.latitude = ipc.latitude;
    camera.protocolVersion = ipc.protocolVersion;
    camera.snNum = ipc.snNum;
    camera.hostKey = ipc.hostKey;
    camera.firmID = ipc.firmID;
    WYCameraCapability *cap = [WYCameraCapability new];
    WYCameraCapabilityFunc *func = [WYCameraCapabilityFunc new];
    func.vtk = (WYCameraCapabilityVTKType)ipc.capability.caps.vtk;
    func.fcr = ipc.capability.caps.fcr;
    func.dcb = ipc.capability.caps.dcb;
    func.md = ipc.capability.caps.md;
    func.ptz = ipc.capability.caps.ptz;
    func.tmpr = ipc.capability.caps.tmpr;
    func.hmd = ipc.capability.caps.hmd;
    func.pir = ipc.capability.caps.pir;
    func.cst = ipc.capability.caps.cst;
    cap.ver = ipc.capability.ver;
    cap.cat = ipc.capability.cat;
    cap.caps = func;
    camera.capability = cap;
    return camera;
}
+ (instancetype)instanceWithMeariBell:(MeariBell *)bell {
    return [self instanceWithMeariIPC:bell];
}




- (instancetype)nvrCamera {
    WYCamera *camera = self.copy;
    camera.devTypeID = 1;
    camera.deviceType = WYDeviceTypeNVR;
    camera.deviceUUID = camera.nvrUUID;
    camera.hostKey = camera.nvrKey;
    return camera;
}
- (void)resetPlayer {
    _player = nil;
}
- (void)setDevTypeID:(NSInteger)devTypeID {
    _devTypeID = devTypeID;
    switch (devTypeID) {
        case 1: {
            _deviceType = WYDeviceTypeNVR;
            break;
        }
        case 2: {
            _deviceType = WYDeviceTypeCamera;
            break;
        }
        case 3: {
            _deviceType = WYDeviceTypeBabyMonitor;
            break;
        }
        case 4: {
            _deviceType = WYDeviceTypeDoorBell;
            break;
        }
        default:
            break;
    }
}
- (BOOL)needForceUpdate {
    return [self.updatePersion isEqualToString:@"Y"];
}
- (void)setNeedForceUpdate:(BOOL)needForceUpdate {
    self.updatePersion = needForceUpdate ? @"Y" : @"N";
}
- (NSDateComponents *)playbackTime {
    NSUInteger timestamp = [self.player getPlaybackTime];
    NSDateComponents *dateC;
    dateC = [NSDateComponents wy_dateComponetsOfUTC0WithTimestamp:timestamp];
    WYLogCam(@"timestamp:%lu %@",timestamp, [dateC timeStringWithNoSprit]);
    return dateC;
}

#pragma mark -- 能力集
- (WYCameraCapability *)capability {
    if (!_capability) {
        switch (self.deviceType) {
            case WYDeviceTypeNVR: {
                _capability = [WYCameraCapability defaultNVR];
                break;
            }
            case WYDeviceTypeCamera: {
                _capability = [WYCameraCapability defaultCamera];
                break;
            }
            case WYDeviceTypeBabyMonitor: {
                _capability = [WYCameraCapability defaultBabyMonitor];
                break;
            }
            case WYDeviceTypeDoorBell: {
                _capability = [WYCameraCapability defaultDoorBell];
                break;
            }
            default:
                break;
        }
    }
    return _capability;
}
- (BOOL)supportVoiceTalk {
    if (self.capability.caps) {
        return self.capability.caps.vtk == WYCameraCapabilityVTKTypeHalfDuplex || self.capability.caps.vtk == WYCameraCapabilityVTKTypeFullDuplex;
    }
    return YES;
}
- (BOOL)supportFullDuplex {
    if (self.capability.caps) {
        return self.capability.caps.vtk == WYCameraCapabilityVTKTypeFullDuplex;
    }
    return NO;
}


#pragma mark -- Utilities
- (int)errorCodeFromErrorString:(NSString *)errorString {
    NSDictionary *dic = errorString.wy_jsonDictionary;
    int errorCode = WY_SafeStringValue(dic[@"code"]).intValue;
    return errorCode;
}
- (int)errorHttpCodeFromErrorString:(NSString *)errorString {
    NSDictionary *dic = errorString.wy_jsonDictionary;
    int errorCode = WY_SafeStringValue(dic[@"http_errorcode"]).intValue;
    return errorCode;
}
- (_PLAY_MODE)playModeWithPreviewing:(BOOL)isPreviewing {
    _PLAY_MODE mode = isPreviewing ? PLAY_MODE : PLAYBACK_MODE;
    WYLogCamS(@"%@", mode == PLAY_MODE ? @"在预览" : @"在回放")
    return mode;
}

#pragma mark - SDK
#pragma mark -- 查询在线
- (void)checkOnlineStatusSuccess:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"开始查询在线状态")
    [self.player checkDevOnlineStatus:self.deviceUUID success:^(id result) {
        WYLogCamSuc(@"查询在线状态成功：result:-----%@-----", result);
        WYDo_Block_Safe_Main1(success, result)
    } failure:^(NSString *error) {
        WYLogCamFail(@"查询在线状态失败：error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}

#pragma mark -- 搜索 & 配网
- (void)startSearch:(WYCameraSearchMode)mode success:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    WYLogCam(@"开始搜索:%@ 当前wifi:%@", [self searchModeDescription:mode], WY_WiFiM.currentSSID)
    SEARCH_MODE searchmode = SEARCH_MODE_LAN;
    switch (mode) {
        case WYCameraSearchModeLan: searchmode = SEARCH_MODE_LAN; break;
        case WYCameraSearchModeCloud_Smartwifi: searchmode = SEARCH_MODE_CLOUD_SMARTWIFI; break;
        case WYCameraSearchModeCloud_AP: searchmode = SEARCH_MODE_CLOUD_AP; break;
        case WYCameraSearchModeCloud_QRCode: searchmode = SEARCH_MODE_CLOUD_QRCODE; break;
        case WYCameraSearchModeCloud: searchmode = SEARCH_MODE_CLOUD; break;
        case WYCameraSearchModeAll: searchmode = SEARCH_MODE_ALL; break;
        default: break;
    }
    [self.player startSearchWithMode:searchmode success:^(id result) {
        WYLogCamSuc(@"搜索成功：result:-----%@-----", result);
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            if (dic) {
                WYCamera *camera = [[WYCamera alloc] init];
                camera.deviceUUID = WY_SafeStringValue(dic[@"p2p_uuid"]);
                camera.snNum = WY_SafeStringValue(dic[@"sn"]);
                camera.ip = WY_SafeStringValue(dic[@"ip"]);
                camera.tp = WY_SafeStringValue(dic[@"tp"]);
                camera.gw = WY_SafeStringValue(dic[@"gw"]);
                camera.mask = WY_SafeStringValue(dic[@"mask"]);
                camera.model = WY_SafeStringValue(dic[@"model"]);
                WYDo_Block_Safe_Main1(success, camera)
            }
        }
    }failure:^(NSString *error) {
        WYLogCamFail(@"搜索失败：error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)stopSearch {
    WYLogCam(@"停止搜索,wifi:%@", WY_WiFiM.currentSSID)
    [self.player stopsearchIPC2];
}
- (void)startMonitorWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    [self stopMonitor];
    WYLogCam(@"开始Monitor wifiSSID:%@ WifiPwd:%@", wifiSSID, wifiPwd)
    [self.player monitor:wifiSSID password:wifiPwd success:^{
        WYLogCamSuc(@"Monitor成功 wifiSSID:%@ WifiPwd:%@", wifiSSID, wifiPwd)
        WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
        WYLogL(@"Monitor失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)stopMonitor {
    [self.player stopmonitor:^{
        WYLogCamSuc(@"停止Monitor成功")
    } failure:^(NSString *error) {
        WYLogCamFail(@"停止Monitor失败，error:%@", error);
    }];
}
- (void)startAPConfigureWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    KEY_PSK psk = wifiPwd.length > 0 ? KEY_MGMT_WPA_PSK : KEY_MGMT_OPEN;
    WYLogCamSelf(@"开始AP配置 wifiSSID:%@ wifiPwd:%@ psk:%d", wifiSSID, wifiPwd, psk)
    [self.player setAp:wifiSSID password:wifiPwd PSK:psk success:^{
        WYLogCamSuc(@"AP配置成功 wifiSSID:%@ wifiPwd:%@ psk:%d", wifiSSID, wifiPwd, psk)
        WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
        WYLogCamFail(@"AP配置失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}


#pragma mark -- 打洞
- (void)startConnectSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    if ([self sdkLogining]) {
        WYLogCamFail(@"已经正在打洞。。。取消重复打洞")
        return;
    }
    WYDeviceType deviceType = self.deviceType;
    NSInteger deviceID = self.deviceID;
    void (^notificationConnectSuccess)(BOOL suc, NSString *description) = ^(BOOL suc, NSString *description){
        [WY_NotificationCenter wy_post_Device_ConnectCompleted:^(WYObj_Device *device) {
            device.deviceID = deviceID;
            device.deviceType = deviceType;
            device.connectSuccess = suc;
            device.connectDescription = description;
            device.camerap = [NSString stringWithFormat:@"%p",self];
        }];
    };
    WYBlock_Void suc = ^{
        notificationConnectSuccess(YES,nil);
        WYDo_Block_Safe(success);
    };
    WYBlock_Error_Str fail = ^(NSString *err) {
        notificationConnectSuccess(NO, err);
        WYDo_Block_Safe1(failure, err);
    };
    
    if ([self sdkLogined]) {
        WYDo_Block_Safe_Main(suc)
        return;
    }

    WYLogCamSelf(@"开始打洞")
    WY_WeakSelf
    [self.player connectIPC:self.deviceUUID username:self.connectName password:self.hostKey success:^{
        WYLogCamSuc(@"打洞成功")
        WYDo_Block_Safe_Main(suc)
    } failure:^(NSString *error) {
        WYLogCamFail(@"打洞失败，error:%@", error);
        int errorcode = [weakSelf errorCodeFromErrorString:error];
        NSString *errorString;
        if (errorcode == ERR_PASSWORD) {
#if defined WYRelease
            errorString = WYLocalString(@"device_connect_err_other");
#else
            errorString = WYLocalString(@"device_connect_err_pwd");
#endif
            
        }else if (errorcode == ERR_DEVICE_OFFLINE) {
            errorString = WYLocalString(@"device_connect_err_offline");
        }else if (errorcode == ERR_DISCONNECTED) {
            errorString = WYLocalString(@"device_connect_err_disconnect");
        }else if (errorcode == ERR_STATUS) {
            errorString = WYLocalString(@"device_connect_err_connecting");
        }else {
            errorString = WYLocalString(@"device_connect_err_other");
        }
        WYDo_Block_Safe_Main1(fail, errorString)
    }];
}
- (void)stopConnectSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    if (!self.sdkLogined && !self.sdkLogining) {
        WYLogCamSuc(@"未登录或未正在登录，停止打洞成功")
        return;
    }
    WYLogCamSelf(@"停止打洞")
    [self.player disconnectIPC:^{
        WYLogCamSuc(@"停止打洞成功")
        WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
        WYLogCamFail(@"停止打洞失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}

#pragma mark -- 获取参数：码率 & 模式 & 静音
- (unsigned int)cameraPlayStatus {
    return [self.player getPlayStatus];
}
- (NSArray *)cameraStatuss:(unsigned int)status {
    NSMutableArray *arr = [NSMutableArray array];
    if (WY_ContainOption(status, CameraStatusNoDevice)) {
        [arr addObject:@"CameraStatusNoDevice"];
    }
    if (WY_ContainOption(status, CameraStatusDeviceOnline)) {
        [arr addObject:@"CameraStatusDeviceOnline"];
    }
    if  (WY_ContainOption(status, CameraStatusLogin)) {
        [arr addObject:@"CameraStatusLogin"];
    }
    if  (WY_ContainOption(status, CameraStatusPlay)) {
        [arr addObject:@"CameraStatusPlay"];
    }
    if  (WY_ContainOption(status, CameraStatusRecording)) {
        [arr addObject:@"CameraStatusRecording"];
    }
    if  (WY_ContainOption(status, CameraStatusMoving)) {
        [arr addObject:@"CameraStatusMoving"];
    }
    if  (WY_ContainOption(status, CameraStatusPlayRecord)) {
        [arr addObject:@"CameraStatusPlayRecord"];
    }
    if  (WY_ContainOption(status, CameraStatusVoicing)) {
        [arr addObject:@"CameraStatusVoicing"];
    }
    if  (WY_ContainOption(status, CameraStatusMuted)) {
        [arr addObject:@"CameraStatusMuted"];
    }
    if  (WY_ContainOption(status, CameraStatusLogining)) {
        [arr addObject:@"CameraStatusLogining"];
    }
    if  (WY_ContainOption(status, CameraStatusNormal)) {
        [arr addObject:@"CameraStatusNormal"];
    }
    return arr;
}

#pragma mark -- 获取参数：（码率、模式、静音）
- (NSString *)getBitrates {
    CGFloat bitrate = [self.player getBts];
    CGFloat bit = bitrate;
    NSString *unit = @"B/s";
    if (bit > 1024) {
        bit /= 1024.0f;
        unit = @"KB/s";
    }
    if (bit > 1024) {
        bit /= 1024.0f;
        unit = @"MB/s";
    }
    NSString *bitString = [NSString stringWithFormat:@"%0.2lf%@", bit, unit];
//    WYLog(@"码率：%.0lf=%@", bitrate, bitString);
    return bitString;
}
- (NSString *)getModes {
    NSInteger mode = [self.player getNatType];
    NSString *modeString;
    switch (mode) {
        case 0:
            modeString = WYLocalString(@"P2P");
            break;
        case 1:
            modeString = WYLocalString(@"Relay");
            break;
        case 2:
            modeString = WYLocalString(@"Lan");
            break;
        default:
            break;
    }
    WYLogCamP(@"模式：%ld=%@", (long)mode, modeString)
    return modeString;
}
- (BOOL)getMute {
    BOOL muted = WYCameraInStatus(CameraStatusMuted);
    WYLogCamP(@"静音状态：%d", muted)
    return muted;
}

#pragma mark -- 预览
- (void)startPreviewWithView:(PPSGLView *)playView streamid:(BOOL)HD success:(WYBlock_Void)success failure:(void(^)(BOOL isPlaying))failure close:(void(^)(WYCameraSleepmodeType sleepmodeType))close {
    WYLogCamSelf(@"开始预览")
    self.playView = playView;
    WY_WeakSelf
    [self.player startPreview2:playView streamid:HD success:^{
        WYLogCamSuc(@"预览成功")
        WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
        WYLogCamFail(@"预览失败，error:%@", error);
        int errorCode = [weakSelf errorCodeFromErrorString:error];
        WYDo_Block_Safe_Main1(failure, errorCode == ERR_PREVIEWING)
    } streamclose:^(NSString *error) {
        WYLogCamFail(@"预览失败，home模式，error:%@", error);
        int errorCode = [weakSelf errorCodeFromErrorString:error];
        WYCameraSleepmodeType type = WYCameraSleepmodeTypeUnknown;
        if (errorCode == ERR_INSLEEP) {
            type = WYCameraSleepmodeTypeLensOff;
            
        }else if (errorCode == ERR_INTIMESLEEP) {
            type = WYCameraSleepmodeTypeLensOffByTime;
            
        }else if (errorCode == ERR_LEAVESLEEP) {
            type = WYCameraSleepmodeTypeLensOn;
            
        }
        WYDo_Block_Safe_Main1(close, type)
    }];
}
- (void)stopPreviewSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"停止预览")
    [self.player stopPreview2:^{
        WYLogCamSuc(@"停止预览成功")
        WYDo_Block_Safe_Main(success)
        
    } failure:^(NSString *error) {
        WYLogCamFail(@"停止预览失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
        
    }];
}
- (void)switchPreviewWithView:(PPSGLView *)playView streamid:(BOOL)HD success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    
    WYLogCamSelf(@"开始切换%@", WY_BOOL(HD, @"高清", @"标清"))
    [self.player changePreview2:playView streamid:HD success:^{
        WYLogCamSuc(@"切换%@成功", WY_BOOL(HD, @"高清", @"标清"))
        WYDo_Block_Safe_Main(success)
        
    } failure:^(NSString *error) {
        WYLogCamFail(@"切换%@失败，error:%@", WY_BOOL(HD, @"高清", @"标清"), error)
        WYDo_Block_Safe_Main1(failure, error)
        
    }];
}

#pragma mark -- 回放
- (void)searchPlaybackVideoDaysInMonth:(NSDateComponents *)month success:(void(^)(NSArray<WYCameraTime *>*videoDays))success empty:(WYBlock_Void)empty failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"开始按月搜索回放,年:%ld, 月:%ld videoid:%ld", (long)month.year, (long)month.month, (long)self.videoid)
    [self.player searchPlaybackListOnMonth:month.year month:month.month videoid:self.videoid success:^(id result) {
        WYLogCamSuc(@"按月搜索成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSArray *arr = [(NSString *)result wy_jsonArray];
            NSMutableArray *res = [NSMutableArray arrayWithCapacity:arr.count];
            for (NSDictionary *dic in arr) {
                WYCameraTime *time = [WYCameraTime timeWithVideoDaysDictionary:dic];
                if (time) {
                    [res addObject:time];
                }
            }
            if (res.count > 0) {
                WYDo_Block_Safe_Main1(success, res)
            }else {
                WYDo_Block_Safe_Main(empty)
            }
        }else {
            WYLogCamFail(@"按月搜索成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"按月搜索失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure,error)
    }];
}
- (void)searchPlaybackVideoTimesInDay:(NSDateComponents *)day success:(void(^)(NSArray<WYCameraTime *>*videoTimes))success empty:(WYBlock_Void)empty failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"开始按天搜索回放,年:%ld月:%ld日:%ld videoid:%ld", (long)day.year, (long)day.month, (long)day.day, (long)self.videoid)
    [self.player searchPlaybackListOnday:day.year month:day.month day:day.day videoid:self.videoid success:^(id result) {
        WYLogCamSuc(@"按天搜索成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSArray *arr = [(NSString *)result wy_jsonArray];
            NSMutableArray *res = [NSMutableArray arrayWithCapacity:arr.count];
            for (NSDictionary *dic in arr) {
                WYCameraTime *time = [WYCameraTime timeWithTimesDictionary:dic];
                if (time) {
                    [res addObject:time];
                }
            }
            if (res.count > 0) {
                NSArray *tidiedRes = [WYCameraTime videoTimesByTidied:res];
                WYDo_Block_Safe_Main1(success, tidiedRes)
            }else {
                WYLogCamFail(@"按天搜索成功，天数为空");
                WYDo_Block_Safe_Main(empty)
            }
        }else {
            WYLogCamFail(@"按天搜索成功,解析数据失败");
            WYDo_Block_Safe_Main(empty)
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"按天搜索失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure,error)
    }];
}


- (void)startPlackbackSDCardWithView:(PPSGLView *)playView startTime:(NSString *)startTime success:(WYBlock_Void)success failure:(void(^)(BOOL isPlaying))failure otherPlaying:(WYBlock_Void)otherPlaying {
    WYLogCamSelf(@"开始回放:%@", startTime)
    self.playbackView = playView;
    WY_WeakSelf
    [self.player startPlaybackSd2:playView starttime:startTime videoid:self.videoid success:^{
        WYLogCamSelf(@"回放成功")
        WYDo_Block_Safe_Main(success)
        
    } failure:^(NSString *error) {
        WYLogCamSelf(@"回放失败，error:%@", error);
        int errorCode = [weakSelf errorCodeFromErrorString:error];
        if (errorCode == ERR_OTHERPLAYBACKING) {
            WYDo_Block_Safe_Main(otherPlaying)
        }else {
            WYDo_Block_Safe_Main1(failure, errorCode == ERR_PLAYBACKING)
        }
    }];
}
- (void)stopPlackbackSDCardSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"停止回放")
    [self.player stopPlaybackSd2:^{
        WYLogCamSuc(@"停止回放成功")
        WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
        WYLogCamFail(@"停止回放失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)seekPlackbackSDCardToTime:(NSString *)seekTime success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"开始seek:%@", seekTime)
    [self.player sendPlaybackCmd:SD_PLAYBACK_SEEK seektime:seekTime success:^{
        WYLogCamSuc(@"seek成功")
        WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
        WYLogCamFail(@"seek失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)pausePlackbackSDCardSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"开始暂停回放")
    [self.player sendPlaybackCmd:SD_PLAYBACK_PASUE seektime:NULL success:^{
        WYLogCamSuc(@"暂停回放成功")
        WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
        WYLogCamSelf(@"暂停回放失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)resumePlackbackSDCardSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"开始继续回放")
    [self.player sendPlaybackCmd:SD_PLAYBACK_RESUME seektime:NULL success:^{
        WYLogCamSuc(@"继续回放成功")
        WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
        WYLogCamSelf(@"继续回放失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
#pragma mark -- 静音
- (CGFloat)getVoiceVolume {
    CGFloat volume = (CGFloat)[self.player getvoiceAveragePower];
//    NSLog(@"获取音量：%lf",volume);
    return volume;
}
- (void)enableMute:(BOOL)muted {
    WYLogCam(@"%@", muted ? @"开始设置静音" : @"开始取消静音")
    [self.player enableMute:muted];
}
- (void)setFullDuplexLoudSpeaker:(BOOL)enable {
    [self.player setFullDuplexLoudSpeaker:enable];
}
- (void)setSpeechMode:(SPEECH_MODE)speechMode {
    [self.player setSpeechMode:speechMode];
}
#pragma mark -- 语音对讲
- (void)startVoicetalkSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    WYLogCam(@"开始语音")
    self.sdkVoiceSpeakingCount++;
    WY_StartTime
    [self.player startvoicetalk:^{
        WYLogCamSuc(@"开启语音成功")
        WY_EndTime(@"开启语音成功  sdk")
        WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
        WYLogCamFail(@"开启语音失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)stopVoicetalkSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    if (self.sdkVoiceSpeakingCount <= 0) {
        return;
    }
    WYLogCam(@"开始停止语音")
    self.sdkVoiceSpeakingCount--;
    [self.player stopvoicetalk:^{
        WYLogCamSuc(@"停止语音成功")
        WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
        WYLogCamFail(@"停止语音失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}

#pragma mark -- 截图
- (void)snapshotToPathInDocument:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"开始截图:%@", path)
    [self.player snapshot:path playmode:[self playModeWithPreviewing:isPreviewing] mode:SNAPSHOT_TO_SHAHE success:^{
        WYLogCamSuc(@"截图成功")
        WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
        WYLogCamFail(@"截图失败，error:%@", error)
        WYDo_Block_Safe_Main1(failure, error.description)
    }];
}
- (void)snapshotToPath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    
    [self snapshotToPathInDocument:path isPreviewing:isPreviewing success:^{
        [WY_PhotoM savePhotoAtPath:path success:^{
            WYDo_Block_Safe_Main(success)
        } failure:^(NSError *error) {
            WYDo_Block_Safe_Main1(failure, error.description)
        }];
    } failure:^(NSString *error) {
        WYDo_Block_Safe_Main1(failure, error)
    }];
}

#pragma mark -- 录像
- (void)startRecordMP4ToPath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    self.recordPath = path;
    WYLogCamSelf(@"开始录像：预览:%d,%@", isPreviewing, path)
    [self.player startrecordmp4:path playmode:[self playModeWithPreviewing:isPreviewing] mode:RECORD_TO_SHAHE success:^{
        WYLogCamSuc(@"开始录像成功")
        WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
        WYLogCamFail(@"开始录像失败,error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)stopRecordMP4IsPreviewing:(BOOL)isPreviewing success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"停止录像:%@",self.recordPath)
    WY_WeakSelf
    NSString *recordPath = self.recordPath.copy;
    [self.player stoprecordmp4:[self playModeWithPreviewing:isPreviewing] success:^{
        WYLogCamSuc(@"停止录像成功")
        [WY_PhotoM saveVideoAtPath:recordPath success:^{
            [WY_FileManager removeItemAtPath:recordPath error:nil];
            WYDo_Block_Safe_Main(success)
        } failure:^(NSError *error) {
            WYDo_Block_Safe_Main1(failure, error.description)
        }];
    } failure:^(NSString *error) {
        WYLogCamFail(@"停止录像失败,error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}

#pragma mark -- 录音
- (void)startRecordWavToPath:(NSString *)path {
    [self.player startRecordAudio:PCM_TO_WAV toPath:path];
}
- (void)stopRecordSuccess:(WYBlock_Str)success {
    [self.player stopRecordAudio:PCM_TO_WAV success:^(NSString *result) {
        WYDo_Block_Safe_Main1(success, result);
    }];
}

#pragma mark -- 播放声音
- (void)startPlayWavAudioWithPath:(NSString *)audioPath finished:(WYBlock_Void)finished{
    [self.player startPlayAudio:PCM_TO_WAV withPath:audioPath finished:^{
        if (finished) {
            WYDo_Block_Safe_Main(finished)
        }
    }];
}
- (void)stopPlayWavAudio {
    [self.player stopPlayAudio:PCM_TO_WAV];
}
#pragma mark -- 云台
- (void)startPTZ:(NSInteger)ps ts:(NSInteger)ts zs:(NSInteger)zs success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"开始云台控制:ps:%ld ts:%ld zs:%ld", (long)ps, (long)ts, (long)zs)
    [self.player startptz:ps ts:ts zs:zs success:^{
        WYLogCamSuc(@"开始云台控制成功")
        WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
        WYLogCamFail(@"开始云台控制失败,error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)stopPTZSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"停止云台控制")
    [self.player stopptz:^{
        WYLogCamSuc(@"停止云台控制成功")
        WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
        WYLogCamFail(@"停止云台控制失败,error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}

#pragma mark -- 缩放、平移
- (int)zoom:(float)scale POS_X:(float)x POS_Y:(float)y {
    WYLogCamSuc(@"开始缩放：scale:%f",scale)
    return [self.player zoom2:scale];
}
- (int)move:(float)x_len Y_LENGHT:(float)y_len {
    WYLogCamSuc(@"开始平移：x:%f y:%f",x_len, y_len)
    return [self.player move2:x_len dpy:y_len];
}


#pragma mark -- 设置（镜像、报警、格式化、版本升级）
- (void)getVersionSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"开始获取版本号")
    [self.player getdeviceparams:GET_PPS_DEVICE_INFO success:^(id result) {
        WYLogCamSuc(@"获取版本号成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = ((NSString *)result).wy_jsonDictionary;
            NSString *version = WY_SafeStringValue(dic[@"firmwareversion"]);
            WYDo_Block_Safe_Main1(success, version)
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"获取版本号失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)getMirrorSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"开始获取镜像")
    [self.player getdeviceparams:GET_PPS_DEVICE_MIRROR success:^(id result) {
        WYLogCamSuc(@"获取镜像成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = ((NSString *)result).wy_jsonDictionary;
            NSString *mirror = WY_SafeStringValue(dic[@"mirror"]);
            WYDo_Block_Safe_Main1(success, mirror)
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"获取镜像失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)getSDCardInfoSuccesss:(void(^)(BOOL suc, NSString *info, BOOL isFormatting))success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"开始获取SD卡信息")
    [self.player getdeviceparams:GET_PPS_DEVICE_SD_STORAGE_INFO success:^(id result) {
        WYLogCamSuc(@"获取SD卡信息成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = ((NSString *)result).wy_jsonDictionary;
            
            CGFloat totalSpace = [WY_SafeStringValue(dic[@"total_space"]) doubleValue];
            NSString *unit = @"MB";
            if (totalSpace >= 1024) {
                unit = @"GB";
                totalSpace /= 1024;
            }
            if (totalSpace >= 1024) {
                unit = @"TB";
                totalSpace /= 1024;
            }
            BOOL resSuc = totalSpace > 0;
            NSString *resInfo = resSuc ? [NSString stringWithFormat:@"%.2lf %@", totalSpace, unit] : WYLocalString(@"No SDCard");
            BOOL resFormat = [WY_SafeStringValue(dic[@"status"]) intValue] == 3;
            if (success) {
                [NSThread wy_doOnMainThread:^{
                    success(resSuc, resInfo, resFormat);
                }];
            }
        }
        
    } failure:^(NSString *error) {
        WYLogCamFail(@"获取SD卡信息失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)getUpgradePercentSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"开始获取升级进度信息")
    [self.player getdeviceparams:GET_PPS_DEVICE_UPGRADE_PERCENT success:^(id result) {
        WYLogCamSuc(@"获取升级进度成功，class:%@,result:-----%@-----", [result class], result)

        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            NSNumber *percent = dic[@"percent"];
            if (percent) {
                WYDo_Block_Safe_Main(success, percent)
            }else {
                WYLogCamFail(@"获取升级进度失败，未获取到进度值percent:%@", dic);
                WYDo_Block_Safe_Main1(failure, nil)
            }
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"获取升级进度失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)getFormatPercentSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"开始获取格式化进度")
    [self.player getdeviceparams:GET_PPS_DEVICE_FORMAT_PERCENT success:^(id result) {
        WYLogCamSuc(@"获取格式化进度成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            NSNumber *percent = dic[@"percent"];
            if (percent) {
                WYDo_Block_Safe_Main1(success, percent)
            }else {
                WYLogCamFail(@"获取格式化进度失败，未获取到进度值percent:%@", dic);
                WYDo_Block_Safe_Main1(failure, nil)
            }
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"获取格式化进度失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}

- (void)setMirrorOpen:(BOOL)open successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSDictionary *dic = @{@"mirror" : @(open ? 3 : 0)};
    WYLogCamSelf(@"开始设置镜像:%@", dic)
    [self.player setdeviceparams:SET_PPS_DEVICE_MIRROR jsonData:dic.wy_jsonString success:^(id result) {
        WYLogCamSuc(@"设置镜像成功，class:%@,result:-----%@-----", [result class], result)
        WYDo_Block_Safe_Main1(success, result)
    } failure:^(NSString *error) {
        WYLogCamFail(@"设置镜像失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)getAlarmSuccesss:(void(^)(WYCameraParamsMotion *motion))success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"开始获取报警")
    WY_WeakSelf
    [self.player getdeviceparams:GET_PPS_DEVICE_ALARM success:^(id result) {
        WYLogCamSuc(@"获取报警成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = ((NSString *)result).wy_jsonDictionary;
            WYCameraParamsMotion *motion = [WYCameraParamsMotion mj_objectWithKeyValues:dic];
            weakSelf.motion = motion;
            WYDo_Block_Safe_Main1(success, motion)
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"获取报警失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)setAlarmLevel:(WYCameraMotionLevel)level successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    WYCameraParamsMotion *motion = [WYCameraParamsMotion motionWithLevel:level];
    NSDictionary *dic = motion.levelDic;
    WYLogCamSelf(@"开始设置报警:%@", dic)
    WY_WeakSelf
    [self.player setdeviceparams:SET_PPS_DEVICE_ALARM jsonData:dic.wy_jsonString success:^(id result) {
        WYLogCamSuc(@"设置报警成功，class:%@,result:-----%@-----", [result class], result)
        weakSelf.motion.enable = motion.enable;
        weakSelf.motion.sensitivity = motion.sensitivity;
        WYDo_Block_Safe_Main1(success, result)
    } failure:^(NSString *error) {
        WYLogCamFail(@"设置报警失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)formatSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    WYLogCamSelf(@"开始格式化")
    [self.player setdeviceparams:SET_PPS_DEVICE_FORAMT jsonData:NULL success:^(id result) {
        WYLogCamSuc(@"格式化成功，class:%@,result:-----%@-----", [result class], result)
        WYDo_Block_Safe_Main1(success, result)
    } failure:^(NSString *error) {
        WYLogCamFail(@"格式化失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)upgradeWithUrl:(NSString *)url currentVersion:(NSString *)currentVersion successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure isUpgrading:(WYBlock_Void)isUpgrading upgradLimit:(WYBlock_Void)limit {
    if (url.length <= 0 || currentVersion.length <= 0) {
        WYLogCamFail(@"升级失败,传参错误:url:%@, currentVersion:%@", url, currentVersion);
        WYDo_Block_Safe_Main1(failure, nil)
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary wy_dictionaryWithPOST_deviceurl:WYDeviceURL_Upgrade];
    dic[@"url"] = url;
    dic[@"firmwareversion"] = currentVersion;
    NSString *json = dic.wy_jsonString;
    
    WY_WeakSelf
    [self.player commondeviceparams2:json success:^(id result) {
        WYLogCamSuc(@"升级成功，class:%@,result:-----%@-----", [result class], result)
        WYDo_Block_Safe_Main1(success, result)
    } failure:^(NSString *error) {
        WYLogCamFail(@"升级失败，error:%@", error);
        int errorCode = [weakSelf errorCodeFromErrorString:error];
        if (errorCode == ERR_HTTP_UPGRADING) {
            WYLogCamFail(@"正在升级...")
            WYDo_Block_Safe_Main(isUpgrading)
        } else if (errorCode == ERR_HTTP_UPGRADLIMIT) {
            WYLogCamFail(@"低电量限制升级...")
            WYDo_Block_Safe_Main(limit)
        } else {
            WYDo_Block_Safe_Main1(failure, error)
        }
    }];
    /*
    NSDictionary *dic = @{@"upgradeurl":url,
                          @"firmwareversion":currentVersion};
    WYLogCamSelf(@"开始升级:%@", dic)
    [self.player setdeviceparams:SET_PPS_DEVICE_UPGRADE jsonData:dic.wy_jsonString success:^(id result) {
        WYLogCamSuc(@"升级成功，class:%@,result:-----%@-----", [result class], result)
        WYDo_Block_Safe_Main1(success, result)
    } failure:^(NSString *error) {
        WYLogCamFail(@"升级失败，error:%@", error);
        int errorCode = [weakSelf errorCodeFromErrorString:error];
        if (errorCode == ERR_UPGRADING) {
            WYLogCamFail(@"正在升级...")
            WYDo_Block_Safe_Main(isUpgrading)
        } else {
            WYDo_Block_Safe_Main1(failure, error)
        }
    }];*/
}

#pragma mark -- home模式(2.1.x版本新增)
+ (NSDictionary *)homeDictionaryWithEnable:(BOOL)enable startTime:(NSString *)startTime stopTime:(NSString *)stopTime repeatWeekdays:(NSArray *)weekdays {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"enable"] = @(enable);
    if (startTime) {
        dic[@"start_time"] = startTime;
    }
    if (stopTime) {
        dic[@"stop_time"] = stopTime;
    }
    if (weekdays && weekdays.count > 0) {
        dic[@"repeat"] = weekdays;
    }
    return dic;
}
- (void)setHomeTimes:(NSArray<WYCameraSettingSleepmodeTimesModel *> *)homeTimes openTimeSleepmode:(BOOL)openTimeSleepmode successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    
    NSMutableDictionary *dic = [NSMutableDictionary wy_dictionaryWithPOST_deviceurl:WYDeviceURL_Settings];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:homeTimes.count];
    for (WYCameraSettingSleepmodeTimesModel *model in homeTimes) {
        NSDictionary *dic = model.homeDictionary;
        [arr addObject:dic];
    }
    dic[@"sleep_time"] = arr;
    if (openTimeSleepmode && !self.versionIsOld) {
        dic[@"sleep"] = [WYCameraParams sleepmodeStringFromType:WYCameraSleepmodeTypeLensOffByTime];
    }
    
    WYLogCamSelf(@"开始设置home模式:%@", dic)
    NSString *json = dic.wy_jsonString;
    WY_WeakSelf
    [self.player commondeviceparams:json success:^(id result) {
        if ([dic[@"sleep"] isEqualToString:[WYCameraParams sleepmodeStringFromType:WYCameraSleepmodeTypeLensOffByTime]]) {
            weakSelf.sleep =  [WYCameraParams sleepmodeStringFromType:WYCameraSleepmodeTypeLensOffByTime];
            weakSelf.params.sleep = [WYCameraParams sleepmodeStringFromType:WYCameraSleepmodeTypeLensOffByTime];
        }
        WYLogCamSuc(@"设置home模式成功，class:%@,result:-----%@-----", [result class], result)
        WYDo_Block_Safe_Main1(success, result)
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"设置home模式失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)getHomeTimeSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSDictionary wy_dictionaryWithGET_deviceurl:WYDeviceURL_Settings];
    WYLogCamSelf(@"开始获取home模式:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"获取home模式成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"获取home模式成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"获取home模式失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}

#pragma mark -- babymonitor(2.2.x版本新增)
- (void)getParamsSuccesss:(void(^)(WYCameraParams *params))success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSDictionary wy_dictionaryWithGET_deviceurl:WYDeviceURL_Settings];
    WYLogCamSelf(@"开始获取所有参数:%@", dic)
    NSString *json = dic.wy_jsonString;
    WY_WeakSelf
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"获取所有参数成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYLogCamSuc(@"获取所有参数成功，result:%@", dic)
            WYCameraParams *p = [WYCameraParams mj_objectWithKeyValues:dic];
            weakSelf.params = p;
            WYDo_Block_Safe_Main1(success, p)
        }else {
            WYLogCamFail(@"获取所有参数成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"获取所有参数失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)getStorageSuccesss:(void(^)(BOOL hasSDCard))success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSDictionary wy_dictionaryWithGET_deviceurl:WYDeviceURL_Storage];
    WYLogCamSelf(@"开始获取存储状态:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"获取存储状态成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            BOOL hasSDCard = NO;
            NSArray *arr = [(NSString *)result wy_jsonArray];
            if (WY_IsKindOfClass(arr, NSArray) && arr.count > 0) {
                for (NSDictionary *dic in arr) {
                    NSString *total_space = WY_SafeStringValue(dic[@"total_space"]);
                    if (total_space.integerValue > 0) {
                        hasSDCard = YES;
                    }
                    break;
                }
            }
            WYDo_Block_Safe_Main1(success, hasSDCard)
        }else {
            WYLogCamFail(@"获取存储状态成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"获取存储状态失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)getSleepmodeSuccesss:(void(^)(WYCameraParams *params))success failure:(WYBlock_Error_Str)failure {
    [self getParamsSuccesss:^(WYCameraParams *params) {
        if (params && params.type != WYCameraSleepmodeTypeUnknown) {
            WYLogCamSuc(@"获取home模式成功，result:-----%@-----", @(params.type))
            WYDo_Block_Safe_Main1(success, params);
        }else {
            WYLogCamFail(@"获取home模式成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        WYDo_Block_Safe_Main1(failure, error);
    }];}
- (void)setSleepmodeType:(WYCameraSleepmodeType)type successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    WYCameraSleepmodeType t = type == WYCameraSleepmodeTypeLensOffByTime && self.versionIsOld ? WYCameraSleepmodeTypeLensOff :type;
    NSString *sleepmodeString = [WYCameraParams sleepmodeStringFromType:t];
    if (!sleepmodeString) {
        WYLogCamFail(@"设置home模式失败，设置参数错误:%@", @(t));
        WYDo_Block_Safe_Main1(failure, nil)
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary wy_dictionaryWithPOST_deviceurl:WYDeviceURL_Settings];
    dic[@"sleep"] = sleepmodeString;
    WYLogCamSelf(@"开始设置home模式:%@", dic)
    NSString *json = dic.wy_jsonString;
    WY_WeakSelf
    [self.player commondeviceparams:json success:^(id result) {
        weakSelf.params.sleep = [WYCameraParams sleepmodeStringFromType:type];
        WYLogCamSuc(@"设置home模式成功，class:%@,result:-----%@-----", [result class], result)
        WYDo_Block_Safe_Main1(success, result)
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"设置home模式失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)getTemp_HumiditySuccesss:(void(^)(CGFloat temp, CGFloat humidity, WYCameraTRHError tempError, WYCameraTRHError humidityError))success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSDictionary wy_dictionaryWithGET_deviceurl:WYDeviceURL_Temp_Humidity];
    WYLogCamSelf(@"开始获取温湿度:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"获取温湿度成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            CGFloat t = [dic[@"temperature_c"] floatValue];
            CGFloat rh = [dic[@"humidity"] floatValue];
            WYCameraTRHError tError = (WYCameraTRHError)[WY_SafeStringValue(dic[@"temperature_error"]) integerValue];
            WYCameraTRHError rhError = (WYCameraTRHError)[WY_SafeStringValue(dic[@"humidity_error"]) integerValue];
            WYDo_Block_Safe_Main4(success, t, rh, tError, rhError);
        }else {
            WYLogCamFail(@"获取温湿度成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"获取温湿度失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}

- (void)playMusic:(NSString *)musicID successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSDictionary wy_dictionaryWithPOST_deviceurl:[WYDeviceURL_MusicStartOne stringByReplacingOccurrencesOfString:@"111111" withString:musicID]];
    WYLogCamSelf(@"开始播放音乐:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"播放音乐成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"播放音乐成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"播放音乐失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)playCurrentMusicSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSDictionary wy_dictionaryWithPOST_deviceurl:WYDeviceURL_MusicStart];
    WYLogCamSelf(@"开始播放当前音乐:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"播放当前音乐成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"播放当前音乐成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"播放当前音乐失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)pauseMusicSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSDictionary wy_dictionaryWithPOST_deviceurl:WYDeviceURL_MusicPause];
    WYLogCamSelf(@"开始暂停播放音乐:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"暂停播放音乐成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"暂停播放音乐成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"暂停播放音乐失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)playNextSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSDictionary wy_dictionaryWithPOST_deviceurl:WYDeviceURL_MusicNext];
    WYLogCamSelf(@"开始切换下一首音乐:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"切换下一首音乐成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"切换下一首音乐成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"切换下一首音乐失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)playPreviousSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSDictionary wy_dictionaryWithPOST_deviceurl:WYDeviceURL_MusicPrev];
    WYLogCamSelf(@"开始切换上一首音乐:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"切换上一首音乐成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"切换上一首音乐成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"切换上一首音乐失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)getCurrentMusicStateSuccesss:(void(^)(WYBabyMonitorMusicModel *music))success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSDictionary wy_dictionaryWithGET_deviceurl:WYDeviceURL_MusicCurrentState];
    WYLogCamSelf(@"开始获取当前音乐状态:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"获取获取当前音乐状态成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYBabyMonitorMusicModel *m = [WYBabyMonitorMusicModel mj_objectWithKeyValues:dic];
            WYDo_Block_Safe_Main1(success, m)
        }else {
            WYLogCamFail(@"获取获取当前音乐状态成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"获取获取当前音乐状态失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)getMusicStateSuccesss:(void(^)(WYBabymonitorMusicStateModel *musicState))success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSDictionary wy_dictionaryWithGET_deviceurl:WYDeviceURL_MusicState];
    WYLogCamSelf(@"开始获取音乐状态:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"获取获取音乐状态成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYBabymonitorMusicStateModel *model = [WYBabymonitorMusicStateModel mj_objectWithKeyValues:dic];
            WYDo_Block_Safe_Main1(success, model)
        }else {
            WYLogCamFail(@"获取获取音乐状态成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"获取获取音乐状态失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)setMusicMode:(WYBabymonitorMusicPlayMode)mode successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSString *url = WYDeviceURL_MusicPlayMode_Default;
    switch (mode) {
        case WYBabymonitorMusicPlayModeRepeatOne: {
            url = WYDeviceURL_MusicPlayMode_RepeatOne;
            break;
        }
        case WYBabymonitorMusicPlayModeRepeatAll: {
            url = WYDeviceURL_MusicPlayMode_RepeatAll;
            break;
        }
        case WYBabymonitorMusicPlayModeRandom: {
            url = WYDeviceURL_MusicPlayMode_Random;
            break;
        }
        case WYBabymonitorMusicPlayModeSingle: {
            url = WYDeviceURL_MusicPlayMode_Single;
            break;
        }
        default:
            break;
    }
    NSMutableDictionary *dic = [NSDictionary wy_dictionaryWithPOST_deviceurl:url];
    WYLogCamSelf(@"开始设置音乐模式:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"切换设置音乐模式成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"切换设置音乐模式成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"切换设置音乐模式失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}

- (void)volumeGetOutputSuccesss:(void(^)(NSInteger volume))success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSDictionary wy_dictionaryWithGET_deviceurl:WYDeviceURL_AudioOutputVolume];
    WYLogCamSelf(@"开始获取输出音量:%@", dic)
    NSString *json = dic.wy_jsonString;
    WY_WeakSelf
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"获取输出音量成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            NSString *volumeStr = WY_SafeStringValue(dic[@"volume"]);
            weakSelf.outVolume = volumeStr.integerValue;
            WYDo_Block_Safe_Main1(success, volumeStr.integerValue)
        }else {
            WYLogCamFail(@"获取输出音量成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"获取输出音量失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)volumeSetOutput:(NSInteger)volume successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSDictionary wy_dictionaryWithPOST_deviceurl:[WYDeviceURL_AudioOutputVolume stringByAppendingPathComponent:@(volume).stringValue]];
    WYLogCamSelf(@"开始设置输出音量:%@", dic)
    NSString *json = dic.wy_jsonString;
    WY_WeakSelf
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"设置输出音量成功:%ld，class:%@,result:-----%@-----", volume, [result class], result)
        weakSelf.outVolume = volume;
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"设置输出音量成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"设置输出音量失败:%ld，error:%@", volume, error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)volumeGetInputSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSDictionary wy_dictionaryWithGET_deviceurl:WYDeviceURL_AudioInputVolume];
    WYLogCamSelf(@"开始获取输入音量:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"获取输入音量成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"获取输入音量成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"获取输入音量失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)volumeSetInput:(id)input successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSDictionary wy_dictionaryWithPOST_deviceurl:[WYDeviceURL_AudioInputVolume stringByAppendingPathComponent:input]];
    WYLogCamSelf(@"开始设置输入音量:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"设置输入音量成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"设置输入音量成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"设置输入音量失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}

- (void)updatetoken:(NSString *)token type:(WYCameraTokenType)type {
    WYLogCam(@"更新 %@ token:%@", [self tokenModeDescription:type], token)
    TOKEN_TYPE t = TOKEN_SMARTWIFI;
    switch (type) {
        case WYCameraTokenTypeSmartwifi: t = TOKEN_SMARTWIFI; break;
        case WYCameraTokenTypeAP: t = TOKEN_AP; break;
        case WYCameraTokenTypeQRCode: t = TOKEN_QRCODE; break;
        default:
            break;
    }
    [self.player updateToken:token tokenType:t];
}

#pragma mark - doorbell
- (void)setDoorBellPIRLevel:(WYDoorBellPIRLevel)level successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
   
    NSMutableDictionary *dic = [NSMutableDictionary wy_dictionaryWithPOST_deviceurl:WYDeviceURL_Settings];
    NSDictionary *subDic = [NSDictionary dictionary];
    switch (level) {
        case WYDoorBellRLevelOff: {
            subDic = @{@"enable":@0};
            break;
        }
        case WYDoorBellPIRLevelLow: {
            subDic = @{@"enable":@1, @"level":@1};
            break;
        }
        case WYDoorBellPIRLevelMedium: {
            subDic = @{@"enable":@1, @"level":@2};
            break;
        }
        case WYDoorBellPIRLevelHigh: {
            subDic = @{@"enable":@1, @"level":@3};
            break;
        }
        default:
            break;
    }
    dic[@"bell"] = @{@"pir":subDic};

    NSString *json = dic.wy_jsonString;
    WY_WeakSelf
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"设置PIR成功，class:%@,result:-----%@-----", [result class], result)
        weakSelf.params.bell.pir.enable = [subDic[@"enable"] boolValue];
        if (subDic[@"level"]) {
            weakSelf.params.bell.pir.level = [subDic[@"level"] integerValue];
        }
        WYDo_Block_Safe_Main1(success, result)
    } failure:^(NSString *error) {
        
        WYLogCamFail(@"设置PIR失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)setDoorBellVolume:(NSInteger)volume success:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSMutableDictionary wy_dictionaryWithPOST_deviceurl:WYDeviceURL_Settings];
    dic[@"bell"] = @{@"volume": @(volume)};
    WYLogCamSelf(@"开始设置门铃音量:%@", dic)
    NSString *json = dic.wy_jsonString;
    WY_WeakSelf
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"设置门铃音量成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            weakSelf.params.bell.volume = volume;
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"设置门铃音量成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"设置门铃音量失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)setDoorBellBatteryLockOpen:(BOOL)open success:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSMutableDictionary wy_dictionaryWithPOST_deviceurl:WYDeviceURL_Settings];
    dic[@"bell"] = @{@"batterylock": @(open ? 1:0)};
    WYLogCamSelf(@"开始设置电池锁:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"设置门铃电池锁成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"设置门铃电池锁成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"设置门铃电池锁失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];

}
- (void)setDoorBellLowPowerOpen:(BOOL)open success:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSMutableDictionary wy_dictionaryWithPOST_deviceurl:WYDeviceURL_Settings];
    dic[@"bell"] = @{@"pwm": @(open?1:0)};
    WYLogCamSelf(@"开始设置低功耗:%@", dic)
    NSString *json = dic.wy_jsonString;
    WY_WeakSelf
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"设置门铃低功耗成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            weakSelf.params.bell.pwm = @(open).integerValue;
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"设置门铃低功耗成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"设置门铃低功耗失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)setDoorBellJingleBellVolumeOpen:(BOOL)open success:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSMutableDictionary wy_dictionaryWithPOST_deviceurl:WYDeviceURL_Settings];
    NSDictionary *subDict = @{@"enable":@(open?1:0)};
    dic[@"bell"] = @{@"charm": subDict};
    WYLogCamSelf(@"开始设置铃铛开关:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"设置铃铛声音开关，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"设置铃铛开关成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"设置铃铛开关失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];

}
- (void)setDoorBellJingleBellVolumeType:(WYDoorBellJingleBellVolumeLevel)volumeType selectedSong:(NSString *)selectedSong repeatTimes:(NSInteger)repeatTimes success:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSMutableDictionary wy_dictionaryWithPOST_deviceurl:WYDeviceURL_Settings];
    NSMutableDictionary *subDict = @{@"selected":selectedSong,
                              @"repetition":@(repeatTimes),
                              @"volume":@(volumeType * 25)}.mutableCopy;
    dic[@"bell"] = @{@"charm": subDict};
    WYLogCamSelf(@"开始设置铃铛声音:%@", dic)
    NSString *json = dic.wy_jsonString;
    WY_WeakSelf
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"设置铃铛声音成功，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            [subDict setObject:weakSelf.params.bell.charm.song forKey:@"song"];
            weakSelf.params.bell.charm = [WYDoorBellParamsJingleBell mj_objectWithKeyValues:subDict];
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"设置铃铛声音成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"设置铃铛声音失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)setDoorebllJingleBellPairSuccess:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSMutableDictionary wy_dictionaryWithPOST_deviceurl:WYDeviceURL_JingleBellPair];
    WYLogCamSelf(@"开始绑定铃铛:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"绑定铃铛，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"绑定铃铛成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"绑定铃铛失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)getDoorebllJingleBellStatusSuccess:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSMutableDictionary wy_dictionaryWithGET_deviceurl:WYDeviceURL_JingleBellStatus];
    WYLogCamSelf(@"获取铃铛状态:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"获取铃铛状态，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"获取铃铛状态成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"获取铃铛状态失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)setDoorebllJingleBellUnbindSuccess:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSMutableDictionary wy_dictionaryWithPOST_deviceurl:WYDeviceURL_JingleBellUnbind];
    WYLogCamSelf(@"解绑铃铛:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"解绑铃铛，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"解绑铃铛成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"绑定铃铛失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
- (void)setDoorbellPlayHostMessageSuccess:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure {
    NSMutableDictionary *dic = [NSMutableDictionary wy_dictionaryWithPOST_deviceurl:WYDeviceURL_PlayHostMessage];
    WYLogCamSelf(@"播放语音留言:%@", dic)
    NSString *json = dic.wy_jsonString;
    [self.player commondeviceparams:json success:^(id result) {
        WYLogCamSuc(@"播放语音留言，class:%@,result:-----%@-----", [result class], result)
        if (WY_IsKindOfClass(result, NSString)) {
            NSDictionary *dic = [(NSString *)result wy_jsonDictionary];
            WYDo_Block_Safe_Main1(success, dic)
        }else {
            WYLogCamFail(@"播放语音留言成功,解析数据失败");
            WYDo_Block_Safe_Main1(failure, nil)
        }
    } failure:^(NSString *error) {
        WYLogCamFail(@"播放语音留言失败，error:%@", error);
        WYDo_Block_Safe_Main1(failure, error)
    }];
}
@end


@implementation NSDictionary (WYCamera)

+ (NSMutableDictionary *)wy_dictionaryWithAction:(NSString *)action deviceurl:(NSString *)deviceurl {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (action) {
        dic[@"action"] = action;
    }
    NSString *deviceTotalUrl = WY_URLDevice(deviceurl);
    if (deviceTotalUrl) {
        dic[@"deviceurl"] = deviceTotalUrl;
    }
    return dic;
}
+ (NSMutableDictionary *)wy_dictionaryWithGET_deviceurl:(NSString *)deviceurl {
    return [self wy_dictionaryWithAction:@"GET" deviceurl:deviceurl];
}
+ (NSMutableDictionary *)wy_dictionaryWithPOST_deviceurl:(NSString *)deviceurl {
    return [self wy_dictionaryWithAction:@"POST" deviceurl:deviceurl];
}

@end
