//
//  WYCameraSegment.h
//  Meari
//
//  Created by 李兵 on 2016/11/29.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYCameraSegment;
@protocol WYCameraSegmentDelegate <NSObject>
@optional
- (void)WYCameraSegment:(WYCameraSegment *)segment didSelectedIndex:(int)index; //0-预览，1-回放


@end

@interface WYCameraSegment: WYBaseView
@property (nonatomic, weak)id<WYCameraSegmentDelegate>delegate;

@property (nonatomic, assign)WYVideoType videoType;
@property (nonatomic, assign)BOOL previewed;
- (instancetype)initWithVideoType:(WYVideoType)videoType;

@end
