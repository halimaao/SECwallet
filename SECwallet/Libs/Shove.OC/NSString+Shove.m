//
//  NSString+Shove.m
//  Shove
//
//  Created by 英迈思实验室移动开发部 on 14-8-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64S.h"

#import "NSString+Shove.h"

@implementation NSString (Shove)

/* 
 * 给字符串md5加密
 */
- (NSString*)md5
{
    const char *ptr = [self UTF8String];

    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];

    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

/*
 * 给字符串hmac md5加密
 */
+ (NSString *)HMACMD5WithString:(NSString *)toEncryptStr WithKey:(NSString *)keyStr
{
    const char *cKey  = [keyStr cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [toEncryptStr cStringUsingEncoding:NSUTF8StringEncoding];
    const unsigned int blockSize = 64;
    char ipad[blockSize];
    char opad[blockSize];
    char keypad[blockSize];
    
    unsigned int keyLen = strlen(cKey);
    CC_MD5_CTX ctxt;
    if (keyLen > blockSize) {
        CC_MD5_Init(&ctxt);
        CC_MD5_Update(&ctxt, cKey, keyLen);
        CC_MD5_Final((unsigned char *)keypad, &ctxt);
        keyLen = CC_MD5_DIGEST_LENGTH;
    }
    else {
        memcpy(keypad, cKey, keyLen);
    }
    
    memset(ipad, 0x36, blockSize);
    memset(opad, 0x5c, blockSize);
    
    int i;
    for (i = 0; i < keyLen; i++) {
        ipad[i] ^= keypad[i];
        opad[i] ^= keypad[i];
    }
    
    CC_MD5_Init(&ctxt);
    CC_MD5_Update(&ctxt, ipad, blockSize);
    CC_MD5_Update(&ctxt, cData, strlen(cData));
    unsigned char md5[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(md5, &ctxt);
    
    CC_MD5_Init(&ctxt);
    CC_MD5_Update(&ctxt, opad, blockSize);
    CC_MD5_Update(&ctxt, md5, CC_MD5_DIGEST_LENGTH);
    CC_MD5_Final(md5, &ctxt);
    
    const unsigned int hex_len = CC_MD5_DIGEST_LENGTH*2+2;
    char hex[hex_len];
    for(i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        snprintf(&hex[i*2], hex_len-i*2, "%02x", md5[i]);
    }
    
    NSData *HMAC = [[NSData alloc] initWithBytes:hex length:strlen(hex)];
    NSString *hash = [[NSString alloc] initWithData:HMAC encoding:NSUTF8StringEncoding];
    return hash;
}


/*
 * imei+4位随机数+imsi+4位随机数
 */
+ (NSString *)retrunMerkey
{
    NSString *imei = [NSString stringWithFormat:@"imei%0.4d",arc4random() % 10000];
    NSString *imsi = [NSString stringWithFormat:@"imsi%0.4d",arc4random() % 10000];
    NSString *merKey = [NSString stringWithFormat:@"%@%@",imei,imsi];
    
    return merKey;
}

/*
 * 给字符串Base64加密
 */
+ (NSString *)base64WithString:(NSString *)toEncryptStr
{
    NSString* decodeResult = nil;
    NSData* encodeData = [toEncryptStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* decodeData = [GTMBase64S encodeData:encodeData];
    
    decodeResult = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    
    return decodeResult;
}

@end
