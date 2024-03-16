#ifndef CAMERAPLAYER_DEFINE_H
#define CAMERAPLAYER_DEFINE_H

#include "hplatform.h"
#include "mraudio.h"
#include "mraudiorec.h"
#include "mrvideo.h"
enum Camera_Cmd {
    MR_START_WIFI_MONITOR,
    MR_STOP_WIFI_MONITOR,
    MR_CHECK_DEVICE_ADD_PWD,
    MR_SET_AP_WIFI,
    MR_SET_LAN_WIFI,
    MR_START_SEARCHDEV, /// ok
    MR_STOP_SEARCHDEV,  /// ok
    MR_LOGIN_CMD,       /// ok
    MR_START_LIVE,      /// ok
    MR_LIVE_OPTIONS,    /// pause resume
    MR_STOP_LIVE,       /// ok
    MR_CHANGE_LIVE_STREAM,
    MR_START_HISTORY,   /// ok
    MR_HISTORY_OPTIONS, /// ok
    MR_STOP_HISTORY,    /// ok
    MR_SET_HISTORY_SPEED,

    MR_DELETE_HISTORY,
    MR_DOWNLOAD_HISTORY,
    // 1:resume 2:pause 3:stop
    MR_DOWNLOAD_HISTORY_CONTROL,

    MR_GET_STREAM_INFO,

    MR_START_VOICETALK, /// ok
    MR_STOP_VOICETALK,  /// ok
    MR_SET_MIRROR,      /// ok
    MR_FORMAT_SD_CARD,  /// ok
    MR_HTTP_PARAMS_V1,  /// ok
    MR_HTTP_PARAMS_V2,  /// ok
    MR_PTZ_MOVE,        /// ok
    MR_PTZ_STOP,        /// ok
    MR_SNAPSHOT,        /// ok
    MR_MUTE,
    MR_START_RECORD, /// ok
    MR_STOP_RECORD,  /// ok
    MR_LOGOUT_CMD,   /// ok
    MR_IOT_LOGIN,    /// ok
    MR_IOT_LOGOUT,   /// ok
    MR_P2P_RECONNECT,
    MR_IOT_SUB_DEVICE,      /// ok
    MR_IOT_SET_PARAMS,      /// ok
    MR_IOT_GET_PARAMS,      /// ok
    MR_IOT_RECONNECT,       /// ok
    MR_SET_LOG_PATH,        /// ok
    MR_SET_LOG_LEVEL,       /// ok
    MR_SET_BURIED_LOG,      /// ok
    MR_INSET_BURIED_LOG,    /// ok
    MR_START_DEVICE_CONFIG,    /// ok
    MR_CLEAN_DEVICE_CONFIG,    /// ok
    MR_DEVICE_CONFIG_COMMON_REQUEST,    /// ok
    MR_START_LIVE_MULTI,
    MR_START_HISTORY_MULTI,
    MR_SNAPSHOT_MULTI,
    MR_START_RECORD_MULTI,
    MR_STOP_RECORD_MULTI,
    MR_DOWNLOAD_HISTORY_MULTI,
    MR_DOWNLOAD_HISTORY_CONTROL_MULTI,

    MR_PLAYER_COMMON_OPERATE,   ///通用操作,使用json传递参数。适用一些特殊设置，不太适合在这里新增指令的

    MR_FILE_PLAYER_RELEASE,
    MR_FILE_PLAYER_START,
    MR_FILE_PLAYER_START_MULTI,
    MR_FILE_PLAYER_STOP,
    MR_FILE_PLAYER_PAUSE,
    MR_FILE_PLAYER_RESUME,
    MR_FILE_PLAYER_SEEK,
    MR_FILE_PLAYER_DEC_KEY,

