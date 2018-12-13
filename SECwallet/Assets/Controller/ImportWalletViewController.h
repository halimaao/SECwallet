//
//  ImportWalletViewController.h
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "BaseViewController.h"

//导入类型 1助记词 2官方钱包 3私钥
typedef enum {
    ImportWalletType_mnemonicPhrase = 1,
    ImportWalletType_keyStore = 2,
    ImportWalletType_privateKey = 3,
    
} ImportWalletType;

@interface ImportWalletViewController : BaseViewController

@property (nonatomic, assign) int importWalletType;

@end
