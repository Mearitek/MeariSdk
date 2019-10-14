/**
 *@file PPSPlayer.h
 *@author HF.CHEN
 */

#import <UIKit/UIKit.h>
#import "PPSVideoDrawable.h"
#import "PPSGLView.h"
typedef void (^PPSuccessHandler)();
typedef void (^PPSInterruptedHandler)();
typedef void (^PPSuccessDict)(NSDictionary *dict);
typedef void (^PPSuccessString)(NSString *result);
typedef void (^PPSuccessList)(NSArray *list);
typedef void (^PPSuccessBOOL)(BOOL result);
typedef void (^PPSuccessID)(id result);
typedef void (^PPSuccessInt)(int result);

typedef void (^PPFailureHandler)();
typedef void (^PPFailureError)(NSString *error);

/**
 *  GETPPSCMD
 */
typedef enum{
    GET_PPS_DEVICE_INFO,
    GET_PPS_DEVICE_MIRROR,
    GET_PPS_DEVICE_ALARM,
    GET_PPS_DEVICE_PIC,
    GET_PPS_DEVICE_UPGRADE_PERCENT,
    GET_PPS_DEVICE_FORMAT_PERCENT,
    GET_PPS_DEVICE_SD_STORAGE_INFO
}GETPPSCMD;

/**
 *  SETPPSCMD
 */
typedef enum{
    SET_PPS_DEVICE_MIRROR,
    SET_PPS_DEVICE_ALARM,
    SET_PPS_DEVICE_PASSWORD,
    SET_PPS_DEVICE_FORAMT,
    SET_PPS_DEVICE_UPGRADE,
    SET_PPS_DEVICE_LOCAL_UPGRADE,
    SET_PPS_DEVICE_REBOOT
}SETPPSCMD;

/**
 *  KEY_PSK
 */
typedef enum{
    KEY_MGMT_OPEN = 0,
    KEY_MGMT_WEP = 1,
    KEY_MGMT_WPA_PSK = 2,
    KEY_MGMT_WPA_ENTPRISE = 3,
    KEY_MGMT_WPA2_PSK = 4
}KEY_PSK;

/**
 *  SD_PLAYBACK_CMD
 */
typedef enum{
    SD_PLAYBACK_SEEK,
    SD_PLAYBACK_PASUE,
    SD_PLAYBACK_RESUME
}SD_PLAYBACK_CMD;

/**
 *  SNAPSHOT_MODE
 */
typedef enum{
    SNAPSHOT_TO_SHAHE,
    SNAPSHOT_TO_PHOTO,
    SNAPSHOT_TO_ALL
}SNAPSHOT_MODE;

/**
 *  RECORD_MODE
 */
typedef enum{
    RECORD_TO_SHAHE,
    RECORD_TO_PHOTO,
    RECORD_TO_ALL
}RECORD_MODE;

typedef enum{
    PLAY_MODE,
    PLAYBACK_MODE
}_PLAY_MODE;

/**
 *  AUDIO_MODE
 */
typedef enum{
    PCM_TO_G711,
    PCM_TO_WAV,
    PCM,
}AUDIO_MODE;
typedef enum {
    TOKEN_SMARTWIFI,
    TOKEN_AP,
    TOKEN_QRCODE
}TOKEN_TYPE;

typedef enum {
    SPEECH_ONE_WAY,
    SPEECH_FULL_DUPLEX
}SPEECH_MODE;

typedef enum {
    VIDEOSTREAM_HD          = 0,
    VIDEOSTREAM_SD          ,
    VIDEOSTREAM_SD_360      ,
    VIDEOSTREAM_SD_480      ,
    VIDEOSTREAM_HD2         ,
    VIDEOSTREAM_UHD_Low     ,
    VIDEOSTREAM_UHD_Middle  ,
    VIDEOSTREAM_UHD_High    ,
}VIDEOSTREAM;

typedef NS_OPTIONS(NSInteger, SEARCH_MODE) {
    SEARCH_MODE_LAN = 1 << 0,
    SEARCH_MODE_CLOUD_SMARTWIFI = 1 << 1,
    SEARCH_MODE_CLOUD_AP = 1 << 2,
    SEARCH_MODE_CLOUD_QRCODE = 1 << 3,
    SEARCH_MODE_CLOUD = SEARCH_MODE_CLOUD_SMARTWIFI | SEARCH_MODE_CLOUD_AP | SEARCH_MODE_CLOUD_QRCODE,
    SEARCH_MODE_ALL = SEARCH_MODE_LAN | SEARCH_MODE_CLOUD
};

