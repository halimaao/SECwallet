//
//  CacheUtil.h
//  TOP_zrt
//
//  Created by Laughing on 16/6/1.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheUtil : NSObject

+(NSString *) creatCacheFileName:(NSDictionary *) parameters;

+(NSString *) creatCacheFileNameWithString:(NSString *) value;

//清除代币交易记录缓存
+(void) clearTokenCoinTradeListCacheFile;

@end
