/**
 *@file MRPlayer.h
 *@author HF.CHEN
 */

#import <UIKit/UIKit.h>

#import "MRPlayerDefine.h"
#import "apple_openglview.h"
#import "cameraplayer_define.h"

/**
 *  MR_CMD_GET
 */
typedef enum {
    MR_CMD_GET_INFO,
    MR_CMD_GET_MIRROR,
    MR_CMD_GET_ALARM,
    MR_CMD_GET_PIC,
    MR_CMD_GET_UPGRADE_PERCENT,
    MR_CMD_GET_FORMAT_PERCENT,
    MR_CMD_GET_SD_STORAGE_INFO
} MR_CMD_GET;

/**
 *  MR_CMD_SET
 */
typedef enum {
    MR_CMD_SET_MIRROR,
    MR_CMD_SET_ALARM,
    MR_CMD_SET_PASSWORD,
    MR_CMD_SET_FORAMT,
    MR_CMD_SET_UPGRADE,
    MR_CMD_SET_LOCAL_UPGRADE,
    MR_CMD_SET_REBOOT
} MR_CMD_SET;

/**
 *  KEY_PSK
 */
typedef enum {
    KEY_MGMT_OPEN = 0,
    KEY_MGMT_WEP = 1,
    KEY_MGMT_WPA_PSK = 2,
    KEY_MGMT_WPA_ENTPRISE = 3,
    KEY_MGMT_WPA2_PSK = 4
} KEY_PSK;

/**
 *  MR_CMD_PLAYBACK
 */
typedef enum { MR_CMD_PLAYBACK_SEEK, MR_CMD_PLAYBACK_PASUE, MR_CMD_PLAYBACK_RESUME } MR_CMD_PLAYBACK;

typedef enum { MR_MODE_PLAY, MR_MODE_PLAYBACK } MR_PLAY_MODE;

/**
 *  AUDIO_MODE
 */
typedef enum {
    PCM_TO_G711,
    PCM_TO_WAV,
    PCM,
} AUDIO_MODE;
typedef enum { TOKEN_SMARTWIFI, TOKEN_AP, TOKEN_QRCODE } TOKEN_TYPE;

typedef enum { SPEECH_ONE_WAY, SPEECH_FULL_DUPLEX } SPEECH_MODE;

typedef enum {
    VIDEO_STREAM_HD = 0,
    VIDEO_STREAM_SD,
    VIDEO_STREAM_SD_360,
    VIDEO_STREAM_SD_480,
    VIDEO_STREAM_HD2,
    VIDEO_STREAM_UHD_Low,
    VIDEO_STREAM_UHD_Middle,
    VIDEO_STREAM_UHD_High,
} VIDEO_STREAM;

typedef NS_OPTIONS(NSInteger, SEARCH_MODE) {
    SEARCH_MODE_LAN = 1 << 0,
    SEARCH_MODE_CLOUD_SMARTWIFI = 1 << 1,
    SEARCH_MODE_CLOUD_AP = 1 << 2,
    SEARCH_MODE_CLOUD_QRCODE = 1 << 3,
    SEARCH_MODE_CLOUD = SEARCH_MODE_CLOUD_SMARTWIFI | SEARCH_MODE_CLOUD_AP | SEARCH_MODE_CLOUD_QRCODE,
    SEARCH_MODE_ALL = SEARCH_MODE_LAN | SEARCH_MODE_CLOUD
};

typedef NS_OPTIONS(NSInteger, PPS_PRTP_DP_MODE_TYPE) {
    PPS_PRTP_GET_DP_REQ = 200000,// APP 获取 DP 点请求
    PPS_PRTP_GET_DP_RSP = 200001,// 设备回复 DP 点请求
    PPS_PRTP_SET_DP_REQ = 200002,// APP 设置 DP 点
    PPS_PRTP_SET_DP_RSP = 200003,// 设备回复设置 DP 点
    PPS_PRTP_UPLOAD_DP_REQ = 200004,// 设备上报 DP 点到 APP
    PPS_PRTP_UPLOAD_DP_RSP = 200005,// APP 回复设备上报 DP 点
    PPS_PRTP_GET_CAPS_REQ = 200006,// APP 获取能力集请求
    PPS_PRTP_GET_CAPS_RSP = 200007,// 设备回复能力集请求
    PPS_PRTP_BIND_REQ = 200008,// 请求绑定
    PPS_PRTP_BIND_RSP = 200009,// 设备回复绑定请求
    PPS_PRTP_BIND_STATUS_REQ = 200010,// 绑定状态指令
    PPS_PRTP_BIND_STATUS_RSP = 200011, // 绑定状态指令
    PPS_PRTP_PLAYBACK_MONTH_REQ = 200104,//按年月搜索
    PPS_PRTP_PLAYBACK_MONTH_RSP = 200105,//按年月搜索 返回
    PPS_PRTP_PLAYBACK_DAY_REQ = 200106,//按天搜索 包含缩略图
    PPS_PRTP_PLAYBACK_DAY_RSP = 200107,//按天搜索 包含缩略图 返回
};

