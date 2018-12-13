//
//  PathService.h
//  CarPooling
//
//  Created by KAI on 15-1-31.
//  Copyright (c) 2015年 KAI. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MEDIA_TYPE_GENERAL_IMAGE @"gnr/imgs"

#define MEDIA_TYPE_MESSAGE_IMAGE @"msg/imgs"

@interface PathService : NSObject

/** 将url链接上的文件名转化为本地文件名（不带路径） */
+ (NSString *)fileNameForUrlStr:(NSString *)urlStr;

/** 取得某个用户的某种资源类型，某个文件的具体路径 */
+ (NSString *)pathForFile:(NSString *)fileName userId:(NSString *)userId mediaType:(NSString *)mediaType;

+ (NSString *)filePathWidthFileName:(NSString *)fileName;

@end
