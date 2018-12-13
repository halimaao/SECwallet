//
//  PathService.m
//  CarPooling
//
//  Created by KAI on 15-1-31.
//  Copyright (c) 2015年 KAI. All rights reserved.
//

#import "PathService.h"

@implementation PathService

+ (NSString *)fileNameForUrlStr:(NSString *)urlStr {
    return [urlStr stringByReplacingOccurrencesOfString:@"/" withString:@"%"];
}

+ (NSString *)pathForFile:(NSString *)fileName userId:(NSString *)userId mediaType:(NSString *)mediaType {
    if (!userId || [userId isEqualToString:@""]) {
        userId = @"0";
    }
    if (!fileName) {
        fileName = @"";
    }

    NSString *fileName2 = fileName;
    
    NSArray *paths = nil;
    BOOL isInCachesDirectory = ([mediaType rangeOfString:@"gnr"].location != NSNotFound);
    if (isInCachesDirectory) {
        paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE);
    } else {
        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
    }
    NSString *usersRootDirectory = [paths objectAtIndex:0];
    NSString *filePath1 = nil;
    if (isInCachesDirectory) {
        //caches目录下的资源全部不带用户id，所有用户的缓存文件都存在同一个目录中
        filePath1 = usersRootDirectory;
    } else {
        filePath1 = [usersRootDirectory stringByAppendingPathComponent:userId];
    }
    NSString *filePath2 = [filePath1 stringByAppendingPathComponent:mediaType];
    NSString *filePath3 = [filePath2 stringByAppendingPathComponent:fileName2];
    return filePath3;
}

+ (NSString *)filePathWidthFileName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (NSString *)cachesPathWidthCachesName:(NSString *)cachesName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    return [cachesDirectory stringByAppendingPathComponent:cachesName];
}

@end
