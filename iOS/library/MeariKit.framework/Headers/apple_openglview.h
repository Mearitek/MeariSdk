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
#include "mrvideo.h"
#import "ios_videotoolbox_vdec.h"

mrvideo_render* apple_opengl_render_create(void* hwnd);

int apple_opengl_render_destory(mrvideo_render* render);

@interface AppleOpenGLView : UIView
@property (nonatomic, assign) CGFloat currentScale;
@property (nonatomic, assign) float currentdpx;
@property (nonatomic, assign) float currentdpy;
@property (nonatomic, readonly) NSInteger currentdrawableWidth;
@property (nonatomic, readonly) NSInteger currentdrawableHeight;
@property (nonatomic, strong) Apple_HardDecoder* hw_dec;

- (id) initWithFrame:(CGRect)frame;

- (void)render_yuv420p:(u_int8_t*)y U:(u_int8_t*)u V:(u_int8_t*)v width:(NSInteger)width height:(NSInteger)height;

- (BOOL)render_yuv420sp:(CVPixelBufferRef)pixelBuffer;

-(void)move:(float)dpx dpy:(float)dpy;

-(void)zoom:(float)scale;

- (BOOL)snapshot:(NSString*)path;

- (void)deallocGLEnvironment;

- (void)rotateCCW90;

- (void)reset;
@end

#endif /* AppleOpenGLView_h */
