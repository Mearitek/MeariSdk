//
//  DeviceSettingCellOne.h
//  Meari
//
//  Created by 李兵 on 16/1/4.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYSettingSearchView;
@protocol DeviceSettingCellOneDelegate <NSObject>
@optional
- (void)DeviceSettingCellOne:(WYSettingSearchView *)cell changeName:(NSString *)newName;

@end

@interface WYSettingSearchView : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, assign)id<DeviceSettingCellOneDelegate> delegate;

@property (nonatomic, weak)UITextField *textField;
@property (nonatomic, weak)UILabel *titleLabel;

@end
