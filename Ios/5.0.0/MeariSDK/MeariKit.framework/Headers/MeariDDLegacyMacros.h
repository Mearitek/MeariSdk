// Software License Agreement (BSD License)
//
// Copyright (c) 2010-2016, Deusty, LLC
// All rights reserved.
//
// Redistribution and use of this software in source and binary forms,
// with or without modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// * Neither the name of Deusty nor the names of its contributors may be used
//   to endorse or promote products derived from this software without specific
//   prior written permission of Deusty, LLC.

/**
 * Legacy macros used for 1.9.x backwards compatibility.
 *
 * Imported by default when importing a MeariDDLog.h directly and MeariDD_LEGACY_MACROS is not defined and set to 0.
 **/
#if MeariDD_LEGACY_MACROS

#warning CocoaLumberjack 1.9.x legacy macros enabled. \
Disable legacy macros by importing CocoaLumberjack.h or MeariDDLogMacros.h instead of MeariDDLog.h or add `#define MeariDD_LEGACY_MACROS 0` before importing MeariDDLog.h.

#ifndef LOG_LEVEL_DEF
    #define LOG_LEVEL_DEF ddLogLevel
#endif

#define LOG_FLAG_ERROR    MeariDDLogFlagError
#define LOG_FLAG_WARN     MeariDDLogFlagWarning
#define LOG_FLAG_INFO     MeariDDLogFlagInfo
#define LOG_FLAG_DEBUG    MeariDDLogFlagDebug
#define LOG_FLAG_VERBOSE  MeariDDLogFlagVerbose

#define LOG_LEVEL_OFF     MeariDDLogLevelOff
#define LOG_LEVEL_ERROR   MeariDDLogLevelError
#define LOG_LEVEL_WARN    MeariDDLogLevelWarning
#define LOG_LEVEL_INFO    MeariDDLogLevelInfo
#define LOG_LEVEL_DEBUG   MeariDDLogLevelDebug
#define LOG_LEVEL_VERBOSE MeariDDLogLevelVerbose
#define LOG_LEVEL_ALL     MeariDDLogLevelAll

#define LOG_ASYNC_ENABLED YES

#define LOG_ASYNC_ERROR    ( NO && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_WARN     (YES && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_INFO     (YES && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_DEBUG    (YES && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_VERBOSE  (YES && LOG_ASYNC_ENABLED)

#define LOG_MACRO(isAsynchronous, lvl, flg, ctx, atag, fnct, frmt, ...) \
        [MeariDDLog log : isAsynchronous                                     \
             level : lvl                                                \
              flag : flg                                                \
           context : ctx                                                \
              file : __FILE__                                           \
          function : fnct                                               \
              line : __LINE__                                           \
               tag : atag                                               \
            format : (frmt), ## __VA_ARGS__]

#define LOG_MAYBE(async, lvl, flg, ctx, fnct, frmt, ...)                       \
        do { if(lvl & flg) LOG_MACRO(async, lvl, flg, ctx, nil, fnct, frmt, ##__VA_ARGS__); } while(0)

#define LOG_OBJC_MAYBE(async, lvl, flg, ctx, frmt, ...) \
        LOG_MAYBE(async, lvl, flg, ctx, __PRETTY_FUNCTION__, frmt, ## __VA_ARGS__)

#define MeariDDLogError(frmt, ...)   LOG_OBJC_MAYBE(LOG_ASYNC_ERROR,   LOG_LEVEL_DEF, LOG_FLAG_ERROR,   0, frmt, ##__VA_ARGS__)
#define MeariDDLogWarn(frmt, ...)    LOG_OBJC_MAYBE(LOG_ASYNC_WARN,    LOG_LEVEL_DEF, LOG_FLAG_WARN,    0, frmt, ##__VA_ARGS__)
#define MeariDDLogInfo(frmt, ...)    LOG_OBJC_MAYBE(LOG_ASYNC_INFO,    LOG_LEVEL_DEF, LOG_FLAG_INFO,    0, frmt, ##__VA_ARGS__)
#define MeariDDLogDebug(frmt, ...)   LOG_OBJC_MAYBE(LOG_ASYNC_DEBUG,   LOG_LEVEL_DEF, LOG_FLAG_DEBUG,   0, frmt, ##__VA_ARGS__)
#define MeariDDLogVerbose(frmt, ...) LOG_OBJC_MAYBE(LOG_ASYNC_VERBOSE, LOG_LEVEL_DEF, LOG_FLAG_VERBOSE, 0, frmt, ##__VA_ARGS__)

#endif
