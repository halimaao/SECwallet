//
//  NetWorkClient.m
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import "NetWorkClient.h"
#import "NetWorkConfig.h"
#import <AdSupport/AdSupport.h>

#define IS_DEBUG YES

@interface NetWorkClient ()

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

@implementation NetWorkClient

- (instancetype)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:BaseServerUrl]];
    
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];  //application/json   text/x-json
    }
    return self;
}

// 上传图片用的配置
- (instancetype)initWithUrl:(NSString *)url
{
    self = [super initWithBaseURL:[NSURL URLWithString:url]];
    if (self) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/x-json", nil];
    }
    return self;
}

// Post请求
- (NSURLSessionDataTask *) requestPost:(NSString *)URLString withParameters:(NSMutableDictionary *)parameters isEncryp:(BOOL)encryp
{
    if (encryp)
    {
//        NSArray *parameterNames = [parameters allKeys];
        //ios10之后最好加一个判断 [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]
        //返回BOOL值  YES说明没有 “开启限制广告跟踪”，可以获取到正确的idfa  如果是NO，说明等待你的就是一串00000000000
        NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        //IOS设备标示
        [parameters setObject:adId forKey:@"imei"];
    }
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        
        if(IS_DEBUG){
            NSLog(@"网络不可用");
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(networkError)]) {
            [self.delegate networkError];
        }
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(startRequest)])
        {
            [self.delegate startRequest];
        }
        
        _dataTask = [self POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject)
                     {
                         
                         if(IS_DEBUG)
                         {
                             NSLog(@"服务器返回成功：\n%@\n", task.response);
                             
                         }
                         
                         if (self.delegate && [self.delegate respondsToSelector:@selector(httpResponseSuccess:dataTask:didSuccessWithObject:)])
                         {
                             
                             [self.delegate httpResponseSuccess:self dataTask:task didSuccessWithObject:responseObject];
                         }
                         
                     } failure:^(NSURLSessionDataTask *task, NSError *error)
                     {
                         if(IS_DEBUG)
                         {
                             NSLog(@"服务器请求异常：\n%@\n", task.response);
                         }
                         
                         if (self.delegate && [self.delegate respondsToSelector:@selector(httpResponseFailure:dataTask:didFailWithError:)])
                         {
                             [self.delegate httpResponseFailure:self dataTask:task didFailWithError:error];
                         }
                         
                     }];
        
    }
    return _dataTask;
}


- (NSURLSessionDataTask *) requestGet:(NSString *)URLString withParameters:(NSMutableDictionary *)parameters isEncryp:(BOOL)encryp
{
    if (encryp)
    {
    }
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        
        if(IS_DEBUG){
            NSLog(@"网络不可用");
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(networkError)]) {
            [self.delegate networkError];
        }
        
    } else {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(startRequest)]) {
            [self.delegate startRequest];
        }
        
        _dataTask = [self GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if(IS_DEBUG){
                NSLog(@"服务器返回成功：\n%@\n", task.response);
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(httpResponseSuccess:dataTask:didSuccessWithObject:)]) {
                [self.delegate httpResponseSuccess:self dataTask:task didSuccessWithObject:responseObject];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            if(IS_DEBUG){
                NSLog(@"服务器请求异常：\n%@\n", task.response);
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(httpResponseFailure:dataTask:didFailWithError:)]) {
                [self.delegate httpResponseFailure:self dataTask:task didFailWithError:error];
            }
            
        }];
    }
    return _dataTask;
}

-(void)cancel
{
    
    if (_dataTask != nil) {
        [_dataTask cancel];
        _dataTask = nil;
    }
}


@end
