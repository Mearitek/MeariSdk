//
//  LBCountryModel.m
//  Pods
//
//  Created by 李兵 on 2017/12/6.
//

#import "LBCountryModel.h"
static NSArray *_countryList;

@implementation LBCountryModel
#pragma mark -- Life
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_countryList) {
            _countryList = @[
                             @{@"IM" : @"44"},
                             @{@"HR" : @"385"},
                             @{@"GW" : @"245"},
                             @{@"IN" : @"91"},
                             @{@"KE" : @"254"},
                             @{@"LA" : @"856"},
                             @{@"IO" : @"246"},
                             @{@"HT" : @"509"},
                             @{@"LB" : @"961"},
                             @{@"GY" : @"595"},
                             @{@"KG" : @"996"},
                             @{@"HU" : @"36"},
                             @{@"LC" : @"1758"},
                             @{@"IQ" : @"964"},
                             @{@"KH" : @"855"},
                             @{@"JM" : @"1876"},
                             @{@"IR" : @"98"},
                             @{@"KI" : @"686"},
                             @{@"IS" : @"354"},
                             @{@"MA" : @"212"},
                             @{@"JO" : @"962"},
                             @{@"IT" : @"39"},
                             @{@"JP" : @"81"},
                             @{@"MC" : @"377"},
                             @{@"KM" : @"269"},
                             @{@"MD" : @"373"},
                             @{@"LI" : @"423"},
                             @{@"KN" : @"1869"},
                             @{@"ME" : @"382"},
                             @{@"NA" : @"264"},
                             @{@"MF" : @"590"},
                             @{@"LK" : @"94"},
                             @{@"KP" : @"850"},
                             @{@"MG" : @"261"},
                             @{@"NC" : @"687"},
                             @{@"MH" : @"692"},
                             @{@"KR" : @"82"},
                             @{@"NE" : @"227"},
                             @{@"NF" : @"672"},
                             @{@"MK" : @"389"},
                             @{@"NG" : @"234"},
                             @{@"ML" : @"223"},
                             @{@"MM" : @"95"},
                             @{@"LR" : @"231"},
                             @{@"NI" : @"505"},
                             @{@"KW" : @"965"},
                             @{@"MN" : @"976"},
                             @{@"LS" : @"266"},
                             @{@"PA" : @"507"},
                             @{@"MO" : @"853"},
                             @{@"LT" : @"370"},
                             @{@"KY" : @"1345"},
                             @{@"MP" : @"1670"},
                             @{@"LU" : @"352"},
                             @{@"NL" : @"31"},
                             @{@"KZ" : @"77"},
                             @{@"MQ" : @"596"},
                             @{@"LV" : @"371"},
                             @{@"MR" : @"222"},
                             @{@"PE" : @"51"},
                             @{@"MS" : @"1664"},
                             @{@"QA" : @"974"},
                             @{@"NO" : @"47"},
                             @{@"PF" : @"689"},
                             @{@"MT" : @"356"},
                             @{@"LY" : @"218"},
                             @{@"NP" : @"977"},
                             @{@"PG" : @"675"},
                             @{@"MU" : @"230"},
                             @{@"PH" : @"63"},
                             @{@"MV" : @"960"},
                             @{@"OM" : @"968"},
                             @{@"NR" : @"674"},
                             @{@"MW" : @"265"},
                             @{@"MX" : @"52"},
                             @{@"PK" : @"92"},
                             @{@"MY" : @"60"},
                             @{@"NU" : @"683"},
                             @{@"PL" : @"48"},
                             @{@"MZ" : @"258"},
                             @{@"PM" : @"508"},
                             @{@"PN" : @"872"},
                             @{@"RE" : @"262"},
                             @{@"SA" : @"966"},
                             @{@"SB" : @"677"},
                             @{@"NZ" : @"64"},
                             @{@"SC" : @"248"},
                             @{@"SD" : @"249"},
                             @{@"PR" : @"1787"},
                             @{@"PR" : @"1939"},
                             @{@"SE" : @"46"},
                             @{@"PS" : @"970"},
                             @{@"PT" : @"351"},
                             @{@"SG" : @"65"},
                             @{@"TC" : @"1649"},
                             @{@"SH" : @"290"},
                             @{@"TD" : @"235"},
                             @{@"SI" : @"386"},
                             @{@"PW" : @"680"},
                             @{@"SJ" : @"47"},
                             @{@"UA" : @"380"},
                             @{@"RO" : @"40"},
                             @{@"SK" : @"421"},
                             @{@"PY" : @"595"},
                             @{@"TG" : @"228"},
                             @{@"SL" : @"232"},
                             @{@"TH" : @"66"},
                             @{@"SM" : @"378"},
                             @{@"SN" : @"221"},
                             @{@"RS" : @"381"},
                             @{@"TJ" : @"992"},
                             @{@"VA" : @"379"},
                             @{@"SO" : @"252"},
                             @{@"TK" : @"690"},
                             @{@"UG" : @"256"},
                             @{@"RU" : @"7"},
                             @{@"TL" : @"670"},
                             @{@"VC" : @"1784"},
                             @{@"TM" : @"993"},
                             @{@"SR" : @"597"},
                             @{@"RW" : @"250"},
                             @{@"TN" : @"216"},
                             @{@"VE" : @"58"},
                             @{@"SS" : @"211"},
                             @{@"TO" : @"676"},
                             @{@"ST" : @"239"},
                             @{@"VG" : @"1284"},
                             @{@"SV" : @"503"},
                             @{@"TR" : @"90"},
                             @{@"VI" : @"1340"},
                             @{@"SX" : @"599"},
                             @{@"WF" : @"681"},
                             @{@"TT" : @"1868"},
                             @{@"SY" : @"963"},
                             @{@"SZ" : @"268"},
                             @{@"TV" : @"688"},
                             @{@"TW" : @"886"},
                             @{@"VN" : @"84"},
                             @{@"US" : @"1"},
                             @{@"TZ" : @"255"},
                             @{@"YE" : @"967"},
                             @{@"ZA" : @"27"},
                             @{@"UY" : @"598"},
                             @{@"VU" : @"678"},
                             @{@"UZ" : @"998"},
                             @{@"WS" : @"685"},
                             @{@"ZM" : @"260"},
                             @{@"AC" : @"247"},
                             @{@"AD" : @"376"},
                             @{@"YT" : @"262"},
                             @{@"AE" : @"971"},
                             @{@"BA" : @"387"},
                             @{@"AF" : @"93"},
                             @{@"BB" : @"1246"},
                             @{@"AG" : @"1268"},
                             @{@"BD" : @"880"},
                             @{@"AI" : @"1264"},
                             @{@"BE" : @"32"},
                             @{@"CA" : @"1"},
                             @{@"BF" : @"226"},
                             @{@"BG" : @"359"},
                             @{@"ZW" : @"263"},
                             @{@"AL" : @"355"},
                             @{@"CC" : @"61"},
                             @{@"BH" : @"973"},
                             @{@"AM" : @"374"},
                             @{@"CD" : @"243"},
                             @{@"BI" : @"257"},
                             @{@"BJ" : @"229"},
                             @{@"AO" : @"244"},
                             @{@"CF" : @"236"},
                             @{@"CG" : @"242"},
                             @{@"BL" : @"590"},
                             @{@"AQ" : @"672"},
                             @{@"CH" : @"41"},
                             @{@"BM" : @"1441"},
                             @{@"AR" : @"54"},
                             @{@"CI" : @"225"},
                             @{@"BN" : @"673"},
                             @{@"DE" : @"49"},
                             @{@"AS" : @"1684"},
                             @{@"BO" : @"591"},
                             @{@"AT" : @"43"},
                             @{@"CK" : @"682"},
                             @{@"AU" : @"61"},
                             @{@"CL" : @"56"},
                             @{@"EC" : @"593"},
                             @{@"BQ" : @"599"},
                             @{@"CM" : @"237"},
                             @{@"BR" : @"55"},
                             @{@"AW" : @"297"},
                             @{@"CN" : @"86"},
                             @{@"EE" : @"372"},
                             @{@"BS" : @"1242"},
                             @{@"DJ" : @"253"},
                             @{@"CO" : @"57"},
                             @{@"BT" : @"975"},
                             @{@"DK" : @"45"},
                             @{@"EG" : @"20"},
                             @{@"AZ" : @"994"},
                             @{@"EH" : @"210"},
                             @{@"DM" : @"1767"},
                             @{@"CR" : @"506"},
                             @{@"BW" : @"267"},
                             @{@"GA" : @"241"},
                             @{@"DO" : @"1809"},
                             @{@"BY" : @"375"},
                             @{@"GB" : @"44"},
                             @{@"CU" : @"53"},
                             @{@"BZ" : @"501"},
                             @{@"CV" : @"238"},
                             @{@"GD" : @"1473"},
                             @{@"FI" : @"358"},
                             @{@"CW" : @"5999"},
                             @{@"GE" : @"995"},
                             @{@"FJ" : @"679"},
                             @{@"CX" : @"61"},
                             @{@"GF" : @"594"},
                             @{@"FK" : @"500"},
                             @{@"CY" : @"537"},
                             @{@"GG" : @"44"},
                             @{@"CZ" : @"420"},
                             @{@"GH" : @"233"},
                             @{@"FM" : @"691"},
                             @{@"ER" : @"291"},
                             @{@"GI" : @"350"},
                             @{@"ES" : @"34"},
                             @{@"FO" : @"298"},
                             @{@"ET" : @"251"},
                             @{@"GL" : @"299"},
                             @{@"DZ" : @"213"},
                             @{@"GM" : @"220"},
                             @{@"ID" : @"62"},
                             @{@"FR" : @"33"},
                             @{@"GN" : @"224"},
                             @{@"IE" : @"353"},
                             @{@"HK" : @"852"},
                             @{@"GP" : @"590"},
                             @{@"GQ" : @"240"},
                             @{@"GR" : @"30"},
                             @{@"HN" : @"504"},
                             @{@"JE" : @"44"},
                             @{@"GS" : @"500"},
                             @{@"GT" : @"502"},
                             @{@"GU" : @"1671"},
                             @{@"IL" : @"972"},
                             ];
        }
    });
}

