//
//  TradeDetailView.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/15.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "TradeDetailView.h"

#define kAssetsViewWidth      kScreenWidth
#define kAssetsViewHeight     Size(265)

@interface TradeDetailView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *infoView;

@end


@implementation TradeDetailView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

//视图
-(void)initTradeDetailViewWith:(NSString *)adress payAddress:(NSString *)payAddress gasPrice:(NSString *)gasPrice sum:(NSString *)sum tokenName:(NSString *)tokenName
{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.frame = [UIScreen mainScreen].bounds;
    UIViewController *topVC = [self appRootViewController];
    [topVC.view addSubview:self];
    
    _infoView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kAssetsViewWidth, kAssetsViewHeight)];
    _infoView.backgroundColor = WHITE_COLOR;
    [self addSubview:_infoView];
    
    //返回按钮
    UIButton *backBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(20), Size(10), Size(16), Size(16))];
    [backBT setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(tradeDetailViewHidden) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:backBT];
    //交易详情
    UILabel *detailLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Size(35))];
    detailLb.font = SystemFontOfSize(18);
    detailLb.textColor = TEXT_DARK_COLOR;
    detailLb.textAlignment = NSTextAlignmentCenter;
    detailLb.text = @"交易详情";
    [_infoView addSubview:detailLb];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(backBT.minX, backBT.maxY +Size(8), kScreenWidth -backBT.minX*2, Size(1))];
    line.backgroundColor = DIVIDE_LINE_COLOR;
    [_infoView addSubview:line];
    //订单信息
    UILabel *infoLb = [[UILabel alloc]initWithFrame:CGRectMake(line.minX, line.maxY +Size(10), Size(80), Size(20))];
    infoLb.font = SystemFontOfSize(16);
    infoLb.textColor = TEXT_DARK_COLOR;
    infoLb.text = @"订单信息";
    [_infoView addSubview:infoLb];
    UILabel *infoDesLb = [[UILabel alloc]initWithFrame:CGRectMake(infoLb.maxX, infoLb.minY, kScreenWidth -infoLb.maxY -Size(50), infoLb.height)];
    infoDesLb.font = SystemFontOfSize(16);
    infoDesLb.textColor = TEXT_BLACK_COLOR;
    infoDesLb.text = @"转账";
    [_infoView addSubview:infoDesLb];
    //转入地址
    UILabel *addreDesLb = [[UILabel alloc]initWithFrame:CGRectMake(infoLb.minX, infoLb.maxY +Size(5), infoLb.width, infoLb.height)];
    addreDesLb.font = SystemFontOfSize(16);
    addreDesLb.textColor = TEXT_DARK_COLOR;
    addreDesLb.text = @"转入地址";
    [_infoView addSubview:addreDesLb];
    UILabel *addressLb = [[UILabel alloc]initWithFrame:CGRectMake(infoDesLb.minX, addreDesLb.minY, infoDesLb.width, Size(35))];
    addressLb.font = SystemFontOfSize(14);
    addressLb.textColor = TEXT_BLACK_COLOR;
    addressLb.numberOfLines = 2;
    addressLb.text = adress;
    [_infoView addSubview:addressLb];
    //付款钱包
    UILabel *payAddressLb = [[UILabel alloc]initWithFrame:CGRectMake(infoLb.minX, addressLb.maxY, infoLb.width, infoLb.height)];
    payAddressLb.font = SystemFontOfSize(16);
    payAddressLb.textColor = TEXT_DARK_COLOR;
    payAddressLb.text = @"付款钱包";
    [_infoView addSubview:payAddressLb];
    UIButton *payAddressBT = [[UIButton alloc]initWithFrame:CGRectMake(payAddressLb.maxX, payAddressLb.minY, infoDesLb.width, infoDesLb.height)];
    payAddressBT.titleLabel.font = SystemFontOfSize(14);
    [payAddressBT setTitleColor:TEXT_BLACK_COLOR forState:UIControlStateNormal];
    [payAddressBT setTitle:payAddress forState:UIControlStateNormal];
    [_infoView addSubview:payAddressBT];
    //矿工费
    UILabel *freeDesLb = [[UILabel alloc]initWithFrame:CGRectMake(payAddressLb.minX, payAddressLb.maxY +Size(5), infoLb.width, infoLb.height)];
    freeDesLb.font = SystemFontOfSize(16);
    freeDesLb.textColor = TEXT_DARK_COLOR;
    freeDesLb.text = @"矿工费";
    [_infoView addSubview:freeDesLb];
    UILabel *freeLb = [[UILabel alloc]initWithFrame:CGRectMake(infoDesLb.minX, freeDesLb.minY, infoDesLb.width, infoLb.height)];
    freeLb.font = SystemFontOfSize(15);
    freeLb.textAlignment = NSTextAlignmentRight;
    freeLb.textColor = TEXT_BLACK_COLOR;
    freeLb.text = [NSString stringWithFormat:@"%@ eth",@"0"];
    [_infoView addSubview:freeLb];
    //金额
    UILabel *sumDesLb = [[UILabel alloc]initWithFrame:CGRectMake(freeDesLb.minX, freeDesLb.maxY +Size(5), infoLb.width, infoLb.height)];
    sumDesLb.font = SystemFontOfSize(16);
    sumDesLb.textColor = TEXT_DARK_COLOR;
    sumDesLb.text = @"金额";
    [_infoView addSubview:sumDesLb];
    UILabel *sumLb = [[UILabel alloc]initWithFrame:CGRectMake(infoDesLb.minX, sumDesLb.minY, infoDesLb.width, infoLb.height)];
    sumLb.font = SystemFontOfSize(15);
    sumLb.textAlignment = NSTextAlignmentRight;
    sumLb.textColor = TEXT_BLACK_COLOR;
    sumLb.text = [NSString stringWithFormat:@"%@ SEC",sum];
    [_infoView addSubview:sumLb];
    
    /*****************确认*****************/
    CGFloat padddingLeft = Size(20);
    UIButton *creatBT = [[UIButton alloc] initWithFrame:CGRectMake(padddingLeft, sumDesLb.maxY +Size(20), kScreenWidth - 2*padddingLeft, Size(45))];
    [creatBT goldBigBtnStyle:@"确认"];
    [creatBT addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:creatBT];
    
    //消失视图
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tradeDetailViewHidden)];
    tapGes.delegate = self;
    [self addGestureRecognizer:tapGes];
    
    [self tradeDetailViewShow];
}

/**
 展示view
 */
-(void)tradeDetailViewShow
{
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.alpha = 1;
        CGRect frame = _infoView.frame;
        frame.origin.y = kScreenHeight -kAssetsViewHeight;
        [_infoView setFrame:frame];
    } completion:^(BOOL finished){
    }];
}

/**
 隐藏view
 */
-(void)tradeDetailViewHidden
{
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
        CGRect frame = _infoView.frame;
        frame.origin.y = kScreenHeight;
        [_infoView setFrame:frame];
    } completion:^(BOOL finished){
        self.alpha = 0;
    }];
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

-(void)nextAction
{
    [self.delegate clickFinish];
    [self tradeDetailViewHidden];
}

@end