/**
 *  ERROR_CODE
 */
static int ERR_VALID_POINT = 1;
static int ERR_SUCCESS=0;
static int ERR_UPGRADING=-1;
static int ERR_PREVIEWING=-2;
static int ERR_NOLOGIN=-3;
static int ERR_PLAYBACKING=-4;
static int ERR_INTIMESLEEP=-5;
static int ERR_INGEOSLEEP=-6;
static int ERR_INSLEEP=-7;
static int ERR_LEAVESLEEP=-8;
static int ERR_NULL_POINT=-9;
static int ERR_NOT_INIT=-10;
static int ERR_STATUS=-11;
static int ERR_DEVICE_OFFLINE = -12;
static int ERR_PASSWORD = -13;
static int ERR_DISCONNECTED = -14;
static int ERR_OTHERPLAYBACKING=-15;
static int ERR_VIDEO_CLIP_RECORDING=-16;
static int ERR_VOICE_TALK_FAIL=-17;
static int ERR_CHECK_TIMEOUT=-27;
static int ERR_HTTP_UPGRADING=501;
static int ERR_HTTP_UPGRADLIMIT=403;
static int ERR_HTTP_SUCCESS =200;
/**
 *  STATUS
 */
static unsigned int CameraStatusNoDevice     = 0;//device not login or offline
static unsigned int CameraStatusDeviceOnline = 1;//device online
static unsigned int CameraStatusLogin        = 1 << 1;//login device
static unsigned int CameraStatusPlay         = 1 << 2;//previewing
static unsigned int CameraStatusRecording    = 1 << 3;//recording
static unsigned int CameraStatusMoving       = 1 << 4;//ptz moving
static unsigned int CameraStatusPlayRecord   = 1 << 5;//playbacking
static unsigned int CameraStatusVoicing      = 1 << 6;//voicing talk
static unsigned int CameraStatusMuted        = 1 << 7;//mute
static unsigned int CameraStatusLogining     = 1 << 8;//already login
static unsigned int CameraStatusPlayChanging = 1 << 9;
static unsigned int CameraStatusPreparePlay  = 1 << 10; //ready preview
static unsigned int CameraStatusNormal       = 0x3;
static NSLock *g_ppsplaystatuslock=nil;
static void  initppsplaystatuslock(){
    if(g_ppsplaystatuslock==nil)
    {
        g_ppsplaystatuslock=[[NSLock alloc]init];
    }
}

__unused static void  PPSPLAY_INIT_BOOL_STATUS(BOOL*x,BOOL y){
    initppsplaystatuslock();
    [g_ppsplaystatuslock lock];
    *x=y;
    [g_ppsplaystatuslock unlock];
}

__unused static void  PPSPLAY_INIT_STATUS(unsigned int*x,unsigned int y){
    initppsplaystatuslock();
    [g_ppsplaystatuslock lock];
    *x=y;
    [g_ppsplaystatuslock unlock];
}

__unused static void  PPSPLAY_ADD_STATUS(unsigned int*x,unsigned int y){
    initppsplaystatuslock();
    [g_ppsplaystatuslock lock];
    *x=*x|y;
    [g_ppsplaystatuslock unlock];
}

__unused static void  PPSPLAY_REMOVE_STATUS(unsigned int*x,unsigned int y){
    initppsplaystatuslock();
    [g_ppsplaystatuslock lock];
    *x=*x&~y;
    [g_ppsplaystatuslock unlock];
}

__unused static BOOL  PPSPLAY_CHECK_WITHOUT_STATUS(unsigned int x,unsigned int y){
    initppsplaystatuslock();
    [g_ppsplaystatuslock lock];
    if((x&y)==y){
        [g_ppsplaystatuslock unlock];
        return false;
    }else{
        [g_ppsplaystatuslock unlock];
        return true;
    }
}

__unused static BOOL  PPSPLAY_CHECK_WITH_STATUS(unsigned int x,unsigned int y){
    initppsplaystatuslock();
    [g_ppsplaystatuslock lock];
    if((x&y)!=y){
        [g_ppsplaystatuslock unlock];
        return false;
    }else{
        [g_ppsplaystatuslock unlock];
        return true;
    }
}