    /// 本地设备的指令，仅用于私有协议设备
    MR_PRTP_DISCOVERY = 500,      /// ok
    MR_PRTP_STOP_DISCOVERY, /// ok
    MR_PRTP_LOGIN,          /// ok
    MR_PRTP_LOGOUT,         /// ok
    MR_PRTP_COMMON_REQ,
    MR_PRTP_START_LIVE, /// ok
    MR_PRTP_STOP_LIVE,  /// ok
    MR_PRTP_MUTE,
    MR_PRTP_SNAPSHOT,
    MR_PRTP_START_RECORD,
    MR_PRTP_STOP_RECORD,
    MR_PRTP_CHANGE_LIVE_STREAM,
    MR_PRTP_START_HISTORY,
    MR_PRTP_HISTORY_OPTIONS,
    MR_PRTP_STOP_HISTORY,
    MR_PRTP_START_VOICETALK,
    MR_PRTP_STOP_VOICETALK,
    MR_PRTP_INIT,       //初始化player
    MR_PRTP_DESTROY,    //释放这个player的所有资源
    MR_PRTP_DOWNLOAD_SOURCE,
    MR_PRTP_START_UPGRADE,
    MR_PRTP_CANCEL_UPGRADE,
    MR_SET_ALARM_CFG,      /// ok
    MR_P2P_FORMAT_SD_CARD_PERCENT,  /// OK
    MR_P2P_GET_INFO,
    MR_CMD_NUMS
};

typedef struct cmd_des {
    int cmd;
    const char *des;
} cmd_des;