/**
 *  ERROR_CODE
 */
static int ERR_VALID_POINT = 1;
static int ERR_SUCCESS = 0;
static int ERR_UPGRADING = -1;
static int ERR_PREVIEWING = -2;
static int ERR_NOLOGIN = -3;
static int ERR_PLAYBACKING = -4;
static int ERR_INTIMESLEEP = -5;
static int ERR_INGEOSLEEP = -6;
static int ERR_INSLEEP = -7;
static int ERR_LEAVESLEEP = -8;
static int ERR_NULL_POINT = -9;
static int ERR_NOT_INIT = -10;
static int ERR_STATUS = -11;
static int ERR_DEVICE_OFFLINE = -12;
static int ERR_PASSWORD = -13;
static int ERR_DISCONNECTED = -14;
static int ERR_OTHERPLAYBACKING = -15;
static int ERR_VIDEO_CLIP_RECORDING = -16;
static int ERR_VOICE_TALK_FAIL = -17;
static int ERR_VOICE_TALK_CREATEFILES_FAILED = -18;
static int ERR_POORTRANSMISSION = -19;
static int ERR_CONNECT_VIDEO_PASSWORD=-100;
static int ERR_CHECK_TIMEOUT = -27;
static int ERR_HTTP_UPGRADING = 501;
static int ERR_HTTP_UPGRADLIMIT = 403;
static int ERR_HTTP_SUCCESS = 200;
static int ERR_LIVE_INTERRUPTED = 3;
static int ERR_HISTORY_INTERRUPTED = 3;

static NSString *const MRDEVICE_PRTP_CONNECT_CHANGE = @"MRDEVICE_PRTP_CONNECT_CHANGE";

@interface MRPlayer : NSObject
@property (nonatomic, assign) SPEECH_MODE speechMode;
@property (strong, nonatomic) NSMutableArray *searchResult;
@property (nonatomic, copy) NSString *smartwifiToken;
@property (nonatomic, copy) NSString *apToken;
@property (nonatomic, copy) NSString *qrcodeToken;
/// 临时回调
@property (nonatomic, copy) MRSuccessHandler mlive_first_render;
@property (nonatomic, copy) MRFailureError mlive_stream_close;
@property (nonatomic, copy) MRSuccessHandler mlive_record_success;
@property (nonatomic, copy) MRFailureError mlive_record_failed;
@property (nonatomic, copy) MRSuccessHandler mhistory_first_render;
@property (nonatomic, copy) MRSuccessHandler mhistory_seek_success;
@property (nonatomic, copy) MRFailureError mhistory_stream_close;
@property (nonatomic, copy) MRSuccessHandler mhistory_record_success;
@property (nonatomic, copy) MRFailureError mhistory_record_failed;
@property (nonatomic, copy) MRSuccessID mdevice_search_success;
@property (nonatomic, copy) MRFailureHandler mconnect_abnormal_close;
@property (nonatomic, copy) MRPrtpConnectHandler mdevice_prtp_connect_change;
@property (nonatomic, assign) unsigned int mstatus;

/**
    player version
 */
+ (NSString *)getVersion;

- (instancetype)init NS_UNAVAILABLE;


- (void)reset;
/**
 *@brief init with a baseUrl
 *@param searchBaseUrl  base Jurl for search by cloud
 */
+ (instancetype)playerWithSearchBaseUrl:(NSString *)searchBaseUrl;

//硬解码开关
+ (void)hardDecodeEnable:(BOOL)enable;
#pragma mark 0.configure wifi and search IPC
/**
 *@brief update token for configuration mode
 *@param token  unique token
 *@param tokenType  token type for configuration mode
 */
