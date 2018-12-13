//
//  MineViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "MineViewController.h"
#import "WalletManageViewController.h"
#import "TradeListViewController.h"
#import "TokenCoinModel.h"
#import "AddressListViewController.h"

#define kTableCellHeight    Size(45)
#define kHeaderHeight    Size(160) +KStatusBarHeight

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addContentView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**************导航栏布局***************/
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)addContentView
{
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -KStatusBarHeight, kScreenWidth, kScreenHeight -KTabbarHeight) style:UITableViewStyleGrouped];
    _mainTableView.backgroundColor = WHITE_COLOR;
    _mainTableView.scrollEnabled = NO;
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight)];
    //背景图片
    UIImageView *bkgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight)];
    bkgIV.image = [UIImage imageNamed:@"homeHeaderbkg"];
    [headerView addSubview:bkgIV];
    //标题
    UILabel *titLb = [[UILabel alloc]initWithFrame:CGRectMake(0, KStatusBarHeight, kScreenWidth, Size(30))];
    titLb.font = BoldSystemFontOfSize(20);
    titLb.textColor = WHITE_COLOR;
    titLb.textAlignment = NSTextAlignmentCenter;
    titLb.text = @"我";
    [self.view addSubview:titLb];
    //收款，扫一扫
    NSArray *titArr = @[@"管理钱包",@"交易记录"];
    NSArray *imgArr = @[@"manageWalletIcon",@"tradeRecordIcon"];
    //快捷功能入口
    CGFloat btWidth = Size(45);
    CGFloat insert = (kScreenWidth -btWidth *imgArr.count)/(imgArr.count +2);
    for (int i = 0; i< titArr.count; i++) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(insert +(insert*2 +btWidth)*i, KStatusBarHeight +Size(50) +Size(10), btWidth, btWidth)];
        iv.image = [UIImage imageNamed:imgArr[i]];
        [_mainTableView addSubview:iv];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(iv.minX -Size(18), iv.maxY, Size(80), Size(35))];
        lb.font = SystemFontOfSize(16);
        lb.textColor = WHITE_COLOR;
        lb.textAlignment = NSTextAlignmentCenter;
        lb.text = titArr[i];
        [headerView addSubview:lb];
        
        UIButton *lnkBtn = [[UIButton alloc]initWithFrame:iv.frame];
        lnkBtn.tag = 1000+i;
        [lnkBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:lnkBtn];
    }
    
    return headerView;
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
    //列表
    static NSString *itemCell = @"cell_item";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = SystemFontOfSize(15);
    cell.textLabel.textColor = TEXT_GOLD_COLOR;
    cell.detailTextLabel.font = SystemFontOfSize(15);
    cell.detailTextLabel.textColor = TEXT_GOLD_COLOR;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"地址薄";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"版本更新";
        //获取版本号
        NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"V%@",app_Version];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        AddressListViewController *controller = [[AddressListViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - 快捷功能入口点击
-(void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1000:
            //管理钱包
        {
            WalletManageViewController *controller = [[WalletManageViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1001:
            //交易记录
        {
            TradeListViewController *controller = [[TradeListViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
