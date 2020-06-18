//
//  MeariDeviceHostMessage.h
//  MeariKit
//
//  Created by MJ2009 on 2019/8/30.
//  Copyright © 2019 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeariDeviceHostMessage : NSObject
@property (nonatomic, strong) NSString *voiceId;
@property (nonatomic, strong) NSString *voiceUrl;
@property (nonatomic, strong) NSString *voiceName;
@end

NS_ASSUME_NONNULL_END
