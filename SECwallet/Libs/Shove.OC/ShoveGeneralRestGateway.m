//
//  ShoveGeneralRestGateway.m
//  Shove
//
//  Created by 英迈思实验室移动开发部 on 14-8-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
// 通用的 REST 类型的网关

#import "ShoveGeneralRestGateway.h"

@implementation ShoveGeneralRestGateway

+ (NSString *) getSignData:(NSMutableDictionary  *)parameters
{

    NSString *signData =@"";
    NSArray *parameterNames = [parameters allKeys];
    NSMutableString *str = [[NSMutableString alloc]init];
    NSString *merkey =@"";
    for (int i = 0; i < [parameters count]; i++) {
        NSString *_key = parameterNames[i];
        /*************中融投****************/
        //字符串=act的参数值+r_type参数值
        if ([_key isEqualToString:@"act"]) {
            [str appendString:parameters[_key]];
        }
        if ([_key isEqualToString:@"r_type"]) {
            [str appendString:parameters[_key]];
        }
        
        if ([_key isEqualToString:@"merKey"]) {
            merkey = parameters[_key];
        }
    }
    
    NSLog(@"%@",merkey);
    
    signData = [NSString HMACMD5WithString:str WithKey:merkey];
    
    return signData;
    
}


@end
