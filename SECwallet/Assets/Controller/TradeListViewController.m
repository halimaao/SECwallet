//
//  TradeListViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/13.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "TradeListViewController.h"
#import "TradeListTableViewCell.h"
#import "TradeModel.h"
#import "WalletModel.h"
#import "AssetsSwitchViewController.h"
#import "TradeInfoViewController.h"

#define KXHeight  (IS_iPhoneX ? 64 : 0)

@interface TradeListViewController()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isHeaderRefresh;
    NSMutableArray *_walletList;  //钱包列表
    NSMutableArray *_dataArrays;  //交易列表
    UIImageView *_noRemindView;
    
    UIView *_noNetworkView;
    BOOL connectNetwork;
    BOOL hasGetDataInfo;   //是否获取了数据
}
@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) WalletModel *walletModel;

@end

@implementation TradeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavgationRightImage:[UIImage imageNamed:@"changeIcon"] withAction:@selector(changeAction)];
    
    [self addSubView];
    [self addNoNetworkView];
    
    //网络监听
    [self networkManager];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* datapath = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
    _walletList = [NSMutableArray array];
    _walletList = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    _walletModel = _walletList[[[AppDefaultUtil sharedInstance].defaultWalletIndex intValue]];
    [self setNavgationItemTitle:_walletModel.walletName];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 延时加载，解决一个因为启动过快，AFN判断网络的类未启动完成导致判断网络无网络的Bug
        [self readTradeRecordListCache];
    });
}

-(void) readTradeRecordListCache
{
    /*************获取交易列表*************/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletRecodeList"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSArray *recodeList = [NSMutableArray array];
    recodeList = [unarchiver decodeObjectForKey:@"walletRecodeList"];
    [unarchiver finishDecoding];
    if (recodeList !=nil) {
        _dataArrays = [NSMutableArray arrayWithArray:recodeList];
        [_infoTableView reloadData];
    }else{
        [self requestTransactionList];
    }
}
- (void)addSubView
{
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -KNaviHeight) style:UITableViewStyleGrouped];
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.backgroundColor = WHITE_COLOR;
    //解决MJ控件IOS11刷新问题
    _infoTableView.estimatedRowHeight =0;
    _infoTableView.estimatedSectionHeaderHeight =0;
    _infoTableView.estimatedSectionFooterHeight =0;
    [self.view addSubview:_infoTableView];
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_infoTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    if (connectNetwork == YES) {
        isHeaderRefresh = YES;
        [_noRemindView removeFromSuperview];
        _isLoading  = NO;
        [self requestTransactionList];
    }else{
        [self hiddenRefreshView];
        _infoTableView.hidden = YES;
        self.view.backgroundColor = BACKGROUND_DARK_COLOR;
        _noNetworkView.hidden = NO;
    }
}

