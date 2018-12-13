//
//  WalletDetailViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "WalletDetailViewController.h"
#import "ChangePasswordViewController.h"
#import "ExportKeyStoreViewController.h"
#import "AddressCodePayViewController.h"
#import "BackupFileBeforeViewController.h"

#define kHeaderHeight    Size(160) +KStatusBarHeight
#define kTableCellHeight Size(55)

@interface WalletDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *walletNameTF;     //钱包名称
    UITextField *passwordDesTF;   //密码提示
    UIButton *secretBtn;  //加密按钮
}

@property (nonatomic, strong) UITableView *infoTableView;

@end

@implementation WalletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addInfoTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**************导航栏布局***************/
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    /*************获取钱包信息*************/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSMutableArray *dataArrays = [NSMutableArray array];
    dataArrays = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    for (WalletModel *model in dataArrays) {
        if ([model.walletName isEqualToString:_walletModel.walletName]) {
            _walletModel = model;
        }
    }
    [_infoTableView reloadData];
    
}

- (void)addInfoTableView
{
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -KStatusBarHeight, kScreenWidth, kScreenHeight+KStatusBarHeight) style:UITableViewStyleGrouped];
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.backgroundColor = WHITE_COLOR;
    _infoTableView.tableFooterView = [self addTableFooterView];
    [self.view addSubview:_infoTableView];
    
}

