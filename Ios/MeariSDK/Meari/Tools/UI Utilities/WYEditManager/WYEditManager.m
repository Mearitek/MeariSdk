//
//  WYEditManager.m
//  Meari
//
//  Created by 李兵 on 16/8/9.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYEditManager.h"

@interface WYEditManager ()
{
    WYEditStytle _editStytle;
}
@property (nonatomic, strong)UIButton *deleteBtn;
@property (nonatomic, strong)UIButton *markBtn;
@property (nonatomic, weak)UIView *bottomView;
@property (weak, nonatomic)id<WYEditManagerDelegate>delegate;

@end

@implementation WYEditManager

#pragma mark - getter
- (UIBarButtonItem *)editItem {
    if (!_editItem) {
        _editItem = [UIBarButtonItem editTextItemWithTarget:self action:@selector(editAction:)];
    }
    return _editItem;
}
- (UIBarButtonItem *)deleteItem {
    if (!_deleteItem) {
        _deleteItem = [UIBarButtonItem deleteImageItemWithTarget:self action:@selector(editAction:)];
    }
    return _deleteItem;
}
- (UIBarButtonItem *)cancelItem {
    if (!_cancelItem) {
        _cancelItem = [UIBarButtonItem cancelImageItemWithTarget:self action:@selector(cancelAction:)];
    }
    return _cancelItem;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        UIButton *btn = [UIButton defaultGreenFillButtonWithTarget:self action:@selector(deleteAction:)];
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = WYFont_Text_S_Normal;
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:WYLocalString(@"DELETE") forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_delete_white"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        _deleteBtn = btn;
    }
    return _deleteBtn;
}
- (UIButton *)markBtn {
    if (!_markBtn) {
        UIButton *btn = [UIButton defaultGreenFillButtonWithTarget:self action:@selector(markAction:)];
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = WYFont_Text_S_Normal;
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:WYLocalString(@"READ ALL") forState:UIControlStateNormal];
        _markBtn = btn;
    }
    return _markBtn;
}


- (void)editAction:(UIBarButtonItem *)sender {
    if ([self.delegate respondsToSelector:@selector(canEdit)]) {
        if ([self.delegate canEdit]) {
            self.edited = YES;
            if ([self.delegate respondsToSelector:@selector(editEdit)]) {
                [self.delegate editEdit];
            }
        }
    }
}
- (void)cancelAction:(UIBarButtonItem *)sender {
    self.edited = NO;
    if ([self.delegate respondsToSelector:@selector(editCancel)]) {
        [self.delegate editCancel];
    }
}
- (void)deleteAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(editDelete)]) {
        [self.delegate editDelete];
    }
}
- (void)markAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(editMark)]) {
        [self.delegate editMark];
    }
}
- (void)setEdited:(BOOL)edited {
    _edited = edited;
    if (_edited) {
        ((UIViewController *)(self.delegate)).navigationItem.rightBarButtonItem = self.cancelItem;
        self.bottomView.hidden = NO;
    }else {
        switch (_editStytle) {
            case WYEditStytleEditDelete: {
                ((UIViewController *)(self.delegate)).navigationItem.rightBarButtonItem = self.editItem;
                self.bottomView.hidden = YES;
                break;
            }
            case WYEditStytleDeleteDelete: {
                ((UIViewController *)(self.delegate)).navigationItem.rightBarButtonItem = self.deleteItem;
                self.bottomView.hidden = YES;
                break;
            }
            case WYEditStytleDeleteDeleteAndMark: {
                ((UIViewController *)(self.delegate)).navigationItem.rightBarButtonItem = self.deleteItem;
                self.bottomView.hidden = YES;
                break;
            }
            default:
                break;
        }
    }
}

WY_Singleton_Implementation(WYEditManager)

- (void)setDelegate:(id<WYEditManagerDelegate>)delegate editStystle:(WYEditStytle)editStytle {
    if (!WY_IsKindOfClass(delegate, UIViewController)) return;
    _editStytle = editStytle;
    self.delegate = delegate;
    UIViewController *vc = (UIViewController *)delegate;
    UIView *bottomV = [self bottomViewWithStytle:editStytle];
    [vc.view addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(vc.view);
        make.height.equalTo(@74);
        make.bottom.equalTo(vc.view).offset(WY_SAFE_BOTTOM_LAYOUT);
        make.centerX.equalTo(vc.view);
    }];
    bottomV.hidden = YES;
    switch (editStytle) {
        case WYEditStytleDeleteDelete: {
            vc.navigationItem.rightBarButtonItem = self.deleteItem;
            break;
        }
        case WYEditStytleDeleteDeleteAndMark: {
            vc.navigationItem.rightBarButtonItem = self.deleteItem;
            break;
        }
        case WYEditStytleEditDelete: {
            vc.navigationItem.rightBarButtonItem = self.editItem;
            break;
        }
        default:
            break;
    }
}

- (UIView *)bottomViewWithStytle:(WYEditStytle)stytle {
    WY_WeakSelf
    UIView *view = [UIView new];
    self.bottomView = view;
    switch (stytle) {
        case WYEditStytleDeleteDelete: {
            [view addSubview:self.deleteBtn];
            [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(40));
                make.width.equalTo(view.mas_width).multipliedBy(0.6);
                make.center.equalTo(view);
            }];
            break;
        }
        case WYEditStytleDeleteDeleteAndMark: {
            [view addSubview:self.markBtn];
            [self.markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(40));
                make.width.equalTo(view.mas_width).multipliedBy(0.5).with.offset(-30);
                make.centerY.equalTo(view);
                make.leading.equalTo(view).with.offset(20);
            }];
            [view addSubview:self.deleteBtn];
            [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(weakSelf.markBtn);
                make.width.equalTo(weakSelf.markBtn);
                make.centerY.equalTo(weakSelf.markBtn);
                make.leading.equalTo(weakSelf.markBtn.mas_trailing).with.offset(20);
                make.trailing.equalTo(view).with.offset(-20);
            }];
            break;
        }
        case WYEditStytleEditDelete: {
            [view addSubview:self.deleteBtn];
            [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(40));
                make.width.equalTo(view.mas_width).multipliedBy(0.6);
                make.center.equalTo(view);
            }];
            break;
        }
        default:
            break;
    }
    return view;
}


@end
