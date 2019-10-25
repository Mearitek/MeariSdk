//
//  MeariMusicInfo.h
//  MeariKit
//
//  Created by Meari on 2017/12/14.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeariMusicInfo : MeariBaseModel
@property (nonatomic, strong) NSString * musicFormat;   //format
@property (nonatomic, strong) NSString * musicID;       //id
@property (nonatomic, strong) NSString * musicName;     //name
@property (nonatomic, strong) NSString * musicUrl;      //url for download
@end
