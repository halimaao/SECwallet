//
//  TradeRecordModel.h
//  TOP_zrt
//
//  Created by Laughing on 16/5/30.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *walletIcon;     //图标

@property (nonatomic, copy) NSString *walletName;
@property (nonatomic, copy) NSString *walletPassword;  //钱包密码(也就是交易密码)
@property (nonatomic, copy) NSString *loginPassword;  //登录密码
@property (nonatomic, copy) NSString *passwordTip;  //密码提示

@property (nonatomic, copy) NSString *address;         //地址
@property (nonatomic, copy) NSString *mnemonicPhrase;  //助记词
@property (nonatomic, assign) NSInteger isBackUpMnemonic;    //是否备份助记词
@property (nonatomic, assign) NSInteger isFromMnemonicImport;  //是否助记词导入

@property (nonatomic, copy) NSString *privateKey;      //私钥
@property (nonatomic, copy) NSString *keyStore;

@property (nonatomic, copy) NSString *balance;        //代币余额
@property (nonatomic, copy) NSString *balance_CNY;    //折算人民币

@property (nonatomic, copy) NSArray *tokenCoinList;    //绑定的代币集合

- (WalletModel*)initWithWalletName:(NSString *)walletName
                 andWalletPassword:(NSString *)walletPassword
                  andLoginPassword:(NSString *)loginPassword
                    andPasswordTip:(NSString *)passwordTip
                        andAddress:(NSString *)address
                 andMnemonicPhrase:(NSString *)mnemonicPhrase
                     andPrivateKey:(NSString *)privateKey
                       andKeyStore:(NSString *)keyStore
                        andBalance:(NSString *)balance
                    andBalance_CNY:(NSString *)balance_CNY
                     andWalletIcon:(NSString *)walletIcon
                  andTokenCoinList:(NSArray *)tokenCoinList
               andIsBackUpMnemonic:(NSInteger)isBackUpMnemonic
           andIsFromMnemonicImport:(NSInteger)isFromMnemonicImport;

@end