__unused static BOOL  PPSPLAY_CHECK_OBJECT_POINT_IS_NULL(void* x){
    initppsplaystatuslock();
    [g_ppsplaystatuslock lock];
    if(x==NULL){
        [g_ppsplaystatuslock unlock];
        return true;
    }else{
        [g_ppsplaystatuslock unlock];
        return false;
    }
}

__unused static BOOL  PPSPLAY_CHECK_NSOBJECT_POINT_IS_NULL(NSObject* x){
    initppsplaystatuslock();
    [g_ppsplaystatuslock lock];
    if(x==nil){
        [g_ppsplaystatuslock unlock];
        return true;
    }else{
        [g_ppsplaystatuslock unlock];
        return false;
    }
}

__unused static BOOL  PPSPLAY_CHECK_NOT_INIT(BOOL x){
    initppsplaystatuslock();
    [g_ppsplaystatuslock lock];
    if(x==false){
        [g_ppsplaystatuslock unlock];
        return true;
    }else{
        [g_ppsplaystatuslock unlock];
        return false;
    }
}

__unused static BOOL  PPSPLAY_CHECK_NSOBJECT_POINT_IS_NOT_NULL(NSObject* x){
    initppsplaystatuslock();
    [g_ppsplaystatuslock lock];
    if(x==nil){
        [g_ppsplaystatuslock unlock];
        return false;
    }else{
        [g_ppsplaystatuslock unlock];
        return true;
    }
}

__unused static NSString* PPSPLAY_CREATE_MSG(NSString* msg,int msgcode){
    initppsplaystatuslock();
    [g_ppsplaystatuslock lock];
    NSString* code = [[NSString alloc] initWithFormat:@"%d",msgcode];
    NSDictionary* msgdic = @{ @"code":code,@"msg":msg};
    NSError *error;
    NSData* msgdata = [NSJSONSerialization dataWithJSONObject:msgdic options:NSJSONWritingPrettyPrinted error:&error];
    NSString* json_msg = [[NSString alloc]initWithData:msgdata encoding:NSUTF8StringEncoding];
    [g_ppsplaystatuslock unlock];
    return json_msg;
}

#define DECODER_MAX 32

@interface PPSPlayer : NSObject
@property (nonatomic, assign) SPEECH_MODE speechMode;

- (instancetype)init NS_UNAVAILABLE;

/**
 *@brief init with a baseUrl
 *@param searchBaseUrl  base Jurl for search by cloud
 */
+ (instancetype)playerWithSearchBaseUrl:(NSString *)searchBaseUrl;

-(NSString*)getVersion;

#pragma mark 0.configure wifi and search IPC
/**
 *@brief update token for configuration mode
 *@param token  unique token
 *@param tokenType  token type for configuration mode
 */
- (void)updateToken:(NSString *)token tokenType:(TOKEN_TYPE)tokenType;

/**
 *@brief update token
 *@param token  unique token
 */
- (int)updatetoken:(NSString*)token DEPRECATED_MSG_ATTRIBUTE("use: - (void)updateToken:(NSString *)token tokenType:(TOKEN_TYPE)tokenType instead");

/**
 *@brief Get the set Token according to the type
 *@param type  configuration mode
 */
- (NSString*)gettoken:(TOKEN_TYPE)type;

/**
 *@brief monitor configure ssid for ipc
 *@param[in]  ssid -- ssid
 *@param[in]  password -- password of device
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)monitor:(NSString*)ssid password:(NSString*)password success:(PPSuccessHandler)success failure:(PPFailureError)error;

/**
 *@brief stop configure ssid for ipc
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)stopmonitor:(PPSuccessHandler)success failure:(PPFailureError)error;

/**
 *@brief ap configure ssid for ipc
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)setAp:(NSString*)ssid password:(NSString*)password PSK:(KEY_PSK)psk success:(PPSuccessHandler)success failure:(PPFailureError)error;

/**
 *@brief search ipc
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)__deprecated searchIPC:(PPSuccessID)success failure:(PPFailureError)error;

/**
 *@brief stop search ip
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)__deprecated stopsearchIPC:(PPSuccessHandler)success failure:(PPFailureError)error;

/**
 *@brief search ipc
 *@param[out] mode      search mode
 *@param[out] success   when success,then call it
 *@param[out] error     when failed,then call it
 */
-(void)startSearchWithMode:(SEARCH_MODE)mode success:(PPSuccessID)success failure:(PPFailureError)error;

/**
 *@brief stop search ip
 */
-(void)stopsearchIPC2;

