//
//  TradeDetailView.h
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/15.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TradeDetailViewDelegate;

@interface TradeDetailView : UIView

@property (nonatomic, weak)id<TradeDetailViewDelegate> delegate;

/**
 创建view
 */
-(void)initTradeDetailViewWith:(NSString *)adress payAddress:(NSString *)payAddress gasPrice:(NSString *)gasPrice sum:(NSString *)sum tokenName:(NSString *)tokenName;

/**
 展示view
 */
-(void)tradeDetailViewShow;

/**
 隐藏view
 */
-(void)tradeDetailViewHidden;

@end

@protocol TradeDetailViewDelegate <NSObject>

//点击事件
-(void)clickFinish;

@end