static cmd_des g_cmd_des[] = {{MR_CHECK_DEVICE_ADD_PWD, "Check device add command"},
                              {MR_SET_AP_WIFI, "Set ap command"},
                              {MR_SET_LAN_WIFI, "Set lan wifi command"},
                              {MR_START_SEARCHDEV, "Enable device search command"},
                              {MR_STOP_SEARCHDEV, "Stop device search command"},
                              {MR_LOGIN_CMD, "Login Device Instructions"},
                              {MR_PLAYER_COMMON_OPERATE, "Device common interface"},
                              {MR_START_LIVE_MULTI, "Open multi-live command"},
                              {MR_START_LIVE, "Open live command"},
                              {MR_LIVE_OPTIONS, "Live related instructions"},
                              {MR_STOP_LIVE, "Stop live command"},
                              {MR_CHANGE_LIVE_STREAM, "Toggle live stream command"},
                              {MR_START_HISTORY_MULTI, "Start multi-playback command"},
                              {MR_START_HISTORY, "Start playback command"},
                              {MR_HISTORY_OPTIONS, "Playback related commands"},
                              {MR_STOP_HISTORY, "Stop playback command"},
                              {MR_SET_HISTORY_SPEED,"Set playback speed command"},
                              {MR_DELETE_HISTORY,"Delete sd record command"},
                              {MR_DOWNLOAD_HISTORY, "Start download playback command"},
                              {MR_DOWNLOAD_HISTORY_MULTI, "Start download playback command for multi-decoder"},
                              {MR_DOWNLOAD_HISTORY_CONTROL, "[Pause|Resume|Stop] download playback command"},
                              {MR_DOWNLOAD_HISTORY_CONTROL_MULTI, "[Pause|Resume|Stop] download playback command for multi-decoder"},
                              {MR_GET_STREAM_INFO, "Get play|playback stream info"},
                              {MR_START_VOICETALK, "Start intercom command"},
                              {MR_STOP_VOICETALK, "Stop intercom command"},
                              {MR_SET_MIRROR, "Set the screen mirroring command"},
                              {MR_SET_ALARM_CFG, "Set motion detection config command"},
                              {MR_FORMAT_SD_CARD, "SD card format command"},
                              {MR_HTTP_PARAMS_V1, "HTTP request V1 command"},
                              {MR_HTTP_PARAMS_V2, "HTTP request V2 command"},
                              {MR_PTZ_MOVE, "Enable PTZ control command"},
                              {MR_PTZ_STOP, "Stop PTZ control command"},
                              {MR_SNAPSHOT, "Screenshot command"},
                              {MR_SNAPSHOT_MULTI, "Screenshot command for multi-decoder"},
                              {MR_MUTE, "Mute command"},
                              {MR_START_RECORD, "Start recording command"},
                              {MR_START_RECORD_MULTI, "Start recording command for multi-decoder"},
                              {MR_STOP_RECORD, "Stop recording command"},
                              {MR_STOP_RECORD_MULTI, "Stop recording command for multi-decoder"},
                              {MR_LOGOUT_CMD, "Logout device command"},
                              {MR_IOT_LOGIN, "Self-developed server login command"},
                              {MR_IOT_LOGOUT, "Self-developed server logout command"},
                              {MR_P2P_RECONNECT, "P2P reconnection recovery command"},
                              {MR_IOT_SUB_DEVICE,          "Self-developed equipment subscription command"},
                              {MR_IOT_SET_PARAMS,          "Self-developed equipment setting command"},
                              {MR_IOT_GET_PARAMS,          "Self-developed equipment to getting command"},
                              {MR_IOT_RECONNECT,           "Self-developed server reconnection command"},
                              {MR_SET_LOG_PATH,            "Set log path command"},
                              {MR_SET_LOG_LEVEL,           "Set log print level command"},
                              {MR_SET_BURIED_LOG,          "Set Buried Point Command"},
                              {MR_INSET_BURIED_LOG,        "Insert a buried log"},

                              {MR_START_DEVICE_CONFIG,     "device config! start"},
                              {MR_CLEAN_DEVICE_CONFIG,     "device config! clean resources"},
                              {MR_DEVICE_CONFIG_COMMON_REQUEST,"device config! request"},

                              {MR_FILE_PLAYER_RELEASE,     "MrFile player release"},
                              {MR_FILE_PLAYER_START,       "MrFile player start"},
                              {MR_FILE_PLAYER_START_MULTI, "MrFile player start-multi"},
                              {MR_FILE_PLAYER_STOP,        "MrFile player stop"},
                              {MR_FILE_PLAYER_PAUSE,       "MrFile player pause"},
                              {MR_FILE_PLAYER_RESUME,      "MrFile player resume"},
                              {MR_FILE_PLAYER_SEEK,        "MrFile player seek"},
                              {MR_FILE_PLAYER_DEC_KEY,        "MrFile player dec key"},

                              {MR_PRTP_DISCOVERY,          "PRTP discovery local devices command"},
                              {MR_PRTP_STOP_DISCOVERY,     "PRTP stop discovery command"},
                              {MR_PRTP_LOGIN,              "PRTP connect local device command"},
                              {MR_PRTP_LOGOUT,             "PRTP disconnet local devices command"},
                              {MR_PRTP_COMMON_REQ,         "PRTP common request command"},
                              {MR_PRTP_START_LIVE,         "PRTP start live command"},
                              {MR_PRTP_STOP_LIVE,          "PRTP stop live command"},
                              {MR_PRTP_MUTE,               "PRTP set mute"},
                              {MR_PRTP_SNAPSHOT,           "PRTP snapshot command"},
                              {MR_PRTP_START_RECORD,       "PRTP start record command"},
                              {MR_PRTP_STOP_RECORD,        "PRTP stop record command"},
                              {MR_PRTP_CHANGE_LIVE_STREAM, "PRTP change live command"},
                              {MR_PRTP_START_HISTORY,      "PRTP start history command"},
                              {MR_PRTP_HISTORY_OPTIONS,    "PRTP set histroy options command"},
                              {MR_PRTP_STOP_HISTORY,       "PRTP stop histroy command"},
                              {MR_PRTP_START_VOICETALK,    "PRTP start voicetalk command"},
                              {MR_PRTP_STOP_VOICETALK,     "PRTP stop voicetalk command"},
                              {MR_PRTP_INIT,                "PRTP init"},
                              {MR_PRTP_DESTROY,             "PRTP destroy"},
                              {MR_PRTP_DOWNLOAD_SOURCE,     "PRTP download"},
                              {MR_P2P_FORMAT_SD_CARD_PERCENT,     "SD card format percent command"},
                              {MR_P2P_GET_INFO,     "P2P info get command"},
                              {MR_PRTP_START_UPGRADE,     "PRTP start upgrade"},
                              {MR_PRTP_CANCEL_UPGRADE,     "PRTP cancel upgrade"},
                              {-1, "Can't find this command"}};

typedef struct _CameraPlayerCmdRep {
    int cmd;       /// 指令码
    int seq;       /// 包号
    int index;     /// Camplayer索引
    int mode;      /// 会废弃
    int result;    /// 返回值
    void *context; /// 用户自定义的上下文指针
    char *params;  /// json结构体，要求必须memalloc
    int len;       /// json结构体长度
} CameraPlayerCmdRep;

typedef void (*cameraplay_cmd_response)(CameraPlayerCmdRep *rep);

