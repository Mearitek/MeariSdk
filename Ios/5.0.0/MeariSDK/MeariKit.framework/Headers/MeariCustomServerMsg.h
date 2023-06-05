//
//  MeariCustomServerMsg.h
//  MeariKit
//
//  Created by xj zhuo on 2020/12/3.
//  Copyright © 2020 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeariCustomServerMsg : NSObject
@property (nonatomic, strong) NSString  *from;
@property (nonatomic, strong) NSString  *to;
@property (nonatomic, strong) NSString  *fromBrand;
@property (nonatomic, strong) NSString  *toBrand;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString  *msgid;
@property (nonatomic, assign) long long t;
@property (nonatomic, strong) NSString  *type;
@property (nonatomic, strong) NSString  *content;
@property (nonatomic, strong) NSString  *field1;

- (instancetype)initWithMsgContentDic:(NSDictionary *)dic;
@end

@interface MeariCustomServerMsgContent : NSObject

@property (nonatomic, strong) NSString  *msgid;
@property (nonatomic, assign) long long t;
@property (nonatomic, strong) NSString  *type;
@property (nonatomic, strong) NSString  *content;
@property (nonatomic, strong) NSString  *field1;

@end

@interface MeariCustomServerMsgAck : NSObject

@property (nonatomic, strong) NSString  *msgid;
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString  *field1;

@end

@interface MeariCustomServerMsgGet : NSObject

@property (nonatomic, strong) NSString  *field1;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) long long start;
@property (nonatomic, assign) long long end;
@property (nonatomic, strong) NSString *type;
- (instancetype)initWithField:(NSString *)field page:(NSInteger)page size:(NSInteger)size  startTime:(long long)start endTime:(long long)end type:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
