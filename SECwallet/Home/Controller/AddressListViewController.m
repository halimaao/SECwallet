//
//  AddressListViewController.m
//  SECwallet
//
//  Created by 通证控股 on 2018/10/17.
//  Copyright © 2018年 通证控股. All rights reserved.
//

#import "AddressListViewController.h"
#import "ScanQRCodeViewController.h"
#import "ManageAddressViewController.h"
#import "AddressModel.h"

#define KXHeight  (IS_iPhoneX ? 64 : 0)
#define kAddContactHeight    Size(40)

@interface AddressListViewController()<UITableViewDelegate,UITableViewDataSource,ScanQRCodeViewControllerDelegate>
{
    UIButton *addBT;
    NSMutableArray *_dataArrays;  //数据列表
    UIView *_noneContactView;
}
@property (nonatomic, strong) UITableView *infoTableView;

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavgationItemTitle:@"地址薄"];
    if (_isDelegate == YES) {
       [self setNavgationRightImage:[UIImage imageNamed:@"scanIcon1"] withAction:@selector(scanAction)];
    }
    
    [self addSubView];
    
}

- (void)addSubView
{
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -KNaviHeight-kAddContactHeight) style:UITableViewStyleGrouped];
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.backgroundColor = WHITE_COLOR;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    [self.view addSubview:_infoTableView];
    //底部添加按钮
    addBT = [[UIButton alloc]initWithFrame:CGRectMake(0, _infoTableView.maxY, kScreenWidth, kAddContactHeight)];
    [addBT setBackgroundImage:[UIImage imageNamed:@"addContact"] forState:UIControlStateNormal];
    [addBT addTarget:self action:@selector(addAddressAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBT];
    /*************获取地址列表*************/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"addressList"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    _dataArrays = [NSMutableArray array];
    _dataArrays = [unarchiver decodeObjectForKey:@"addressList"];
    [unarchiver finishDecoding];
    
    //无地址薄视图
    _noneContactView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_noneContactView];
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -Size(150))/2, Size(100)+KXHeight, Size(150), Size(120))];
    iv.image = [UIImage imageNamed:@"noneContact"];
    [_noneContactView addSubview:iv];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, iv.maxY +Size(30), kScreenWidth, Size(20))];
    lb.font = SystemFontOfSize(14);
    lb.textColor = TEXT_BLACK_COLOR;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = @"暂无联系人哦";
    [_noneContactView addSubview:lb];
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth -Size(100))/2, lb.maxY, Size(100), Size(30))];
    bt.titleLabel.font = SystemFontOfSize(14);
    [bt setTitleColor:TEXT_GOLD_COLOR forState:UIControlStateNormal];
    [bt setTitle:@"点此添加" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(addAddressAction) forControlEvents:UIControlEventTouchUpInside];
    [_noneContactView addSubview:bt];
    
    if (_dataArrays.count > 0) {
        _noneContactView.hidden = YES;
        addBT.hidden = NO;
        [_infoTableView reloadData];
    }else{
        addBT.hidden = YES;
        _noneContactView.hidden = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*************获取地址列表*************/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"addressList"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    _dataArrays = [NSMutableArray array];
    _dataArrays = [unarchiver decodeObjectForKey:@"addressList"];
    [unarchiver finishDecoding];
    if (_dataArrays.count > 0) {
        _noneContactView.hidden = YES;
        addBT.hidden = NO;
        [_infoTableView reloadData];
    }
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArrays.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Size(5);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Size(8))];
    headerView.backgroundColor = BACKGROUND_DARK_COLOR;
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Size(64);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *itemCell = @"cell_item";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:@"contactHeader"];
    cell.textLabel.font = SystemFontOfSize(15);
    cell.textLabel.textColor = TEXT_BLACK_COLOR;
    cell.detailTextLabel.font = SystemFontOfSize(15);
    cell.detailTextLabel.textColor = TEXT_DARK_COLOR;
    
    AddressModel *model = _dataArrays[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",model.name,model.phone];
    cell.detailTextLabel.text = [NSString addressToAsterisk:model.address];
    //编辑按钮
    UIButton *editBT = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -Size(40), Size(64-35)/2, Size(40), Size(35))];
    editBT.tag = indexPath.row;
    [editBT setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [editBT addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:editBT];
    return cell;
}

#pragma 编辑
-(void)editAction:(UIButton *)sender
{
    ManageAddressViewController *controller = [[ManageAddressViewController alloc]init];
    controller.manageAddressViewType = ManageAddressViewType_edit;
    AddressModel *model = _dataArrays[sender.tag];
    controller.currentModel = model;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isDelegate == YES) {
        AddressModel *model = _dataArrays[indexPath.row];
        [self.delegate sendScanCode:model.address];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//可编辑状态
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //删除地址
        AddressModel *model = _dataArrays[indexPath.row];
        [_dataArrays removeObject:model];
        //替换list中当前地址信息
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"addressList"];
        NSMutableData* data = [NSMutableData data];
        NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:_dataArrays forKey:@"addressList"];
        [archiver finishEncoding];
        [data writeToFile:path atomically:YES];
        [_infoTableView reloadData];
        if (_dataArrays.count == 0) {
            addBT.hidden = YES;
            _noneContactView.hidden = NO;
        }
    }];
    return @[deleteAction];
}

#pragma 扫一扫
-(void)scanAction
{
    ScanQRCodeViewController *controller = [[ScanQRCodeViewController alloc]init];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma ScanQRCodeViewControllerDelegate
-(void)getScanCode:(NSString *)codeStr
{
    [self.delegate sendScanCode:codeStr];
    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
    if (index>2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-1)] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma 添加地址
-(void)addAddressAction
{
    ManageAddressViewController *controller = [[ManageAddressViewController alloc]init];
    controller.manageAddressViewType = ManageAddressViewType_add;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
