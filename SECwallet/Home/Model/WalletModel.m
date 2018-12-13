//
//  TradeRecordModel.m
//  TOP_zrt
//
//  Created by Laughing on 16/5/30.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import "WalletModel.h"

@implementation WalletModel

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
           andIsFromMnemonicImport:(NSInteger)isFromMnemonicImport
{
    if (self = [super init]) {
        
        _walletName = walletName;
        _walletPassword = walletPassword;
        _loginPassword = loginPassword;
        _passwordTip = passwordTip;
        
        _address = address;
        _mnemonicPhrase = mnemonicPhrase;
        _privateKey = privateKey;
        _keyStore = keyStore;
        
        _balance = balance;
        _balance_CNY = balance_CNY;
        _walletIcon = walletIcon;
        
        _tokenCoinList = tokenCoinList;
        _isBackUpMnemonic = isBackUpMnemonic;
        _isFromMnemonicImport = isFromMnemonicImport;
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.walletName forKey:@"walletName"];
    [aCoder encodeObject:self.walletPassword forKey:@"walletPassword"];
    [aCoder encodeObject:self.loginPassword forKey:@"loginPassword"];
    [aCoder encodeObject:self.passwordTip forKey:@"passwordTip"];
    
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.mnemonicPhrase forKey:@"mnemonicPhrase"];
    [aCoder encodeObject:self.privateKey forKey:@"privateKey"];
    [aCoder encodeObject:self.keyStore forKey:@"keyStore"];
    
    [aCoder encodeObject:self.balance forKey:@"balance"];
    [aCoder encodeObject:self.balance_CNY forKey:@"balance_CNY"];
    [aCoder encodeObject:self.walletIcon forKey:@"walletIcon"];
    
    [aCoder encodeObject:self.tokenCoinList forKey:@"tokenCoinList"];
    [aCoder encodeInteger:self.isBackUpMnemonic forKey:@"isBackUpMnemonic"];
    [aCoder encodeInteger:self.isFromMnemonicImport forKey:@"isFromMnemonicImport"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.walletName = [aDecoder decodeObjectForKey:@"walletName"] ;
        self.walletPassword = [aDecoder decodeObjectForKey:@"walletPassword"];
        self.loginPassword = [aDecoder decodeObjectForKey:@"loginPassword"];
        self.passwordTip = [aDecoder decodeObjectForKey:@"passwordTip"];
        
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.mnemonicPhrase = [aDecoder decodeObjectForKey:@"mnemonicPhrase"];
        self.privateKey = [aDecoder decodeObjectForKey:@"privateKey"];
        self.keyStore = [aDecoder decodeObjectForKey:@"keyStore"];
        
        self.balance = [aDecoder decodeObjectForKey:@"balance"];
        self.balance_CNY = [aDecoder decodeObjectForKey:@"balance_CNY"];
        self.walletIcon = [aDecoder decodeObjectForKey:@"walletIcon"];
        
        self.tokenCoinList = [aDecoder decodeObjectForKey:@"tokenCoinList"];
        self.isBackUpMnemonic = [aDecoder decodeIntegerForKey:@"isBackUpMnemonic"];
        self.isFromMnemonicImport = [aDecoder decodeIntegerForKey:@"isFromMnemonicImport"];
    }
    return self;
}


@end
