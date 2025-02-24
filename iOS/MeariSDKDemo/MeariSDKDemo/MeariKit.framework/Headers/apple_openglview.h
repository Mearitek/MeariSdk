//
//  AppleOpenGLView.h
//  MRPlayer
//
//  Created by 陈杭峰 on 2017/5/23.
//  Copyright © 2017年 ppstrong. All rights reserved.
//

#ifndef Apple_OpenGL_View_h
#define Apple_OpenGL_View_h
#import <UIKit/UIKit.h>

#import "ios_videotoolbox_vdec.h"
#include "mrvideo.h"

mrvideo_render *apple_opengl_render_create(void *hwnd);
mrvideo_render *apple_opengl_render_create1(void *hwnd,int tag);

int apple_opengl_render_destory(mrvideo_render *render);

int releasePiexlBuffer(char *data,char res[4]);

@interface AppleOpenGLView : UIView {
    @public CVPixelBufferRef _bufferData;
    NSLock *glActiveLock;
    double displayTs;
//    BOOL bufferUsed;
}
@property (nonatomic, assign) CGFloat currentScale;
@property (nonatomic, assign) float currentdpx;
@property (nonatomic, assign) float currentdpy;
@property (nonatomic, readonly) NSInteger currentdrawableWidth;
@property (nonatomic, readonly) NSInteger currentdrawableHeight;
@property (nonatomic, strong) Apple_HardDecoder *hw_dec;
@property (nonatomic, assign) int streamid;
@property (nonatomic, assign) int videowidth;
@property (nonatomic, assign) int videoheight;

@property (nonatomic, assign) BOOL bufferUsed;
@property (nonatomic, assign) BOOL fisheyeFlag;
//@property (nonatomic, assign) CVPixelBufferRef bufferData;

- (id)initWithFrame:(CGRect)frame;

- (void)render_yuv420p:(u_int8_t *)y U:(u_int8_t *)u V:(u_int8_t *)v width:(NSInteger)width height:(NSInteger)height;

- (BOOL)render_yuv420sp:(CVPixelBufferRef)pixelBuffer;

- (void)move:(float)dpx dpy:(float)dpy;

- (void)zoom:(float)scale;

- (BOOL)snapshot:(NSString *)path;

- (void)resetHardDecode;

- (void)releaserender;

- (void)deallocGLEnvironment;

- (void)deallocGLEnvironmentWithoutResetHard;

- (void)reset;

- (void)rotateCCW90;

- (void)setFisheyeInfo:(CGFloat)r x:(CGFloat)x y:(CGFloat)y;
- (void)setFisheyeInfo:(CGFloat)ra rb:(CGFloat)rb x:(CGFloat)x y:(CGFloat)y;
//时间类型 1:预览 2:回放 3:云回放
- (void)setTimeType:(int)type;
- (void)setTimeZoneName:(NSString *)timeZone;
@end

#endif /* AppleOpenGLView_h */
