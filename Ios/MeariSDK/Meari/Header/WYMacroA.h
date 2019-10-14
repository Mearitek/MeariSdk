//
//  WYMacroA.h
//  Meari
//
//  Created by 李兵 on 16/8/22.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#ifndef WYMacroA_h
#define WYMacroA_h

#pragma mark - /* Block **/
typedef void(^WYBlock_Void)();
typedef void(^WYBlock_ID)(id obj);
typedef void(^WYBlock_ID2)(id obj1, id obj2);
typedef void(^WYBlock_BOOL)(BOOL obj);
typedef void(^WYBlock_Int)(NSInteger obj);
typedef void(^WYBlock_Num)(NSNumber *obj);
typedef void(^WYBlock_Str)(NSString *obj);
typedef void(^WYBlock_Arr)(NSArray *obj);
typedef void(^WYBlock_Dic)(NSDictionary *obj);
typedef void(^WYBlock_Error)(NSError *error);
typedef void(^WYBlock_Error_Str)(NSString *error);
typedef void(^WYBlock_TableView)(UITableView *tableView);

#pragma mark - /* Class **/
#define WY_NotificationCenter        [NSNotificationCenter defaultCenter]
#define WY_FileManager               [NSFileManager defaultManager]
#define WY_Application               [UIApplication sharedApplication]
#define WY_UserDefaults              [NSUserDefaults standardUserDefaults]
#define WY_CurentDevice              [UIDevice currentDevice]
#define WY_CurrentThread             [NSThread currentThread]
#define WY_MainScreen                [UIScreen mainScreen]
#define WY_MainBundle                [NSBundle mainBundle]
#define WY_CurrentCalendar           [NSCalendar currentCalendar]
#define WY_CurrentLocale             [NSLocale currentLocale]

#pragma mark - /* Property **/
#define WY_ScreenScale               [UIScreen mainScreen].scale
#define WY_ScreenBounds              [UIScreen mainScreen].bounds
#define WY_ScreenWidth               [UIScreen mainScreen].bounds.size.width
#define WY_ScreenHeight              [UIScreen mainScreen].bounds.size.height
#define WY_KeyWindow                 [UIApplication sharedApplication].keyWindow
#define WY_SystemVerionFloatValue    [UIDevice currentDevice].systemVersion.floatValue

#pragma mark - /* Method **/
#define WY_ClassName(classArg)           NSStringFromClass([classArg class])
#define WY_IsKindOfClass(arg,classArg)   [arg isKindOfClass:[classArg class]]
#define WY_ThreadCancelledThenReturn     if(WY_CurrentThread.isCancelled) return;
#define WY_Weak(obj)                     __weak typeof(obj) weak##obj = obj;
#define WY_Strong(obj)                   __strong typeof(obj) strong##obj = weakobj;
#define WY_WeakSelf                      __weak typeof(self) weakSelf = self;
#define WY_StrongSelf                    __strong typeof(weakSelf) strongSelf = weakSelf;
#define WY_BOOL(boolV,yesV,noV)          ((boolV) ? (yesV) : (noV))     
#define WY_ContainOption(all, one)       ((all & one) == one)
#define WY_SafeStringValue(arg)          [NSString stringWithFormat:@"%@", arg ?: @""]
#define WY_SafeValue(arg)                arg ? arg: @""
#define WY_Limit(arg,min,max)            (arg < min ? min : (arg > max ? max : arg))
#define WY_IsMQTTTimeout(arg,threshold)  (([[NSDate date] timeIntervalSince1970]*1000 - arg)/1000.0/60.0 > threshold)

#pragma mark - /* Scalar **/
#define WY_1_PIXEL                       (1.0 / WY_ScreenScale)
#define WY_SideViewController_Width      (WY_ScreenWidth * 0.8)
#define WY_Version_GreaterThanOrEqual_8  (WY_SystemVerionFloatValue >= 8.0)
#define WY_Version_GreaterThanOrEqual_9  (WY_SystemVerionFloatValue >= 9.0)
#define WY_Version_GreaterThanOrEqual_10 (WY_SystemVerionFloatValue >= 10.0)
#define WY_Version_GreaterThanOrEqual_11 (WY_SystemVerionFloatValue >= 11.0)
#define WY_iPhone_4                      (MAX(WY_ScreenWidth, WY_ScreenHeight) == 480)
#define WY_iPhone_5                      (MAX(WY_ScreenWidth, WY_ScreenHeight) == 568)
#define WY_iPhone_6                      (MAX(WY_ScreenWidth, WY_ScreenHeight) == 667)
#define WY_iPhone_6P                     (MAX(WY_ScreenWidth, WY_ScreenHeight) == 736)
#define WY_iPhone_45                     (MIX(WY_ScreenWidth, WY_ScreenHeight) == 320)
#define WY_iPhone_X                      (MAX(WY_ScreenWidth, WY_ScreenHeight) == 812)
#define WY_Unit_Date_YMD                 (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
#define WY_Unit_Date_HMS                 (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond)
#define WY_Unit_Date_YMDHMS              (WY_Unit_Date_YMD | WY_Unit_Date_HMS)
#define WY_StatusBar_H                   WY_Application.statusBarFrame.size.height
#define WY_NavBar_H                      44
#define WY_TopBar_H                      (WY_StatusBar_H + WY_NavBar_H)
#define WY_SAFE_TOP                      44
#define WY_SAFE_BOTTOM                   34
#define WY_SAFE_BOTTOM_LAYOUT            (WY_iPhone_X ? -(WY_SAFE_BOTTOM) : 0)


