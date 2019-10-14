//
//  WYProgressPageView.m
//  Meari
//
//  Created by 李兵 on 2016/12/23.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYProgressPageView.h"
@interface WYProgressPageView ()
@property (nonatomic, strong)YLImageView *animateImage;

@end

@implementation WYProgressPageView
#pragma mark - Private
#pragma mark -- Getter
- (YLImageView *)animateImage {
    if (!_animateImage) {
        YLImageView *imageV = [[YLImageView alloc] initWithFrame:self.bounds];
        imageV.image = [YLGIFImage imageNamed:@"gif_camera_search.gif"];
        _animateImage = imageV;
    }
    return _animateImage;
}

#pragma mark -- Init
- (void)initSet {
    self.hidden = YES;
    
}
- (void)initLayout {
    [self addSubview:self.animateImage];
}

#pragma mark -- Life
- (void)initAction {
    [self initSet];
    [self initLayout];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.animateImage.bounds = CGRectMake(0, 0, self.animateImage.image.size.width/2, self.animateImage.image.size.height/2);
    self.animateImage.center = CGPointMake(self.width/2, self.height/2);
}

#pragma mark - Public
+ (instancetype)pageView {
    return [[WYProgressPageView alloc] initWithFrame:CGRectMake(0, 0, WY_ScreenWidth, 30)];
}
- (void)show {
    self.hidden = NO;
}
- (void)hide {
    self.hidden = YES;
}

@end
