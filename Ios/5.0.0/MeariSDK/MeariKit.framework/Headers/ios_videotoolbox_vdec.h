//
//  harddecoder.h
//  VTDemo
//
//  Created by lileilei on 15/7/25.
//  Copyright (c) 2015年 lileilei. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <VideoToolbox/VideoToolbox.h>

typedef enum : NSUInteger {
    PPSHardDecoder_Video_ID_H264 = 0,
    PPSHardDecoder_Video_ID_HEVC,
} PPSHardDecoderVideoID;

@interface Apple_HardDecoder : NSObject

@property (nonatomic, assign) CMVideoFormatDescriptionRef formatDesc;
@property (nonatomic, assign) VTDecompressionSessionRef decompressionSession;
@property (nonatomic, assign) int spsSize;
@property (nonatomic, assign) int ppsSize;
@property (nonatomic, assign) int seiSize;
@property (nonatomic, assign) BOOL isplayback;

- (CVPixelBufferRef)decodeFrame:(uint8_t *)frame withSize:(uint32_t)frameSize videoId:(PPSHardDecoderVideoID)videoId timestamp:(long)timestamp magic:(int)magic;
- (void)stopDecode;
@end

