/*
 video interface file
     - sdl   -- 基于SDL开发视频频播放器
     - opengles  -- 基于OPENGL ES开发视频频播放器
*/
#ifndef _MRVIDEO_H_
#define _MRVIDEO_H_

enum{
    MRVIDEO_RENDER_NONE=0,
    MRVIDEO_RENDER_SDL,    //SDL视频播放
    MRVIDEO_RENDER_APPLE_OPENGLES,    //IOS OPENGL视频播放
    MRVIDEO_RENDER_ANDROID_OPENGLES,  //ANDROID OPENGL视频播放
    MRVIDEO_MAX_NUMS
};

enum{
    HW_FLUSH=0,
    HW_FEED_FOR_FIRST_RENDER,
    HW_INPUT_DECODER,
    HW_OUTPUT_REDNER,
    HW_END,
    HW_DETECT,
    HW_STOP
};

typedef struct _MRRational{
    int num;
    int den;
}MRRational;

typedef struct mrvideo_render{
    int (*mrvideo_hw_dec_render)(void* hwnd,void* ffp,int hw_type,int streamid,char* data,int size,int width,int height,int64_t ts);
    void (*mrvideo_image_render)(void* hwnd,void* ffp,int format,int colorspace,unsigned char** data,int* linesize,int width,int height,MRRational sar);
    int (*mrvideo_close)(void* hwnd,void* ffp);
    int type;
    void *hwnd;
}mrvideo_render;

typedef struct mrview_rect{
    float x;
    float y;
    float width;
    float height;
}mrview_rect;


#endif
