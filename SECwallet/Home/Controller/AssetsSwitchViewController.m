//
//  AssetsSwitchViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/14.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "AssetsSwitchViewController.h"
#import "WalletModel.h"

@interface AssetsSwitchViewController()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArrays;  //列表列表
}
@property (nonatomic, strong) UITableView *infoTableView;

@end

@implementation AssetsSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavgationItemTitle:@"切换账户"];
    _dataArrays = [NSMutableArray array];
    [self addSubView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavgationLeftImage:[UIImage imageNamed:@"backIcon"] withAction:@selector(backAction)];
}

- (void)addSubView
{
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -KNaviHeight) style:UITableViewStyleGrouped];
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.backgroundColor = DARK_COLOR;
    [self.view addSubview:_infoTableView];
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //如果默认钱包位置大于9，则让cell自动滚动到默认钱包位置
    if ([[AppDefaultUtil sharedInstance].defaultWalletIndex intValue] > 8) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[[AppDefaultUtil sharedInstance].defaultWalletIndex intValue] inSection:0];
            [_infoTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        });
    }
    return _assetsList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? Size(10) :0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = DARK_COLOR;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Size(55);
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
    cell.textLabel.font = BoldSystemFontOfSize(18);
    cell.textLabel.textColor = TEXT_BLACK_COLOR;
    WalletModel *model = _assetsList[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:model.walletIcon];
    cell.textLabel.text = model.walletName;
    
    if (indexPath.row == [[AppDefaultUtil sharedInstance].defaultWalletIndex integerValue]) {
        cell.backgroundColor = COLOR(209, 163, 101, 1);
        cell.textLabel.textColor = WHITE_COLOR;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [[AppDefaultUtil sharedInstance].defaultWalletIndex integerValue]) {
        /***********更新当前选中的钱包位置信息***********/
        [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:[NSString stringWithFormat:@"%ld",indexPath.row]];
        /*************切换钱包后删除之前代币数据缓存*************/
        [CacheUtil clearTokenCoinTradeListCacheFile];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletPageView object:nil];
    }
    
    [self backAction];
}

@end
