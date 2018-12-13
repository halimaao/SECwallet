//
//  ImportWalletViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "ImportWalletViewController.h"
#import "CommonHtmlShowViewController.h"
#import "WalletModel.h"
#import "RootViewController.h"
#import "IQKeyboardManager.h"

#define KInputTVViewHeight   Size(110)
#define KInputDesViewHeight  Size(30)
#define KInputTFViewHeight   Size(15)

@interface ImportWalletViewController ()<UITextFieldDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    UITextView *inputTV;
    //密码
    UILabel *passwordDesLb;
    UITextField *passwordTF;
    UIView *line1;
    //重复密码
    UILabel *re_passwordDesLb;
    UITextField *re_passwordTF;
    UIView *line2;
    //密码提示
    UILabel *passwordTipDesLb;
    UITextField *passwordTipTF;
    UIView *line3;
    
    UIButton *agreementBtn;
    //协议内容
    UIButton *seeProtocol;
    UIButton *importBT;
    
    UILabel *importTipLb;
    
    UILabel *placeholderLb;
    
    NSTimer *_importTimer;   //导入计时器
    int _timing; //定时
    BOOL hasImportSuccess;
}

@end

@implementation ImportWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}

-(void)initSubViews
{
    /***********************导入助记词***********************/
    inputTV = [[UITextView alloc]initWithFrame:CGRectMake(Size(20), Size(20), kScreenWidth -Size(20)*2, KInputTVViewHeight)];
    inputTV.backgroundColor = DARK_COLOR;
    inputTV.layer.cornerRadius = Size(5);
    inputTV.font = SystemFontOfSize(14);
    inputTV.textColor = TEXT_BLACK_COLOR;
    inputTV.autocapitalizationType = UITextAutocapitalizationTypeNone;
    inputTV.delegate = self;
    [self.view addSubview:inputTV];
    placeholderLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(8), Size(8), inputTV.width, Size(20))];
    placeholderLb.font = SystemFontOfSize(15);
    placeholderLb.textColor = COLOR(176, 175, 175, 1);
    placeholderLb.text = @"助记词，按空格分隔";
    [inputTV addSubview:placeholderLb];
    //密码
    passwordDesLb = [[UILabel alloc] initWithFrame:CGRectMake(inputTV.minX, inputTV.maxY +Size(10), inputTV.width, KInputDesViewHeight)];
    passwordDesLb.font = SystemFontOfSize(16);
    passwordDesLb.textColor = TEXT_DARK_COLOR;
    passwordDesLb.text = @"密码";
    [self.view addSubview:passwordDesLb];
    passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(inputTV.minX, passwordDesLb.maxY, inputTV.width, KInputTFViewHeight)];
    passwordTF.font = SystemFontOfSize(14);
    passwordTF.textColor = TEXT_BLACK_COLOR;
    passwordTF.placeholder = @"8~30位数字，英文字母以及特殊字符至少2种组合";
    passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    passwordTF.secureTextEntry = YES;
    passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:passwordTF];
    line1 = [[UIView alloc]initWithFrame:CGRectMake(passwordTF.minX, passwordTF.maxY, passwordTF.width, Size(0.5))];
    line1.backgroundColor = DIVIDE_LINE_COLOR;
    [self.view addSubview:line1];
    //重复密码
    re_passwordDesLb = [[UILabel alloc] initWithFrame:CGRectMake(inputTV.minX, line1.maxY +Size(10), inputTV.width, KInputDesViewHeight)];
    re_passwordDesLb.font = SystemFontOfSize(16);
    re_passwordDesLb.textColor = TEXT_DARK_COLOR;
    re_passwordDesLb.text = @"重复密码";
    [self.view addSubview:re_passwordDesLb];
    re_passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(passwordTF.minX, re_passwordDesLb.maxY, passwordTF.width, passwordTF.height)];
    re_passwordTF.font = SystemFontOfSize(14);
    re_passwordTF.textColor = TEXT_BLACK_COLOR;
    re_passwordTF.placeholder = @"请再次确认密码";
    re_passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    re_passwordTF.secureTextEntry = YES;
    re_passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:re_passwordTF];
    line2 = [[UIView alloc]initWithFrame:CGRectMake(re_passwordTF.minX, re_passwordTF.maxY, re_passwordTF.width, Size(0.5))];
    line2.backgroundColor = DIVIDE_LINE_COLOR;
    [self.view addSubview:line2];
    //密码提示
    passwordTipDesLb = [[UILabel alloc] initWithFrame:CGRectMake(inputTV.minX, line2.maxY +Size(10), inputTV.width, KInputDesViewHeight)];
    passwordTipDesLb.font = SystemFontOfSize(16);
    passwordTipDesLb.textColor = TEXT_DARK_COLOR;
    passwordTipDesLb.text = @"密码提示（选填）";
    [self.view addSubview:passwordTipDesLb];
    passwordTipTF = [[UITextField alloc] initWithFrame:CGRectMake(re_passwordTF.minX, passwordTipDesLb.maxY, re_passwordTF.width, re_passwordTF.height)];
    passwordTipTF.font = SystemFontOfSize(14);
    passwordTipTF.textColor = TEXT_BLACK_COLOR;
    passwordTipTF.tintColor = TEXT_GOLD_COLOR;
    passwordTipTF.delegate = self;
    [self.view addSubview:passwordTipTF];
    line3 = [[UIView alloc]initWithFrame:CGRectMake(passwordTipTF.minX, passwordTipTF.maxY, passwordTipTF.width, Size(0.5))];
    line3.backgroundColor = DIVIDE_LINE_COLOR;
    [self.view addSubview:line3];
    
    /*****************用户协议*****************/
    agreementBtn = [[UIButton alloc] initWithFrame:CGRectMake(Size(15), passwordTipTF.maxY + Size(10),kScreenWidth/2 -Size(20), Size(20))];
    [agreementBtn setTitleColor:TEXT_DARK_COLOR forState:UIControlStateNormal];
    [agreementBtn setTitle:@" 我已仔细阅读并同意" forState:UIControlStateNormal];
    agreementBtn.titleLabel.font = SystemFontOfSize(15);
    agreementBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [agreementBtn setImage:[UIImage imageNamed:@"invest_protocolun"] forState:UIControlStateNormal];
    [agreementBtn setImage:[UIImage imageNamed:@"invest_protocol"] forState:UIControlStateSelected];
    agreementBtn.selected = NO;
    [agreementBtn addTarget:self action:@selector(agreementBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreementBtn];
    //协议内容
    seeProtocol = [[UIButton alloc]initWithFrame:CGRectMake(agreementBtn.maxX, agreementBtn.minY, kScreenWidth/2, agreementBtn.height)];
    seeProtocol.titleLabel.font = SystemFontOfSize(15);
    seeProtocol.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"服务条款"];
    //设置：在某个单位长度内的内容显示成金色
    [str addAttribute:NSForegroundColorAttributeName value:COLOR(175, 136, 68, 1) range:NSMakeRange(0, 4)];
    [seeProtocol setAttributedTitle:str forState:UIControlStateNormal];
    [seeProtocol addTarget:self action:@selector(seeProtocol:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:seeProtocol];
    /*****************导入钱包*****************/
    importBT = [[UIButton alloc] initWithFrame:CGRectMake(Size(20), seeProtocol.maxY +Size(30), kScreenWidth - 2*Size(20), Size(45))];
    [importBT darkBtnStyle:@"开始导入"];
    [importBT addTarget:self action:@selector(beginImportAction) forControlEvents:UIControlEventTouchUpInside];
    importBT.userInteractionEnabled = NO;
    [self.view addSubview:importBT];
    
    //说明
    UIButton *tipBtn = [[UIButton alloc] init];
    if (_importWalletType == ImportWalletType_mnemonicPhrase) {
        [tipBtn setTitle:@"什么是助记词？" forState:UIControlStateNormal];
    }else if (_importWalletType == ImportWalletType_keyStore) {
        importTipLb = [[UILabel alloc] initWithFrame:CGRectMake(inputTV.minX, Size(15), inputTV.width, Size(40))];
        importTipLb.font = SystemFontOfSize(15);
        importTipLb.textColor = TEXT_DARK_COLOR;
        importTipLb.numberOfLines = 3;
        importTipLb.text = @"直接复制粘贴以太坊官方钱包keyStore文件内容至输入框。";
//        importTipLb.text = @"直接复制粘贴以太坊官方钱包keyStore文件内容至输入框或者通过生成keyStore内容的二维码，扫码录入。";
        //设置行间距
        NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:importTipLb.text];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = Size(5);
        [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
        importTipLb.attributedText = msgStr;
        [self.view addSubview:importTipLb];
        inputTV.frame = CGRectMake(importTipLb.minX, importTipLb.maxY +Size(10), importTipLb.width, KInputTVViewHeight);
        inputTV.backgroundColor = WHITE_COLOR;
        inputTV.layer.borderWidth = Size(1);
        inputTV.layer.borderColor = DARK_COLOR.CGColor;
        passwordDesLb.frame = CGRectMake(inputTV.minX, inputTV.maxY +Size(30), inputTV.width, KInputDesViewHeight);
        passwordDesLb.text = @"keyStore密码";
        passwordTF.frame = CGRectMake(inputTV.minX, passwordDesLb.maxY, inputTV.width, KInputTFViewHeight);
        passwordTF.placeholder = nil;
        passwordTF.secureTextEntry = YES;
        passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        line1.frame = CGRectMake(passwordTF.minX, passwordTF.maxY, passwordTF.width, Size(0.5));
        re_passwordDesLb.hidden = YES;
        re_passwordTF.hidden = YES;
        line2.hidden = YES;
        passwordTipDesLb.hidden = YES;
        passwordTipTF.hidden = YES;
        line3.hidden = YES;
        agreementBtn.frame = CGRectMake(Size(15), line1.maxY+ Size(10), kScreenWidth/2 -Size(20), Size(20));
        seeProtocol.frame = CGRectMake(agreementBtn.maxX, agreementBtn.minY, kScreenWidth/2, agreementBtn.height);
        importBT.frame = CGRectMake(Size(20), seeProtocol.maxY +Size(50), kScreenWidth - 2*Size(20), Size(45));
        
        placeholderLb.text = @"keystore文本内容";
        [tipBtn setTitle:@"什么是keystore？" forState:UIControlStateNormal];
        
    }else if (_importWalletType == ImportWalletType_privateKey) {
        inputTV.backgroundColor = WHITE_COLOR;
        inputTV.layer.borderWidth = Size(1);
        inputTV.layer.borderColor = DARK_COLOR.CGColor;
        
        placeholderLb.text = @"明文私钥";
        [tipBtn setTitle:@"什么是私钥？" forState:UIControlStateNormal];
    }
    
    tipBtn.frame = CGRectMake((kScreenWidth -Size(150))/2, importBT.maxY + Size(15), Size(150), Size(25));
    [tipBtn setTitleColor:TEXT_GOLD_COLOR forState:UIControlStateNormal];
    tipBtn.titleLabel.font = SystemFontOfSize(15);
    [tipBtn addTarget:self action:@selector(tipBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tipBtn];
}

//协议
-(void)agreementBtnAction:(UIButton *)btn
{
    [self dismissKeyboardAction];
    agreementBtn.selected = !agreementBtn.selected;
    if (!agreementBtn.selected) {
        [importBT darkBtnStyle:@"开始导入"];
        importBT.userInteractionEnabled = NO;
    }else{
        [importBT goldBigBtnStyle:@"开始导入"];
        importBT.userInteractionEnabled = YES;
    }
}
//查看协议内容
-(void)seeProtocol:(UIButton *)btn
{
    CommonHtmlShowViewController *viewController = [[CommonHtmlShowViewController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.commonHtmlShowViewType = CommonHtmlShowViewType_RgsProtocol;
    viewController.titleStr = @"商户协议";
    [self.navigationController pushViewController:viewController animated:YES];
}

//查看提示内容
-(void)tipBtnAction:(UIButton *)btn
{
    CommonHtmlShowViewController *viewController = [[CommonHtmlShowViewController alloc]init];
    viewController.titleStr = btn.titleLabel.text;
    viewController.commonHtmlShowViewType = CommonHtmlShowViewType_RgsProtocol;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 导入钱包
-(void)beginImportAction
{
    [self dismissKeyboardAction];
    if (_importWalletType == ImportWalletType_mnemonicPhrase) {
        //验证输入
        if (inputTV.text.length == 0) {
            [self hudShowWithString:@"请输入助记词" delayTime:1.5];
            return;
        }
        if (passwordTF.text.length >30 || passwordTF.text.length <8) {
            [self hudShowWithString:@"请输入8~30位密码" delayTime:1.5];
            return;
        }
        if ([NSString validatePassword:passwordTF.text] == NO) {
            [self hudShowWithString:@"请输入数字和字母组合密码" delayTime:1.5];
            return;
        }
        if (re_passwordTF.text.length == 0) {
            [self hudShowWithString:@"请输入确认密码" delayTime:1.5];
            return;
        }
        if (![passwordTF.text isEqualToString:re_passwordTF.text]) {
            [self hudShowWithString:@"两次密码输入不一致，请重新输入！" delayTime:1.5];
            return;
        }
    
        //导入助记词
        [self createLoadingView:@"导入钱包中···"];
        //添加计时器
        dispatch_async(dispatch_get_main_queue(), ^{
            _timing = 5;
            hasImportSuccess = NO;
            _importTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
        });
        [HSEther hs_inportMnemonics:inputTV.text pwd:passwordTF.text block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey, BOOL suc, HSWalletError error) {
            [self hiddenLoadingView];
            hasImportSuccess = YES;
            if (error == HSWalletErrorMnemonicsLength) {
                [self hudShowWithString:@"助记词长度不够" delayTime:1.5];
            }else if (error == HSWalletErrorMnemonicsCount) {
                [self hudShowWithString:@"助记词个数不够" delayTime:1.5];
            }else if (error == HSWalletErrorMnemonicsValidWord) {
                [self hudShowWithString:@"助记词有误" delayTime:1.5];
            }else if (error == HSWalletImportMnemonicsSuc) {
                
                /*************先获取钱包列表并将最新钱包排在第一位*************/
                NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
                NSData* data2 = [NSData dataWithContentsOfFile:path];
                NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data2];
                NSMutableArray *list = [NSMutableArray array];
                list = [unarchiver decodeObjectForKey:@"walletList"];
                [unarchiver finishDecoding];
                //判断是否已存在
                for (WalletModel *model in list) {
                    if ([inputTV.text isEqualToString:model.mnemonicPhrase]) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"钱包已存在，是否设置为新密码？（请牢记钱包新密码）" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [alertView show];
                        return;
                    }
                }
                
                //不存在就保存钱包
                [self hudShowWithString:@"助记词导入成功" delayTime:1.5];
                //随机生成用户名
                NSString *nameStr = [NSString getRandomStringWithNum:8];
                //随机生成钱包ICON
                int i = arc4random() % 6;
                NSString *iconStr = [NSString stringWithFormat:@"wallet%d",i];
                /*************默认钱包信息*************/
                NSArray *privateKeyArr = [privateKey componentsSeparatedByString:@"x"];
                WalletModel *model = [[WalletModel alloc]initWithWalletName:nameStr andWalletPassword:passwordTF.text andLoginPassword:passwordTF.text andPasswordTip:passwordTipTF.text andAddress:address andMnemonicPhrase:mnemonicPhrase andPrivateKey:privateKeyArr.lastObject andKeyStore:keyStore andBalance:@"0" andBalance_CNY:@"0" andWalletIcon:iconStr andTokenCoinList:@[@"SEC"] andIsBackUpMnemonic:1 andIsFromMnemonicImport:1];
                NSMutableData* data = [NSMutableData data];
                NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                if (list.count > 0) {
                    [list insertObject:model atIndex:list.count];
                    [archiver encodeObject:list forKey:@"walletList"];
                    [archiver finishEncoding];
                    [data writeToFile:path atomically:YES];
                    [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:[NSString stringWithFormat:@"%ld",list.count-1]];
                }else{
                    NSMutableArray *list1 = [NSMutableArray array];
                    [list1 insertObject:model atIndex:0];
                    [archiver encodeObject:list1 forKey:@"walletList"];
                    [archiver finishEncoding];
                    [data writeToFile:path atomically:YES];
                    [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:@"0"];
                }
                
                [self backToHomeAction];
            }
        }];
        
    }else if (_importWalletType == ImportWalletType_keyStore) {
        importTipLb = [[UILabel alloc] initWithFrame:CGRectMake(inputTV.minX, Size(15), inputTV.width, Size(40))];
        importTipLb.font = SystemFontOfSize(15);
        importTipLb.textColor = TEXT_DARK_COLOR;
        importTipLb.numberOfLines = 3;
        importTipLb.text = @"直接复制粘贴以太坊官方钱包keyStore文件内容至输入框。";
        //        importTipLb.text = @"直接复制粘贴以太坊官方钱包keyStore文件内容至输入框或者通过生成keyStore内容的二维码，扫码录入。";
        //设置行间距
        NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:importTipLb.text];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = Size(5);
        [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
        importTipLb.attributedText = msgStr;
        [self.view addSubview:importTipLb];
        inputTV.frame = CGRectMake(importTipLb.minX, importTipLb.maxY +Size(10), importTipLb.width, KInputTVViewHeight);
        inputTV.backgroundColor = WHITE_COLOR;
        inputTV.layer.borderWidth = Size(1);
        inputTV.layer.borderColor = DARK_COLOR.CGColor;
        passwordDesLb.frame = CGRectMake(inputTV.minX, inputTV.maxY +Size(30), inputTV.width, KInputDesViewHeight);
        passwordDesLb.text = @"keyStore密码";
        passwordTF.frame = CGRectMake(inputTV.minX, passwordDesLb.maxY, inputTV.width, KInputTFViewHeight);
        passwordTF.placeholder = nil;
        line1.frame = CGRectMake(passwordTF.minX, passwordTF.maxY, passwordTF.width, Size(0.5));
        re_passwordDesLb.hidden = YES;
        re_passwordTF.hidden = YES;
        line2.hidden = YES;
        passwordTipDesLb.hidden = YES;
        passwordTipTF.hidden = YES;
        line3.hidden = YES;
        agreementBtn.frame = CGRectMake(Size(15), line1.maxY+ Size(10), kScreenWidth/2, Size(20));
        seeProtocol.frame = CGRectMake(agreementBtn.maxX, agreementBtn.minY, kScreenWidth/2, agreementBtn.height);
        importBT.frame = CGRectMake(Size(20), seeProtocol.maxY +Size(50), kScreenWidth - 2*Size(20), Size(45));
        
        //验证输入
        if (inputTV.text.length == 0) {
            [self hudShowWithString:@"请输入KeyStore" delayTime:1.5];
            return;
        }
        if (passwordTF.text.length >30 || passwordTF.text.length <8) {
            [self hudShowWithString:@"请输入8~30位密码" delayTime:1.5];
            return;
        }
        if ([NSString validatePassword:passwordTF.text] == NO) {
            [self hudShowWithString:@"请输入数字和字母组合密码" delayTime:1.5];
            return;
        }
        //导入KeyStore
        [self createLoadingView:@"导入钱包中···"];
        //添加计时器
        dispatch_async(dispatch_get_main_queue(), ^{
            _timing = 5;
            hasImportSuccess = NO;
            _importTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
        });
        [HSEther hs_importKeyStore:inputTV.text pwd:passwordTF.text block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey, BOOL suc, HSWalletError error) {
            [self hiddenLoadingView];
            hasImportSuccess = YES;
            if (error == HSWalletErrorKeyStoreLength) {
                [self hudShowWithString:@"KeyStore长度不够" delayTime:1.5];
            }else if (error == HSWalletErrorKeyStoreValid) {
                [self hudShowWithString:@"密码不正确" delayTime:1.5];
            }else if (error == HSWalletImportKeyStoreSuc) {
                
                /*************先获取钱包列表并将最新钱包排在第一位*************/
                NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
                NSData* data2 = [NSData dataWithContentsOfFile:path];
                NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data2];
                NSMutableArray *list = [NSMutableArray array];
                list = [unarchiver decodeObjectForKey:@"walletList"];
                [unarchiver finishDecoding];
                //判断是否已存在
                for (WalletModel *model in list) {
                    if ([inputTV.text isEqualToString:model.keyStore]) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"钱包已存在，是否设置为新密码？（请牢记钱包新密码）" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [alertView show];
                        return;
                    }
                }
                
                //不存在就保存钱包
                [self hudShowWithString:@"KeyStore导入成功" delayTime:1.5];
                //随机生成用户名
                NSString *nameStr = [NSString getRandomStringWithNum:8];
                //随机生成钱包ICON
                int i = arc4random() % 6;
                NSString *iconStr = [NSString stringWithFormat:@"wallet%d",i];
                /*************默认钱包信息*************/
                NSArray *privateKeyArr = [privateKey componentsSeparatedByString:@"x"];
                WalletModel *model = [[WalletModel alloc]initWithWalletName:nameStr andWalletPassword:passwordTF.text andLoginPassword:passwordTF.text andPasswordTip:passwordTipTF.text andAddress:address andMnemonicPhrase:mnemonicPhrase andPrivateKey:privateKeyArr.lastObject andKeyStore:keyStore andBalance:@"0" andBalance_CNY:@"0" andWalletIcon:iconStr andTokenCoinList:@[@"SEC"] andIsBackUpMnemonic:1 andIsFromMnemonicImport:0];
                NSMutableData* data = [NSMutableData data];
                NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                if (list.count > 0) {
                    [list insertObject:model atIndex:list.count];
                    [archiver encodeObject:list forKey:@"walletList"];
                    [archiver finishEncoding];
                    [data writeToFile:path atomically:YES];
                    [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:[NSString stringWithFormat:@"%ld",list.count-1]];
                }else{
                    NSMutableArray *list1 = [NSMutableArray array];
                    [list1 insertObject:model atIndex:0];
                    [archiver encodeObject:list1 forKey:@"walletList"];
                    [archiver finishEncoding];
                    [data writeToFile:path atomically:YES];
                    [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:@"0"];
                }
                
                [self backToHomeAction];
            }
        }];
        
    }else if (_importWalletType == ImportWalletType_privateKey) {
        inputTV.backgroundColor = WHITE_COLOR;
        inputTV.layer.borderWidth = Size(1);
        inputTV.layer.borderColor = DARK_COLOR.CGColor;
        
        //验证输入
        if (inputTV.text.length == 0) {
            [self hudShowWithString:@"请输入私钥" delayTime:1.5];
            return;
        }
        if (inputTV.text.length != 64) {
            [self hudShowWithString:@"请输入正确的私钥" delayTime:1.5];
            return;
        }
        if (passwordTF.text.length >30 || passwordTF.text.length <8) {
            [self hudShowWithString:@"请输入8~30位密码" delayTime:1.5];
            return;
        }
        if ([NSString validatePassword:passwordTF.text] == NO) {
            [self hudShowWithString:@"请输入数字和字母组合密码" delayTime:1.5];
            return;
        }
        if (re_passwordTF.text.length == 0) {
            [self hudShowWithString:@"请输入确认密码" delayTime:1.5];
            return;
        }
        if (![passwordTF.text isEqualToString:re_passwordTF.text]) {
            [self hudShowWithString:@"两次密码输入不一致，请重新输入！" delayTime:1.5];
            return;
        }
        //导入私钥
        [self createLoadingView:@"导入钱包中···"];
        //添加计时器
        dispatch_async(dispatch_get_main_queue(), ^{
            _timing = 5;
            hasImportSuccess = NO;
            _importTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
        });
        [HSEther hs_importWalletForPrivateKey:inputTV.text pwd:passwordTF.text block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey, BOOL suc, HSWalletError error) {
            [self hiddenLoadingView];
            hasImportSuccess = YES;
            if (error == HSWalletErrorPrivateKeyLength) {
                [self hudShowWithString:@"私钥长度不够" delayTime:1.5];
            }else if (error == HSWalletImportPrivateKeySuc) {
                
                /*************先获取钱包列表并将最新钱包排在第一位*************/
                NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
                NSData* data2 = [NSData dataWithContentsOfFile:path];
                NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data2];
                NSMutableArray *list = [NSMutableArray array];
                list = [unarchiver decodeObjectForKey:@"walletList"];
                [unarchiver finishDecoding];
                //判断是否已存在
                for (WalletModel *model in list) {
                    if ([inputTV.text isEqualToString:model.privateKey]) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"钱包已存在，是否设置为新密码？（请牢记钱包新密码）" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [alertView show];
                        return;
                    }
                }
                
                //不存在就保存钱包
                [self hudShowWithString:@"私钥导入成功" delayTime:1.5];
                //随机生成用户名
                NSString *nameStr = [NSString getRandomStringWithNum:8];
                //随机生成钱包ICON
                int i = arc4random() % 6;
                NSString *iconStr = [NSString stringWithFormat:@"wallet%d",i];
                /*************默认钱包信息*************/
                NSArray *privateKeyArr = [privateKey componentsSeparatedByString:@"x"];
                WalletModel *model = [[WalletModel alloc]initWithWalletName:nameStr andWalletPassword:passwordTF.text andLoginPassword:passwordTF.text andPasswordTip:passwordTipTF.text andAddress:address andMnemonicPhrase:mnemonicPhrase andPrivateKey:privateKeyArr.lastObject andKeyStore:keyStore andBalance:@"0" andBalance_CNY:@"0" andWalletIcon:iconStr andTokenCoinList:@[@"SEC"] andIsBackUpMnemonic:1 andIsFromMnemonicImport:0];
                NSMutableData* data = [NSMutableData data];
                NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                if (list.count > 0) {
                    [list insertObject:model atIndex:list.count];
                    [archiver encodeObject:list forKey:@"walletList"];
                    [archiver finishEncoding];
                    [data writeToFile:path atomically:YES];
                    [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:[NSString stringWithFormat:@"%ld",list.count-1]];
                }else{
                    NSMutableArray *list1 = [NSMutableArray array];
                    [list1 insertObject:model atIndex:0];
                    [archiver encodeObject:list1 forKey:@"walletList"];
                    [archiver finishEncoding];
                    [data writeToFile:path atomically:YES];
                    [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:@"0"];
                }
                
                [self backToHomeAction];
            }
        }];
    }
}

