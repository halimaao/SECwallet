//
//  BackupRemindViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/9.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "BackupRemindViewController.h"
#import "BackupFileBeforeViewController.h"
#import "RootViewController.h"

@interface BackupRemindViewController ()

@end

@implementation BackupRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavgationItemTitle:@"备份钱包"];
    [self setNavgationRightImage:[UIImage imageNamed:@"jump"] withAction:@selector(jumpAction)];
    [self.navigationItem.rightBarButtonItem setImage:[[UIImage imageNamed:@"jump"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
}

//进入首页
-(void)jumpAction
{
    RootViewController *controller = [[RootViewController alloc] init];
    AppDelegateInstance.window.rootViewController = controller;
    [AppDelegateInstance.window makeKeyAndVisible];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletInfoUI object:nil];
}

-(void)setupUI
{
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -Size(45))/2, Size(35), Size(45), Size(45))];
    icon.image = [UIImage imageNamed:@"backupIcon"];
    [self.view addSubview:icon];
    
    UILabel *titLb = [[UILabel alloc]initWithFrame:CGRectMake(0, icon.maxY +Size(20), kScreenWidth, Size(25))];
    titLb.font = SystemFontOfSize(18);
    titLb.textColor = TEXT_BLACK_COLOR;
    titLb.textAlignment = NSTextAlignmentCenter;
    titLb.text = @"最后一步：立即备份你的钱包！";
    [self.view addSubview:titLb];
    
    UILabel *remindLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(20), titLb.maxY +Size(20), kScreenWidth -Size(40), Size(60))];
    remindLb.font = SystemFontOfSize(16);
    remindLb.textColor = TEXT_DARK_COLOR;
    remindLb.numberOfLines = 3;
    remindLb.text = @"备份钱包：导出[助记词]并抄写到安全的地方，千万不要保存到网络上。然后尝试转入，转出小额资产开始使用。";
    //设置行间距
    NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:remindLb.text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = Size(5);
    [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
    remindLb.attributedText = msgStr;
    [self.view addSubview:remindLb];
    /*****************下一步*****************/
    UIButton *nextBT = [[UIButton alloc] initWithFrame:CGRectMake(Size(20),remindLb.maxY +Size(45), kScreenWidth - 2*Size(20), Size(45))];
    [nextBT goldBigBtnStyle:@"备份钱包"];
    [nextBT addTarget:self action:@selector(backupAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBT];
}

-(void)backupAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *pswTF = alertController.textFields.firstObject;
        if (pswTF.text.length == 0) {
            [self hudShowWithString:@"密码不能为空" delayTime:1];
            return;
        }else{
            if ([pswTF.text isEqualToString:_walletModel.loginPassword]) {
                BackupFileBeforeViewController *controller = [[BackupFileBeforeViewController alloc]init];
                controller.walletModel = _walletModel;
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:controller];
                [self presentViewController:navi animated:YES completion:nil];
            }else{
                [self hudShowWithString:@"密码不正确" delayTime:1];
                return;
            }
        }        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.secureTextEntry = YES;
    }];
    [self presentViewController:alertController animated:true completion:nil];
}

@end
