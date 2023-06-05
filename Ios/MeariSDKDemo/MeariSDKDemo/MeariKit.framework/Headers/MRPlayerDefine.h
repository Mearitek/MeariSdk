//
//  MRDefine.h
//  MeariPlayerKit
//
//  Created by FMG on 2019/9/4.
//  Copyright © 2019 FMG. All rights reserved.
//


#ifndef MRDefine_h
#define MRDefine_h

#ifdef __OBJC__
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^MRSuccessHandler)(void);
typedef void (^MRAbnormalDisconnect)(void);
typedef void (^MRSuccessDict)(NSDictionary *dict);
typedef void (^MRSuccessString)(NSString *result);
typedef void (^MRSuccessList)(NSArray *list);
typedef void (^MRSuccessBOOL)(BOOL result);
typedef void (^MRSuccessID)(id result);
typedef void (^MRSuccessInt)(int result);
typedef void (^MRVoiceVolume)(int volume);

typedef void (^MRFailureHandler)(void);
typedef void (^MRFailureError)(NSString *error);
typedef void (^MRPrtpConnectHandler)(int connected);
typedef struct{
    MRSuccessHandler     cb_success_handler;
    MRAbnormalDisconnect cb_abnormal_disconnect;
    MRSuccessDict        cb_success_dict;
    MRSuccessString      cb_success_string;
    MRSuccessList        cb_success_list;
    MRSuccessBOOL        cb_success_bool;
    MRSuccessID          cb_success_id;
    MRSuccessInt         cb_success_Int;
    MRVoiceVolume        cb_voice_volume;
    MRFailureHandler     cb_failure_handler;
    MRFailureError       cb_failure_error;
    MRFailureError       cb_streamclose;
}MRPlayerCallBack;
#endif
#endif /* MRDefine_h */