- (void)updateToken:(NSString *)token tokenType:(TOKEN_TYPE)tokenType;

/**
 *@brief Get the set Token according to the type
 *@param type  configuration mode
 */
- (NSString *)getToken:(TOKEN_TYPE)type;

/**
 *@brief monitor configure ssid for ipc
 *@param[in]  ssid -- ssid
 *@param[in]  password -- password of device
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)monitor:(NSString *)ssid
       password:(NSString *)password
        success:(MRSuccessHandler)success
        failure:(MRFailureError)error;

/**
 *@brief stop configure ssid for ipc
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)stopmonitor:(MRSuccessHandler)success failure:(MRFailureError)error;

/**
 *@brief ap configure ssid for ipc
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)setAp:(NSString *)ssid
     password:(NSString *)password
          PSK:(KEY_PSK)psk
      success:(MRSuccessHandler)success
      failure:(MRFailureError)error;

- (void)setLanWireDevice:(NSString *)deviceip
                   token:(NSString *)token
                 success:(MRSuccessHandler)success
                 failure:(MRFailureError)error;

/**
 *@brief search ipc
 *@param[out] mode      search mode
 *@param[out] success   when success,then call it
 *@param[out] error     when failed,then call it
 */
- (void)startSearchWithMode:(SEARCH_MODE)mode success:(MRSuccessID)success failure:(MRFailureError)error;

/**
 *@brief stop search ip
 */
- (void)stopSearchIPC;

#pragma mark 1.connect device and login
/**
 *@brief check Ipc is online or offline or check timeout for show UI
 *@param[in]  uid -- uuid
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)checkDevOnlineStatus:(NSString *)uid success:(MRSuccessID)success failure:(MRFailureError)error;

/**
 *@brief first you must connect IPC
 *@param[in]  uid -- uuid
 *@param[in]  username -- username of device
 *@param[in]  password -- password of device
 *@param[out] disconnect  monitor the device status in real time, the network is particularly poor or in sleeps, then
 *call it
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)connectIPC:(NSString *)uid
              username:(NSString *)username
              password:(NSString *)password
               success:(MRSuccessHandler)success
    abnormalDisconnect:(MRAbnormalDisconnect)disconnect
               failure:(MRFailureError)error;

- (void)connectIPC2:(NSString *)logindata
               success:(MRSuccessHandler)success
    abnormalDisconnect:(MRAbnormalDisconnect)disconnect
               failure:(MRFailureError)error;
/**
 *@brief you can disconnect IPC
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)disconnectIPC:(MRSuccessHandler)success failure:(MRFailureError)error;

#pragma mark 2.preview

- (void)startPreview:(AppleOpenGLView *)glLayer
            streamid:(VIDEO_STREAM)stream
             success:(MRSuccessHandler)success
             failure:(MRFailureError)error
         streamclose:(MRFailureError)streamclose;

- (void)startPreview:(AppleOpenGLView *)gllayer
            streamid:(VIDEO_STREAM)stream
             channel:(int)channel
             success:(MRSuccessHandler)success
             failure:(MRFailureError)error
         streamclose:(MRFailureError)streamclose;

- (void)stopPreview:(MRSuccessHandler)success failure:(MRFailureError)error;

- (void)changePreview:(AppleOpenGLView *)glLayer
             streamid:(VIDEO_STREAM)stream
              success:(MRSuccessHandler)success
              failure:(MRFailureError)error;

#pragma mark 3.playback
/**
 *@brief start playback sd card
 *@param[in]  month -- month such as 1-12
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)searchPlaybackListOnMonth:(NSInteger)year
                            month:(NSInteger)month
                          videoid:(NSInteger)videoid
                          success:(MRSuccessID)success
                          failure:(MRFailureError)error;

/**
 *@brief start playback sd card
 *@param[in]  month -- month such as 1-12
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)searchPlaybackListOnday:(NSInteger)year
                          month:(NSInteger)month
                            day:(NSInteger)day
                        videoid:(NSInteger)videoid
                        success:(MRSuccessID)success
                        failure:(MRFailureError)error;

/**
 *@brief start playback sd card
 *@param[in]  videoUIView -- videoUIView
 *@param[in]  starttime -- 20150312120000
 *@param[in]  videoid -- streamid of device
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */

