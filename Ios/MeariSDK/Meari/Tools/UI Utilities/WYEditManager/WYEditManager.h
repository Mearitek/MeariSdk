//
//  WYEditManager.h
//  Meari
//
//  Created by 李兵 on 16/8/9.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WY_EditM [WYEditManager sharedWYEditManager]
typedef NS_ENUM(NSInteger, WYEditStytle) {
    WYEditStytleDeleteDelete,
    WYEditStytleDeleteDeleteAndMark,
    WYEditStytleEditDelete
};

@class WYEditManager;
@protocol WYEditManagerDelegate <NSObject>

@optional
- (BOOL)canEdit;
- (void)editEdit;
- (void)editCancel;
- (void)editDelete;
- (void)editMark;

@end

@interface WYEditManager : NSObject
@property (nonatomic, strong)UIBarButtonItem *editItem;
@property (nonatomic, strong)UIBarButtonItem *deleteItem;
@property (nonatomic, strong)UIBarButtonItem *cancelItem;
@property (nonatomic, assign)BOOL edited;



WY_Singleton_Interface(WYEditManager)
- (void)setDelegate:(id<WYEditManagerDelegate>)delegate editStystle:(WYEditStytle)editStytle;
@end
