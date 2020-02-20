//
//  WYHostMessageModel.h
//  Meari
//
//  Created by MJ2009 on 2019/8/28.
//  Copyright © 2019 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM (NSInteger, WYHostMsgDownloadStatus) {
    WYHostMsgDownloadNone,
    WYHostMsgDownloading,
    WYHostMsgDownloadSuccess,
    WYHostMsgDownloadFailure,
};

@interface WYHostMessageModel : MeariDeviceHostMessage

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, assign) WYHostMsgDownloadStatus downloadState;
@property (nonatomic, assign) BOOL playing;
@property (nonatomic, assign) BOOL preparePlaying;
- (instancetype)initWithDeviceHostMessage:(MeariDeviceHostMessage *)msg;


@end

NS_ASSUME_NONNULL_END
