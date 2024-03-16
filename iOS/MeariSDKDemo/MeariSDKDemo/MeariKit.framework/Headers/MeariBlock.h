//
//  MeariBlock.h
//  MeariKit
//
//  Created by duan on 2023/8/8.
//  Copyright © 2023 Meari. All rights reserved.
//

#ifndef MeariBlock_h
#define MeariBlock_h

typedef void(^MeariSuccess)(void);
typedef void(^MeariSuccess_BOOL)(BOOL isSuccess);
typedef void(^MeariSuccess_Dictionary)(NSDictionary *dict);
typedef void(^MeariSuccess_String)(NSString *string);

typedef void(^MeariFailure)(NSError *error);

#endif /* MeariBlock_h */
