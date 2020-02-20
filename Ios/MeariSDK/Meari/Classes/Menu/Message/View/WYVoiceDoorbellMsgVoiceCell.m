//
//  WYVoiceDoorbellMsgVoiceCell.m
//  Meari
//
//  Created by MJ2009 on 2018/7/5.
//  Copyright © 2018年 Meari. All rights reserved.
//

#import "WYVoiceDoorbellMsgVoiceCell.h"
#import "WYLongPressImageView.h"

@interface WYVoiceDoorbellMsgVoiceCell()
@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) WYLongPressImageView *bubbleIV;
@property (nonatomic, strong) YLImageView *animateIV;
@property (nonatomic, strong) UILabel *timeLB;

@property (nonatomic, assign) BOOL isRead;

@property (nonatomic, assign) double duration;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation WYVoiceDoorbellMsgVoiceCell

- (void)setModel:(WYVoiceMsgModel *)model {
    _model = model;
//    self.duration = model.msg.voiceDuration.doubleValue;
//    self.isRead = model.msg.msgType.integerValue == 4;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSet];
        [self initLayout];
    }
    return self;
}

- (void)initSet {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.bubbleIV addTapGestureTarget:self action:@selector(tapGR:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tapGR:(UITapGestureRecognizer *)tap {
    self.isPlaying = !self.isPlaying;
    self.isRead = YES;
//    [self.player play];
    if (self.playAction&&self.isPlaying) {
        self.playAction(self.model);
    } else if (self.stopAction&&!self.isPlaying) {
        self.stopAction(self.model);
    }
    [self networkRequestReadStatus];
}
//标记已读
- (void)networkRequestReadStatus {
    [[MeariUser sharedInstance] updateVoiceMessageStatusWithMessageID:self.model.msg.msgID.integerValue success:nil failure:nil];
}

- (void)playbackFinished:(id)sender {
    self.isPlaying = NO;
}

- (void)initLayout {
    [self.contentView addSubview:self.iconIV];
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(8);
        make.size.mas_equalTo(50);
    }];
    self.iconIV.layer.cornerRadius = 25;
    self.iconIV.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.bubbleIV];
    [self.bubbleIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconIV.mas_right).offset(8);
        make.top.mas_equalTo(self.iconIV).offset(8);
//        make.height.mas_equalTo(34);
        make.bottom.mas_equalTo(-16);
        make.width.mas_equalTo(50);
    }];
    
    [self.bubbleIV addSubview:self.animateIV];
    [self.animateIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(13);
        make.bottom.mas_equalTo(-8);
        make.width.mas_equalTo(22);
    }];
    
    [self.bubbleIV addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bubbleIV);
    }];
    
    [self.contentView addSubview:self.timeLB];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bubbleIV.mas_right).offset(2);
        make.bottom.mas_equalTo(self.bubbleIV);
        make.right.mas_lessThanOrEqualTo(-18);
    }];
}

- (void)setIsRead:(BOOL)isRead {
    _isRead = isRead;
    
    NSString *bubbleImgName = WY_BOOL(isRead, @"img_voice_bubble_read", @"img_voice_bubble_no_read");
    self.bubbleIV.image = [UIImage imageNamed:bubbleImgName];
    [self.bubbleIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV.mas_top).offset(isRead?8:4);
    }];
    
    [self.animateIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WY_BOOL(isRead, 8, 8));
        make.centerY.equalTo(self.bubbleIV);
    }];
    [self.timeLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bubbleIV.mas_right).offset(WY_BOOL(isRead, 5, 2));
    }];
}

- (void)setDeleteAction:(void (^)(void))deleteAction {
    self.bubbleIV.deleteAction = deleteAction;
}

- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoading];
        if (isPlaying) {
            self.animateIV.image = [YLGIFImage imageNamed:@"gif_doorbell_sound.gif"];
        } else {
            self.animateIV.image = [UIImage imageNamed:@"sound"];
        }
    });
}
- (void)showLoading {
    self.animateIV.hidden = YES;
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
}
- (void)hideLoading {
    self.animateIV.hidden = NO;
    self.indicatorView.hidden = YES;
    [self.indicatorView stopAnimating];
}

- (void)setDuration:(double)duration {
    _duration = duration;
    
    CGFloat maxWidth = WY_ScreenWidth - 160;
    CGFloat width = 30 + duration * 20;
    if (width > maxWidth) {
        width = maxWidth;
    }
    [self.bubbleIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    
    self.timeLB.text = [NSString stringWithFormat:@"%.0f\"",duration];
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        _iconIV.image = [UIImage imageNamed:@"img_voice_doorBell_msg"];
    }
    return _iconIV;
}

- (WYLongPressImageView *)bubbleIV {
    if (!_bubbleIV) {
        _bubbleIV = [WYLongPressImageView new];
        _bubbleIV.image = [UIImage imageNamed:@"img_voice_bubble_no_read"];
    }
    return _bubbleIV;
}

- (YLImageView *)animateIV {
    if (!_animateIV) {
        _animateIV = [YLImageView new];
        _animateIV.image = [UIImage imageNamed:@"sound"];
    }
    return _animateIV;
}

- (UILabel *)timeLB {
    if (!_timeLB) {
        _timeLB = [UILabel new];
        _timeLB.font = WYFont_Text_XXS_Normal;
        _timeLB.textColor = WY_FontColor_Gray;
    }
    return _timeLB;
}
- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.hidden = YES;
    }
    return _indicatorView;
}

@end
