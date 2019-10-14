//
//  WYNVRInstallVC.m
//  Meari
//
//  Created by 李兵 on 2016/11/3.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYNVRInstallVC.h"
#import "WYNVRSearchVC.h"

@interface WYNVRInstallVC ()

@property (weak, nonatomic) IBOutlet UILabel *one;
@property (weak, nonatomic) IBOutlet UILabel *two;
@property (weak, nonatomic) IBOutlet UILabel *connectNVR;
@property (weak, nonatomic) IBOutlet UILabel *connectNVRDetail;
@property (weak, nonatomic) IBOutlet UILabel *startAdding;
@property (weak, nonatomic) IBOutlet UILabel *startAddingDetail;
@property (weak, nonatomic) IBOutlet UIButton *readyToGo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *connectNVRTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *connectNVRWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startAddingTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *readyToGoBottom;


@end

@implementation WYNVRInstallVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //约束
    self.connectNVRTop.constant = WY_iPhone_4 ? 25 : 35;
    self.connectNVRWidth.constant = WY_iPhone_4 ? 20 : 0;
    self.readyToGoBottom.constant = WY_iPhone_4 ? 30 : 40;
    self.startAddingTop.constant = WY_iPhone_4 ? 15 : 30;
    
    
    //圆角
    self.one.layer.masksToBounds = self.two.layer.masksToBounds = self.readyToGo.layer.masksToBounds = YES;
    self.one.layer.cornerRadius = self.two.layer.cornerRadius = 11;
    self.readyToGo.layer.cornerRadius = 20;
    
    //颜色
    self.one.textColor = self.two.textColor = [UIColor whiteColor];
    self.connectNVR.textColor = self.startAdding.textColor = WY_FontColor_Cyan;
    self.one.backgroundColor = self.two.backgroundColor = self.readyToGo.backgroundColor = WY_MainColor;
    self.connectNVRDetail.textColor = self.startAddingDetail.textColor = WY_FontColor_Gray;
    [self.readyToGo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //字体
    self.one.font = self.two.font = self.connectNVR.font = self.startAdding.font = self.readyToGo.titleLabel.font = WYFont_Text_M_Normal;
    self.connectNVRDetail.font = self.startAddingDetail.font = WYFont_Text_S_Normal;
    
    //内容
    self.connectNVR.text = WYLocalString(@"ConnectNVR");
    self.connectNVRDetail.text = WYLocalString(@"InstallNVRDescription");
    self.startAdding.text = WYLocalString(@"Start adding");
    self.startAddingDetail.text = WYLocalString(@"Start adding detail");
    self.connectNVR.text = WYLocalString(@"ConnectNVR");
    [self.readyToGo setTitle:WYLocalString(@"READY TO GO") forState:UIControlStateNormal];
    
    self.navigationItem.title = WYLocalString(@"INSTALL NVR");
    
}
#pragma mark - Action
- (IBAction)readyToGoAction:(UIButton *)sender {
    [self wy_pushToVC:WYVCTypeNVRSearch];
}


@end
