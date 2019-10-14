//
//  UIViewController+Extension.h
//  Meari
//
//  Created by 李兵 on 2016/11/11.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Extension)

/**
 KVO
 */
@property (nonatomic, strong)NSSet *wy_observeredKeypaths;
- (void)wy_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
- (void)wy_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context;
- (void)wy_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

- (BOOL)wy_isTop;


@end


@interface UIViewController (WYTransition)
@property (nonatomic, assign, readonly)WYVCType wy_vcType;
@property (nonatomic, assign)WYVCType wy_pushFromVCType;
@property (nonatomic, assign)WYVCType wy_pushToVCType;
- (void)wy_pushToVC:(WYVCType)vcType;
- (void)wy_pushToVC:(WYVCType)vcType sender:(nullable id)sender;
- (void)wy_popToVC:(WYVCType)vcType;
- (void)wy_popToVC:(WYVCType)vcType sender:(nullable id)sender;
- (void)wy_popToRootVC;
- (void)wy_pop;
- (instancetype)wy_pushFromVC;

- (void)wy_presentVC:(WYVCType)vcType sender:(nullable id)sender modalTransitionStyle:(UIModalTransitionStyle)modalTransitionStyle;
- (void)wy_dismiss;
- (void)wy_dropFromPage:(WYVCType)fromVC toPage:(WYVCType)toVC;

+ (Class)wy_vcClassWithType:(WYVCType)VCType;
+ (WYVCType)wy_typeWithVCClass:(Class)VCClass;

@end
NS_ASSUME_NONNULL_END
