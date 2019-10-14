//
//  LBCountryModel.h
//  Pods
//
//  Created by 李兵 on 2017/12/6.
//

#import <Foundation/Foundation.h>
@class LBCountryModel;
typedef void (^LBCountrySelectBlock) (LBCountryModel *country);
@interface LBCountryModel : NSObject
@property (nonatomic, copy)NSString *countryCode;
@property (nonatomic, copy)NSString *phoneCode;
@property (nonatomic, copy)NSString *phoneCodePlus;
@property (nonatomic, copy)NSString *localizedCountryName;
@property (nonatomic, copy)NSString *displayCountryName;
- (NSString *)localizedCountryNameInLanguage:(NSString *)language;

@property (nonatomic, assign, readonly, getter=isChinaMainland) BOOL chinaMainland;
@property (nonatomic, assign, readonly, getter=isChinaHongkong) BOOL chinaHongkong;
@property (nonatomic, assign, readonly, getter=isChinaMacao) BOOL chinaMacao;
@property (nonatomic, assign, readonly, getter=isChinaTaiwan) BOOL chinaTaiwan;


+ (NSArray <LBCountryModel *>*)allCountriesArray;
+ (NSDictionary <NSString *, LBCountryModel *>*)allCountriesDictionaryOfLanguage:(NSString *)language;
+ (instancetype)countryWithLocale:(NSLocale *)locale;



@end


#pragma mark - Category

@interface NSString (LBCountry)
- (NSString *)lbc_pinyin;
- (NSString *)lbc_firstChar;
- (NSString *)lbc_firstUpperChar;
- (NSString *)lbc_trimSpace;
@end

@interface NSLocale (LBCountry)
+ (instancetype)lbc_localWithCountryCode:(NSString *)countryCode language:(NSString *)language;
@end
