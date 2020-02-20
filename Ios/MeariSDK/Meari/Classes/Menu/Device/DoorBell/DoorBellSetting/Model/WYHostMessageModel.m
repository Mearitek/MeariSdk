//
//  WYHostMessageModel.m
//  Meari
//
//  Created by MJ2009 on 2019/8/28.
//  Copyright © 2019 Meari. All rights reserved.
//

#import "WYHostMessageModel.h"

@implementation WYHostMessageModel

- (instancetype)initWithDeviceHostMessage:(MeariDeviceHostMessage *)msg {
    if (self = [super init]) {
        self.voiceName = msg.voiceName;
        self.voiceId = msg.voiceId;
        self.voiceUrl = msg.voiceUrl;
    }
    return self;
}
@end