// 隐藏刷新视图
-(void) hiddenRefreshView
{
    if (!_infoTableView.isHeaderHidden)
    {
        [_infoTableView headerEndRefreshing];
    }
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArrays.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Size(8);
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
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *itemCell = @"cell_item";
    TradeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil)
    {
        cell = [[TradeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TradeModel *model = _dataArrays[indexPath.row];
    [cell fillCellWithObject:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeModel *model = _dataArrays[indexPath.row];
    TradeInfoViewController *viewController = [[TradeInfoViewController alloc] init];
    viewController.tradeModel = model;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 获取交易记录列表
-(void)requestTransactionList
{
    if (isHeaderRefresh == NO) {
        [self createLoadingView:nil];
    }
//    [HSEther hs_getTransactionListWithToken:nil walletAddress:_walletModel.address block:^(NSArray *arrayList, HSWalletError error) {
//        [self hiddenLoadingView];
//        [self hiddenRefreshView];
//        hasGetDataInfo = YES;
//        if (error == HSWalletSucLogList && connectNetwork == YES) {
//            connectNetwork = YES;
//            _infoTableView.hidden = NO;
//            _noNetworkView.hidden = YES;
//            
//            if (arrayList.count > 0) {
//                //将arrayList按照时间进行排序
//                NSArray *sortArray = [arrayList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//                    TradeModel *pModel1 = obj1;
//                    TradeModel *pModel2 = obj2;
//                    if (pModel1.blockNum.integerValue > pModel2.blockNum.integerValue) {
//                        return NSOrderedAscending;   //升序
//                    }else if (pModel1.blockNum.integerValue < pModel2.blockNum.integerValue){
//                        return NSOrderedDescending;  //降序
//                    }else {
//                        return NSOrderedSame;       //相等
//                    }
//                }];
//                _dataArrays = [NSMutableArray arrayWithArray:sortArray];
//                /*************保存交易记录*************/
//                NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletRecodeList"];
//                NSMutableData* data = [NSMutableData data];
//                NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
//                [archiver encodeObject:_dataArrays forKey:@"walletRecodeList"];
//                [archiver finishEncoding];
//                [data writeToFile:path atomically:YES];
//                [_noRemindView removeFromSuperview];
//                [_infoTableView reloadData];
//            }else{
//                _dataArrays = [NSMutableArray array];
//                [_infoTableView reloadData];
//                /*************保存交易记录*************/
//                NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletRecodeList"];
//                NSMutableData* data = [NSMutableData data];
//                NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
//                [archiver encodeObject:nil forKey:@"walletRecodeList"];
//                [archiver finishEncoding];
//                [data writeToFile:path atomically:YES];
//                
//                [_noRemindView removeFromSuperview];
//                _noRemindView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth -Size(200))/2, (kScreenHeight -Size(220))/2 -KXHeight, Size(200), Size(200))];
//                _noRemindView.image = [UIImage imageNamed:@"noTradeInfoBkg"];
//                [_infoTableView addSubview:_noRemindView];
//            }
//            
//        }else if (error == HSWalletErrorLogList) {
//            [self hudShowWithString:@"数据获取失败" delayTime:1.5];
//            _dataArrays = [NSMutableArray array];
//            [_infoTableView reloadData];
//            [_noRemindView removeFromSuperview];
//            _noRemindView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth -Size(200))/2, (kScreenHeight -Size(220))/2 -KXHeight, Size(200), Size(200))];
//            _noRemindView.image = [UIImage imageNamed:@"noTradeInfoBkg"];
//            [_infoTableView addSubview:_noRemindView];
//            
//        }else if (error == HSNoneNetWork) {
//            [self hiddenRefreshView];
//        }
//    }];
}

#pragma 切换账户
-(void)changeAction
{
    AssetsSwitchViewController *viewController = [[AssetsSwitchViewController alloc]init];
    viewController.assetsList = _walletList;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - 网络监听管理
- (void)networkManager
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        _isLoading  = NO;
        [self hiddenRefreshView];
        if (status == 0) {
            //无网络视图
            connectNetwork = NO;
            _infoTableView.hidden = YES;
            [_noRemindView removeFromSuperview];
            self.view.backgroundColor = BACKGROUND_DARK_COLOR;
            _noNetworkView.hidden = NO;
        }else{
            connectNetwork = YES;
        }
    }];
}
-(void)addNoNetworkView
{
    _noNetworkView = [[UIView alloc] initWithFrame:CGRectMake(0, Size(8), kScreenWidth, kScreenHeight)];
    _noNetworkView.backgroundColor = WHITE_COLOR;
    [self.view addSubview:_noNetworkView];
    _noNetworkView.hidden = YES;
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -Size(150))/2, Size(120), Size(150), Size(120))];
    iv.image = [UIImage imageNamed:@"noNetwork"];
    [_noNetworkView addSubview:iv];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, iv.maxY +Size(30), kScreenWidth, Size(20))];
    lb.font = SystemFontOfSize(14);
    lb.textColor = TEXT_BLACK_COLOR;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = @"你的钱包掉～掉线了！";
    [_noNetworkView addSubview:lb];
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth -Size(100))/2, lb.maxY, Size(100), Size(30))];
    bt.titleLabel.font = SystemFontOfSize(14);
    [bt setTitleColor:TEXT_GOLD_COLOR forState:UIControlStateNormal];
    [bt setTitle:@"点击重试" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(refreshNetworkAction) forControlEvents:UIControlEventTouchUpInside];
    [_noNetworkView addSubview:bt];
}

-(void)refreshNetworkAction
{
    _isLoading  = NO;
    [self requestTransactionList];
}

@end
