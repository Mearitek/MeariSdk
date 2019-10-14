//
//  UIImage+Extension.m
//  Meari
//
//  Created by 李兵 on 16/3/2.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
- (BOOL)wy_saveToPath:(NSString *)path {
    if (CGSizeEqualToSize(self.size, CGSizeZero) || !path) {
        return NO;
    }
    return [UIImageJPEGRepresentation(self, 1.0) writeToFile:path atomically:YES];
}
//截取图片的某一部分
- (UIImage *)clipImageInRect:(CGRect)rect {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbScale;
}
//  颜色转换为背景图片
+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


/**
 *  压缩图片
 *
 *  @param image 原图片
 *  @param asize 指定的压缩大小
 *
 *  @return 压缩后的等比例的图片
 */
+ (nullable UIImage *)imageWithOriginalImage:(nonnull UIImage *)image scaledSize:(CGSize)asize;{
    UIImage *newimage;
    if (image){
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


@end



@implementation UIImage (WYConst)
//选择
+ (instancetype)select_small_normal_image {
    return [UIImage imageNamed:@"btn_select_small_normal"];
}
+ (instancetype)select_small_selected_image {
    return [UIImage imageNamed:@"btn_select_small_selected"];
}
+ (instancetype)select_middle_normal_image {
    return [UIImage imageNamed:@"btn_select_middle_normal"];
}
+ (instancetype)select_middle_selected_image {
    return [UIImage imageNamed:@"btn_select_middle_selected"];
}

//占位图
+ (instancetype)placeholder_person_image {
    return [UIImage imageNamed:@"img_person_placeholder"];
}
+ (instancetype)placeholder_device_image {
    return [UIImage imageNamed:@"img_device_placeholder"];
}
+ (instancetype)placeholder_device2_image {
    return [UIImage imageNamed:@"img_device2_placeholder"];
}
+ (instancetype)placeholder_alarmMsg_image {
    return [UIImage imageNamed:@"img_alarmMsg_placeholder"];
}
+ (instancetype)placeholder_camera_image {
    return [UIImage imageNamed:@"img_camera_placeholder"];
}
+ (instancetype)placeholder_imgNotExist_image {
    return [UIImage imageNamed:@"img_imgNotExist_placeholder"];
}

//toolbar
+ (instancetype)voice_normal_image {
    return [UIImage imageNamed:@"btn_camera_preview_voice_normal"];
}
+ (instancetype)voice_normal_fullDuplex_image {
    return [UIImage imageNamed:@"btn_camera_preview_voice_fullDuplex_normal"];
}
+ (instancetype)voice_normal_image_landscape {
    return [UIImage imageNamed:@"btn_camera_preview_voice_normal_landscape"];
}
+ (instancetype)voice_normal_image_fullDuplex_landscape {
    return [UIImage imageNamed:@"btn_camera_preview_voice_fullDuplex_normal_landscape"];
}
+ (instancetype)voice_slected_image {
    return [UIImage imageNamed:@"btn_camera_preview_voice_selected"];
}
+ (instancetype)voice_baby_slected_image {
    return [UIImage imageNamed:@"btn_baby_preview_voice_selected"];
}
+ (instancetype)voice_disabled_image {
    return [UIImage imageNamed:@"btn_camera_preview_voice_disabled"];
}
+ (instancetype)snapshot_normal_image {
    return [UIImage imageNamed:@"btn_camera_preview_snapshot_normal"];
}
+ (instancetype)snapshot_normal_image_landscape {
    return [UIImage imageNamed:@"btn_camera_preview_snapshot_normal_landscape"];
}
+ (instancetype)snapshot_slected_image {
    return [UIImage imageNamed:@"btn_camera_preview_snapshot_selected"];
}
+ (instancetype)snapshot_baby_slected_image {
    return [UIImage imageNamed:@"btn_baby_preview_snapshot_selected"];
}
+ (instancetype)snapshot_disabled_image {
    return [UIImage imageNamed:@"btn_camera_preview_snapshot_disabled"];
}
+ (instancetype)record_normal_image {
    return [UIImage imageNamed:@"btn_camera_preview_record_normal"];
}
+ (instancetype)record_normal_image_landscape {
    return [UIImage imageNamed:@"btn_camera_preview_record_normal_landscape"];
}
+ (instancetype)record_slected_image {
    return [UIImage imageNamed:@"btn_camera_preview_record_selected"];
}
+ (instancetype)record_baby_slected_image {
    return [UIImage imageNamed:@"btn_baby_preview_record_selected"];
}
+ (instancetype)record_disabled_image {
    return [UIImage imageNamed:@"btn_camera_preview_record_disabled"];
}
+ (instancetype)mute_normal_image {
    return [UIImage imageNamed:@"btn_camera_preview_mute_normal"];
}
+ (instancetype)mute_normal_image_landscape {
    return [UIImage imageNamed:@"btn_camera_preview_mute_normal_landscape"];
}
+ (instancetype)mute_slected_image {
    return [UIImage imageNamed:@"btn_camera_preview_mute_selected"];
}
+ (instancetype)mute_baby_slected_image {
    return [UIImage imageNamed:@"btn_baby_preview_mute_selected"];
}
+ (instancetype)mute_disabled_image {
    return [UIImage imageNamed:@"btn_camera_preview_mute_disabled"];
}
+ (instancetype)volumeOn_normal_image {
    return [UIImage imageNamed:@"btn_camera_preview_volumeOn_normal"];
}
+ (instancetype)volumeOn_normal_image_landscape {
    return [UIImage imageNamed:@"btn_camera_preview_volumeOn_normal_landscape"];
}
+ (instancetype)volumeOn_slected_image {
    return [UIImage imageNamed:@"btn_camera_preview_volumeOn_selected"];
}
+ (instancetype)volumeOn_disabled_image {
    return [UIImage imageNamed:@"btn_camera_preview_volumeOn_disabled"];
}
+ (instancetype)volumeOn_baby_slected_image {
    return [UIImage imageNamed:@"btn_baby_preview_volumeOn_selected"];
}
+ (instancetype)play_normal_image {
    return [UIImage imageNamed:@"btn_camera_preview_play_normal"];
}
+ (instancetype)play_normal_image_landscape {
    return [UIImage imageNamed:@"btn_camera_preview_play_normal_landscape"];
}
+ (instancetype)play_slected_image {
    return [UIImage imageNamed:@"btn_camera_preview_play_selected"];
}
+ (instancetype)play_baby_slected_image {
    return [UIImage imageNamed:@"btn_baby_preview_play_selected"];
}
+ (instancetype)play_disabled_image {
    return [UIImage imageNamed:@"btn_camera_preview_play_disabled"];
}
+ (instancetype)music_normal_image {
    return [UIImage imageNamed:@"btn_baby_preview_music_normal"];
}
+ (instancetype)music_normal_image_landscape {
    return [UIImage imageNamed:@"btn_baby_preview_music_normal_landscape"];
}
+ (instancetype)music_highlighted_image {
    return [UIImage imageNamed:@"btn_baby_preview_music_highlighted"];
}
+ (instancetype)music_slected_image {
    return [UIImage imageNamed:@"btn_baby_preview_music_selected"];
}
+ (instancetype)music_disabled_image {
    return [UIImage imageNamed:@"btn_baby_preview_music_disabled"];
}
+ (instancetype)calendar_normal_image {
    return [UIImage imageNamed:@"btn_camera_preview_calendar_normal"];
}
+ (instancetype)calendar_normal_image_landscape {
    return [UIImage imageNamed:@"btn_camera_preview_calendar_normal_landscape"];
}
+ (instancetype)calendar_slected_image {
    return [UIImage imageNamed:@"btn_camera_preview_calendar_selected"];
}
+ (instancetype)calendar_baby_slected_image {
    return [UIImage imageNamed:@"btn_baby_preview_calendar_selected"];
}

//sdkparam
+ (instancetype)sleepmodeOn_baby_preview_highlighted_image {
    return [UIImage imageNamed:@"btn_baby_preview_sleepmodeOn_highlighted"];
}
+ (instancetype)sleepmodeOn_camera_preview_highlighted_image {
    return [UIImage imageNamed:@"btn_camera_preview_sleepmodeOn_highlighted"];
}
+ (instancetype)sleepmodeOn_camera_preview_disabled_image {
    return [UIImage imageNamed:@"btn_camera_preview_sleepmodeOn_disabled"];
}
+ (instancetype)sleepmodeOn_camera_preview_normal_image {
    return [UIImage imageNamed:@"btn_camera_preview_sleepmodeOn_normal"];
}
+ (instancetype)sleepmodeOff_baby_preview_highlighted_image {
    return [UIImage imageNamed:@"btn_baby_preview_sleepmodeOff_highlighted"];
}
+ (instancetype)sleepmodeOff_camera_preview_highlighted_image {
    return [UIImage imageNamed:@"btn_camera_preview_sleepmodeOff_highlighted"];
}
+ (instancetype)sleepmodeOff_camera_preview_disabled_image {
    return [UIImage imageNamed:@"btn_camera_preview_sleepmodeOff_disabled"];
}
+ (instancetype)sleepmodeOff_camera_preview_normal_image {
    return [UIImage imageNamed:@"btn_camera_preview_sleepmodeOff_normal"];
}
+ (instancetype)sleepmodeOffByTime_baby_preview_highlighted_image {
    return [UIImage imageNamed:@"btn_baby_preview_sleepmodeOffByTime_highlighted"];
}
+ (instancetype)sleepmodeOffByTime_camera_preview_highlighted_image {
    return [UIImage imageNamed:@"btn_camera_preview_sleepmodeOffByTime_highlighted"];
}
+ (instancetype)sleepmodeOffByTime_camera_preview_disabled_image {
    return [UIImage imageNamed:@"btn_camera_preview_sleepmodeOffByTime_disabled"];
}
+ (instancetype)sleepmodeOffByTime_camera_preview_normal_image {
    return [UIImage imageNamed:@"btn_camera_preview_sleepmodeOffByTime_normal"];
}


//loading
+ (instancetype)loadingImage {
    return [UIImage imageNamed:@"img_loading"];
}
+ (instancetype)loadingOrangeImage {
    return [UIImage imageNamed:@"img_loading_orange"];
}

//bg
+ (instancetype)bgGreenImage {
    return [UIImage imageNamed:@"bg_green"];
}
+ (instancetype)bgOrangeImage {
    return [UIImage imageNamed:@"bg_orange"];
}
+ (instancetype)bgGrayImage {
    return [UIImage imageNamed:@"bg_gray"];
}
+ (instancetype)bgLightGrayImage {
    return [UIImage imageWithColor:WY_BGColor_Highlighted_cell];
}
@end
