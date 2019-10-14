//
//  WYBabyMonitorMusicCell.m
//  Meari
//
//  Created by 李兵 on 2017/3/13.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBabyMonitorMusicCell.h"
#import "WYBabyMonitorMusicModel.h"

@interface WYBabyMonitorMusicCell ()
@property (nonatomic, strong)UIImageView *songImageView;
@property (nonatomic, strong)UILabel *songNameLabel;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)YLImageView *playingView;
@property (nonatomic, strong)WYProgressCircleView *downloadView;
@property (nonatomic, strong)UIButton *playBtn;
@property (nonatomic, strong)UIView *line;
@end

@implementation WYBabyMonitorMusicCell
#pragma mark - Private
#pragma mark -- Getter
- (UIImageView *)songImageView {
    if (!_songImageView) {
        _songImageView = [UIImageView new];
        _songImageView.image = [UIImage music_slected_image];
        _songImageView.highlightedImage = [UIImage music_highlighted_image];
    }
    if (!_songImageView.superview) {
        [self addSubview:_songImageView];
    }
    return _songImageView;
}
- (UILabel *)songNameLabel {
    if (!_songNameLabel) {
        _songNameLabel = [UILabel labelWithFrame:CGRectZero
                                            text:nil
                                       textColor:WY_FontColor_Black
                                        textfont:WYFont_Text_M_Normal
                                   numberOfLines:1
                                   lineBreakMode:NSLineBreakByTruncatingTail
                                   lineAlignment:NSTextAlignmentLeft
                                       sizeToFit:NO];
    }
    if (!_songNameLabel.superview) {
        [self addSubview:_songNameLabel];
    }
    return _songNameLabel;
}
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [UILabel labelWithFrame:CGRectZero
                                          text:nil
                                     textColor:WY_FontColor_Gray
                                      textfont:WYFont_Text_S_Normal
                                 numberOfLines:0
                                 lineBreakMode:NSLineBreakByTruncatingTail
                                 lineAlignment:NSTextAlignmentRight
                                     sizeToFit:NO];
    }
    if (!_statusLabel.superview) {
        [self addSubview:_statusLabel];
    }
    return _statusLabel;
}
- (YLImageView *)playingView {
    if (!_playingView) {
        _playingView = [[YLImageView alloc] init];
        _playingView.image = [YLGIFImage imageNamed:@"gif_music_playing.gif"];
        _playingView.userInteractionEnabled = NO;
        [self addSubview:_playingView];
    }
    return _playingView;
}
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithFrame:CGRectZero
                                 normalImage:[UIImage imageNamed:@"btn_baby_music_list_play_normal"]
                            highlightedImage:[UIImage imageNamed:@"btn_baby_music_play_highlighted"]
                               selectedImage:nil
                                      target:nil
                                      action:nil];
        _playBtn.userInteractionEnabled = NO;
        [self addSubview:_playBtn];
    }
    return _playBtn;
}
- (WYProgressCircleView *)downloadView {
    if (!_downloadView) {
        _downloadView = [WYProgressCircleView new];
        _downloadView.progress = 0;
        _downloadView.fillCircleColor = WY_FontColor_DarkOrange;
        _downloadView.backgroundCircleColor = WY_FontColor_DarkOrange;
        _downloadView.progressCircleColor = WY_FontColor_LightOrange;
        _downloadView.textColor = [UIColor whiteColor];
        _downloadView.showText = YES;
        [_downloadView setTextFont:WYFont_Text_S_Normal];
        _downloadView.userInteractionEnabled = NO;
        [self addSubview:_downloadView];
    }
    return _downloadView;
}

#pragma mark -- Init
- (void)initSet {

}
- (void)initLayout {
    WY_WeakSelf
    [self.songImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.centerY.equalTo(weakSelf);
        make.leading.equalTo(weakSelf).with.offset(13);
    }];
    [self.songNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.leading.equalTo(weakSelf.songImageView.mas_trailing).with.offset(13);
    }];
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.leading.equalTo(weakSelf.songNameLabel.mas_trailing).with.offset(0);
        make.trailing.equalTo(weakSelf.playingView.mas_leading).with.offset(-10);
    }];
    [self.playingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.centerY.equalTo(weakSelf);
        make.trailing.equalTo(weakSelf).with.offset(-16);
    }];
    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.playingView);
        make.center.equalTo(weakSelf.playingView);
    }];
    [self.downloadView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.playingView);
        make.center.equalTo(weakSelf.playingView);
    }];
    [self addLineViewAtBottom];
}

#pragma mark -- Utilities
#pragma mark -- Life
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSet];
        [self initLayout];
    }
    return self;
}

#pragma mark -- Public
- (void)setModel:(WYBabyMonitorMusicModel *)model {
    _model = model;
    self.songNameLabel.text = model.info.musicName;
    switch (model.status) {
        case WYBabyMonitorMusicStatusPaused: {
            self.statusLabel.text = nil;
            self.playingView.hidden = YES;
            self.downloadView.hidden = YES;
            self.playBtn.hidden = NO;
            break;
        }
        case WYBabyMonitorMusicStatusPlaying: {
            self.playingView.hidden = NO;
            self.downloadView.hidden = YES;
            self.playBtn.hidden = YES;
            break;
        }
        case WYBabyMonitorMusicStatusDownloading: {
            self.playingView.hidden = YES;
            self.downloadView.hidden = NO;
            self.playBtn.hidden = YES;
            self.downloadView.needFill = YES;
            self.downloadView.showText = YES;
            self.downloadView.progress = model.download_percent/100.0;
            [self insertSubview:self.downloadView aboveSubview:self.playingView];
            break;
        }
        case WYBabyMonitorMusicStatusPlayingAndDownloading: {
            self.playingView.hidden = NO;
            self.downloadView.hidden = NO;
            self.playBtn.hidden = YES;
            self.downloadView.needFill = NO;
            self.downloadView.showText = NO;
            self.downloadView.progress = model.download_percent/100.0;
            [self insertSubview:self.downloadView aboveSubview:self.playingView];
            break;
        }
        default:
            break;
    }
}

@end
