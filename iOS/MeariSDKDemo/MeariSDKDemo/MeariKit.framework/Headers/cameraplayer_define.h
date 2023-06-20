#ifndef CAMERAPLAYER_DEFINE_H
#define CAMERAPLAYER_DEFINE_H

#include "mraudio.h"
#include "mrvideo.h"
enum Camera_Cmd{
    MR_START_WIFI_MONITOR,
    MR_STOP_WIFI_MONITOR,
    MR_SET_AP_WIFI,
    MR_START_SEARCHDEV, /// ok
    MR_STOP_SEARCHDEV, /// ok
    MR_LOGIN_CMD, /// ok
    MR_START_LIVE, /// ok
    MR_LIVE_OPTIONS,/// pause resume
    MR_STOP_LIVE, /// ok
    MR_START_HISTORY, /// ok
    MR_HISTORY_OPTIONS,/// ok
    MR_STOP_HISTORY, /// ok
    MR_START_VOICETALK, /// ok
    MR_STOP_VOICETALK, /// ok
    MR_SET_MIRROR,/// ok
    MR_FORMAT_SD_CARD,/// ok
    MR_HTTP_PARAMS_V1, /// ok
    MR_HTTP_PARAMS_V2, /// ok
    MR_PTZ_MOVE, /// ok
    MR_PTZ_STOP, /// ok
    MR_SNAPSHOT, /// ok
    MR_START_RECORD, /// ok
    MR_STOP_RECORD, /// ok
    MR_LOGOUT_CMD, /// ok
    MR_IOT_LOGIN, /// ok
    MR_IOT_LOGOUT, /// ok
    MR_IOT_SUB_DEVICE, /// ok
    MR_IOT_SET_PARAMS, /// ok
    MR_IOT_GET_PARAMS, /// ok
    MR_IOT_RECONNECT, /// ok
    MR_SET_LOG_PATH, /// ok
    MR_SET_LOG_LEVEL, /// ok
    MR_SET_BURIED_LOG, /// ok
    MR_INSET_BURIED_LOG, /// ok
    MR_CMD_NUMS
};

typedef struct cmd_des{
    int cmd;
    const char* des;
}cmd_des;

static cmd_des g_cmd_des[]={
    {MR_START_SEARCHDEV, "开启设备搜索指令"},
    {MR_STOP_SEARCHDEV, "停止设备搜索指令"},
    {MR_LOGIN_CMD, "登录设备指令"},
    {MR_START_LIVE, "开启直播指令"},
    {MR_LIVE_OPTIONS, "直播相关指令"},
    {MR_STOP_LIVE, "停止直播指令"},
    {MR_START_HISTORY, "开启回放指令"},
    {MR_HISTORY_OPTIONS, "回放相关指令"},
    {MR_STOP_HISTORY, "停止回放指令"},
    {MR_START_VOICETALK, "开启对讲指令"},
    {MR_STOP_VOICETALK, "停止对讲指令"},
    {MR_SET_MIRROR, "设置画面镜像指令"},
    {MR_FORMAT_SD_CARD, "SD卡格式化指令"},
    {MR_HTTP_PARAMS_V1, "HTTP请求V1指令"},
    {MR_HTTP_PARAMS_V2, "HTTP请求V2指令"},
    {MR_PTZ_MOVE, "开启云台控制指令"},
    {MR_PTZ_STOP, "停止云台指令"},
    {MR_SNAPSHOT, "截图指令"},
    {MR_START_RECORD, "开启录像指令"},
    {MR_STOP_RECORD, "停止录像指令"},
    {MR_LOGOUT_CMD, "登出设备指令"},
    {MR_IOT_LOGIN, "自研服务器登录指令"},
    {MR_IOT_LOGOUT, "自研服务器登出指令"},
    {MR_IOT_SUB_DEVICE, "自研设备订阅指令"},
    {MR_IOT_SET_PARAMS, "自研设备设置指令"},
    {MR_IOT_GET_PARAMS, "自研设备获取指令"},
    {MR_IOT_RECONNECT, "自研服务器重连指令"},
    {MR_SET_LOG_PATH,"设置日志路径指令"},
    {MR_SET_LOG_LEVEL,"设置日志打印等级指令"},
    {MR_SET_BURIED_LOG,"设置埋点指令"},
    {MR_INSET_BURIED_LOG,"插入一条埋点日志"},
    {-1,"找不到这个指令"}
};

typedef struct _CameraPlayerCmdRep{
    int cmd;/// 指令码
    int seq;/// 包号
    int index;/// Camplayer索引
    int mode;/// 会废弃
    int result;/// 返回值
    void *context;/// 用户自定义的上下文指针
    char *params;/// json结构体
    int  len;/// json结构体长度
}CameraPlayerCmdRep;

typedef void (*cameraplay_cmd_response)(CameraPlayerCmdRep* rep);

typedef struct _CameraPlayerCmd{
    int cmd;/// 指令码
    int seq;/// 包号
    int index;/// Camplayer索引
    int mode;/// 会废弃
    void *context;/// 用户自定义的上下文指针
    char *params;/// json结构体
    int  len;/// json结构体长度
    cameraplay_cmd_response callback;/// 自定义指令成功回调,NULL则不调用
}CameraPlayerCmd;

/// 该回调只用于commit提交任务后回调，包括各种操作指令
typedef void (*camera_cmd_callback)(CameraPlayerCmdRep* resp);
/// 状态包含一下几种: P2P异常断开、播放中断、设备休眠、设备已唤醒、设备进入地理围栏、发现码流切换
enum{
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
    CAMERA_FOUND
};

