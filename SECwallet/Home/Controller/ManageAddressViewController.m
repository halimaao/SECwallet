//
//  EditAddressViewController.m
//  SECwallet
//
//  Created by 通证控股 on 2018/10/17.
//  Copyright © 2018年 通证控股. All rights reserved.
//

#import "ManageAddressViewController.h"
#import "ScanQRCodeViewController.h"

#define kTableCellHeight Size(55)

@interface ManageAddressViewController ()<UITableViewDelegate,UITableViewDataSource,ScanQRCodeViewControllerDelegate,UITextFieldDelegate>
{
    UITextField *nameTF;       //姓名
    UITextField *addressTF;    //地址
    UIScrollView *addressContentView;
    UITextField *phoneTF;      //电话
    UITextField *emailTF;      //邮箱
    UITextField *remarkTF;     //备注
}

@property (nonatomic, strong) UITableView *infoTableView;

@end

@implementation ManageAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_manageAddressViewType == ManageAddressViewType_add) {
        [self setNavgationItemTitle:@"新增地址"];
    }else{
        [self setNavgationItemTitle:@"编辑地址"];
    }
    
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
    _infoTableView.backgroundColor = WHITE_COLOR;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.scrollEnabled = NO;
    _infoTableView.tableFooterView = [self addTableFooterView];
    [self.view addSubview:_infoTableView];
}

#pragma mark - addTableFooterView
- (UIView *)addTableFooterView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Size(140))];
    CGFloat padddingLeft = Size(20);
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(padddingLeft, Size(80), kScreenWidth - 2*padddingLeft, Size(45))];
    if (_manageAddressViewType == ManageAddressViewType_add) {
        [saveBtn goldBigBtnStyle:@"确认新增"];
    }else{
        [saveBtn goldBigBtnStyle:@"保存修改"];
    }
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:saveBtn];
    
    return footView;
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
        //姓名
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"contactHeader"]];
        UILabel *nameLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(15), 0, kScreenWidth -Size(15 +30), Size(35))];
        nameLb.font = SystemFontOfSize(16);
        nameLb.textColor = TEXT_GOLD_COLOR;
        nameLb.text = @"姓名";
        [cell.contentView addSubview:nameLb];
        nameTF = [[UITextField alloc] initWithFrame:CGRectMake(nameLb.minX, nameLb.maxY, nameLb.width, kTableCellHeight -nameLb.height)];
        nameTF.font = SystemFontOfSize(14);
        nameTF.textColor = TEXT_BLACK_COLOR;
        if (_manageAddressViewType == ManageAddressViewType_add) {
            nameTF.placeholder = @"请输入联系人姓名";
        }else{
            nameTF.text = _currentModel.name;
        }
        [cell.contentView addSubview:nameTF];
        
    }else if (indexPath.row == 1) {
        //扫一扫
        UIButton *scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -Size(20 +20), kTableCellHeight -Size(20 +5), Size(20), Size(20))];
        [scanBtn setBackgroundImage:[UIImage imageNamed:@"scanIcon2"] forState:UIControlStateNormal];
        [scanBtn addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:scanBtn];
        UILabel *addressLb = [[UILabel alloc]initWithFrame:CGRectMake(nameTF.minX, 0, nameTF.width, Size(35))];
        addressLb.font = SystemFontOfSize(16);
        addressLb.textColor = TEXT_GOLD_COLOR;
        addressLb.text = @"联系人钱包地址";
        [cell.contentView addSubview:addressLb];
        addressContentView = [[UIScrollView alloc]initWithFrame:CGRectMake(addressLb.minX, addressLb.maxY, kScreenWidth -Size(15 +45), Size(20))];
        addressContentView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        [cell.contentView addSubview:addressContentView];
        addressTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, addressContentView.width, addressContentView.height)];
        addressTF.font = SystemFontOfSize(14);
        addressTF.textColor = TEXT_BLACK_COLOR;
        addressTF.delegate = self;
        addressTF.keyboardType = UIKeyboardTypeNamePhonePad;
        if (_manageAddressViewType == ManageAddressViewType_add) {
            addressTF.placeholder = @"请输入或粘贴联系人钱包地址";
        }else{
            addressTF.text = _currentModel.address;
        }
        [addressContentView addSubview:addressTF];
        
    }else if (indexPath.row == 2) {
        //手机号
        UILabel *phoneLb = [[UILabel alloc]initWithFrame:CGRectMake(nameTF.minX, 0, nameTF.width, Size(35))];
        phoneLb.font = SystemFontOfSize(16);
        phoneLb.textColor = COLOR(104, 104, 104, 1);
        phoneLb.text = @"手机号码";
        [cell.contentView addSubview:phoneLb];
        phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(phoneLb.minX, phoneLb.maxY, phoneLb.width, Size(20))];
        phoneTF.font = SystemFontOfSize(14);
        phoneTF.textColor = TEXT_BLACK_COLOR;
        phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        phoneTF.placeholder = @"请输入联系人手机号码";
        if (_manageAddressViewType == ManageAddressViewType_edit) {
            phoneTF.text = _currentModel.phone;
        }
        [cell.contentView addSubview:phoneTF];
        
    }else if (indexPath.row == 3) {
        //邮箱
        UILabel *emailLb = [[UILabel alloc]initWithFrame:CGRectMake(nameTF.minX, 0, nameTF.width, Size(35))];
        emailLb.font = SystemFontOfSize(16);
        emailLb.textColor = COLOR(104, 104, 104, 1);
        emailLb.text = @"邮箱";
        [cell.contentView addSubview:emailLb];
        emailTF = [[UITextField alloc] initWithFrame:CGRectMake(emailLb.minX, emailLb.maxY, emailLb.width, Size(20))];
        emailTF.font = SystemFontOfSize(14);
        emailTF.textColor = TEXT_BLACK_COLOR;
        phoneTF.keyboardType = UIKeyboardTypeEmailAddress;
        emailTF.placeholder = @"请输入联系人邮箱";
        if (_manageAddressViewType == ManageAddressViewType_edit) {
            emailTF.text = _currentModel.email;
        }
        [cell.contentView addSubview:emailTF];
        
    }else if (indexPath.row == 4) {
        //备注
        UILabel *remarkLb = [[UILabel alloc]initWithFrame:CGRectMake(nameTF.minX, 0, nameTF.width, Size(35))];
        remarkLb.font = SystemFontOfSize(16);
        remarkLb.textColor = COLOR(104, 104, 104, 1);
        remarkLb.text = @"备注";
        [cell.contentView addSubview:remarkLb];
        remarkTF = [[UITextField alloc] initWithFrame:CGRectMake(remarkLb.minX, remarkLb.maxY, remarkLb.width, Size(20))];
        remarkTF.font = SystemFontOfSize(14);
        remarkTF.textColor = TEXT_BLACK_COLOR;
        remarkTF.placeholder = @"选填";
        if (_manageAddressViewType == ManageAddressViewType_edit) {
            remarkTF.text = _currentModel.remark;
        }
        [cell.contentView addSubview:remarkTF];
    }
    
    return cell;
}

