//
//  TradeDetailViewController.h
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/11.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletModel.h"
#import "TokenCoinModel.h"
@interface TradeDetailViewController : BaseViewController

@property (nonatomic, strong) TokenCoinModel *tokenCoinModel;
@property (nonatomic, strong) WalletModel *walletModel;

@property (nonatomic, assign) BOOL isRecordListRefresh;

@end