#define PLAY_MODE 0
#define PLAYBACK_MODE 1
#define VOICE_MODE 2
#define MODE_CLOUD_SEARCH 0
#define MODE_LOCAL_SEARCH 1
#define MODE_ALL_SEARCH -1
#define MAX_WIFI_SSID_LENGTH 64
#define MAX_WIFI_PASSWORD_LENGTH 128

#define MAX_CAMERA_COUNT 64
#define DEFAULT_CAMERA_INDEX 65

typedef void (*camera_status_callback)(void *userdata,int camera_index,int status_code,int result,char* params,int len);
/// 下面的回调服务于码流相关
/// 回调当前音频媒体信息
typedef void (*camera_audio_mediainfo_callback)(void *userdata,int camera_index,int channels, int samples,int media_format,int hw_enable);
/// 回调当前视频媒体信息
typedef void (*camera_video_mediainfo_callback)(void *userdata,int camera_index,int width, int height,double fps,int media_format);
/// 回调当前从设备端收到的视频流
typedef void (*camera_video_recv_stream_callback)(void *userdata,int camera_index,int media_format, unsigned char *data, int size, double pts,double duration,int width, int height);
/// 回调当前解码后的视频流，注意如果硬解码就还是原始流，软解码就是YUV420数据
typedef void (*camera_video_dec_render_callback)(void *userdata,int camera_index, unsigned char *data, int len, int width, int height,int hw_enable);
/// 回调当前从设备端收到的音频流
typedef void (*camera_audio_recv_stream_callback)(void *userdata,int camera_index, unsigned char *data, int len,int channels, int samples,int media_format);
/// 回调音频解码后的PCM数据
typedef void (*camera_audio_dec_render_callback)(void *userdata, unsigned char *data, int len,int channels, int samples,int media_format);

typedef struct camera_callback
{
    void *userdata;
    int   camera_index;
    camera_cmd_callback cmd_cb;
    camera_status_callback status_cb;
    camera_audio_mediainfo_callback audio_recv_mediainfo_cb;
    camera_video_mediainfo_callback video_recv_mediainfo_cb;
    camera_video_recv_stream_callback video_recv_stream_cb;
    camera_video_dec_render_callback video_dec_render_cb;
    camera_audio_recv_stream_callback audio_recv_stream_cb;
    camera_audio_dec_render_callback audio_dec_render_cb;
} camera_callback;

#define CameraStatusNoDevice 0
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
        if (x <= 0)                \
        {                          \
            return INVALID_HANDLE; \
        }                          \
    }
#define CHECK_IN_STATUS(x, y)      \
    {                              \
        if ((x & y) != y)          \
        {                          \
            return INVALID_STATUS; \
        }                          \
    }
#define CHECK_NULL(x)             \
    {                             \
        if (x == NULL)            \
        {                         \
            return INVALID_POINT; \
        }                         \
    }
#define CHECK_NULL_CHAR(x) \
    {                      \
        if (x == NULL)     \
        {                  \
            return NULL;   \
        }                  \
    }
#define CHECK_NULL_VOID(x) \
    {                      \
        if (x == NULL)     \
        {                  \
            return;        \
        }                  \
    }

enum Voice_Type{
    SD_NORMAL=0,
    SD_MAN,
    SD_CLOWN,
    // can not set
    SD_SETTING_NORMAL=100,
    SD_SETTING_MAN,
    SD_SETTING_CLOWN
};

enum{
   MR_STREAM_LIVE,
   MR_STREAM_HISTORY,
   MR_STREAM_VOICE,
   MR_STREAM_NUMS
};

typedef struct _wifiParams{
    char ssid[32];
    char password[64];
}wifiParams;

typedef struct _ptzParams{
    int enable;
    int ts;
    int ps;
    int zs;
}ptzParams;

typedef struct _voicetalkParams{
   mraudio_render *arender;
   char phone[32];
   char model[32];
   int  mode;/// 0-单向对讲 1-双向对讲 2-语音门铃对讲
}voicetalkParams;

typedef struct _liveParams{
    mrvideo_render *render;
    mraudio_render *arender;
    int port;
    int isLowPix;
    int extraParams;
}liveParams;

typedef struct _seekParams{
    char seektime[32];
}seekParams;

typedef struct _historyParams{
    mrvideo_render *render;
    mraudio_render *arender;
    char playtime[32];
    int  channel;
}historyParams;

typedef struct _CameraPlayerConfig{
    int sync_mode;/// 0-音频 1-视频 2-外部时钟
    int show_status;/// 打印内部状态
    double playSpeed;/// 播放速度0.25~4.0
    int video_disable;/// 0-不禁用 1-禁用
    int audio_disable;/// 0-不禁用 1-禁用
    int voice_mode;///0-单向对讲 1-双向对讲 2: 语音门铃
    int step_play;///0-不启用 1-启用逐帧播放
    enum Voice_Type voicetype;/// 变声配置
    int hardware_dec;//0-启用软解码 1-启用硬解码器
}CameraPlayerConfig;

typedef struct _CameraPlayerInfo{
    char uuid[32];/// 设备P2P号
    char password[32];/// 设备访问密码
    int status;/// 当前播放器状态
    int p2pmode;/// 当前打洞模式
    int handle;/// ppsdk打洞返回的上下文实例
}CameraPlayerInfo;

char* print_cmd(int cmd,char* data);
#endif
