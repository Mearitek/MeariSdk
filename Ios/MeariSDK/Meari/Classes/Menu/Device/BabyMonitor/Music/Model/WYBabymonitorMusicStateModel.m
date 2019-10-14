//
//  WYBabymonitorMusicStateModel.m
//  Meari
//
//  Created by 李兵 on 2017/3/16.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBabymonitorMusicStateModel.h"

@implementation WYBabyMonitorMusicOneModel
- (WYBabyMonitorMusicStatus)status {
    if (_is_playing) {
        if (_download_percent >= 0 && _download_percent < 100) {
            _status = WYBabyMonitorMusicStatusDownloading;
        }else {
            _status = WYBabyMonitorMusicStatusPlaying;
        }
    }else {
        _status = WYBabyMonitorMusicStatusPaused;
    }
    return _status;
}
@end


@implementation WYBabymonitorMusicStateModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"play_list" : @"WYBabyMonitorMusicOneModel"};
}
- (void)setMode:(NSString *)mode {
    _mode = mode.copy;
    
    if ([mode isEqualToString:@"repeat_one"]) {
        self.musicMode = WYBabymonitorMusicPlayModeRepeatOne;
    }else if ([mode isEqualToString:@"repeat_all"]) {
        self.musicMode = WYBabymonitorMusicPlayModeRepeatAll;
    }else if ([mode isEqualToString:@"random"]) {
        self.musicMode = WYBabymonitorMusicPlayModeRandom;
    }else if ([mode isEqualToString:@"single"]) {
        self.musicMode = WYBabymonitorMusicPlayModeSingle;
    }else {
        self.musicMode = WYBabymonitorMusicPlayModeSingle;
    }
}
- (WYBabyMonitorMusicOneModel *)currentModel {
    for (WYBabyMonitorMusicOneModel *model in self.play_list) {
        if ([model.musicID isEqualToString:self.current_musicID]) {
            _currentModel = model;
            _currentModel.is_playing = self.is_playing;
            break;
        }
    }
    return _currentModel;
}
- (WYBabyMonitorMusicOneModel *)nextModel {
    NSInteger index = [self.play_list indexOfObject:_currentModel];
    if (index < self.play_list.count - 1) {
        return self.play_list[index+1];
    }
    return nil;
}
- (WYBabyMonitorMusicOneModel *)prevModel {
    NSInteger index = [self.play_list indexOfObject:_currentModel];
    if (index > 0) {
        return self.play_list[index-1];
    }
    return nil;
}

@end

