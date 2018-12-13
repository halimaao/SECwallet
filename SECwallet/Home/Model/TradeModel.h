//
//  TradeModel.h
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/11.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WalletModel.h"
#import <ethers/ethers.h>

@interface TradeModel : NSObject

@property (nonatomic, assign) int type;         //类型（1转入 2转出）
@property (nonatomic, copy) NSString *icon;     //图标
@property (nonatomic, copy) NSString *tokenAddress;   //代币合约地址
@property (nonatomic, copy) NSString *transferAddress;  //转账地址
@property (nonatomic, copy) NSString *gatherAddress;   //收款地址
@property (nonatomic, copy) NSString *time;     //时间
@property (nonatomic, copy) NSString *sum;      //额度

@property (nonatomic, assign) int status;      //交易状态(1成功 0失败 2打包中)
@property (nonatomic, copy) NSString *gas;      //矿工费
@property (nonatomic, copy) NSString *tip;      //备注
@property (nonatomic, copy) NSString *tradeNum; //交易号
@property (nonatomic, copy) NSString *blockNum; //区块号

- (instancetype)initWithDictionary:(NSDictionary *)dictionary walletAddress:(NSString *)walletAddress;

- (instancetype)initWithTransactionInfoPromise:(TransactionInfoPromise *)info walletAddress:(NSString *)walletAddress;

@end