- (void)startPlaybackSd:(AppleOpenGLView *)glLayer
              starttime:(NSString *)starttime
                videoid:(NSInteger)videoid
                success:(MRSuccessHandler)success
                failure:(MRFailureError)error;

/**
 *@brief send playback sd card cmd(seek,pause,resume)
 *@param[in]  cmd -- MR_CMD_PLAYBACK
 *@param[in]  seektime -- seektime(20160727201414)
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)sendPlaybackCmd:(MR_CMD_PLAYBACK)cmd
               seektime:(NSString *)seektime
                success:(MRSuccessHandler)success
                failure:(MRFailureError)error;

/**
 *@brief stop playback sd card
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */

- (void)stopPlaybackSd:(MRSuccessHandler)success failure:(MRFailureError)error;

/**
 *@brief get current playback time,hms
 *@return h*3600+min*60+sec
 */
- (NSUInteger)getPlaybackTime;

/**
 *@brief Set playback speed
 *@param[out] speed
 */
- (void)setPlaybackSpeed:(double)speed;
/**
 *@brief delete playback video
 *@param[out] startTime 20150312120000
 *@param[out] endTime   20150312120010
 *@param[out] videoid   streamid of device
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)deletePlaybackVideo:(NSString *)startTime endTime:(NSString *)endTime videoid:(NSInteger)videoid success:(MRSuccessHandler)success failure:(MRFailureError)error;
/**
 *@brief start download playback video
 *@param[out] startTime 20150312120000
 *@param[out] endTime   20150312120010
 *@param[out] videoid   streamid of device
 *@param[out] path      download file path
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)startDownloadPlaybackVideo:(NSString *)startTime endTime:(NSString *)endTime videoid:(NSInteger)videoid filePath:(NSString *)path success:(MRSuccessHandler)success failure:(MRFailureError)error;

/**
 *@brief start download playback video
 *@param[out] downloadIndex   current donwload index
 *@param[out] cmd   control of download 1:resume 2:pause 3:stop
 *@param[out] videoid   streamid of device
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)downloadPlaybackVideoControl:(int)downloadIndex cmd:(int)cmd videoid:(NSInteger)videoid success:(MRSuccessHandler)success failure:(MRFailureError)error;
/**
 *@brief Get the progress of the download
 *@param[out] videoid   streamid of device
 *@param[out] success  when success,then call it -- {"deletepercent":0}
 *@param[out] error  when failed,then call it
 */
- (void)getDownloadVideoPercent:(int)videoid
                        success:(MRSuccessID)success
                        failure:(MRFailureError)error;
/**
 *@brief Get the progress of the delete
 *@param[out] videoid   streamid of device
 *@param[out] success  when success,then call it -- {"deletepercent":0}
 *@param[out] error  when failed,then call it
 */
- (void)getDeleteVideoPercent:(int)videoid
                      success:(MRSuccessID)success
                      failure:(MRFailureError)error;

#pragma mark 4.mute
/**
 *@brief enable audio mute
 *@param[in]  muted -- true/false
 */
- (void)enableMute:(BOOL)muted;

#pragma mark 5.voice talk
/**
 *@brief init voice talk environment
 *@param[out] baseUrl  get voice param
 *@param[out] userid  user tag
 */
- (void)initVoiceTalk:(NSString *)baseUrl
               userID:(NSString *)userid
                model:(NSString *)model
             firmware:(NSString *)firmware;

/**
 *@brief get double voice talk mic volume
 *@return 1.0f- normal
 */
- (float)getMicVolume;

/**
 *@brief set double voice talk mic volume
 *@param[in] gain  1.0f normal
 */
- (void)setMicVolume:(float)gain;

/**
 *@brief get double voice talk speaker volume
 *@return 1.0f- normal
 */
- (float)getSpeakerVolume;

/**
 *@brief set double voice talk speaker volume
 *@param[in] gain  1.0f normal
 */
- (void)setSpeakerVolume:(float)gain;

/**
 *@brief enable voice talk
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)startvoicetalk:(BOOL)isvoicebell success:(MRSuccessHandler)success failure:(MRFailureError)error;

/**
 *@brief disable voice talk
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)stopvoicetalk:(MRSuccessHandler)success failure:(MRFailureError)error;

/**
 *@brief set voice talk type
 *@param[in]  voicetype  normal|man|clown
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)setvoicetype:(enum Voice_Type)voicetype success:(MRSuccessHandler)success failure:(MRFailureError)error;

- (GLfloat)getvoiceAveragePower;

/**
 *@brief only for voicebell,pasue phone record voice
 */