typedef struct _CameraPlayerCmd {
    int cmd;                          /// 指令码
    int seq;                          /// 包号
    int index;                        /// Camplayer索引
    int mode;                         /// 会废弃
    void *context;                    /// 用户自定义的上下文指针
    char *params;                     /// json结构体，!!!要求要用alloc
    int len;                          /// json结构体长度
    cameraplay_cmd_response callback; /// 自定义指令成功回调,NULL则不调用
} CameraPlayerCmd;

/// 该回调只用于commit提交任务后回调，包括各种操作指令
typedef void (*camera_cmd_callback)(CameraPlayerCmdRep *resp);
/// 状态包含一下几种:
/// P2P异常断开、播放中断、设备休眠、设备已唤醒、设备进入地理围栏、发现码流切换
enum {
    CAMERA_P2P_DISCONNECT,
    CAMERA_LIVE_FIRST_RENDER,
    CAMERA_LIVE_IN_SLEEP,
    CAMERA_LIVE_IN_TIME_SLEEP,
    CAMERA_LIVE_IN_GEO,
    CAMERA_LIVE_LEAVE_SLEEP,
    CAMERA_LIVE_INTERRUPTED,
    CAMERA_LIVE_FIND_NEW_MEDIA_STREAM,
    CAMERA_HISTORY_FIRST_RENDER,
    CAMERA_HISTORY_SEEK,
    CAMERA_HISTORY_FIND_NEW_MEDIA_STREAM,
    CAMERA_HISTORY_INTERRUPTED,
    CAMERA_FOUND,
    CAMERA_P2P_CONNECT_CHANGED,
    //自适应流变化
    CAMERA_AUTO_STREAM_CHANGED,
};

//通用的回调接口类型
enum {
    COMMON_PRTP_PIC = 0,
    COMMON_PRTP_DOWNLOAD = 1,
    COMMON_PRTP_UPGRADE = 2,
};

//多路流中的流的tag
enum {
    MULTI_STREAM_VIDEO_TAG_0 = 0,
    MULTI_STREAM_VIDEO_TAG_1 = 1,
    MULTI_STREAM_VIDEO_TAG_2 = 2,
    MULTI_STREAM_VIDEO_TAG_3 = 3,
    MULTI_STREAM_VIDEO_TAG_4 = 4,
    MULTI_STREAM_VIDEO_TAG_5 = 5,
};

#define PLAY_MODE 0
#define PLAYBACK_MODE 1
#define VOICE_MODE 2
#define CLOUD_MODE 3
#define PLAYBACK_DOWNLOAD_MODE 4
#define MODE_CLOUD_SEARCH 0
#define MODE_LOCAL_SEARCH 1
#define MODE_ALL_SEARCH -1
#define MAX_WIFI_SSID_LENGTH 64
#define MAX_WIFI_PASSWORD_LENGTH 128

#define MAX_CAMERA_COUNT 64
#define DEFAULT_CAMERA_INDEX 65

typedef void (*camera_status_callback)(void *userdata, int camera_index, int status_code, int result, char *params,
                                       int len);
typedef void (*camera_common_callback)(void *userdata, int camera_index, int type, int arg_int, char* arg_str, char *data,
                                       int data_len);
/// 下面的回调服务于码流相关
/// 回调当前音频媒体信息
typedef void (*camera_audio_mediainfo_callback)(void *userdata, int camera_index, int channels, int samples,
                                                int media_format, int hw_enable);
/// 回调当前视频媒体信息
typedef void (*camera_video_mediainfo_callback)(void *userdata, int camera_index, int width, int height, double fps,
                                                int media_format, int time_ms);
/// 回调当前从设备端收到的视频流
typedef void (*camera_video_recv_stream_callback)(void *userdata, int camera_index, int media_format,
                                                  unsigned char *data, int size, double pts, double duration, int width,
                                                  int height);
/// 回调当前解码后的视频流，注意如果硬解码就还是原始流，软解码就是YUV420数据
typedef void (*camera_video_dec_render_callback)(void *userdata, int camera_index, unsigned char *data, int len,
                                                 int width, int height, int hw_enable);
/// 回调当前从设备端收到的音频流
typedef void (*camera_audio_recv_stream_callback)(void *userdata, int camera_index, unsigned char *data, int len,
                                                  int channels, int samples, int media_format);
