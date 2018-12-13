//
//  TransferViewController.h
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/15.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletModel.h"
#import "TokenCoinModel.h"

@protocol TransferViewControllerDelegate;

@interface TransferViewController : BaseViewController

@property (nonatomic, strong) TokenCoinModel *tokenCoinModel;
@property (nonatomic, strong) WalletModel *walletModel;

@property (nonatomic, weak)id<TransferViewControllerDelegate> delegate;

@end

@protocol TransferViewControllerDelegate <NSObject>

//交易完成事件
-(void)transferSuccess:(TokenCoinModel *)tokenCoinModel;

@end
