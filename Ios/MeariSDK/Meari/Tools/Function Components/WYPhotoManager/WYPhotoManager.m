//
//  WYPhotoManager.m
//  Meari
//
//  Created by 李兵 on 2016/12/5.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYPhotoManager.h"

@import Photos;

@interface WYPhotoManager ()
{
    dispatch_queue_t _saveQueue;
}
@property (strong, nonatomic) PHAssetCollection *album;

@end

@implementation WYPhotoManager
#pragma mark - Private
#pragma mark -- Getter
- (PHAssetCollection *)album {
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title=%@", WYAPP_Album];
    __block PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:fetchOptions];
    NSError *error;
    if (fetchResult.count <= 0) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:WYAPP_Album];
        } error:&error];
        if (error) {
            (@"创建相册失败,error:%@", error);
        }else {
            fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:fetchOptions];
            _album = fetchResult.firstObject;
        }
    } else {
        _album = fetchResult.firstObject;
    }
    return _album;
}

#pragma mark - Life
- (void)initSet {
    _saveQueue = dispatch_queue_create("AlbumSaveQueue", nil);
}

#pragma mark - Public
WY_Singleton_Implementation(PhotoManager)
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSet];
    }
    return self;
}

- (void)savePhotoAtPath:(NSString *)path success:(WYBlock_Void)saveSuccess failure:(WYBlock_Error)saveFailure {
    if (!WY_IsKindOfClass(path, NSString) || path.length <= 0) {
        WYDo_Block_Safe_Main1(saveFailure, [NSError wy_errorWithDomain:@"图片url为空"])
        return;
    }
    WYBlock_Void save = ^{
        dispatch_async(_saveQueue, ^{
            if (!self.album) {
                WYDo_Block_Safe_Main1(saveFailure, [NSError wy_errorWithDomain:@"相册创建失败"])
                return;
            }
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetChangeRequest *q = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:[NSURL fileURLWithPath:path]];
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:self.album] addAssets:@[q.placeholderForCreatedAsset]];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                [WY_FileManager removeItemAtPath:path error:nil];
                if (success) {
                    WYDo_Block_Safe_Main(saveSuccess)
                }else {
                    NSLog(@"save photo at path:%@ failure, error:%@", path, error);
                    WYDo_Block_Safe_Main1(saveFailure, error)
                }
            }];
        });
    };
    [WYAuthorityManager checkAuthorityOfPhotoWithAlert:^{
        save();
    }];
}
- (void)saveVideoAtPath:(NSString*)path success:(WYBlock_Void)saveSuccess failure:(WYBlock_Error)saveFailure {
    if (!WY_IsKindOfClass(path, NSString) || path.length <= 0) {
        WYDo_Block_Safe_Main1(saveFailure, [NSError wy_errorWithDomain:@"录像url为空"])
        return;
    }
    
    WYBlock_Void save = ^{
        dispatch_async(_saveQueue, ^{
            if (!self.album) {
                WYDo_Block_Safe_Main1(saveFailure, [NSError wy_errorWithDomain:@"相册创建失败"])
                return;
            }
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetChangeRequest *q = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:path]];
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:self.album] addAssets:@[q.placeholderForCreatedAsset]];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                [WY_FileManager removeItemAtPath:path error:nil];
                if (success) {
                    WYDo_Block_Safe_Main(saveSuccess)
                }else {
                    NSLog(@"save photo at path:%@ failure, error:%@", path, error);
                    WYDo_Block_Safe_Main1(saveFailure, error)
                }
            }];
        });
    };
    
    [WYAuthorityManager checkAuthorityOfPhotoWithAlert:^{
        save();
    }];
}

- (void)savePhotoAtPath:(NSString *)path {
    [self savePhotoAtPath:path success:^{
        WY_HUD_SHOW_TOAST(WYLocalString(@"status_photoSaved"))
    } failure:^(NSError *error) {
        WY_HUD_SHOW_TOAST(WYLocalString(@"fail_snapshot"))
    }];
}
- (void)saveVideoAtPath:(NSString *)path {
    [self saveVideoAtPath:path success:^{
        WY_HUD_SHOW_TOAST(WYLocalString(@"status_videoSaved"))
    } failure:^(NSError *error) {
        WY_HUD_SHOW_TOAST(WYLocalString(@"fail_saveRecord"))
    }];
}

@end
