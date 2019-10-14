//
//  LBCountrySearchVC.h
//  Pods
//
//  Created by 李兵 on 2017/12/6.
//

#import <UIKit/UIKit.h>
#import "LBCountryModel.h"

@class LBCountrySearchVC;
@protocol LBCountrySearchVCDelegate<NSObject>
@optional
- (void)searchVC:(LBCountrySearchVC *)vc selectCountry:(LBCountryModel *)country;
@end

@interface LBCountrySearchVC : UIViewController
@property (nonatomic, weak)id<LBCountrySearchVCDelegate>delegate;

@property (nonatomic, weak) UISearchController *searchVC;
- (void)showCountries:(NSArray <LBCountryModel *>*)countries showPhoneCodePlus:(BOOL)showPhoneCodePlus;

@end
