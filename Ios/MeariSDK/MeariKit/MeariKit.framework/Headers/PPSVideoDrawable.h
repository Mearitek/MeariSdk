/**
 *@file PPSVideoDrawable.h
 *@author HF.CHEN
 */
#import <GLKit/GLKit.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/EAGL.h>

@interface PPSVideoDrawable : GLKView


@property (nonatomic, assign) CGFloat currentScale;
@property (nonatomic, assign) float currentdpx;
@property (nonatomic, assign) float currentdpy;
@property (nonatomic, readonly) NSInteger currentdrawableWidth;
@property (nonatomic, readonly) NSInteger currentdrawableHeight;

- (void)refreshTextureWithY:(u_int8_t*)y U:(u_int8_t*)u V:(u_int8_t*)v width:(NSInteger)width height:(NSInteger)height;

- (void)refreshTextureWithY:(u_int8_t*)y U:(u_int8_t*)u V:(u_int8_t*)v width:(NSInteger)width height:(NSInteger)height index:(NSInteger)index;

- (void)renderAndShow;

- (void)clearView;

#pragma mark zoom
- (int)zoom:(float)scale POS_X:(float)x POS_Y:(float)y;

- (int)move:(float)x_len Y_LENGHT:(float)y_len;

- (int)mirror:(int)type;

- (int)zoom2:(float)scale;

- (int)move2:(float)dpx dpy:(float)dpy;

@end
