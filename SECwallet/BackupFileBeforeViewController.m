//
//  BackupFileBeforeViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/8.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "BackupFileBeforeViewController.h"
#import "BackupFileViewController.h"
#import "WalletModel.h"

@interface BackupFileBeforeViewController ()

@end

@implementation BackupFileBeforeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavgationItemTitle:@"备份助记词"];
    
    [self setupUI];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:@"请勿截图" contentText:@"如果有人获取你的助记词将直接获取你的资产！请抄下助记词并放在安全的地方。" imageName:@"noScreenShort" leftButtonTitle:@"知道了" rightButtonTitle:nil alertViewType:CommonAlertViewType_style2];
        [alert show];
    });
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationItem.leftBarButtonItem = nil;
//}

-(void)setupUI
{
    UILabel *titLb = [[UILabel alloc]initWithFrame:CGRectMake(0, Size(30), kScreenWidth, Size(25))];
    titLb.font = BoldSystemFontOfSize(18);
    titLb.textColor = TEXT_GOLD_COLOR;
    titLb.textAlignment = NSTextAlignmentCenter;
    titLb.text = @"抄写下你的钱包助记词";
    [self.view addSubview:titLb];
    
    UILabel *remindLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(20), titLb.maxY +Size(15), kScreenWidth -Size(20)*2, Size(60))];
    remindLb.font = SystemFontOfSize(15.5);
    remindLb.textColor = TEXT_DARK_COLOR;
    remindLb.numberOfLines = 3;
    remindLb.text = @"助记词用于恢复钱包或重置钱包密码，将它准确的抄写到纸上，并存放在的只有你知道的安全的地方。";
    //设置行间距
    NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:remindLb.text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = Size(5);
    [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
    remindLb.attributedText = msgStr;
    [self.view addSubview:remindLb];
    
    UIView *bkgView = [[UIView alloc]initWithFrame:CGRectMake(remindLb.minX, remindLb.maxY +Size(25), remindLb.width, Size(100))];
    bkgView.backgroundColor = DARK_COLOR;
    bkgView.layer.cornerRadius = Size(5);
    [self.view addSubview:bkgView];
    UILabel *fileDataLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(8), Size(8), bkgView.width -Size(16), Size(80))];
    fileDataLb.font = SystemFontOfSize(18);
    fileDataLb.textColor = TEXT_BLACK_COLOR;
    fileDataLb.numberOfLines = 3;
    fileDataLb.text = _walletModel.mnemonicPhrase;
    [bkgView addSubview:fileDataLb];
    
    /*****************下一步*****************/
    UIButton *nextBT = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth -Size(155))/2, bkgView.maxY +Size(40), Size(155), Size(45))];
    [nextBT goldBigBtnStyle:@"下一步"];
    [nextBT addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBT];
}

-(void)nextAction
{
    BackupFileViewController *controller = [[BackupFileViewController alloc]init];
    controller.walletModel = _walletModel;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