- (void)pausevoicetalk;

/**
 *@brief only for voicebell,resume phone record voice
 */
- (void)resumevoicetalk;

- (void)startRecordWavForVoicetalk:(NSString *)path success:(MRSuccessHandler)success failure:(MRFailureError)error;

- (void)stopRecordWavForVoicetalk;
typedef enum { _BOY = 0, _Gril, _Man } _VoiceTalkType;
- (void)startSoundtouchForVoicetalk:(_VoiceTalkType)type
                            success:(MRSuccessHandler)success
                            failure:(MRFailureError)error;

- (void)stopSoundtouchForVoicetalk;

/**
 *@brief snapshot
 *@param[in]  path     must be XXXX/XXX.jpg
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)snapshot:(NSString *)path
        playmode:(MR_PLAY_MODE)playmode
         success:(MRSuccessHandler)success
         failure:(MRFailureError)error;

/**
 *@brief snapshot
 *@param[in]  path     must be XXXX/XXX.jpg
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)pic_to_yuv:(NSString *)path
           yuvfile:(NSString *)yuvfile
           success:(MRSuccessHandler)success
           failure:(MRFailureError)error;

#pragma mark 7.record mp4
/**
 *@brief startrecordmp4
 *@param[in]  path     must be XXXX/XXX.mp4
 *@param[in]  playmode    play or playback
 *@param[in]  recordVoice Mp4 has sound or no sound
 *@param[out] disconnect  When the code stream changes,then call it
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)startrecordmp4:(NSString *)path
              playmode:(MR_PLAY_MODE)playmode
           recordVoice:(BOOL)recordVoice
               success:(MRSuccessHandler)success
    abnormalDisconnect:(MRAbnormalDisconnect)disconnect
               failure:(MRFailureError)error;

/**
 *@brief stoprecordmp4
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)stoprecordmp4:(MR_PLAY_MODE)mode success:(MRSuccessHandler)success failure:(MRFailureError)error;

#pragma mark 8.ptz move
/**
 *@brief ptz move
 *@param[in] ps - left or right move -100~100.
 *@param[in] ts - up or down move -100~100.
 *@param[in] zs - 0.
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)startptz:(NSInteger)ps
              ts:(NSInteger)ts
              zs:(NSInteger)zs
         success:(MRSuccessHandler)success
         failure:(MRFailureError)error;

/**
 *@brief stopptz
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)stopptz:(MRSuccessHandler)success failure:(MRFailureError)error;

#pragma mark 9.get or set device params
/**
 *@brief getdeviceinfo
 *@param[in]  cmd    look up enum of cmd
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)getdeviceparams:(MR_CMD_GET)cmd success:(MRSuccessID)success failure:(MRFailureError)error;

/**
 *@brief setdeviceinfo
 *@param[in]  cmd    look up enum of cmd
 *@param[in]  jsonData json foramt data
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)setdeviceparams:(MR_CMD_SET)cmd
               jsonData:(NSString *)jsonData
                success:(MRSuccessID)success
                failure:(MRFailureError)error;

- (void)commondeviceparams:(NSString *)jsonData success:(MRSuccessID)success failure:(MRFailureError)error;

/**
 * Callback with http code, recommended
 */
- (void)commondeviceparams2:(NSString *)jsonData success:(MRSuccessID)success failure:(MRFailureError)error;

- (void)facedetect:(char *)yuv420sp success:(MRSuccessID)success failure:(MRFailureError)error;

#pragma mark 10.get status
/**
 *@brief getPlayStatus
 *@return CameraStatus
 */
- (unsigned int)getPlayStatus;

/**
 *@brief video streaming bit
 *@return bit/s
 */
- (NSInteger)getBitRate;

/**
 *@brief Is the player muted?
 *@return muted or unmute
 */
- (BOOL)isMuted;

/**
 *@brief 0:P2P 1:Relay 2:LAN
 *@return video network mode
 */
- (NSInteger)getNatType;

#pragma mark 13.zoom and move
/**
 *brief zoom
 *params scale>=1
 *return 0-success -6-status not in preview and playback
 */
- (int)zoom2:(float)scale;

