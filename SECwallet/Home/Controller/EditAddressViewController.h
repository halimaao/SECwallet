//
//  EditAddressViewController.h
//  CECwallet
//
//  Created by 通证控股 on 2018/10/17.
//  Copyright © 2018年 通证控股. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    ImportWalletType_mnemonicPhrase = 1,
    ImportWalletType_keyStore = 2,
    ImportWalletType_privateKey = 3,
    
} ImportWalletType;

@interface ManageAddressViewController : BaseViewController

@end

NS_ASSUME_NONNULL_END
