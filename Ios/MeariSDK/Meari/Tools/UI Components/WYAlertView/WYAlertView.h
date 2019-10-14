//
//  WYAlertView.h
//  WYAlertVIew
//
//  Created by 李兵 on 2016/12/20.
//  Copyright © 2016年 李兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYAlertView;
typedef void(^WYAlertAction)(WYAlertView *alertView, NSInteger buttonIndex);

@interface WYAlertView : UIView
@property (nonatomic, assign)NSInteger emptyIndex;
@property (nonatomic, assign)NSInteger cancelButtonIndex;
@property (nonatomic, assign)NSInteger firstOtherButtonIndex;
@property (nonatomic, copy) WYAlertAction alertAction;

//非强制show
+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButton  otherButton:(NSString *)otherButton alertAction:(WYAlertAction)alertAction;
+ (void)showWithTitle:(NSString *)title message:(NSAttributedString *)message cancelButton:(NSString *)cancelButton otherButton:(NSString *)otherButton alignment:(NSTextAlignment)alignment alertAction:(WYAlertAction)alertAction;
+ (void)showWithTitle:(NSString *)title message:(NSAttributedString *)message cancelButton:(NSString *)cancelButton otherButton:(NSString *)otherButton alignment:(NSTextAlignment)alignment stytle:(WYUIStytle)stytle alertAction:(WYAlertAction)alertAction;

//非强制show，点空白处消失
+ (void)softShowWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButton  otherButton:(NSString *)otherButton alertAction:(WYAlertAction)alertAction;
+ (void)softShowWithTitle:(NSString *)title message:(NSAttributedString *)message cancelButton:(NSString *)cancelButton otherButton:(NSString *)otherButton alignment:(NSTextAlignment)alignment alertAction:(WYAlertAction)alertAction;
+ (void)softShowWithTitle:(NSString *)title message:(NSAttributedString *)message cancelButton:(NSString *)cancelButton otherButton:(NSString *)otherButton alignment:(NSTextAlignment)alignment stytle:(WYUIStytle)stytle alertAction:(WYAlertAction)alertAction;


//强制show
+ (void)forceShowWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButton  otherButton:(NSString *)otherButton  alertAction:(WYAlertAction)alertAction;
+ (void)forceShowWithTitle:(NSString *)title message:(NSAttributedString *)message cancelButton:(NSString *)cancelButton otherButton:(NSString *)otherButton alignment:(NSTextAlignment)alignment alertAction:(WYAlertAction)alertAction;
+ (void)forceShowWithTitle:(NSString *)title message:(NSAttributedString *)message cancelButton:(NSString *)cancelButton otherButton:(NSString *)otherButton alignment:(NSTextAlignment)alignment stytle:(WYUIStytle)stytle alertAction:(WYAlertAction)alertAction;

//dismiss
+ (void)dismiss;
@end