- (void)countdown
{
    if (_timing != 0) {
        _timing --;
    }else{
        //倒计时结束
        [self hiddenLoadingView];
        if (hasImportSuccess == NO) {
            [self hudShowWithString:@"导入失败，请重新输入" delayTime:2];
        }
        _importTimer = nil;
        [_importTimer invalidate];
        [_importTimer setFireDate:[NSDate distantFuture]];
        hasImportSuccess = YES;
    }
}

#pragma 导入成功进入首页
-(void)backToHomeAction
{
    //进入首页
    RootViewController *controller = [[RootViewController alloc] init];
    AppDelegateInstance.window.rootViewController = controller;
    [AppDelegateInstance.window makeKeyAndVisible];
    /*************导入钱包成功后删除之前代币数据缓存*************/
    [CacheUtil clearTokenCoinTradeListCacheFile];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletInfoUI object:nil];
}

#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == passwordTipTF) {
        //限制输入12位
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        if (passwordTipTF.text.length >= 12) {
            passwordTipTF.text = [textField.text substringToIndex:12];
            return NO;
        }
    }
    return YES;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        /***********更新当前钱包密码***********/
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
        NSData* datapath = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
        NSMutableArray *list = [NSMutableArray array];
        list = [unarchiver decodeObjectForKey:@"walletList"];
        [unarchiver finishDecoding];
        for (int i = 0; i< list.count; i++) {
            WalletModel *model = list[i];
            if ([inputTV.text isEqualToString:model.mnemonicPhrase]) {
                [model setLoginPassword:passwordTF.text];
                [list replaceObjectAtIndex:i withObject:model];
            }
        }
        //替换list中当前钱包信息
        NSMutableData* data = [NSMutableData data];
        NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:list forKey:@"walletList"];
        [archiver finishEncoding];
        [data writeToFile:path atomically:YES];
        
        [self backAction];
    }
}

#pragma UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    placeholderLb.hidden = YES;
    [IQKeyboardManager sharedManager].shouldFixTextViewClip = NO;
    [IQKeyboardManager sharedManager].canAdjustTextView = NO;
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > 0) {
        placeholderLb.hidden = YES;
    }else{
        placeholderLb.hidden = NO;
    }    
}

#pragma mark - 点击空白处收回键盘
-(void)dismissKeyboardAction
{
    [inputTV resignFirstResponder];
    [passwordTF resignFirstResponder];
    [re_passwordTF resignFirstResponder];
    [passwordTipTF resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //移除定时器
    [_importTimer setFireDate:[NSDate distantFuture]];
    _importTimer = nil;
    [_importTimer invalidate];
    [super viewDidDisappear:animated];
}

@end