- (NSString *)description {
    return [NSString stringWithFormat:@"countryCode:%@ phoneCode:%@ phoneCodePlus:%@ displayCountryName:%@ localizedCountryName:%@", self.countryCode, self.phoneCode, self.phoneCodePlus, self.displayCountryName, self.localizedCountryName];
}

#pragma mark -- Private


#pragma mark - Public
#pragma mark -- Getter
- (NSString *)phoneCodePlus {
    return [NSString stringWithFormat:@"+%@", self.phoneCode];
}
- (BOOL)isChinaMainland {
    return [self.countryCode isEqualToString:@"CN"];
}
- (BOOL)isChinaHongkong {
    return [self.countryCode isEqualToString:@"HK"];
}
- (BOOL)isChinaMacao {
    return [self.countryCode isEqualToString:@"MO"];
}
- (BOOL)isChinaTaiwan {
    return [self.countryCode isEqualToString:@"TW"];
}
- (NSString *)localizedCountryName {
    if (!_localizedCountryName) {
        _localizedCountryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:self.countryCode];
    }
    return _localizedCountryName;
}
- (NSString *)localizedCountryNameInLanguage:(NSString *)language {
    return [[NSLocale lbc_localWithCountryCode:self.countryCode language:language] displayNameForKey:NSLocaleCountryCode value:self.countryCode];
}

