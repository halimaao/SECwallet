//
//  CreatStoreViewController.m
//  CEC_wallet
//
//  Created by Laughing on 2017/9/6.
//  Copyright © 2017年 AnrenLionel. All rights reserved.
//

#import "CreatWalletViewController.h"
#import "RootViewController.h"
#import "BackupRemindViewController.h"
#import "ImportWalletManageViewController.h"
#import "CommonHtmlShowViewController.h"
#import "WalletModel.h"

#define kTableCellHeight Size(60)

@interface CreatWalletViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *walletNameTF;     //钱包名称
    UITextField *passwordTF;       //密码
    UITextField *re_passwordTF;   //重复密码
    UITextField *passwordDesTF;   //密码提示
    UIButton *agreementBtn;  //用户协议
    
    UIButton *creatBT;
    WalletModel *tempModel;
    
    NSMutableArray *walletList;
}

@property (nonatomic, strong) UITableView *infoTableView;

@end

@implementation CreatWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavgationItemTitle:@"创建钱包"];
    
    /*************获取钱包列表*************/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    walletList = [NSMutableArray array];
    walletList = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    
    [self addInfoTableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboardAction)];
    [self.view addGestureRecognizer:tap];
        
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isNoBack == YES) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)addInfoTableView
{
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-KNaviHeight +Size(15)) style:UITableViewStyleGrouped];
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.backgroundColor = WHITE_COLOR;
    _infoTableView.scrollEnabled = NO;
    _infoTableView.tableFooterView = [self addTableFooterView];
    [self.view addSubview:_infoTableView];
}

