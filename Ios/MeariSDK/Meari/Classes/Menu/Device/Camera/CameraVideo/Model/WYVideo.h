//
//  WYVideo.h
//  Meari
//
//  Created by 李兵 on 2016/11/28.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, WYVideoType) {
    WYVideoTypePreviewHD = 1,
    WYVideoTypePreviewSD,
    WYVideoTypePreviewAT,
    WYVideoTypePlaybackSDCard,
    WYVideoTypePlaybackNVR
};
@interface WYVideo : NSObject

@property (nonatomic, strong)MeariDevice *camera;
@property (nonatomic, assign)WYVideoType videoType;
@property (nonatomic, strong)NSDateComponents *dateComponets;

+ (instancetype)videoWithCamera:(MeariDevice *)camera videoType:(WYVideoType)videoType dateComponets:(NSDateComponents *)dateComponents;
@end
