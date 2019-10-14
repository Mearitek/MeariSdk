//
//  WYMeSignupCell.h
//  Meari
//
//  Created by 李兵 on 2017/9/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYMeSignupModel;
@interface WYMeSignupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (nonatomic, assign)WYMeSignupModel *model;
@end
