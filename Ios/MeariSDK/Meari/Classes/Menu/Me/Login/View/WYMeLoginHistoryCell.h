//
//  WYMeLoginHistoryCell.h
//  Meari
//
//  Created by 李兵 on 2017/9/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYMeLoginHistoryCell;
@protocol WYLoginHistoryCellDelegate <NSObject>
@optional
- (void)WYMeLoginHistoryCell:(WYMeLoginHistoryCell *)cell deleteUser:(NSString *)userAccount;

@end

@interface WYMeLoginHistoryCell : UITableViewCell
@property (nonatomic, weak)id<WYLoginHistoryCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@end
