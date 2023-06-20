//
//  MeariPlayView.h
//  MeariKit
//
//  Created by Meari on 2017/12/27.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "apple_openglview.h"

@interface MeariPlayView : UIView

@property (nonatomic, strong, readonly)AppleOpenGLView *videoView;

@end
