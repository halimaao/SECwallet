//
//  WalletManageViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "WalletManageViewController.h"
#import "WalletListTableViewCell.h"
#import "WalletModel.h"
#import "WalletDetailViewController.h"
#import "CreatWalletViewController.h"
#import "ImportWalletManageViewController.h"

@interface WalletManageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArrays;  //资产列表
}
@property (nonatomic, strong) UITableView *infoTableView;

@end

@implementation WalletManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavgationItemTitle:@"管理钱包"];
    
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = DARK_COLOR;
    
    /*************获取钱包信息*************/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    _dataArrays = [NSMutableArray array];
    _dataArrays = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    [_infoTableView reloadData];
    
    if (_dataArrays.count == 0) {
        CreatWalletViewController *viewController = [[CreatWalletViewController alloc] init];
        viewController.isNoBack = YES;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
        [self presentViewController:navi animated:YES completion:nil];
    }    
}
- (void)setupUI
{
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(Size(8), 0, kScreenWidth -Size(8)*2, kScreenHeight-KNaviHeight -Size(45 +10)) style:UITableViewStyleGrouped];
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.backgroundColor = DARK_COLOR;
    [self.view addSubview:_infoTableView];
    
    //底部按钮
    UIButton *creatBT = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight-KNaviHeight -Size(45), kScreenWidth/2, Size(45))];
    [creatBT customerBtnStyle:@"" andBkgImg:@"creatWalletBT"];
    [creatBT addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    creatBT.tag = 1000;
    [self.view addSubview:creatBT];
    UIButton *importBT = [[UIButton alloc]initWithFrame:CGRectMake(creatBT.maxX, creatBT.minY, creatBT.width, creatBT.height)];
    [importBT customerBtnStyle:@"" andBkgImg:@"importWalletBT"];
    [importBT addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    importBT.tag = 1001;
    [self.view addSubview:importBT];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArrays.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Size(10);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = DARK_COLOR;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == _dataArrays.count ? Size(10) : 0.1f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = DARK_COLOR;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //列表
    static NSString *itemCell = @"cell_item";
    WalletListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil)
    {
        cell = [[WalletListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"accessory_right"]];
    cell.layer.cornerRadius = Size(5);
    WalletModel *model = _dataArrays[indexPath.section];
    [cell fillCellWithObject:model];
    return cell;
    
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //钱包详情
    WalletDetailViewController *viewController = [[WalletDetailViewController alloc]init];
    viewController.walletModel = _dataArrays[indexPath.section];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - 快捷功能入口点击
-(void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1000:
            //创建钱包
        {
            CreatWalletViewController *viewController = [[CreatWalletViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
            [self presentViewController:navi animated:YES completion:nil];
        }
            break;
        case 1001:
            //导入钱包
        {
            ImportWalletManageViewController *viewController = [[ImportWalletManageViewController alloc]init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
            [self presentViewController:navi animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

@end