/// 回调音频解码后的PCM数据
typedef void (*camera_audio_dec_render_callback)(void *userdata, unsigned char *data, int len, int channels,
                                                 int samples, int media_format);

typedef struct camera_callback {
    void *userdata;
    int camera_index;
    camera_cmd_callback cmd_cb;
    camera_common_callback common_cb;
    camera_status_callback status_cb;
    camera_audio_mediainfo_callback audio_recv_mediainfo_cb;
    camera_video_mediainfo_callback video_recv_mediainfo_cb;
    camera_video_recv_stream_callback video_recv_stream_cb;
    camera_video_dec_render_callback video_dec_render_cb;
    camera_audio_recv_stream_callback audio_recv_stream_cb;
    camera_audio_dec_render_callback audio_dec_render_cb;
} camera_callback;

#define CameraStatusNoDevice 0
#define CameraStatusDeviceOnline 1
#define CameraStatuslogin (1 << 1)
#define CameraStatusPlay (1 << 2)
#define CameraStatusPlayback (1 << 3)
#define CameraStatusMoving (1 << 4)
#define CameraStatusVoice (1 << 5)
#define CameraStatusPlayMuted (1 << 6)
#define CameraStatusPlaybackMuted (1 << 7)
#define CameraStatusPlayRecord (1 << 8)
#define CameraStatusPlaybackRecord (1 << 9)
#define CameraStatusPlaySnapshot (1 << 10)
#define CameraStatusPlaybackSnapshot (1 << 11)
#define CameraStatusLogining (1 << 12)
#define CameraStatusPreparePlay (1 << 13)
#define CameraStatusSpeaking (1 << 14)
#define CameraStatusPlayMulti (1 << 15)
#define CameraStatusPlaybackMulti (1 << 16)

#define PrtpStatusDefault 0
#define PrtpStatusConnect (1 << 1)
#define PrtpStatusAuth (1 << 2)

#define SUCCESS_OPERATION 0
#define FAILURE_OPERATION -1
#define INVALID_PARAMS -2
#define BUSY_WORK -3
#define INVALID_HANDLE -4
#define INVALID_INDEX -5
#define INVALID_POINT -6
#define INVALID_STATUS -7
#define INVALID_OPERATION -8
#define CHECK_HANDLE(x)            \
    {                              \
        if (x <= 0) {              \
            return INVALID_HANDLE; \
        }                          \
    }
#define CHECK_IN_STATUS(x, y)                      \
    {                                              \
        if ((x & y) != y) {                        \
            hlogw("%d not have status(%d)", x, y); \
            return INVALID_STATUS;                 \
        }                                          \
    }
#define CHECK_NOT_IN_STATUS(x, y)              \
    {                                          \
        if ((x & y) == y) {                    \
            hlogw("%d have status(%d)", x, y); \
            return INVALID_STATUS;             \
        }                                      \
    }
#define CHECK_NULL(x)             \
    {                             \
        if (x == NULL) {          \
            return INVALID_POINT; \
        }                         \
    }
#define CHECK_NULL_CHAR(x) \
    {                      \
        if (x == NULL) {   \
            return NULL;   \
        }                  \
    }
#define CHECK_NULL_VOID(x) \
    {                      \
        if (x == NULL) {   \
            return;        \
        }                  \
    }

#define ADD_CAMERA_STATUS(x, y)                          \
    {                                                    \
        if ((x & y) != y)                                \
            x = x + y;                                   \
        else                                             \
            hlogw("%d no need to add status(%d)", x, y); \
    }

#define REMOVE_CAMERA_STATUS(x, y)                          \
    {                                                       \
        if ((x & y) == y)                                   \
            x = x - y;                                      \
        else                                                \
            hlogw("%d no need to remove status(%d)", x, y); \
    }

enum Voice_Type {
    SD_NORMAL = 0,
    SD_MAN,
    SD_CLOWN,
    // can not set
    SD_SETTING_NORMAL = 100,
    SD_SETTING_MAN,
    SD_SETTING_CLOWN
};

enum { MR_STREAM_LIVE, MR_STREAM_HISTORY, MR_STREAM_VOICE, MR_STREAM_NUMS };