#pragma mark - /* Log **/
#if DEBUG
    #define NSLog(format,...)  printf("%s:%.4lf:%s[%04d]%s\n", [[[NSDate date] dateByAddingTimeInterval:[NSTimeZone systemTimeZone].secondsFromGMT].description stringByReplacingOccurrencesOfString:@" +0000" withString:@""].UTF8String, [[NSDate date] timeIntervalSinceReferenceDate] - floor([[NSDate date] timeIntervalSinceReferenceDate]), __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
#endif







#pragma mark - /* Code block */
//block
#define WYDo_Block_Safe(block, ...)\
if (block) {\
block(__VA_ARGS__);\
}
#define WYDo_Block_Safe1(block, arg1)  WYDo_Block_Safe(block, (arg1))
#define WYDo_Block_Safe2(block, arg1, arg2) WYDo_Block_Safe(block, (arg1), (arg2))
#define WYDo_Block_Safe3(block, arg1, arg2, arg3) WYDo_Block_Safe(block, (arg1), (arg2), (arg3))
#define WYDo_Block_Safe4(block, arg1, arg2, arg3, arg4) WYDo_Block_Safe(block, (arg1), (arg2), (arg3), (arg4))


//block on main thread
#define WYDo_Block_Safe_Main(block, ...)\
if (block) {\
if ([NSThread currentThread].isMainThread) {\
block(__VA_ARGS__);\
}else {\
dispatch_async(dispatch_get_main_queue(), ^{\
block(__VA_ARGS__);\
});\
}\
}
#define WYDo_Block_Safe_Main1(block, arg1)  WYDo_Block_Safe_Main(block, (arg1))
#define WYDo_Block_Safe_Main2(block, arg1, arg2) WYDo_Block_Safe_Main(block, (arg1), (arg2))
#define WYDo_Block_Safe_Main3(block, arg1, arg2, arg3) WYDo_Block_Safe_Main(block, (arg1), (arg2), (arg3))
#define WYDo_Block_Safe_Main4(block, arg1, arg2, arg3, arg4) WYDo_Block_Safe_Main(block, (arg1), (arg2), (arg3), (arg4))


//Singleton
#define WY_Singleton_Interface(name) +(instancetype)shared##name;
#define WY_Singleton_Implementation(name)\
+ (instancetype)shared##name {\
static id instance = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance = [[self alloc] init];\
});\
return instance;\
}

//Coder
#define WY_CoderAndCopy \
- (void)encodeWithCoder:(NSCoder *)aCoder {\
unsigned int count = 0;\
Ivar *list = class_copyIvarList([self class], &count);\
for (int i = 0; i < count; i++) {\
Ivar iv = list[i];\
const char *name = ivar_getName(iv);\
if (strlen(name) > 0) {\
NSString *key = [NSString stringWithUTF8String:name];\
[aCoder encodeObject:[self valueForKey:key] forKey:key];\
}\
}\
free(list);\
}\
- (instancetype)initWithCoder:(NSCoder *)aDecoder {\
self = [super init];\
if (self) {\
unsigned int count = 0;\
Ivar *list = class_copyIvarList([self class], &count);\
for (int i = 0; i < count; i++) {\
Ivar iv = list[i];\
const char *name = ivar_getName(iv);\
if (strlen(name) > 0) {\
NSString *key = [NSString stringWithUTF8String:name];\
id value = [aDecoder decodeObjectForKey:key];\
[self setValue:value forKey:key];\
}\
}\
free(list);\
}\
return self;\
}\
- (instancetype)copyWithZone:(NSZone *)zone {\
id copy = [[[self class] alloc] init];\
unsigned int count = 0;\
Ivar *list = class_copyIvarList([self class], &count);\
for (int i = 0; i < count; i++) {\
Ivar iv = list[i];\
const char *name = ivar_getName(iv);\
if (strlen(name) > 0) {\
NSString *key = [NSString stringWithUTF8String:name];\
id v = [self valueForKey:key];\
[copy setValue:v forKey:key];\
}\
}\
free(list);\
return copy;\
}

//Getter
#define WYGetter_MutableArray(name)\
- (NSMutableArray *)name {\
if (!_##name) {\
_##name = [NSMutableArray arrayWithCapacity:0];\
}\
return _##name;\
}
#define WYGetter_MutableDictionary(name)\
- (NSMutableDictionary *)name {\
if (!_##name) {\
_##name = [NSMutableDictionary dictionary];\
}\
return _##name;\
}

//runtime
#define WY_ExchangeClassImp(sel1,sel2) \
method_exchangeImplementations(class_getClassMethod(self, sel1), class_getClassMethod(self, sel2));
#define WY_ExchangeInstanceImp(sel1,sel2) \
method_exchangeImplementations(class_getInstanceMethod(self, sel1), class_getInstanceMethod(self, sel2));



#endif /* WYMacroA_h */
