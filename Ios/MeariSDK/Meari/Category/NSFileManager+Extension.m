//
//  NSFileManager+Extension.m
//  Meari
//
//  Created by 李兵 on 2016/11/9.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "NSFileManager+Extension.h"

static NSString *thumbFolderName = @"Thumbs";
static NSString *videoFolderName = @"Video";
static NSString *photoFolderName = @"Photo";
static NSString *audioFolderName = @"Audio";


@implementation NSFileManager (Extension)
//系统文件夹
+ (NSString *)documentFolder {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}
+ (NSString*)libraryFolder {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
}
+ (NSString*)cachesFolder {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
}

//自定义文件夹
+ (NSString*)thumbFolder {
    return [self createSubFolder:thumbFolderName superFolder:[self libraryFolder]];
}
+ (NSString*)videoFolder {
    return [self createSubFolder:videoFolderName superFolder:[self documentFolder]];
}
+ (NSString*)photoFolder {
    return [self createSubFolder:photoFolderName superFolder:[self documentFolder]];
}
+ (NSString *)audioFolder {
    return [self createSubFolder:audioFolderName superFolder:[self documentFolder]];
}

//文件
+ (NSString *)thumbFile:(NSString *)sn {
    NSString *thumbFile = [[self thumbFolder] stringByAppendingFormat:@"/%@.jpg", sn];
    return thumbFile;
}
+ (NSString *)wy_videoFileWithSN:(NSString *)sn; {
    return [[self videoFolder] stringByAppendingFormat:@"/%@-%@.mp4", sn, [self dateFormatterName]];
}
+ (NSString *)wy_photoFileWithSN:(NSString *)sn {
    return [[self photoFolder] stringByAppendingFormat:@"/%@-%@.jpg", sn, [self dateFormatterName]];
}


#pragma mark - private
+ (NSString *)createSubFolder:(NSString *)subFolderName superFolder:(NSString *)superFolder {
    NSString *path = [superFolder stringByAppendingPathComponent:subFolderName];
    if (![[self defaultManager] fileExistsAtPath:path]) {
        [[self defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
    
}
+ (NSString *)createFile:(NSString *)filename atFolder:(NSString *)folder {
    NSString *path = [folder stringByAppendingPathComponent:filename];
    if (![[self defaultManager] fileExistsAtPath:path]) {
        [[self defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}
+ (NSString *)dateFormatterName {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSDate *now = [NSDate date];
    int ms = ((double)now.timeIntervalSince1970 - (int)now.timeIntervalSince1970) * 1000;
    return [NSString stringWithFormat:@"%@%03d", [dateFormatter stringFromDate:now], ms];
}
+ (NSString *)currentTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd--HH-mm-ss";
    NSDate *now = [NSDate date];
    int ms = ((double)now.timeIntervalSince1970 - (int)now.timeIntervalSince1970) * 1000;
    return [NSString stringWithFormat:@"%@.%03d", [dateFormatter stringFromDate:now], ms];
}

@end
