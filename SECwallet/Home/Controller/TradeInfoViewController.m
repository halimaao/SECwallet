//
//  TradeInfoViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/16.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "TradeInfoViewController.h"
#import "CommonHtmlShowViewController.h"

#define kHeaderHeight    Size(100) +KStatusBarHeight

@interface TradeInfoViewController ()

@end

@implementation TradeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addContentView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**************导航栏布局***************/
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - 底部收款视图
- (void)addContentView
{
    UIImageView *bkgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight)];
    bkgView.image = [UIImage imageNamed:@"tradeBkg"];
    [self.view addSubview:bkgView];
    //返回按钮
    UIImageView *backIV = [[UIImageView alloc]initWithFrame:CGRectMake(Size(15), Size(10)+KStatusBarHeight, Size(16), Size(16))];
    backIV.image = [UIImage imageNamed:@"backIcon"];
    [self.view addSubview:backIV];
    UIButton *backBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(5), KStatusBarHeight, Size(35), Size(35))];
    [backBT addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBT];
    //名称
    UILabel *nameLb = [[UILabel alloc]initWithFrame:CGRectMake(0, backIV.minY, kScreenWidth, Size(20))];
    nameLb.font = BoldSystemFontOfSize(18);
    nameLb.textColor = WHITE_COLOR;
    nameLb.textAlignment = NSTextAlignmentCenter;
    nameLb.text = @"交易记录";
    [self.view addSubview:nameLb];
    
    //头像
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -Size(55))/2, bkgView.maxY -Size(55)/2, Size(55), Size(55))];
    headerView.image = [UIImage imageNamed:@"tradeInfoIcon_success"];
    if (_tradeModel.status == 0) {
        headerView.image = [UIImage imageNamed:@"tradeInfoIcon_fail"];
    }
    [self.view addSubview:headerView];
    
    //金额
    UILabel *sumLb = [[UILabel alloc]initWithFrame:CGRectMake(0, headerView.maxY +Size(5), kScreenWidth, Size(30))];
    sumLb.font = SystemFontOfSize(22);
    sumLb.textColor = TEXT_BLACK_COLOR;
    sumLb.textAlignment = NSTextAlignmentCenter;
    sumLb.text = [NSString stringWithFormat:@"%@ sec",_tradeModel.sum];
    //设置不同字体
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:sumLb.text];
    if ([sumLb.text containsString:@"ether"]) {
        [attStr addAttribute:NSForegroundColorAttributeName value:TEXT_DARK_COLOR range:NSMakeRange(sumLb.text.length -5, 5)];
        [attStr addAttribute:NSFontAttributeName value:SystemFontOfSize(12) range:NSMakeRange(sumLb.text.length -5, 5)];
    }else{
        [attStr addAttribute:NSForegroundColorAttributeName value:TEXT_DARK_COLOR range:NSMakeRange(sumLb.text.length -3, 3)];
        [attStr addAttribute:NSFontAttributeName value:SystemFontOfSize(12) range:NSMakeRange(sumLb.text.length -3, 3)];
    }
    sumLb.attributedText = attStr;
    [self.view addSubview:sumLb];
    if (_tradeModel.status == 0) {
        UILabel *desLb = [[UILabel alloc]initWithFrame:CGRectMake(0, sumLb.maxY, kScreenWidth, Size(15))];
        desLb.font = SystemFontOfSize(12);
        desLb.textColor = COLOR(222, 57, 57, 1);
        desLb.textAlignment = NSTextAlignmentCenter;
        desLb.text = @"交易失败";
        [self.view addSubview:desLb];
    }
    
    //横线
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(Size(20), sumLb.maxY +Size(10), kScreenWidth -Size(20 *2), Size(1))];
    line1.backgroundColor = DIVIDE_LINE_COLOR;
    [self.view addSubview:line1];
    
//    NSArray *titleArr = @[@"发款方",@"收款方",@"矿工费用",@"备注",@"交易号",@"区块",@"交易时间"];
    NSArray *titleArr = @[@"发款方",@"收款方",@"矿工费用",@"交易号",@"区块",@"交易时间"];
    NSArray *contentArr = @[_tradeModel.transferAddress,_tradeModel.gatherAddress,_tradeModel.gas,_tradeModel.tradeNum,_tradeModel.blockNum,_tradeModel.time];
    for (int i = 0; i< titleArr.count; i++) {
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(line1.minX, line1.maxY +i*Size(30 +20), kScreenWidth -line1.minX*2, Size(30))];
        titleLb.font = SystemFontOfSize(16);
        titleLb.textColor = TEXT_DARK_COLOR;
        titleLb.text = titleArr[i];
        [self.view addSubview:titleLb];
        UILabel *contentLb = [[UILabel alloc]initWithFrame:CGRectMake(titleLb.minX, titleLb.maxY, titleLb.width, Size(20))];
        contentLb.font = SystemFontOfSize(12);
        contentLb.textColor = TEXT_DARK_COLOR;
        if (i == 4) {
            contentLb.textColor = COLOR(87, 186, 116, 1);
        }
        contentLb.text = contentArr[i];
        [self.view addSubview:contentLb];
    }
    
//    if (_tradeModel.status == 1) {
//        UIButton *moreBT = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight -Size(40), kScreenWidth, Size(40))];
//        [moreBT setBackgroundImage:[UIImage imageNamed:@"checkMore"] forState:UIControlStateNormal];
//        [moreBT addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:moreBT];
//    }
}

#pragma 查看更多信息
-(void)moreAction
{
    NSURL *jumpURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MoreServerUrl,_tradeModel.tradeNum]];
    [[UIApplication sharedApplication] openURL:jumpURL];
}

@end
