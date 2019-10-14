//
//  NSFileManager+Extension.h
//  Meari
//
//  Created by 李兵 on 2016/11/9.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSFileManager (Extension)

//系统文件夹
+ (NSString *)documentFolder;      //document  
+ (NSString *)libraryFolder;       //library   
+ (NSString *)cachesFolder;        //caches

//自定义文件夹
+ (NSString *)thumbFolder;         //缩略图     
+ (NSString *)videoFolder;         //录像       
+ (NSString *)photoFolder;         //截图
+ (NSString *)audioFolder;

//文件
+ (NSString *)thumbFile:(NSString *)thumbName;  //缩略图
+ (NSString *)wy_videoFileWithSN:(NSString *)sn;//录像
+ (NSString *)wy_photoFileWithSN:(NSString *)sn;//截图


@end