#pragma mark - addTableFooterView
- (UIView *)addTableFooterView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Size(150))];
    /*****************删除钱包*****************/
    CGFloat padddingLeft = Size(20);
    //备份按钮
    if ((_walletModel.isBackUpMnemonic == NO && _walletModel.mnemonicPhrase.length > 0) || _walletModel.isFromMnemonicImport == YES) {
        UIButton *backupBT = [[UIButton alloc]initWithFrame:CGRectMake(padddingLeft, Size(20), kScreenWidth - 2*padddingLeft, Size(45))];
        [backupBT goldBigBtnStyle:@"备份助记词"];
        [backupBT addTarget:self action:@selector(backupAction) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:backupBT];
        
        UIButton *deleteBT = [[UIButton alloc] initWithFrame:CGRectMake(backupBT.minX, backupBT.maxY +Size(10), backupBT.width, backupBT.height)];
        [deleteBT darkBtnStyle:@"删除钱包"];
        [deleteBT addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:deleteBT];
    }else{
        UIButton *deleteBT = [[UIButton alloc] initWithFrame:CGRectMake(padddingLeft, Size(40), kScreenWidth - 2*padddingLeft, Size(45))];
        [deleteBT goldBigBtnStyle:@"删除钱包"];
        [deleteBT addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:deleteBT];
    }
    
    return footView;
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _walletModel.passwordTip.length >0 ? 4 : 3;
    }else{
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 0 ? Size(5) : Size(0.1);
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = DARK_COLOR;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return kHeaderHeight;
    }else if (indexPath.section == 1) {
        return kTableCellHeight -Size(8);
    }else{
        return kTableCellHeight;
    }
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
    cell.textLabel.font = SystemFontOfSize(16);
    cell.textLabel.textColor = COLOR(101, 101, 101, 1);
    if ((indexPath.section == 0 && indexPath.row ==2) ||(indexPath.section == 1)) {
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"accessory_right"]];
    }
    
    CGFloat toX = Size(15);
    if (indexPath.section == 0 && indexPath.row == 0) {
        //头部视图
        UIImageView *bkgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight)];
        bkgView.image = [UIImage imageNamed:@"homeHeaderbkg"];
        [cell.contentView addSubview:bkgView];
        //返回按钮
        UIImageView *backIV = [[UIImageView alloc]initWithFrame:CGRectMake(Size(15), Size(10)+KStatusBarHeight, Size(16), Size(16))];
        backIV.image = [UIImage imageNamed:@"backIcon"];
        [cell.contentView addSubview:backIV];
        UIButton *backBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(10), KStatusBarHeight, Size(30), Size(35))];
        [backBT addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:backBT];
        //保存按钮
        UIButton *saveBT = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth -Size(45 +15), backIV.minY, Size(45), Size(20))];
        saveBT.titleLabel.font = SystemFontOfSize(18);
        [saveBT setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        [saveBT setTitle:@"保存" forState:UIControlStateNormal];
        [saveBT addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:saveBT];
        //名称
        UILabel *nameLb = [[UILabel alloc]initWithFrame:CGRectMake(0, backIV.minY, kScreenWidth, Size(20))];
        nameLb.font = BoldSystemFontOfSize(20);
        nameLb.textColor = WHITE_COLOR;
        nameLb.textAlignment = NSTextAlignmentCenter;
        nameLb.text = _walletModel.walletName;
        [bkgView addSubview:nameLb];
        //头像
        UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -Size(50))/2, nameLb.maxY +Size(5), Size(50), Size(50))];
        headerView.image = [UIImage imageNamed:_walletModel.walletIcon];
        [bkgView addSubview:headerView];
        //总资产
        UILabel *totalSumLb = [[UILabel alloc]initWithFrame:CGRectMake(0, headerView.maxY +Size(5), kScreenWidth, Size(20))];
        totalSumLb.font = BoldSystemFontOfSize(16);
        totalSumLb.textColor = WHITE_COLOR;
        totalSumLb.textAlignment = NSTextAlignmentCenter;
        totalSumLb.text = [NSString stringWithFormat:@"%@Ether",_walletModel.balance];
        [bkgView addSubview:totalSumLb];
        //地址
        UIView *addressBkgView = [[UIView alloc]initWithFrame:CGRectMake(Size(60), totalSumLb.maxY +Size(5), kScreenWidth -Size(60)*2, Size(30))];
        addressBkgView.backgroundColor = WHITE_COLOR;
        addressBkgView.layer.cornerRadius = Size(2);
        [cell.contentView addSubview:addressBkgView];
        UILabel *addressLb = [[UILabel alloc]initWithFrame:CGRectMake(addressBkgView.minX+Size(3), addressBkgView.minY, addressBkgView.width -Size(3)*2, Size(30))];
        addressLb.font = SystemFontOfSize(12);
        addressLb.textColor = TEXT_DARK_COLOR;
        addressLb.text = _walletModel.address;
        addressLb.numberOfLines = 2;
        [cell.contentView addSubview:addressLb];
        UIImageView *addressIV = [[UIImageView alloc]initWithFrame:CGRectMake(addressBkgView.maxX +Size(5), addressLb.minY +Size(5), Size(20), Size(20))];
        addressIV.image = [UIImage imageNamed:@"codeIcon"];
        [cell.contentView addSubview:addressIV];
        UIButton *addressBT = [[UIButton alloc]initWithFrame:CGRectMake(addressBkgView.minX, addressBkgView.minY, addressBkgView.width +Size(20), Size(20))];
        [addressBT addTarget:self action:@selector(showAddressCodeAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:addressBT];
        
        return cell;
        
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        //钱包名
        UILabel *desLb = [[UILabel alloc]initWithFrame:CGRectMake(toX, Size(10), Size(150), Size(20))];
        desLb.font = SystemFontOfSize(16);
        desLb.textColor = COLOR(101, 101, 101, 1);
        desLb.text = @"钱包名";
        [cell.contentView addSubview:desLb];
        walletNameTF = [[UITextField alloc] initWithFrame:CGRectMake(desLb.minX, desLb.maxY, kScreenWidth -toX, Size(25))];
        walletNameTF.font = SystemFontOfSize(16);
        walletNameTF.textColor = TEXT_DARK_COLOR;
        //默认
        walletNameTF.text = _walletModel.walletName;
        walletNameTF.delegate = self;
        [cell.contentView addSubview:walletNameTF];
        
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        //修改密码
        cell.textLabel.text = @"修改密码";
        
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        //密码提示
        UILabel *desLb = [[UILabel alloc]initWithFrame:CGRectMake(toX, Size(10), Size(150), Size(20))];
        desLb.font = SystemFontOfSize(16);
        desLb.textColor = COLOR(101, 101, 101, 1);
        desLb.text = @"密码提示";
        [cell.contentView addSubview:desLb];
        passwordDesTF = [[UITextField alloc] initWithFrame:CGRectMake(desLb.minX, desLb.maxY, kScreenWidth -toX, Size(25))];
        passwordDesTF.font = SystemFontOfSize(15);
        passwordDesTF.textColor = TEXT_DARK_COLOR;
        passwordDesTF.keyboardType = UIKeyboardTypeNamePhonePad;
        passwordDesTF.secureTextEntry = YES;
        passwordDesTF.text = _walletModel.passwordTip;
        passwordDesTF.userInteractionEnabled = NO;
        [cell.contentView addSubview:passwordDesTF];
        /*****************密码可见、不可见*****************/
        secretBtn = [[UIButton alloc] initWithFrame:CGRectMake(passwordDesTF.maxX -Size(18 +15), desLb.maxY +(passwordDesTF.height -Size(14))/2 -Size(10), Size(18), Size(14))];
        [secretBtn setBackgroundImage:[UIImage imageNamed:@"secrecy"] forState:UIControlStateNormal];
        [secretBtn setBackgroundImage:[UIImage imageNamed:@"noSecrecy"] forState:UIControlStateSelected];
        [secretBtn addTarget:self action:@selector(secretBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:secretBtn];
        
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        //导出私钥
        cell.textLabel.text = @"导出私钥";
        
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        //导出Keystore
        cell.textLabel.text = @"导出Keystore";
    }
    
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissKeyboardAction];
    if (indexPath.section == 0 && indexPath.row == 2) {
        //修改密码
        ChangePasswordViewController *viewController = [[ChangePasswordViewController alloc]init];
        viewController.walletModel = _walletModel;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        //导出私钥
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入钱包密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *pswTF = alertController.textFields.firstObject;
            if (pswTF.text.length == 0) {
                [self hudShowWithString:@"密码不能为空" delayTime:1];
                return;
            }else{
                if ([pswTF.text isEqualToString:_walletModel.loginPassword]) {
                    CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:@"导出私钥" contentText:_walletModel.privateKey imageName:nil leftButtonTitle:@"复制" rightButtonTitle:nil alertViewType:CommonAlertViewType_style3];
                    [alert show];
                    alert.leftBlock = ^() {
                        //复制
                        UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
                        pastboard.string = _walletModel.privateKey;
                        [self hudShowWithString:@"已复制" delayTime:1];
                    };
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
        
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        //导入KeyStore
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入钱包密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *pswTF = alertController.textFields.firstObject;
            if (pswTF.text.length == 0) {
                [self hudShowWithString:@"密码不能为空" delayTime:1];
                return;
            }else{
                if ([pswTF.text isEqualToString:_walletModel.loginPassword]) {
                    ExportKeyStoreViewController *viewController = [[ExportKeyStoreViewController alloc]init];
                    viewController.keyStore = _walletModel.keyStore;
                    [self.navigationController pushViewController:viewController animated:YES];
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
}

#pragma 删除钱包
-(void)deleteAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入钱包密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *pswTF = alertController.textFields.firstObject;
        if (pswTF.text.length == 0) {
            [self hudShowWithString:@"密码不能为空" delayTime:1];
            return;
        }else{
            if ([pswTF.text isEqualToString:_walletModel.loginPassword]) {
                NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
                NSData* datapath = [NSData dataWithContentsOfFile:path];
                NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
                NSMutableArray *list = [NSMutableArray array];
                list = [unarchiver decodeObjectForKey:@"walletList"];
                [unarchiver finishDecoding];
                //如果删除的钱包是当前默认的钱包则要清除钱包交易记录数据缓存
                WalletModel *defaultMode = list[[[AppDefaultUtil sharedInstance].defaultWalletIndex intValue]];
                if ([defaultMode.walletName isEqualToString:_walletModel.walletName]) {
                    [CacheUtil clearTokenCoinTradeListCacheFile];
                }
                
                /***********更新当前钱包信息***********/
                for (int i = 0; i< list.count; i++) {
                    WalletModel *model = list[i];
                    if ([model.walletName isEqualToString:_walletModel.walletName]) {
                        [list removeObject:model];
                    }
                }
                //替换list中当前钱包信息
                NSMutableData* data = [NSMutableData data];
                NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                [archiver encodeObject:list forKey:@"walletList"];
                [archiver finishEncoding];
                [data writeToFile:path atomically:YES];
                /***********更新当前选中的钱包位置信息***********/
                [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:@"0"];
                
                if (list.count > 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletInfoUI object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletPageView object:nil];
                }
                
                [self backAction];
                
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

#pragma mark - 保存信息
-(void)saveData
{
    [self dismissKeyboardAction];
    [self createLoadingView:@"正在保存..."];
    if (![walletNameTF.text isEqualToString:_walletModel.walletName]) {
        /***********更新当前钱包信息***********/
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
        NSData* datapath = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
        NSMutableArray *list = [NSMutableArray array];
        list = [unarchiver decodeObjectForKey:@"walletList"];
        [unarchiver finishDecoding];
        for (int i = 0; i< list.count; i++) {
            WalletModel *model = list[i];
            if ([model.walletName isEqualToString:_walletModel.walletName]) {
                [model setWalletName:walletNameTF.text];
                [list replaceObjectAtIndex:i withObject:model];
                _walletModel = list[i];
            }
        }
        //替换list中当前钱包信息
        NSMutableData* data = [NSMutableData data];
        NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:list forKey:@"walletList"];
        [archiver finishEncoding];
        [data writeToFile:path atomically:YES];
    }
    //延迟执行
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
}

-(void)delayMethod
{
    [self hiddenLoadingView];
    [self hudShowWithString:@"保存成功" delayTime:1.5];
    [_infoTableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletPageView object:nil];
}

#pragma 收款码
-(void)showAddressCodeAction
{
    AddressCodePayViewController *viewController = [[AddressCodePayViewController alloc] init];
    viewController.walletModel = _walletModel;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma 备份助记词
-(void)backupAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入钱包密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
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

//密码是否加密
-(void)secretBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        passwordDesTF.secureTextEntry = NO;
    }else{
        passwordDesTF.secureTextEntry = YES;
    }
}

#pragma UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //判断钱包名是否有重复
    /*************获取钱包列表*************/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSMutableArray *walletList = [NSMutableArray array];
    walletList = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    for (WalletModel *model in walletList) {
        if ([walletNameTF.text isEqualToString:model.walletName] && ![walletNameTF.text isEqualToString:_walletModel.walletName]) {
            [self hudShowWithString:@"钱包名已存在" delayTime:1.5];
        }
    }
}

#pragma mark - 点击空白处收回键盘
-(void)dismissKeyboardAction
{
    [walletNameTF resignFirstResponder];
}

@end
