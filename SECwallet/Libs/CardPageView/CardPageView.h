//
//  CardPage.h
//  CollectionCardPage
//
//  Created by ymj_work on 16/5/28.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardPageViewDelegate;

@interface CardPageView : UIView

-(id)initWithFrame:(CGRect)frame withWalletList:(NSArray *)walletList;

@property (nonatomic, weak)id<CardPageViewDelegate> delegate;

@end

@protocol CardPageViewDelegate <NSObject>

//助记词备份事件
-(void)backUpMnemonicAction;

//二维码收款事件
-(void)showAddressCodeAction;

//滑动刷新钱包事件
-(void)refreshWallet:(int)page clearCache:(BOOL)clearCache;

//添加代币事件
-(void)addTokenCoinAction;

@end