#pragma UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGSize size = [textField.text calculateSize:SystemFontOfSize(16) maxWidth:kScreenWidth*2];
    if (size.width > kScreenWidth -Size(75)) {
        addressTF.frame = CGRectMake(Size(0), 0, size.width+Size(10), Size(20));
        [addressContentView setContentSize:CGSizeMake(size.width, addressTF.height)];
    }else{
        addressTF.frame = CGRectMake(Size(0), 0, kScreenWidth -Size(15 +45), Size(20));
        [addressContentView setContentSize:CGSizeMake(kScreenWidth -Size(15 +45), addressTF.height)];
    }
}

#pragma mark 完成
-(void)saveAction
{
    [self dismissKeyboardAction];
    if (nameTF.text.length == 0) {
        [self hudShowWithString:@"请输入姓名" delayTime:1.5];
        return;
    }
    if (addressTF.text.length == 0) {
        [self hudShowWithString:@"请输入收款人钱包地址" delayTime:1.5];
        return;
    }
    //判断扫描的是否为钱包地址(前缀是0x并且长度为42位)
    if (!([addressTF.text hasPrefix:@"0x"] && addressTF.text.length == 42)) {
        [self hudShowWithString:@"地址不正确，请重新输入" delayTime:1.5];
        return;
    }
    if (phoneTF.text.length > 0) {
        if ([NSString validateMobile:phoneTF.text] == NO) {
            [self hudShowWithString:@"号码格式不正确，请重新输入" delayTime:1.5];
            return;
        }
    }
    if (emailTF.text.length > 0) {
        if ([NSString validateEmail:emailTF.text] == NO) {
            [self hudShowWithString:@"邮箱格式不正确，请重新输入" delayTime:1.5];
            return;
        }
    }
    
    /***************判断地址已存在****************/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"addressList"];
    NSData* data2 = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data2];
    NSMutableArray *list = [NSMutableArray array];
    list = [unarchiver decodeObjectForKey:@"addressList"];
    [unarchiver finishDecoding];
    if (_manageAddressViewType == ManageAddressViewType_add) {
        for (AddressModel *model in list) {
            if ([model.name isEqualToString:nameTF.text] && [model.address isEqualToString:addressTF.text] && [model.phone isEqualToString:phoneTF.text]) {
                [self hudShowWithString:@"该地址已存在" delayTime:1.5];
                return;
            }
        }
    }else if (_manageAddressViewType == ManageAddressViewType_edit) {
        [list enumerateObjectsUsingBlock:^(AddressModel *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.name isEqualToString:_currentModel.name] && [obj.address isEqualToString:_currentModel.address] && [obj.phone isEqualToString:_currentModel.phone]) {
                *stop = YES;
                if (*stop == YES) {
                    [list removeObject:obj];
                }
            }
            *stop = NO; //移除了数组中的元素之后继续执行
            if (*stop) {
                NSLog(@"array is %@",list);
            }
        }];
        for (AddressModel *model in list) {
            if ([model.name isEqualToString:nameTF.text] && [model.address isEqualToString:addressTF.text] && [model.phone isEqualToString:phoneTF.text]) {
                [self hudShowWithString:@"该地址已存在" delayTime:1.5];
                return;
            }
        }
    }
    
    [self createLoadingView:nil];
    AddressModel *model = [[AddressModel alloc]initWithName:nameTF.text andPhone:phoneTF.text andAddress:addressTF.text andEmail:emailTF.text andRemark:remarkTF.text];
    /*************先获取地址列表并将最新地址排在第一位*************/
    NSMutableData* data = [NSMutableData data];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    if (_manageAddressViewType == ManageAddressViewType_add) {
        if (list.count > 0) {
            [list insertObject:model atIndex:0];
            [archiver encodeObject:list forKey:@"addressList"];
            [archiver finishEncoding];
            [data writeToFile:path atomically:YES];
        }else{
            NSMutableArray *list1 = [NSMutableArray array];
            [list1 insertObject:model atIndex:0];
            [archiver encodeObject:list1 forKey:@"addressList"];
            [archiver finishEncoding];
            [data writeToFile:path atomically:YES];
        }
    }else if (_manageAddressViewType == ManageAddressViewType_edit) {
        //先删除当前地址在插入保存的地址
        [list enumerateObjectsUsingBlock:^(AddressModel *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.name isEqualToString:_currentModel.name] && [obj.address isEqualToString:_currentModel.address] && [obj.phone isEqualToString:_currentModel.phone]) {
                *stop = YES;
                if (*stop == YES) {
                    [list removeObject:obj];
                }
            }
            *stop = NO; //移除了数组中的元素之后继续执行
            if (*stop) {
                NSLog(@"array is %@",list);
            }
        }];

        [list insertObject:model atIndex:0];
        [archiver encodeObject:list forKey:@"addressList"];
        [archiver finishEncoding];
        [data writeToFile:path atomically:YES];
    }
    
    //延迟执行
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
}
-(void)delayMethod
{
    [self hiddenLoadingView];
    [self backAction];
}

#pragma 扫一扫
-(void)scanAction
{
    [self dismissKeyboardAction];
    ScanQRCodeViewController *controller = [[ScanQRCodeViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 点击空白处收回键盘
-(void)dismissKeyboardAction
{
    [nameTF resignFirstResponder];
    [addressTF resignFirstResponder];
    [phoneTF resignFirstResponder];
    [emailTF resignFirstResponder];
    [remarkTF resignFirstResponder];
}

#pragma ScanQRCodeViewControllerDelegate
-(void)getScanCode:(NSString *)codeStr
{
    if ([codeStr containsString:@"###"]) {
        NSArray *arr = [codeStr componentsSeparatedByString:@"###"];
        addressTF.text = arr[0];
    }else{
        addressTF.text = codeStr;
    }
    CGSize size = [addressTF.text calculateSize:SystemFontOfSize(16) maxWidth:kScreenWidth*2];
    addressTF.frame = CGRectMake(0, 0, size.width+Size(10), Size(20));
    [addressContentView setContentSize:CGSizeMake(size.width+Size(10), addressTF.height)];
}

@end
