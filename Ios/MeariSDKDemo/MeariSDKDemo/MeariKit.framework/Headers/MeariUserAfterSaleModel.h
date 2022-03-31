//
//  MeariUserAfterSaleModel.h
//  MeariKit
//
//  Created by maj on 2021/9/7.
//  Copyright © 2021 Meari. All rights reserved.
//

#import <MeariKit/MeariKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeariUserCloudPromotionModel : MeariBaseModel
@property (nonatomic, copy) NSString *facebook;
@property (nonatomic, copy) NSString *afterSalePhone;
@property (nonatomic, copy) NSString *afterSaleEmail;

@end

@interface MeariUserAfterSaleModel : MeariBaseModel
@property (nonatomic, copy) NSString *tp;
@property (nonatomic, assign) BOOL aiOpen; // ai try info
@property (nonatomic, assign) BOOL cloudOpen; // cloud try info
@property (nonatomic, strong) MeariUserCloudPromotionModel *cloudPromotionModel;

@end

NS_ASSUME_NONNULL_END
