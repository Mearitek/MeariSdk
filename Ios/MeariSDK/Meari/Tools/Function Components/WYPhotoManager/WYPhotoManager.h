//
//  WYPhotoManager.h
//  Meari
//
//  Created by 李兵 on 2016/12/5.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WY_PhotoM  [WYPhotoManager sharedPhotoManager]

@interface WYPhotoManager : NSObject
WY_Singleton_Interface(PhotoManager)

- (void)savePhotoAtPath:(NSString *)path success:(WYBlock_Void)saveSuccess failure:(WYBlock_Error)saveFailure;
- (void)saveVideoAtPath:(NSString*)path success:(WYBlock_Void)saveSuccess failure:(WYBlock_Error)saveFailure;

- (void)savePhotoAtPath:(NSString *)path;
- (void)saveVideoAtPath:(NSString *)path;

@end
