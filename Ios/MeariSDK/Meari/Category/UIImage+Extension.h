//
//  UIImage+Extension.h
//  Meari
//
//  Created by 李兵 on 16/3/2.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

- (BOOL)wy_saveToPath:(NSString *)path;
- (UIImage *)clipImageInRect:(CGRect)rect;

//  颜色转换为背景图片
+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color;


/**
 *  压缩图片
 *
 *  @param image 原图片
 *  @param asize 指定的压缩大小
 *
 *  @return 压缩后的等比例的图片
 */
+ (nullable UIImage *)imageWithOriginalImage:(nonnull UIImage *)image scaledSize:(CGSize)asize;

@end


NS_ASSUME_NONNULL_BEGIN
@interface UIImage (WYConst)
//选择
+ (instancetype)select_small_normal_image;
+ (instancetype)select_small_selected_image;
+ (instancetype)select_middle_normal_image;
+ (instancetype)select_middle_selected_image;

//占位图
+ (instancetype)placeholder_person_image;
+ (instancetype)placeholder_device_image;
+ (instancetype)placeholder_device2_image;
+ (instancetype)placeholder_alarmMsg_image;
+ (instancetype)placeholder_camera_image;
+ (instancetype)placeholder_imgNotExist_image;

//toolbar
+ (instancetype)voice_normal_image;
+ (instancetype)voice_normal_fullDuplex_image;
+ (instancetype)voice_normal_image_landscape;
+ (instancetype)voice_normal_image_fullDuplex_landscape;
+ (instancetype)voice_slected_image;
+ (instancetype)voice_baby_slected_image;
+ (instancetype)voice_disabled_image;
+ (instancetype)snapshot_normal_image;
+ (instancetype)snapshot_normal_image_landscape;
+ (instancetype)snapshot_slected_image;
+ (instancetype)snapshot_baby_slected_image;
+ (instancetype)snapshot_disabled_image;
+ (instancetype)record_normal_image;
+ (instancetype)record_normal_image_landscape;
+ (instancetype)record_slected_image;
+ (instancetype)record_baby_slected_image;
+ (instancetype)record_disabled_image;
+ (instancetype)mute_normal_image;
+ (instancetype)mute_normal_image_landscape;
+ (instancetype)mute_slected_image;
+ (instancetype)mute_baby_slected_image;
+ (instancetype)mute_disabled_image;
+ (instancetype)volumeOn_normal_image;
+ (instancetype)volumeOn_normal_image_landscape;
+ (instancetype)volumeOn_slected_image;
+ (instancetype)volumeOn_baby_slected_image;
+ (instancetype)volumeOn_disabled_image;
+ (instancetype)play_normal_image;
+ (instancetype)play_normal_image_landscape;
+ (instancetype)play_slected_image;
+ (instancetype)play_baby_slected_image;
+ (instancetype)play_disabled_image;
+ (instancetype)music_normal_image;
+ (instancetype)music_normal_image_landscape;
+ (instancetype)music_highlighted_image;
+ (instancetype)music_slected_image;
+ (instancetype)music_disabled_image;
+ (instancetype)calendar_normal_image;
+ (instancetype)calendar_normal_image_landscape;
+ (instancetype)calendar_slected_image;
+ (instancetype)calendar_baby_slected_image;

//sdkparam
+ (instancetype)sleepmodeOn_baby_preview_highlighted_image;
+ (instancetype)sleepmodeOn_camera_preview_highlighted_image;
+ (instancetype)sleepmodeOn_camera_preview_disabled_image;
+ (instancetype)sleepmodeOn_camera_preview_normal_image;
+ (instancetype)sleepmodeOff_baby_preview_highlighted_image;
+ (instancetype)sleepmodeOff_camera_preview_highlighted_image;
+ (instancetype)sleepmodeOff_camera_preview_disabled_image;
+ (instancetype)sleepmodeOff_camera_preview_normal_image;
+ (instancetype)sleepmodeOffByTime_baby_preview_highlighted_image;
+ (instancetype)sleepmodeOffByTime_camera_preview_highlighted_image;
+ (instancetype)sleepmodeOffByTime_camera_preview_disabled_image;
+ (instancetype)sleepmodeOffByTime_camera_preview_normal_image;



//loading
+ (instancetype)loadingImage;
+ (instancetype)loadingOrangeImage;

//bg
+ (instancetype)bgGreenImage;
+ (instancetype)bgOrangeImage;
+ (instancetype)bgGrayImage;
+ (instancetype)bgLightGrayImage;

@end
NS_ASSUME_NONNULL_END