#pragma mark - addTableFooterView
- (UIView *)addTableFooterView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Size(180))];
    /*****************用户协议*****************/
    agreementBtn = [[UIButton alloc] initWithFrame:CGRectMake(Size(10), Size(10),kScreenWidth/2 -Size(20), Size(20))];
    [agreementBtn setTitleColor:TEXT_DARK_COLOR forState:UIControlStateNormal];
    [agreementBtn setTitle:@" 我已仔细阅读并同意" forState:UIControlStateNormal];
    agreementBtn.titleLabel.font = SystemFontOfSize(15);
    agreementBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [agreementBtn setImage:[UIImage imageNamed:@"invest_protocolun"] forState:UIControlStateNormal];
    [agreementBtn setImage:[UIImage imageNamed:@"invest_protocol"] forState:UIControlStateSelected];
    agreementBtn.selected = NO;
    [agreementBtn addTarget:self action:@selector(agreementBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:agreementBtn];
    
    //协议内容
    UIButton *seeProtocol = [[UIButton alloc]initWithFrame:CGRectMake(agreementBtn.maxX, agreementBtn.minY, kScreenWidth/2, CGRectGetHeight(agreementBtn.frame))];
    seeProtocol.titleLabel.font = SystemFontOfSize(15);
    seeProtocol.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"服务条款"];
    //设置：在某个单位长度内的内容显示成蓝色
    [str addAttribute:NSForegroundColorAttributeName value:TEXT_GOLD_COLOR range:NSMakeRange(0, 4)];
    [seeProtocol setAttributedTitle:str forState:UIControlStateNormal];
    [seeProtocol addTarget:self action:@selector(seeProtocol:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:seeProtocol];
    /*****************创建钱包*****************/
    CGFloat padddingLeft = Size(20);
    creatBT = [[UIButton alloc] initWithFrame:CGRectMake(padddingLeft, seeProtocol.maxY +Size(40), kScreenWidth - 2*padddingLeft, Size(45))];
    [creatBT darkBtnStyle:@"创建钱包"];
    [creatBT addTarget:self action:@selector(creatAction) forControlEvents:UIControlEventTouchUpInside];
    creatBT.userInteractionEnabled = NO;
    [footView addSubview:creatBT];
    
    /*****************导入钱包*****************/
    UIButton *importBT = [[UIButton alloc] initWithFrame:CGRectMake(creatBT.minX, creatBT.maxY +Size(20), creatBT.width, creatBT.height)];
    [importBT setTitleColor:COLOR(213, 174, 121, 1) forState:UIControlStateNormal];
    importBT.titleLabel.font = SystemFontOfSize(16);
    [importBT setTitle:@"导入钱包" forState:UIControlStateNormal];
    [importBT addTarget:self action:@selector(importAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:importBT];
    
    return footView;
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Size(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return Size(0.1);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *header = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Size(50))];
    header.image = [UIImage imageNamed:@"creatWalletHeaderView"];
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //每个单元格的视图
    static NSString *itemCell = @"cell_item";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat toX = Size(15);
    if (indexPath.row == 0) {
        //钱包名称
        UILabel *desLb = [[UILabel alloc]initWithFrame:CGRectMake(toX, Size(5), Size(150), Size(30))];
        desLb.font = SystemFontOfSize(16);
        desLb.textColor = TEXT_DARK_COLOR;
        desLb.text = @"钱包名称";
        [cell.contentView addSubview:desLb];
        walletNameTF = [[UITextField alloc] initWithFrame:CGRectMake(desLb.minX, desLb.maxY, kScreenWidth -toX, Size(25))];
        walletNameTF.font = SystemFontOfSize(16);
        walletNameTF.textColor = TEXT_BLACK_COLOR;
        walletNameTF.delegate = self;
        [walletNameTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        //默认
        if (walletList.count +1>=10) {
            walletNameTF.text = [NSString stringWithFormat:@"wallet%lu",(unsigned long)walletList.count+1];
        }else{
            walletNameTF.text = [NSString stringWithFormat:@"wallet0%lu",(unsigned long)walletList.count+1];
        }
        [cell.contentView addSubview:walletNameTF];
        
    }else if (indexPath.row == 1) {
        //密码
        UILabel *desLb = [[UILabel alloc]initWithFrame:CGRectMake(toX, Size(5), Size(150), Size(30))];
        desLb.font = SystemFontOfSize(16);
        desLb.textColor = TEXT_DARK_COLOR;
        desLb.text = @"密码";
        [cell.contentView addSubview:desLb];
        passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(desLb.minX, desLb.maxY, kScreenWidth -toX, Size(25))];
        passwordTF.font = SystemFontOfSize(14);
        passwordTF.textColor = TEXT_BLACK_COLOR;
        passwordTF.placeholder = @"8~30位字符必须包含数字，英文字母以及特殊字符至少2种";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:passwordTF.placeholder];
        [placeholder addAttribute:NSFontAttributeName value:SystemFontOfSize(12) range:NSMakeRange(0, passwordTF.placeholder.length)];
        passwordTF.attributedPlaceholder = placeholder;
        passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
        passwordTF.secureTextEntry = YES;
        passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [cell.contentView addSubview:passwordTF];
        
    }else if (indexPath.row == 2) {
        //重复密码
        UILabel *desLb = [[UILabel alloc]initWithFrame:CGRectMake(toX, Size(5), Size(150), Size(30))];
        desLb.font = SystemFontOfSize(16);
        desLb.textColor = TEXT_DARK_COLOR;
        desLb.text = @"重复密码";
        [cell.contentView addSubview:desLb];
        re_passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(desLb.minX, desLb.maxY, kScreenWidth -toX, Size(25))];
        re_passwordTF.font = SystemFontOfSize(14);
        re_passwordTF.textColor = TEXT_BLACK_COLOR;
        re_passwordTF.placeholder = @"请再次确认密码";
        re_passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
        re_passwordTF.secureTextEntry = YES;
        re_passwordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        [cell.contentView addSubview:re_passwordTF];
        
    }else if (indexPath.row == 3) {
        //密码提示
        UILabel *desLb = [[UILabel alloc]initWithFrame:CGRectMake(toX, Size(5), Size(150), Size(30))];
        desLb.font = SystemFontOfSize(16);
        desLb.textColor = TEXT_DARK_COLOR;
        desLb.text = @"密码提示（选填）";
        [cell.contentView addSubview:desLb];
        passwordDesTF = [[UITextField alloc] initWithFrame:CGRectMake(desLb.minX, desLb.maxY, kScreenWidth -toX, Size(25))];
        passwordDesTF.font = SystemFontOfSize(14);
        passwordDesTF.textColor = TEXT_BLACK_COLOR;
        passwordDesTF.delegate = self;
        [cell.contentView addSubview:passwordDesTF];
    }
    return cell;
}

