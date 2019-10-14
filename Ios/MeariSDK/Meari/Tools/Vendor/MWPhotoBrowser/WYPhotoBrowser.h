//
//  WYPhotoBrowser.h
//  Meari
//
//  Created by 李兵 on 2017/3/2.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <MWPhotoBrowser/MWPhotoBrowser.h>

@interface WYPhotoBrowser : MWPhotoBrowser

+ (instancetype)wy_browserWithDelegate:(id<MWPhotoBrowserDelegate>)delegate currentIndex:(NSInteger)index;

@end
