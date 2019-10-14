//
//  WYMeMineAvatarVC.m
//  Meari
//
//  Created by 李兵 on 2017/9/20.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYMeMineAvatarVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface WYMeMineAvatarVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong)UIView  *containerView;
@property (nonatomic, strong)UIImageView *maskImageView;
@property (nonatomic, strong)UIImageView *avatarImageView;

@property (nonatomic, strong)UIButton *takephotoBtn;
@property (nonatomic, strong)UIButton *uploadBtn;
@property (strong, nonatomic) NSData* imageData;
@end

@implementation WYMeMineAvatarVC
#pragma mark -- Getter
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        [self.view addSubview:_containerView];
    }
    return _containerView;
}
- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [UIImageView new];
        _maskImageView.image = [UIImage imageNamed:@"imp_me_avatar_mask"];
        [self.view addSubview:_maskImageView];
    }
    return _maskImageView;
}
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        [_avatarImageView wy_setImageWithURL:[NSURL URLWithString:WY_USER_IMAGE] placeholderImage:[UIImage placeholder_person_image]];
        [self.view addSubview:_avatarImageView];
    }
    return _avatarImageView;
}
- (UIButton *)takephotoBtn {
    if (!_takephotoBtn) {
        _takephotoBtn = [UIButton wy_buttonWithStytle:WYButtonStytleFilledGreenAndWhiteTitle target:self action:@selector(takephotoAction:)];
        _takephotoBtn.wy_normalTitle = WYLocalString(@"me_takephoto");
        [self.view addSubview:_takephotoBtn];
    }
    return _takephotoBtn;
}
- (UIButton *)uploadBtn {
    if (!_uploadBtn) {
        _uploadBtn = [UIButton wy_buttonWithStytle:WYButtonStytleFilledGreenAndWhiteTitle target:self action:@selector(uploadAction:)];
        _uploadBtn.wy_normalTitle = WYLocalString(@"me_upload");
        [self.view addSubview:_uploadBtn];
    }
    return _uploadBtn;
}

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSet];
    [self initLayout];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.takephotoBtn.layer.masksToBounds = YES;
    self.takephotoBtn.layer.cornerRadius = self.takephotoBtn.height/2;
    self.uploadBtn.layer.masksToBounds = YES;
    self.uploadBtn.layer.cornerRadius = self.takephotoBtn.height/2;
}

#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"me_mine_avatar_title");
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem checkmarkImageItemWithTarget:self action:@selector(saveAction:)];
}
- (void)initLayout {
    WY_WeakSelf
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.equalTo(weakSelf.containerView.mas_width).multipliedBy(1.0f);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
    }];
    [self.takephotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.view).offset(30);
        make.height.equalTo(@44);
        make.top.equalTo(weakSelf.containerView.mas_bottom).offset(20);
    }];
    [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.takephotoBtn.mas_trailing).offset(20);
        make.trailing.equalTo(weakSelf.view).offset(-30);
        make.height.width.equalTo(weakSelf.takephotoBtn);
        make.centerY.equalTo(weakSelf.takephotoBtn);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.containerView);
    }];
    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.containerView);
    }];
}

#pragma mark -- Action
- (void)takephotoAction:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
    [WYAuthorityManager checkAuthorityOfCameraWithAlert:nil];
}
- (void)uploadAction:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
    [WYAuthorityManager checkAuthorityOfCameraWithAlert:nil];
}
- (void)saveAction:(UIButton *)sender {
    if (self.imageData.length <= 0) {
        return;
    }
    [self networkRequestUploadAvatar];
}

#pragma mark -- Network
- (void)networkRequestUploadAvatar {
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    [[MeariUser sharedInstance] uploadUserAvatar:[UIImage imageWithData:self.imageData] success:^(NSString *avatarUrl) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakSelf.wy_isTop) {
                [weakSelf wy_popToVC:WYVCTypeMeMine sender:[UIImage imageWithData:weakSelf.imageData]];
            }
        });
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}

#pragma mark - Delegate
#pragma mark -- UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type = info[UIImagePickerControllerMediaType];
    BOOL isImage = [type isEqualToString: (__bridge NSString *)kUTTypeImage];
    if (isImage) {
        UIImage *originalImage = info[UIImagePickerControllerEditedImage];
        CGSize size = CGSizeMake(2*self.avatarImageView.width, 2*self.avatarImageView.height);
        UIImage *pressedImage = [UIImage imageWithOriginalImage:originalImage scaledSize:size];
        self.avatarImageView.image = pressedImage;
        NSData *pressedImageData = UIImageJPEGRepresentation(pressedImage, 1.0);
        
        NSData *imageData;
        if (pressedImageData.length < 10000) {
            imageData = pressedImageData;
        }else if (pressedImageData.length >= 10000 && pressedImageData.length < 20000) {
            imageData = UIImageJPEGRepresentation(pressedImage, 0.99);
        }else if (pressedImageData.length >= 20000 && pressedImageData.length < 30000) {
            imageData = UIImageJPEGRepresentation(pressedImage, 0.6);
        }else if (pressedImageData.length >= 30000 && pressedImageData.length < 40000) {
            imageData = UIImageJPEGRepresentation(pressedImage, 0.4);
        }else if (pressedImageData.length >= 40000 && pressedImageData.length < 50000) {
            imageData = UIImageJPEGRepresentation(pressedImage, 0.3);
        }else if (pressedImageData.length >= 50000 && pressedImageData.length < 100000) {
            imageData = UIImageJPEGRepresentation(pressedImage, 0.1);
        }else if (pressedImageData.length >= 100000) {
            imageData = UIImageJPEGRepresentation(pressedImage, 0.0);
        }
        self.imageData = imageData;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