#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == walletNameTF || textField == passwordDesTF) {
        //限制输入12位
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        if (walletNameTF.text.length >= 12) {
            walletNameTF.text = [textField.text substringToIndex:12];
            return NO;
        }
        if (passwordDesTF.text.length >= 12) {
            passwordDesTF.text = [textField.text substringToIndex:12];
            return NO;
        }
    }
    return YES;
}
//协议
-(void)agreementBtnAction:(UIButton *)btn
{
    agreementBtn.selected = !agreementBtn.selected;
    if (!agreementBtn.selected) {
        [creatBT darkBtnStyle:@"创建钱包"];
        creatBT.userInteractionEnabled = NO;
    }else{
        [creatBT goldBigBtnStyle:@"创建钱包"];
        creatBT.userInteractionEnabled = YES;
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

#pragma mark 创建钱包 
-(void)creatAction
{
    [self dismissKeyboardAction];
    if (walletNameTF.text.length == 0) {
        [self hudShowWithString:@"请输入钱包名称" delayTime:1.5];
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
    if (!agreementBtn.selected) {
        [self hudShowWithString:@"请先阅读并同意服务条款" delayTime:1.5];
        return;
    }

    //判断钱包名是否有重复
    for (WalletModel *model in walletList) {
        if ([walletNameTF.text isEqualToString:model.walletName]) {
            [self hudShowWithString:@"钱包名已存在" delayTime:1.5];
            return;
        }
    }
    
    [self requestCreatWalletBy:passwordTF.text];
}

#pragma 创建钱包
-(void)requestCreatWalletBy:(NSString *)password
{
    //创建钱包 等5秒钟，创建比较慢
    [self createLoadingView:@"创建钱包中···"];
    [HSEther hs_createWithPwd:passwordTF.text block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey) {
        [self hiddenLoadingView];
        /*************默认钱包信息*************/
        address = @"0xa2ff742445303c6faced63922f2cde818f62e840";
        //随机生成钱包ICON
        int i = arc4random() % 6;
        NSString *iconStr = [NSString stringWithFormat:@"wallet%d",i];
        tempModel = [[WalletModel alloc]initWithWalletName:walletNameTF.text andWalletPassword:passwordTF.text andLoginPassword:passwordTF.text andPasswordTip:passwordDesTF.text andAddress:address andMnemonicPhrase:mnemonicPhrase andPrivateKey:privateKey andKeyStore:keyStore andBalance:@"0" andBalance_CNY:@"0" andWalletIcon:iconStr andTokenCoinList:@[@"SEC"] andIsBackUpMnemonic:0 andIsFromMnemonicImport:0];
        
        /*************先获取钱包列表将最新钱包排在末尾并设置为默认钱包*************/
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
        NSData* data2 = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data2];
        NSMutableArray *list = [NSMutableArray array];
        list = [unarchiver decodeObjectForKey:@"walletList"];
        [unarchiver finishDecoding];
        NSMutableData* data = [NSMutableData data];
        NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        if (list.count > 0) {
            [list insertObject:tempModel atIndex:list.count];
            [archiver encodeObject:list forKey:@"walletList"];
            [archiver finishEncoding];
            [data writeToFile:path atomically:YES];
            [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:[NSString stringWithFormat:@"%ld",list.count-1]];
        }else{
            NSMutableArray *list1 = [NSMutableArray array];
            [list1 insertObject:tempModel atIndex:0];
            [archiver encodeObject:list1 forKey:@"walletList"];
            [archiver finishEncoding];
            [data writeToFile:path atomically:YES];
            [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:@"0"];
        }
        
        
        BackupRemindViewController *controller = [[BackupRemindViewController alloc]init];
        controller.walletModel = tempModel;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:controller];
        [self presentViewController:navi animated:YES completion:nil];
        
    }];
}

#pragma mark 导入钱包
-(void)importAction
{
    ImportWalletManageViewController *viewController = [[ImportWalletManageViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - 点击空白处收回键盘
-(void)dismissKeyboardAction
{
    [walletNameTF resignFirstResponder];
    [passwordTF resignFirstResponder];
    [re_passwordTF resignFirstResponder];

}

@end