/**
 *brief move
 *params dpx - screen dp x move
 dpy - screen dp y move
 *return 0-success -6-status not in preview and playback
 */
- (int)move2:(float)dpx dpy:(float)dpy;

/**
 *brief record audio
 *params filePath - mode path
 */
- (void)startRecordAudio:(AUDIO_MODE)mode toPath:(NSString *)filePath;

/**
 *@brief stop record audio
 *@param[out] success  when success,then call it,block mode file path
 */
- (void)stopRecordAudio:(AUDIO_MODE)mode success:(MRSuccessString)success;

/**
 *@brief start play audio
 *@param[out] mode  audio mode
 *@param[out] filePath  audio path
 *@param[out] finished  audio play finished
 */
- (void)startPlayAudio:(AUDIO_MODE)mode withPath:(NSString *)filePath finished:(MRSuccessHandler)finished;

/**
 *@brief stop g711 audio
 *@param[out] mode audio mode
 */
- (void)stopPlayAudio:(AUDIO_MODE)mode;

/**
 *@brief  full duplex speech
 *@params enable is yes to open loud speaker
 */
- (void)setLoudSpeakerOpen:(BOOL)enable;

/**
 *@brief  full duplex speech
 */
- (NSString *)getVoiceEffectInfo;

#pragma mark 14. Network config Encryption
/**
 *@brief  Encry qrcode text
 */
- (NSData *)qrcodeEncryption:(NSString *)ssid password:(NSString *)psw token:(NSString *)token subDevice:(BOOL)sub;

/**
 *@brief Encry Ap info
 */
- (void)setApEncryption:(NSString *)ssid
               password:(NSString *)password
                  token:(NSString *)token
                success:(MRSuccessHandler)success
                failure:(MRFailureError)error;

#pragma mark 15. Encryption Method
//二维码加密
+ (NSData *)meariQrcodeEncryption:(NSString *)content;
//二维码解密
+ (NSString *)meariQrcodeDecryption:(char *)content length:(int)length;
//新版本v2的图片加密之后的名称key
+ (char *)meariAlarmImageMd5Key:(NSString *)password;
//新版本v2的图片加密 解密前面1024字节
+ (NSData *)meariAlarmImageDecodeHeadData:(NSString *)password data:(NSData *)data;

#pragma mark 16. Prtp Protocol
+ (int)prtpDiscovery:(int)timeout  success:(MRSuccessID)success failure:(MRFailureError)error;

+ (int)prtpStopDiscovery:(MRSuccessHandler)success failure:(MRFailureError)error;

- (int)prtpLogin:(NSString*)ip port:(int)port user:(NSString*)user password:(NSString*)password success:(MRSuccessHandler)success abnormalDisconnect:(MRAbnormalDisconnect)disconnect failure:(MRFailureError)error;

- (int)prtpInitConnect:(NSString*)ip port:(int)port success:(MRSuccessHandler)success failure:(MRFailureError)error;

- (int)prtpLogin:(NSString*)user password:(NSString*)password success:(MRSuccessHandler)success failure:(MRFailureError)error;

- (int)prtpLogout:(MRSuccessHandler)success failure:(MRFailureError)error;

- (int)prtpDestroy:(MRSuccessHandler)success failure:(MRFailureError)error;

- (int)prtpCommonRequestData:(char*)data len:(int)len msgid:(PPS_PRTP_DP_MODE_TYPE)msgid success:(MRSuccessID)success failure:(MRFailureError)error;

- (int)prtpStartLive:(AppleOpenGLView *)gllayer channel:(int)channel streamid:(int)streamid success:(MRSuccessHandler)success failure:(MRFailureError)error streamclose:(MRFailureError)streamclose;

- (int)prtpChangeLive:(AppleOpenGLView *)glLayer channel:(int)channel streamid:(int)streamid success:(MRSuccessHandler)success failure:(MRFailureError)error;

- (int)prtpStopLive:(int)channel streamid:(int)streamid success:(MRSuccessHandler)success failure:(MRFailureError)error;

- (int)prtpStartHistory:(char*)files  channelid:(int)channelid startTime:(int)startTime endTime:(int)endTime  success:(MRSuccessHandler)success failure:(MRFailureError)error streamclose:(MRFailureError)streamclose;

- (int)prtpStopHistory:(MRSuccessHandler)success failure:(MRFailureError)error;

@end
