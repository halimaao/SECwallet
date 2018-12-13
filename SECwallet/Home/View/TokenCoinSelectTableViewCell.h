//
//  TokenCoinSelectTableViewCell.h
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/19.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletModel.h"

#define kTableCellHeight Size(85)

@interface TokenCoinSelectTableViewCell : UITableViewCell

-(void) fillCellWithObject:(id) object with:(WalletModel *)walletModel;

@end

