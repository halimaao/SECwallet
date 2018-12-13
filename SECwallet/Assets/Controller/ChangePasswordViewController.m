//
//  ChangePasswordViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/13.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ImportWalletManageViewController.h"

#define kTableCellHeight Size(45)

@interface ChangePasswordViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *passwordTF;       //密码
    UITextField *newpasswordTF;    //新密码
    UITextField *re_passwordTF;   //重复新密码
    UITextField *passwordDesTF;   //密码提示
}

@property (nonatomic, strong) UITableView *infoTableView;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavgationItemTitle:@"更改密码"];
    [self setNavgationRightTitle:@"完成" withAction:@selector(savePassword)];
    
    [self addInfoTableView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboardAction)];
    [self.view addGestureRecognizer:tap];
    
}
//解决手势和cell点击事件冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
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
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Size(80))];
    UILabel *desLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(15), Size(20), Size(235), Size(30))];
    desLb.font = SystemFontOfSize(14);
    desLb.textColor = TEXT_DARK_COLOR;
    desLb.text = @"忘记密码？导入助记词或私钥可重置密码。";
    [footView addSubview:desLb];
    UIButton *importBtn = [[UIButton alloc] initWithFrame:CGRectMake(desLb.maxX, desLb.minY, Size(50), Size(30))];
    importBtn.titleLabel.font = SystemFontOfSize(14);
    [importBtn setTitleColor:COLOR(173, 129, 65, 1) forState:UIControlStateNormal];
    [importBtn setTitle:@"马上导入" forState:UIControlStateNormal];
    [importBtn addTarget:self action:@selector(importBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:importBtn];
    
    return footView;
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        //密码
        passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(Size(15), 0, kScreenWidth -Size(15 +10), kTableCellHeight)];
        passwordTF.font = SystemFontOfSize(16);
        passwordTF.textColor = TEXT_BLACK_COLOR;
        passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
        passwordTF.secureTextEntry = YES;
        passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        passwordTF.placeholder = @"当前密码";
        [cell.contentView addSubview:passwordTF];
        
    }else if (indexPath.row == 1) {
        //新密码
        newpasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(passwordTF.minX, 0, passwordTF.width, kTableCellHeight)];
        newpasswordTF.font = SystemFontOfSize(16);
        newpasswordTF.textColor = TEXT_BLACK_COLOR;
        newpasswordTF.secureTextEntry = YES;
        newpasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        newpasswordTF.placeholder = @"新密码";
        newpasswordTF.keyboardType = UIKeyboardTypeASCIICapable;
        [cell.contentView addSubview:newpasswordTF];
        
    }else if (indexPath.row == 2) {
        //重复密码
        re_passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(newpasswordTF.minX, 0, newpasswordTF.width, kTableCellHeight)];
        re_passwordTF.font = SystemFontOfSize(16);
        re_passwordTF.textColor = TEXT_BLACK_COLOR;
        re_passwordTF.placeholder = @"重复新密码";
        re_passwordTF.secureTextEntry = YES;
        re_passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        re_passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
        [cell.contentView addSubview:re_passwordTF];
        
    }else if (indexPath.row == 3) {
        //密码提示
        passwordDesTF = [[UITextField alloc] initWithFrame:CGRectMake(re_passwordTF.minX, 0, re_passwordTF.width, kTableCellHeight)];
        passwordDesTF.font = SystemFontOfSize(16);
        passwordDesTF.textColor = TEXT_BLACK_COLOR;
        passwordDesTF.placeholder = @"密码提示（选填）";
        passwordDesTF.delegate = self;
        [cell.contentView addSubview:passwordDesTF];
    }
    
    return cell;
}

#pragma mark 完成
-(void)savePassword
{
    [self dismissKeyboardAction];
    if (passwordTF.text.length >30 || passwordTF.text.length <8) {
        [self hudShowWithString:@"请输入8~30位密码" delayTime:1.5];
        return;
    }
    if ([NSString validatePassword:passwordTF.text] == NO) {
        [self hudShowWithString:@"请输入数字和字母组合密码" delayTime:1.5];
        return;
    }
    if (![passwordTF.text isEqualToString:_walletModel.loginPassword]) {
        [self hudShowWithString:@"当前密码验证失败" delayTime:1.5];
        return;
    }
    if (![newpasswordTF.text isEqualToString:re_passwordTF.text]) {
        [self hudShowWithString:@"两次密码输入不一致，请重新输入！" delayTime:1.5];
        return;
    }
    if (newpasswordTF.text.length > 0) {
        [self createLoadingView:nil];
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
                [model setLoginPassword:newpasswordTF.text];
                [model setPasswordTip:passwordDesTF.text];
                [list replaceObjectAtIndex:i withObject:model];
            }
        }
        //替换list中当前钱包信息
        NSMutableData* data = [NSMutableData data];
        NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:list forKey:@"walletList"];
        [archiver finishEncoding];
        [data writeToFile:path atomically:YES];
        //延迟执行
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
    }
}
-(void)delayMethod
{
    [self hiddenLoadingView];
    [self backAction];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletPageView object:nil];
}

#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == passwordDesTF) {
        //限制输入12位
        if (range.length == 1 && string.length == 0) {
            return YES;
        }else if (passwordDesTF.text.length >= 12) {
            passwordDesTF.text = [textField.text substringToIndex:12];
            return NO;
        }
    }
    return YES;
}

-(void)importBtnAction
{
    ImportWalletManageViewController *viewController = [[ImportWalletManageViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - 点击空白处收回键盘
-(void)dismissKeyboardAction
{
    [passwordTF resignFirstResponder];
    [newpasswordTF resignFirstResponder];
    [re_passwordTF resignFirstResponder];
}

@end
