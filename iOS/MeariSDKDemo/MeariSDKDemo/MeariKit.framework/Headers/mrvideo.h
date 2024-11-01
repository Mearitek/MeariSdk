/*
 video interface file
     - sdl   -- 基于SDL开发视频频播放器
     - opengles  -- 基于OPENGL ES开发视频频播放器
*/
#ifndef _MRVIDEO_H_
#define _MRVIDEO_H_

enum {
    MRVIDEO_RENDER_NONE = 0,
    MRVIDEO_RENDER_SDL,              // SDL视频播放
    MRVIDEO_RENDER_APPLE_OPENGLES,   // IOS OPENGL视频播放
    MRVIDEO_RENDER_ANDROID_OPENGLES, // ANDROID OPENGL视频播放
    MRVIDEO_MAX_NUMS
};

enum {
    //重置刷新解码器状态
    HW_FLUSH = 0,
    //一直输入数据直到解码成功
    HW_FEED_FOR_FIRST_RENDER,
    //解码
    HW_INPUT_DECODER,
    //渲染HW_INPUT_DECODER的数据
    HW_OUTPUT_RENDER,
    //标识流解码结束（刷新解码器里可能得未输出的数据）
    HW_END,
    //解码+渲染
    HW_DEC_AND_RENDER,
    //判断数据是否支持解码
    HW_DETECT,
    //解码器使用结束
    HW_STOP
};

typedef struct _MRRational {
    int num;
    int den;
} MRRational;

typedef struct mrvideo_render {
    int (*mrvideo_hw_dec_render)(void* hwnd, void* ffp, int hw_type, int streamid, char* data, int size, int width,
                                 int height, double ts, char **out_data);
    void (*mrvideo_image_render)(void* hwnd, void* ffp, int format, int colorspace, unsigned char** data, int* linesize,
                                 int width, int height, MRRational sar);
    int (*mrvideo_close)(void* hwnd, void* ffp);
    int type;
    //render的自定义标识
    int tag;
    void* hwnd;
} mrvideo_render;

typedef struct mrview_rect {
    float x;
    float y;
    float width;
    float height;
} mrview_rect;

#endif
