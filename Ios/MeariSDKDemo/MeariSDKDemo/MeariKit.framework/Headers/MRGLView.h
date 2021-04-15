//
//  MRGLView.h
//  MRPlayer
//
//  Created by 陈杭峰 on 2017/5/23.
//  Copyright © 2017年 ppstrong. All rights reserved.
//

#ifndef MRGLView_h
#define MRGLView_h
#import <UIKit/UIKit.h>

@interface MRGLView : UIView
@property (nonatomic, assign) CGFloat currentScale;
@property (nonatomic, assign) float currentdpx;
@property (nonatomic, assign) float currentdpy;
@property (nonatomic, readonly) NSInteger currentdrawableWidth;
@property (nonatomic, readonly) NSInteger currentdrawableHeight;

- (id) initWithFrame:(CGRect)frame;

- (void)render_yuv420p:(u_int8_t*)y U:(u_int8_t*)u V:(u_int8_t*)v width:(NSInteger)width height:(NSInteger)height;

- (BOOL)render_yuv420sp:(CVPixelBufferRef)pixelBuffer;

-(void)move:(float)dpx dpy:(float)dpy;

-(void)zoom:(float)scale;

- (UIImage*)snapshot;

@end

#endif /* MRGLView_h */
