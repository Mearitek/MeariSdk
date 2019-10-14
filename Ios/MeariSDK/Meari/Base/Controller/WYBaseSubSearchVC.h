//
//  WYBaseSearchVC.h
//  Meari
//
//  Created by 李兵 on 2016/11/18.
//  Copyright © 2016年 PPStrong. All rights reserved.
//


@interface WYBaseSubSearchVC : WYBaseSubVC

@property (nonatomic, assign)BOOL hideTopLabel;
@property (nonatomic, assign)BOOL hideTopBtn;
@property (nonatomic, assign)BOOL hideBottomBtn;
@property (nonatomic, assign)BOOL hideBottomView;

@property (nonatomic, assign, getter=isStopedByOvertime)BOOL stopedByOvertime;


- (void)insertObject:(id)object inDataSourceAtIndex:(NSUInteger)index;
- (void)removeObjectFromDataSourceAtIndex:(NSUInteger)index;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context;

- (void)setLabelText:(NSString *)text;
- (void)setLabelEnabled:(BOOL)enabled;
- (void)setTopBtnTitle:(NSString *)title;
- (void)setBottomBtnTitle:(NSString *)title filled:(BOOL)filled;

- (void)clickTopBtn:(UIButton *)sender;
- (void)clickBottomBtn:(UIButton *)sender;

- (void)startSearch NS_REQUIRES_SUPER;
- (void)stopSearch NS_REQUIRES_SUPER;
- (void)clickLabel NS_REQUIRES_SUPER;



@end

