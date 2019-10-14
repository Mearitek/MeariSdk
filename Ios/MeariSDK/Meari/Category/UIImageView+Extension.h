//
//  UIImageView+Extension.h
//  Meari
//
//  Created by 李兵 on 2017/3/2.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)
- (void)wy_setGIFImageWithURL:(NSURL *)gifURL;
@end

#import "UIImageView+WebCache.h"
@interface UIImageView (SDWebImage)
- (void)wy_setAlarmImageWithURL:(NSURL *)url deviceID:(NSInteger)deviceID placeholderImage:(UIImage *)placeholder;
- (void)wy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)wy_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock;
@end


