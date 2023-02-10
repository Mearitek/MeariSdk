//
//  MeariMusicInfo.h
//  MeariKit
//
//  Created by Meari on 2017/12/14.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeariMusicInfo : MeariBaseModel
@property (nonatomic, strong) NSString * musicFormat;   // format (音乐格式)
@property (nonatomic, strong) NSString * musicID;       // id (音乐ID)
@property (nonatomic, strong) NSString * musicName;     // name (音乐名字)
@property (nonatomic, strong) NSString * musicUrl;      // url for download (音乐地址)
@end
