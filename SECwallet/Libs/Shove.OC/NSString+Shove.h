//
//  NSString+Shove.h
//  Shove
//
//  Created by 英迈思实验室移动开发部 on 14-8-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Shove)

/* 
 * 给字符串md5加密
 */
- (NSString *)md5;

/*
 * 给字符串hmac md5加密
 */
+ (NSString *)HMACMD5WithString:(NSString *)toEncryptStr WithKey:(NSString *)keyStr;

/*
 * imei+4位随机数+imsi+4位随机数
 */
+ (NSString *)retrunMerkey;

/*
 * 给字符串Base64加密
 */
+ (NSString *)base64WithString:(NSString *)toEncryptStr;


@end
