//
//  SdfadsfViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/13.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "ExportKeyStoreViewController.h"

@interface ExportKeyStoreViewController ()

@end

@implementation ExportKeyStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavgationItemTitle:@"导出KeyStore"];
    [self setupUI];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:@"请勿截图" contentText:@"请确保四周无人及无任何摄像头！勿用截图或拍照的方式保存Keystore文件或对应二维码。" imageName:@"noScreenShort" leftButtonTitle:@"知道了" rightButtonTitle:nil alertViewType:CommonAlertViewType_style2];
        [alert show];
    });    
}

-(void)setupUI
{
    //离线保存
    UILabel *tit1Lb = [[UILabel alloc]initWithFrame:CGRectMake(Size(18), Size(20), kScreenWidth -Size(18)*2, Size(20))];
    tit1Lb.font = BoldSystemFontOfSize(16);
    tit1Lb.textColor = COLOR(174, 130, 66, 1);
    tit1Lb.text = @"离线保存";
    [self.view addSubview:tit1Lb];
    UILabel *remind1Lb = [[UILabel alloc]initWithFrame:CGRectMake(tit1Lb.minX, tit1Lb.maxY, tit1Lb.width, Size(30))];
    remind1Lb.font = SystemFontOfSize(13);
    remind1Lb.textColor = TEXT_DARK_COLOR;
    remind1Lb.numberOfLines = 2;
    remind1Lb.text = @"请复制粘贴Keystore文件到安全、离线的地方保存。切勿保存至邮箱、记事本、网盘、聊天工具等，非常危险。";
    [self.view addSubview:remind1Lb];
    //请勿使用网络传输
    UILabel *tit2Lb = [[UILabel alloc]initWithFrame:CGRectMake(tit1Lb.minX, remind1Lb.maxY +Size(15), tit1Lb.width, tit1Lb.height)];
    tit2Lb.font = BoldSystemFontOfSize(16);
    tit2Lb.textColor = COLOR(174, 130, 66, 1);
    tit2Lb.text = @"请勿使用网络传输";
    [self.view addSubview:tit2Lb];
    UILabel *remind2Lb = [[UILabel alloc]initWithFrame:CGRectMake(tit1Lb.minX, tit2Lb.maxY, tit2Lb.width, Size(45))];
    remind2Lb.font = SystemFontOfSize(13);
    remind2Lb.textColor = TEXT_DARK_COLOR;
    remind2Lb.numberOfLines = 3;
    remind2Lb.text = @"请勿通过网络工具传输Keystore文件，一旦被黑客获取将造成不可挽回的资产损失。建议离线设备通过扫二维码方式传输。";
    [self.view addSubview:remind2Lb];
    //密码保险箱保存
    UILabel *tit3Lb = [[UILabel alloc]initWithFrame:CGRectMake(tit1Lb.minX, remind2Lb.maxY +Size(10), tit1Lb.width, tit1Lb.height)];
    tit3Lb.font = BoldSystemFontOfSize(16);
    tit3Lb.textColor = COLOR(174, 130, 66, 1);
    tit3Lb.text = @"密码保险箱保存";
    [self.view addSubview:tit3Lb];
    UILabel *remind3Lb = [[UILabel alloc]initWithFrame:CGRectMake(tit3Lb.minX, tit3Lb.maxY, tit3Lb.width, Size(30))];
    remind3Lb.font = SystemFontOfSize(13);
    remind3Lb.textColor = TEXT_DARK_COLOR;
    remind3Lb.numberOfLines = 2;
    remind3Lb.text = @"如需在线保存，则建议使用安全等级更高的1Password等密码保管软件保存Keystore。";
    [self.view addSubview:remind3Lb];
    
    UIView *bkgView = [[UIView alloc]initWithFrame:CGRectMake(remind3Lb.minX, remind3Lb.maxY +Size(15), remind3Lb.width, Size(160))];
    bkgView.backgroundColor = DARK_COLOR;
    bkgView.layer.cornerRadius = Size(5);
    [self.view addSubview:bkgView];
    UILabel *fileDataLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(8), Size(8), bkgView.width -Size(16), Size(160 -8*2))];
    fileDataLb.font = SystemFontOfSize(12);
    fileDataLb.textColor = TEXT_BLACK_COLOR;
    fileDataLb.numberOfLines = 20;
    fileDataLb.text = _keyStore;
    [bkgView addSubview:fileDataLb];
    
    /*****************复制*****************/
    UIButton *copyBT = [[UIButton alloc] initWithFrame:CGRectMake(bkgView.minX, bkgView.maxY +Size(30), bkgView.width, Size(45))];
    [copyBT goldBigBtnStyle:@"复制KeyStore"];
    [copyBT addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyBT];
}

-(void)copyAction
{
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = _keyStore;
    [self hudShowWithString:@"已复制" delayTime:1];
}

@end
