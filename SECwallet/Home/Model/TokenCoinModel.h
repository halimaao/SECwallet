//
//  TokenCoinModel.h
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/15.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TokenCoinModel : NSObject

@property (nonatomic, copy) NSString *icon;           //图标
@property (nonatomic, copy) NSString *name;          //资产名称
@property (nonatomic, copy) NSString *subName;       //资产全称
@property (nonatomic, copy) NSString *contract;      //代币合约
@property (nonatomic, copy) NSString *tokenNum;      //十进制
@property (nonatomic, copy) NSString *balance;       //余额
@property (nonatomic, copy) NSString *balance_CNY;   //折算人民币

@end
