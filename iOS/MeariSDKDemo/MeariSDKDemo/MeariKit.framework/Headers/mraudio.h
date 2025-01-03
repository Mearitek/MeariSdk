/*
 audio interface file
     - sdl  -- 基于SDL开发音频播放器
     - audiounit -- 基于IOS AUDIOUINIT开发音频播放器开发
     - audiotrack -- 基于Android 系统播放器开发
     - opengles   -- 基于OPENGL ES框架开发音频播放器开发
*/
#ifndef _MRAUDIO_H
#define _MRAUDIO_H
enum {
    MRAUDIO_RENDER_NONE = 0,
    MRAUDIO_RENDER_SDL,               // SDL播放
    MRAUDIO_RENDER_APPLE_AUDIOUNIT,   // IOS AUDIOUNIT播放
    MRAUDIO_RENDER_APPLE_AUDIOQUEUE,  // IOS AUDIOQUEUE播放
    MRAUDIO_RENDER_ANDROID_AUDITRACK, // ANDROID AUDITRACK播放
    MRAUDIO_RENDER_ANDROID_OPENGLES,  // OPENGLES播放
    MRAUDIO_MAX_NUMS
};
#define MAX_CHANNEL_AUDIO_NUMS 64 //定义最多音频播放通道数64个
typedef struct _audiodata {
    int freq;      // 音频采样率 44100 32000 16000 8000
    int format;    // 音频格式 8|16
    int channels;  // 音频通道数 1|2
    int samples;   // 音频采样率
    void *arender; // 传回mraudio_render
} audioinfo;

typedef struct mraudio_render {
    /*
    * mraudio_init
    *   ffplay取流后回调播放器初始化参数
    *   [out]audioctx      播放器实例，可以是播放器类或者播放器结构体，
                           在调用ffplay_reg_audio_render时传入

    *   [out]ffp           当前ffplayer的实例
    *   [out]info          ffplayer实例码流解复用后得到的音频参数
    */
    int (*mraudio_init)(void *audioctx, void *ffp, audioinfo *info);
    /*
    * mraudio_open
    *   ffplayer通知打开音频播放器，部分播放器可以再外部实现，无需实现
    *   [out]audioctx       播放器实例，可以是播放器类或者播放器结构体，
                            在调用ffplay_reg_audio_render时传入

    *   [out]ffp            当前ffplayer的实例
     *  [return]mraudio_play时如果不一定会立马播放此声音，这里需要返回缓存的数据大小
    */
    int (*mraudio_open)(void *audioctx, void *ffp);
    /*
  * mraudio_play
  *   ffplayer通知播放声音，声音数据提供给播放器，仅用于不是系统调用的音频播放器
  *   [out]audioctx       播放器实例，可以是播放器类或者播放器结构体，
                        在调用ffplay_reg_audio_render时传入

  *   [out]ffp            当前ffplayer的实例
  *   [out]data           PCM数据内容
  *   [out]len            PCM数据长度
  *   [out]sec            数据时长,秒为单位
  */
    int (*mraudio_play)(void *audioctx, void *ffp, char *data, int len, double sec, audioinfo *audio_info);
    /*
     * mraudio_getaudio
     *   系统获取参数
     *   [out]ffp            当前ffplayer或mrplayer的实例
     *   [out]data           PCM数据内容
     *   [out]len            PCM数据长度
     */
    int (*mraudio_getaudio)(void *ffp, char *data, int len);
    /*
    * mraudio_stop
    *   ffplayer通知停止音频播放器，部分播放器可以再外部实现，无需实现
    *   [out]audioctx       播放器实例，可以是播放器类或者播放器结构体，
                            在调用ffplay_reg_audio_render时传入

    *   [out]ffp            当前ffplayer的实例
    */
    int (*mraudio_stop)(void *audioctx, void *ffp);
    /*
     * mraudio_destory
     *   ffplayer通知销毁音频播放器，部分播放器可以再外部实现，无需实现
     *   [out]render       render实例
     */
    int (*mraudio_destory)(void *audioctx, void *ffp);
    //  后期使用，现在先保存当前音频播放类型
    int type;
    //  播放器实例,提供给ffplayer使用
    void *audioctx;
} mraudio_render;

#endif