+ (NSArray <LBCountryModel *>*)allCountriesArray {
    __block NSMutableArray *arr = [NSMutableArray arrayWithCapacity:_countryList.count];
    NSString *countryCode;
    NSString *phoneCode;
    for (NSDictionary *dic in _countryList) {
        countryCode = dic.allKeys.firstObject;
        phoneCode = dic.allValues.firstObject;
        LBCountryModel *m = [LBCountryModel new];
        m.countryCode = countryCode;
        m.phoneCode = phoneCode;
        [arr addObject:m];
    }
    return arr;
}
+ (NSDictionary <NSString *, LBCountryModel *>*)allCountriesDictionaryOfLanguage:(NSString *)language {
    NSArray *originalData = [LBCountryModel allCountriesArray];
    BOOL isChinese = [language hasPrefix:@"zh"];
    __block NSString *preStr;
    __block NSString *nextStr;
    __block NSMutableArray *sectionArr = [NSMutableArray arrayWithCapacity:0];
    __block NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    __block NSString *firstChar;
    __block NSString *countryName;
    [originalData enumerateObjectsUsingBlock:^(LBCountryModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        countryName = [obj localizedCountryNameInLanguage:language];
        obj.displayCountryName = countryName;
        firstChar = isChinese ? countryName.lbc_pinyin.lbc_firstUpperChar : countryName.lbc_firstUpperChar;
        if (!preStr) {
            preStr = firstChar;
            [sectionArr addObject:obj];
            dic[preStr] = sectionArr;
        }else {
            nextStr = firstChar;
            if ([nextStr isEqualToString:preStr]) {
                [sectionArr addObject:obj];
            }else {
                sectionArr = dic[nextStr];
                if (!sectionArr) {
                    sectionArr = [NSMutableArray arrayWithCapacity:0];
                }
                preStr = nextStr;
                [sectionArr addObject:obj];
                dic[preStr] = sectionArr;
            }
        }
    }];
    return dic;
}

