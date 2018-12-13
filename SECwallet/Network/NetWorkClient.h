//
//  NetWorkClient.h
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@protocol HTTPClientDelegate;

@interface NetWorkClient : AFHTTPSessionManager

@property (nonatomic, weak) id<HTTPClientDelegate>delegate;

- (instancetype)init;

- (instancetype)initWithUrl:(NSString *)url;

// 网络请求数据
- (NSURLSessionDataTask *) requestGet:(NSString *)URLString withParameters:(NSMutableDictionary *)parameters isEncryp:(BOOL)encryp;

// Post请求
- (NSURLSessionDataTask *) requestPost:(NSString *)URLString withParameters:(NSMutableDictionary *)parameters isEncryp:(BOOL)encryp;

// 取消网络请求
-(void) cancel;

@end

// 网络请求代理
@protocol HTTPClientDelegate <NSObject>

@optional

// 开始网络请求
-(void) startRequest;

// 网络请求成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj;

// 网络请求失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error;

// 网络异常
-(void) networkError;

@end