#pragma mark 1.connect device and login
/**
 *@brief check Ipc is online or offline or check timeout for show UI
 *@param[in]  uid -- uuid
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)checkDevOnlineStatus:(NSString*)uid success:(PPSuccessID)success failure:(PPFailureError)error;

/**
 *@brief first you must connect IPC
 *@param[in]  uid -- uuid
 *@param[in]  username -- username of device
 *@param[in]  password -- password of device
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)connectIPC:(NSString*)uid username:(NSString*)username password:(NSString*)password success:(PPSuccessHandler)success failure:(PPFailureError)error;

-(void)connectIPC2:(NSString*)logindata  success:(PPSuccessHandler)success failure:(PPFailureError)error;
/**
 *@brief you can disconnect IPC
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)disconnectIPC:(PPSuccessHandler)success failure:(PPFailureError)error;

#pragma mark 2.preview
-(void)__deprecated startPreview:(PPSVideoDrawable*)videoUIView streamid:(BOOL)HD success:(PPSuccessHandler)success failure:(PPFailureError)error streamclose:(PPFailureError)streamclose;
/**
 *@brief first you must connect IPC
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)__deprecated stopPreview:(PPSuccessHandler)success failure:(PPFailureError)error;

-(void)__deprecated changePreview:(PPSVideoDrawable*)videoUIView  streamid:(BOOL)HD success:(PPSuccessHandler)success failure:(PPFailureError)error;

-(void)startPreview2:(PPSGLView*)glLayer streamid:(VIDEOSTREAM)stream success:(PPSuccessHandler)success failure:(PPFailureError)error streamclose:(PPFailureError)streamclose;

-(void)stopPreview2:(PPSuccessHandler)success failure:(PPFailureError)error;

-(void)changePreview2:(PPSGLView*)glLayer  streamid:(VIDEOSTREAM)stream success:(PPSuccessHandler)success failure:(PPFailureError)error;

#pragma mark 3.playback
/**
 *@brief start playback sd card
 *@param[in]  month -- month such as 1-12
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)searchPlaybackListOnMonth:(NSInteger)year month:(NSInteger)month videoid:(NSInteger)videoid success:(PPSuccessID)success failure:(PPFailureError)error;

/**
 *@brief start playback sd card
 *@param[in]  month -- month such as 1-12
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)searchPlaybackListOnday:(NSInteger)year month:(NSInteger)month day:(NSInteger)day videoid:(NSInteger)videoid success:(PPSuccessID)success failure:(PPFailureError)error;

/**
 *@brief start playback sd card
 *@param[in]  videoUIView -- videoUIView
 *@param[in]  starttime -- 20150312120000
 *@param[in]  videoid -- streamid of device
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)__deprecated startPlaybackSd:(PPSVideoDrawable*)videoUIView starttime:(NSString*)starttime videoid:(NSInteger)videoid success:(PPSuccessHandler)success failure:(PPFailureError)error;

-(void)startPlaybackSd2:(PPSGLView*)glLayer starttime:(NSString*)starttime videoid:(NSInteger)videoid success:(PPSuccessHandler)success failure:(PPFailureError)error;

/**
 *@brief send playback sd card cmd(seek,pause,resume)
 *@param[in]  cmd -- SD_PLAYBACK_CMD
 *@param[in]  seektime -- seektime(20160727201414)
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)sendPlaybackCmd:(SD_PLAYBACK_CMD)cmd seektime:(NSString*)seektime success:(PPSuccessHandler)success failure:(PPFailureError)error;

/**
 *@brief stop playback sd card
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)__deprecated stopPlaybackSd:(PPSuccessHandler)success failure:(PPFailureError)error;

-(void)stopPlaybackSd2:(PPSuccessHandler)success failure:(PPFailureError)error;

/**
 *@brief get current playback time,hms
 *@return h*3600+min*60+sec
 */
-(NSUInteger)getPlaybackTime;

#pragma mark 4.mute
/**
 *@brief enable audio mute
 *@param[in]  mute -- true/false
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
- (void)__deprecated enableMute:(BOOL)mute mode:(_PLAY_MODE)mode success:(PPSuccessHandler)success failure:(PPFailureError)error;
- (void)enableMute:(BOOL)muted;

#pragma mark 5.voice talk
/**
 *@brief init voice talk environment
 *@param[out] baseUrl  get voice param
 *@param[out] userid  user tag
 */
