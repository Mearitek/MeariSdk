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
@property (nonatomic, copy) NSString *voiceId;
@property (nonatomic, copy) NSString *voiceUrl;
@property (nonatomic, copy) NSString *voiceSignedUrl;
@property (nonatomic, copy) NSString *voiceName;
@property (nonatomic, assign) BOOL canNotDelete; //True表示是默认音频，默认音频不能删除
@end

NS_ASSUME_NONNULL_END
