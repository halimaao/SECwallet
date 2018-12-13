//
//  ShoveGeneralRestGateway.h
//  Shove
//
//  Created by 英迈思实验室移动开发部 on 14-8-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
// 通用的 REST 类型的网关

#import <Foundation/Foundation.h>

@interface ShoveGeneralRestGateway : NSObject

+ (NSString *) getSignData:(NSMutableDictionary  *)parameters;

@end
