//
//  AppDefaultUtil.m
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import "AppDefaultUtil.h"
#import <arpa/inet.h>
#import <ifaddrs.h>

#define KEY_FIRST_LANCHER       @"FirstLancher"           // 记录用户是否第一次登录，YES为是，NO为否
#define KEY_DefaultWalletIndex  @"defaultWalletIndex"     // 默认钱包位置

@interface AppDefaultUtil()

@end

@implementation AppDefaultUtil

+ (instancetype)sharedInstance {
    static AppDefaultUtil *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[AppDefaultUtil alloc] init];
        
    });
    
    return _sharedClient;
}

// 设置用户是否第一次登录
-(void) setFirstLancher:(BOOL)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:KEY_FIRST_LANCHER];
    [defaults synchronize];
}

// 设置用户是否第一次登登录
-(BOOL) isFirstLancher
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:KEY_FIRST_LANCHER];
}

// 判断用户是否创建了钱包
-(BOOL) hasCreatWallet
{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* datapath = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
    NSMutableArray *list = [NSMutableArray array];
    list = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    if (list.count > 0) {
        return YES;
    }else{
        return NO;
    }
}

// 保存默认钱包位置
-(void) setDefaultWalletIndex:(NSString *)index
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:index forKey:KEY_DefaultWalletIndex];
    [defaults synchronize];
}

// 获取默认钱包位置
-(NSString *) defaultWalletIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:KEY_DefaultWalletIndex];
}


@end
