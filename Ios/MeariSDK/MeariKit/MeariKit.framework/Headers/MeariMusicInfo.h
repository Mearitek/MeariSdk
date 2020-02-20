//
//  MeariMusicInfo.h
//  MeariKit
//
//  Created by Meari on 2017/12/14.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeariMusicInfo : MeariBaseModel
@property (nonatomic, strong) NSString * musicFormat;   //音乐格式
@property (nonatomic, strong) NSString * musicID;       //音乐ID
@property (nonatomic, strong) NSString * musicName;     //音乐名字
@property (nonatomic, strong) NSString * musicUrl;      //音乐地址
@end