+ (instancetype)currentCountry {
    return [self countryWithLocale:[NSLocale currentLocale]];
}
+ (instancetype)countryWithLocale:(NSLocale *)locale {
    if (!locale) {
        return nil;
    }
    NSDictionary *localeInfo = [NSLocale componentsFromLocaleIdentifier:locale.localeIdentifier];
    NSString *countryCode = localeInfo[NSLocaleCountryCode];
    if (!countryCode) {
        return nil;
    }
    NSString *phoneCode;
    for (NSDictionary *dic in _countryList) {
        if ([dic.allKeys.firstObject isEqualToString:countryCode]) {
            phoneCode = dic.allValues.firstObject;
        }
    }
    NSString *languageCode = localeInfo[NSLocaleLanguageCode];
    if (!phoneCode) {
        return nil;
    }
    LBCountryModel *m = [LBCountryModel new];
    m.countryCode = countryCode;
    m.phoneCode = phoneCode;
    if (languageCode) {
        m.displayCountryName = [m localizedCountryNameInLanguage:languageCode];
    }
    return m;
}

@end


#pragma mark - Category

@implementation NSString (LBCountry)
- (NSString *)lbc_pinyin {
    NSMutableString *s = self.mutableCopy;
    CFStringTransform((__bridge CFMutableStringRef)s, NULL, kCFStringTransformToLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)s, NULL, kCFStringTransformStripDiacritics, NO);
    return s;
}
- (NSString *)lbc_firstChar {
    if (self.length > 0) {
        return [self substringToIndex:1];
    }
    return nil;
}
- (NSString *)lbc_firstUpperChar {
    return self.lbc_firstChar.uppercaseString;
}
- (NSString *)lbc_trimSpace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}
@end


@implementation NSLocale (LBCountry)
+ (instancetype)lbc_localWithCountryCode:(NSString *)countryCode language:(NSString *)language {
    if (!countryCode || !language) {
        return nil;
    }
    NSString *identifier = [NSLocale localeIdentifierFromComponents:@{NSLocaleCountryCode : countryCode,
                                                                      NSLocaleLanguageCode : language,
                                                                      }];
    NSLocale *loc = [NSLocale localeWithLocaleIdentifier:identifier];
    return loc;
}
@end