-(void)initVoiceTalk:(NSString *)baseUrl userID:(NSString *)userid model:(NSString *)model firmware:(NSString *)firmware;

/**
 *@brief enable voice talk
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)startvoicetalk:(BOOL)isvoicebell success:(PPSuccessHandler)success failure:(PPFailureError)error;

/**
 *@brief disable voice talk
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)stopvoicetalk:(PPSuccessHandler)success failure:(PPFailureError)error;

-(GLfloat)getvoiceAveragePower;

/**
 *@brief only for voicebell,pasue phone record voice
 */
-(void)pausevoicetalk;

/**
 *@brief only for voicebell,resume phone record voice
 */
-(void)resumevoicetalk;

#pragma mark 6.snapshot
-(BOOL)createSFAlbum:(NSString*)AlbumName;

/**
 *@brief snapshot
 *@param[in]  path     must be XXXX/XXX.jpg
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)snapshot:(NSString*)path playmode:(_PLAY_MODE)playmode mode:(SNAPSHOT_MODE)mode success:(PPSuccessHandler)success failure:(PPFailureError)error;

/**
 *@brief getframe
 *@param[out] success  when success,then call it，return UIImage
 *@param[out] error  when failed,then call it
 */
-(void)__deprecated getframe:(PPSuccessID)success failure:(PPFailureError)error;

#pragma mark 7.record mp4
/**
 *@brief startrecordmp4
 *@param[in]  path     must be XXXX/XXX.mp4
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)startrecordmp4:(NSString*)path playmode:(_PLAY_MODE)playmode mode:(RECORD_MODE)mode success:(PPSuccessHandler)success failure:(PPFailureError)error;

/**
 *@brief startrecordmp4
 *@param[in]  path     must be XXXX/XXX.mp4
 *@param[out] success  when success,then call it
 *@param[out] interrputed  When the code stream changes,then call it
 *@param[out] error  when failed,then call it
 */
-(void)startrecordmp4:(NSString*)path playmode:(_PLAY_MODE)playmode mode:(RECORD_MODE)mode success:(PPSuccessHandler)success recordInterrputed:(PPSInterruptedHandler)interrputed failure:(PPFailureError)error;

/**
 *@brief stoprecordmp4
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)stoprecordmp4:(_PLAY_MODE)mode success:(PPSuccessHandler)success failure:(PPFailureError)error;

#pragma mark 8.ptz move
/**
 *@brief ptz move
 *@param[in] ps - left or right move -100~100.
 *@param[in] ts - up or down move -100~100.
 *@param[in] zs - 0.
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)startptz:(NSInteger)ps ts:(NSInteger)ts zs:(NSInteger)zs success:(PPSuccessHandler)success failure:(PPFailureError)error;

/**
 *@brief stopptz
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)stopptz:(PPSuccessHandler)success failure:(PPFailureError)error;

#pragma mark 9.get or set device params
/**
 *@brief getdeviceinfo
 *@param[in]  cmd    look up enum of cmd
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)getdeviceparams:(GETPPSCMD)cmd success:(PPSuccessID)success failure:(PPFailureError)error;

/**
 *@brief setdeviceinfo
 *@param[in]  cmd    look up enum of cmd
 *@param[in]  jsonData json foramt data
 *@param[out] success  when success,then call it
 *@param[out] error  when failed,then call it
 */
-(void)setdeviceparams:(SETPPSCMD)cmd jsonData:(NSString*)jsonData success:(PPSuccessID)success failure:(PPFailureError)error;

-(void)commondeviceparams:(NSString*)jsonData success:(PPSuccessID)success failure:(PPFailureError)error;
//callback http code
-(void)commondeviceparams2:(NSString*)jsonData success:(PPSuccessID)success failure:(PPFailureError)error;

#pragma mark 10.get status
/**
 *@brief getPlayStatus
 *@return CameraStatus
 */
-(unsigned int)getPlayStatus;

-(NSInteger)getBts;

-(BOOL)isPlayingHD;

-(BOOL)isMuted;

-(NSInteger)getNatType;


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
- (void)stopRecordAudio:(AUDIO_MODE)mode success:(PPSuccessString)success;


/**
 *@brief start play audio
 *@param[out] mode  audio mode
 *@param[out] filePath  audio path
 *@param[out] finished  audio play finished
 */
- (void)startPlayAudio:(AUDIO_MODE)mode withPath:(NSString *)filePath finished:(PPSuccessHandler)finished;

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
@end
