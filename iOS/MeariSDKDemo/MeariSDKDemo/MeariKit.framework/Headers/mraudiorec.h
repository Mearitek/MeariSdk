#ifndef MRAUDIO_REC_H
#define MRAUDIO_REC_H

enum {
    MRAUDIO_REC_NONE = 0,
    MRAUDIO_REC_SDL,               // SDL录音
    MRAUDIO_REC_APPLE_AUDIOUNIT,   // IOS AUDIOUNIT录音
    MRAUDIO_REC_APPLE_AUDIOQUEUE,  // IOS AUDIOQUEUE录音
    MRAUDIO_REC_ANDROID_AUDITRACK, // ANDROID AUDITRACK录音
    MRAUDIO_REC_ANDROID_OPENGLES,  // OPENGLES录音
    MRAUDIO_REC_MAX_NUMS
};

typedef struct _audiorecinfo {
    int freq;
    int foramt;
    int channels;
    int samples;
} audiorecinfo;

/// 这个只要外部注册即可
typedef int (*mraudio_input_data)(void *audioctx, void *ffp, char *data, int len, double peakPower,
                                  double averagePower);

typedef struct _mraudio_rec_dev {
    int (*mraudio_input_init)(void *audioctx, void *ffp, audiorecinfo *info);
    int (*mraudio_input_open)(void *audioctx, void *ffp);
    int (*mraudio_input_stop)(void *audioctx, void *ffp);
    int (*mraudio_input_destory)(void *audioctx, void *ffp);
    mraudio_input_data cb;
    void *audioctx;
    void *ffp;
} mraudio_rec_dev;

#endif