typedef enum {
    MR_DOWNLOAD_STATUS_NO = 0,
    MR_DOWNLOAD_STATUS_ING,
    MR_DOWNLOAD_STATUS_PAUSE,
}ENUM_MR_DOWNLOAD_STATUS;

typedef struct _lanParams {
    char ip[32];
    char token[32];
    char deviceAddPwd[64];
} lanParams;

typedef struct _wifiParams {
    char ssid[32];
    char password[64];
    char token[32];
    int type;
} wifiParams;

typedef struct _searchParams {
    char search_url[64];
    char token[32];
    //自己传自己使用
    void *user_data;
} searchParams;

typedef struct _ptzParams {
    int enable;
    int ts;
    int ps;
    int zs;
} ptzParams;

typedef struct _historyDeleteParams {
    //2021 0201 020202
    char startTime[16];
    char endTime[16];
    int channelId;
} historyDeleteParams;

typedef struct _historyDownloadControlParams {
    int cmd;
    int channelId;
    int downloadIndex;
} playbackDownloadControlParams;

typedef struct _historyDownloadParams {
    //2021 0201 020202
    char startTime[16];
    char endTime[16];
    //android 可以比较长 搞大点
    char savedFilePath[512];
    int channelId;
    int timeZone;
} historyDownloadParams;

typedef struct _multiHistoryDownloadParams {
    //2021 0201 020202
    char startTime[16];
    char endTime[16];
    //json字符串 {"0":"xxxxx","1":"xxxxx",.....}
    char files[512 * 3];
    int channelId;
    int timeZone;
    int count;
} multiHistoryDownloadParams;

typedef struct _voicetalkParams {
    mraudio_render *arender;
    mraudio_rec_dev *indev;
    char phone[32];
    char model[32];
    int mode; /// 0-单向对讲 1-双向对讲 2-语音门铃对讲
    char files[512];
    char files2[512];
    float mic;
    float speak;
} voicetalkParams;

typedef struct _liveParams {
    mrvideo_render *render;
    mraudio_render *arender;
    int enable_hw;
    int port;
    int isLowPix;
    int extraParams;
} liveParams;

typedef struct _multiLiveParams {
    int count;
    //长度为count的(mrvideo_render *)数组
    mrvideo_render **render;
    //长度为count的(mraudio_render *)数组
    mraudio_render **arender;
    int enable_hw;
    int port;
    int isLowPix;
    int extraParams;
} multiLiveParams;

typedef struct _seekParams {
    char seektime[32];
} seekParams;

typedef struct _historyParams {
    mrvideo_render *render;
    mraudio_render *arender;
    int enable_hw;
    char playtime[32];
    uint32_t startutctime;
    uint32_t endutctime;
    char playfile[64];
    int channel;
} historyParams;

typedef struct _multiHistoryParams {
    int count;
    //长度为count的(mrvideo_render *)数组
    mrvideo_render **render;
    //长度为count的(mraudio_render *)数组
    mraudio_render **arender;

    int enable_hw;
    char playtime[32];
    uint32_t startutctime;
    uint32_t endutctime;
    char playfile[512];
    int channel;
} multiHistoryParams;

typedef struct _CameraPlayerInfo {
    char uuid[32];     /// 设备P2P号
    char password[32]; /// 设备访问密码
    int status;        /// 当前播放器状态
    int p2pmode;       /// 当前打洞模式
    int handle;        /// ppsdk打洞返回的上下文实例
} CameraPlayerInfo;

typedef struct {
    char ip[32];
    int port;
} DeviceConfigParams;

typedef struct _PrtpConnectInfo {
    char ip[32];
    int port;
    char user[32];
    char password[64];
    char* params;
} PrtpConnectInfo;

typedef struct _PrtpConfigInfo {
    int auto_reconnect;        //是否自动重连
    unsigned int reconnect_timeout_ms;    //从断开到连接上的最大时间
    int reconnect_interval_ms;  //重连间隔时间
} PrtpConfigInfo;

typedef struct _PrtpUpgradeFirmwareParams {
    char version_name[256];
    char filePath[512];
} PrtpUpgradeFirmwareParams;

typedef struct {
    int type;
    char key[128];
    int v;
} FilePlayerKey;

char *print_cmd(int cmd, char *data);
#endif
