//
//  AddressCodePayViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "AddressCodePayViewController.h"

#define kHeaderHeight    Size(105) +KStatusBarHeight

@interface AddressCodePayViewController ()<UITextFieldDelegate>
{
    //支付码
    UIImageView *payCode;
    //金额
    UITextField *sumTF;
}
@end

@implementation AddressCodePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboardAction)];
    [self.view addGestureRecognizer:tap];
    
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
    nameLb.text = @"收款码";
    [self.view addSubview:nameLb];
    
    //头像
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -Size(65))/2, bkgView.maxY -Size(65)/2, Size(65), Size(65))];
    headerView.image = [UIImage imageNamed:_walletModel.walletIcon];
    [self.view addSubview:headerView];
    //地址
    UILabel *addressLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(55), bkgView.maxY +Size(30), kScreenWidth -Size(55)*2, Size(30))];
    addressLb.font = SystemFontOfSize(13);
    addressLb.textColor = TEXT_DARK_COLOR;
    addressLb.numberOfLines = 2;
    addressLb.text = _walletModel.address;
    [self.view addSubview:addressLb];
    //金额
    sumTF = [[UITextField alloc]initWithFrame:CGRectMake(addressLb.minX, addressLb.maxY +Size(20), addressLb.width, Size(20))];
    sumTF.font = SystemFontOfSize(12);
    sumTF.textColor = TEXT_BLACK_COLOR;
    sumTF.keyboardType = UIKeyboardTypeNumberPad;
    sumTF.delegate = self;
    sumTF.text = @"0";
    [self.view addSubview:sumTF];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(sumTF.minX, sumTF.maxY, sumTF.width, Size(0.5))];
    line.backgroundColor = DIVIDE_LINE_COLOR;
    [self.view addSubview:line];
    //支付码
    payCode = [[UIImageView alloc]initWithFrame:CGRectMake(addressLb.minX, line.maxY +Size(20), addressLb.width, addressLb.width)];
    payCode.image = [NSString twoDimensionCodeWithUrl:[NSString stringWithFormat:@"%@###%@",_walletModel.address,sumTF.text]];
    [self.view addSubview:payCode];
    //复制收款地址
    UIButton *copyBT = [[UIButton alloc] initWithFrame:CGRectMake(payCode.minX, payCode.maxY +Size(20), payCode.width, Size(45))];
    [copyBT goldBigBtnStyle:@"复制收款地址"];
    [copyBT addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyBT];
    
}

#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    sumTF.text = nil;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField.text floatValue] <= [_walletModel.balance floatValue]) {
        //更新收款地址二维码
        payCode.image = [NSString twoDimensionCodeWithUrl:[NSString stringWithFormat:@"%@###%@",_walletModel.address,sumTF.text]];
    }else{
        [self hudShowWithString:@"超过最大余额，请重新输入" delayTime:2];
        textField.text = nil;
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma 复制收款地址
-(void)copyAction
{
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = _walletModel.address;
    [self hudShowWithString:@"已复制" delayTime:1];
}

#pragma mark - 点击空白处收回键盘
-(void)dismissKeyboardAction
{
    [sumTF resignFirstResponder];
}

@end
