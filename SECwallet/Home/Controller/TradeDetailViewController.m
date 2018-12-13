//
//  TradeDetailViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/11.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "TradeDetailViewController.h"
#import "TradeListTableViewCell.h"
#import "TradeModel.h"
#import "TransferViewController.h"
#import "AddressCodePayViewController.h"
#import "TradeInfoViewController.h"

@interface TradeDetailViewController()<UITableViewDelegate,UITableViewDataSource,TransferViewControllerDelegate>
{
    BOOL isHeaderRefresh;
    NSMutableArray *_dataArrays;  //交易列表列表
    UIImageView *_noRemindView;
    //转账
    UIButton *transferBT;
    //收款
    UIButton *gatherBT;
    
    UIView *_noNetworkView;
    BOOL connectNetwork;
    NSArray *recodeListCache;   //缓存的数据
}
@property (nonatomic, strong) UITableView *infoTableView;
@property(nonatomic, assign) NSInteger listCount;

@end

@implementation TradeDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavgationItemTitle:_tokenCoinModel.name];
    
    [self addSubView];
    [self addNoNetworkView];
    [self readTradeRecordListCache];
    //网络监听
    [self networkManager];
    if (recodeListCache != nil) {
        _dataArrays = [NSMutableArray arrayWithArray:recodeListCache];
        [_infoTableView reloadData];
    }else{
        [self requestTransactionHash];
    }

}

#pragma TransferViewControllerDelegate 转账成功事件
//-(void)transferSuccess:(TokenCoinModel *)tokenCoinModel
//{
//    _tokenCoinModel = tokenCoinModel;
//    [self requestTransactionHash];
//}
-(void) readTradeRecordListCache
{
    /*************获取交易列表*************/
    NSString *fileName = [NSString stringWithFormat:@"recodeList_%@",_tokenCoinModel.name];
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:fileName];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    recodeListCache = [unarchiver decodeObjectForKey:fileName];
    [unarchiver finishDecoding];
}

- (void)addSubView
{
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -KNaviHeight -Size(45)) style:UITableViewStyleGrouped];
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
    
    //转账
    transferBT = [[UIButton alloc] initWithFrame:CGRectMake(0, _infoTableView.maxY, kScreenWidth/2, Size(45))];
    [transferBT customerBtnStyle:@"" andBkgImg:@"transferBT"];
    [transferBT addTarget:self action:@selector(transferAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:transferBT];
    //收款
    gatherBT = [[UIButton alloc] initWithFrame:CGRectMake(transferBT.maxX, transferBT.minY, transferBT.width, transferBT.height)];
    [gatherBT customerBtnStyle:@"" andBkgImg:@"gatherBT"];
    [gatherBT addTarget:self action:@selector(gatherAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gatherBT];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    if (connectNetwork == YES) {
        [self readTradeRecordListCache];
        isHeaderRefresh = YES;
        [_noRemindView removeFromSuperview];
        _isLoading  = NO;
        [self requestTransactionHash];
    }else{
        [self hiddenRefreshView];
        _infoTableView.hidden = YES;
        transferBT.hidden = YES;
        gatherBT.hidden = YES;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : _dataArrays.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? Size(3) :Size(8);
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
    if (indexPath.section == 0) {
        return Size(95);
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        return Size(40);
    }else{
        return kTableCellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || (indexPath.section == 1 && indexPath.row ==0)) {
        //每个单元格的视图
        static NSString *itemCell = @"cell_item";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = SystemFontOfSize(14);
        cell.textLabel.textColor = COLOR(159, 159, 159, 1);
        if (indexPath.section == 0 ) {
            //项目
//            NSArray *titArr = @[@"可用",@"冻结",@"折合（CNY）"];
            NSArray *titArr = @[@"可用",@"冻结"];
            CGFloat width = (kScreenWidth -Size(15)*(titArr.count -1))/titArr.count;
            for (int i = 0; i<titArr.count; i++) {
                UILabel *titLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(15) +width *i, Size(5), width, Size(25))];
                titLb.font = SystemFontOfSize(14);
                titLb.textColor = TEXT_DARK_COLOR;
                titLb.text = titArr[i];
                [cell.contentView addSubview:titLb];
            }
            
            NSArray *sumArr = @[_walletModel.balance,@"0.00000000",@"0.00000000"];
            for (int i = 0; i<titArr.count; i++) {
                UILabel *sumLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(15) +width *i, Size(45), width, Size(15))];
                sumLb.font = SystemFontOfSize(14);
                sumLb.textColor = TEXT_BLACK_COLOR;
                sumLb.text = sumArr[i];
                [cell.contentView addSubview:sumLb];
            }
            //折算
            NSArray *desArr = @[@"≈0.12",@"≈12.44",@"≈0.00000000"];
            for (int i = 0; i<titArr.count; i++) {
                UILabel *desLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(15) +width *i, Size(60), width, Size(15))];
                desLb.font = SystemFontOfSize(14);
                desLb.textColor = TEXT_BLACK_COLOR;
                desLb.text = desArr[i];
//                [cell.contentView addSubview:desLb];
            }
            return cell;
        }else{
            cell.textLabel.text = @"最近交易记录";
            return cell;
        }
        
    }else{
        static NSString *itemCell2 = @"cell_item2";
        TradeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell2];
        if (cell == nil)
        {
            cell = [[TradeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TradeModel *model = _dataArrays[indexPath.row -1];
        [cell fillCellWithObject:model];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row >0) {
        TradeModel *model = _dataArrays[indexPath.row -1];
        TradeInfoViewController *viewController = [[TradeInfoViewController alloc] init];
        viewController.tradeModel = model;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma 获取交易记录列表
-(void)requestTransactionHash
{
    if (isHeaderRefresh == NO) {
        [self createLoadingView:nil];
    }

    //地址去掉0x
    NSString *from = [_walletModel.address componentsSeparatedByString:@"x"].lastObject;
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:BaseServerUrl]];
    [client invokeMethod:@"sec_getTransactions" withParameters:@[from] requestId:@(1) success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSInteger status = [dic[@"status"] integerValue];
        [self hiddenLoadingView];
        [self hiddenRefreshView];
        if (status == 1) {
            NSArray *Chainlist = dic[@"resultInChain"];
            if (Chainlist.count > 0) {
                for (NSDictionary *dic in Chainlist) {
                    TradeModel *model = [[TradeModel alloc]initWithDictionary:dic walletAddress:from];
                    [_dataArrays addObject:model];
                }
            }
            NSArray *Poollist = dic[@"resultInPool"];
            if (Poollist.count > 0) {
                for (NSDictionary *dic in Poollist) {
                    TradeModel *model = [[TradeModel alloc]initWithDictionary:dic walletAddress:from];
                    [_dataArrays addObject:model];
                }
            }
            if (_dataArrays.count > 0) {
                /*************保存交易记录*************/
                NSString *fileName = [NSString stringWithFormat:@"recodeList_%@",_tokenCoinModel.name];
                NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:fileName];
                NSMutableData* data = [NSMutableData data];
                NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                [archiver encodeObject:_dataArrays forKey:fileName];
                [archiver finishEncoding];
                [data writeToFile:path atomically:YES];
                [_noRemindView removeFromSuperview];
                [_infoTableView reloadData];
                
                //当刷新出了新数据则弹出提示  recodeListCache
                if (_dataArrays.count > recodeListCache.count && isHeaderRefresh == YES) {
                    [self hudShowWithString:[NSString stringWithFormat:@"已更新%ld条数据",_dataArrays.count-recodeListCache.count] delayTime:3];
                }
                
            }else{
                _dataArrays = [NSMutableArray array];
                [_infoTableView reloadData];
                [_noRemindView removeFromSuperview];
                _noRemindView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth -Size(200))/2, (kScreenHeight -Size(220))/2, Size(200), Size(200))];
                _noRemindView.image = [UIImage imageNamed:@"noTradeInfoBkg"];
                [_infoTableView addSubview:_noRemindView];
            }
            
            _infoTableView.hidden = NO;
            transferBT.hidden = NO;
            gatherBT.hidden = NO;
            _noNetworkView.hidden = YES;
            
        }else{
            [self hudShowWithString:@"数据获取失败" delayTime:1.5];
            _dataArrays = [NSMutableArray array];
            [_infoTableView reloadData];
            [_noRemindView removeFromSuperview];
            _noRemindView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth -Size(200))/2, (kScreenHeight -Size(220))/2, Size(200), Size(200))];
            _noRemindView.image = [UIImage imageNamed:@"noTradeInfoBkg"];
            [_infoTableView addSubview:_noRemindView];
            
            _infoTableView.hidden = NO;
            transferBT.hidden = NO;
            gatherBT.hidden = NO;
            _noNetworkView.hidden = YES;
        }
        
        isHeaderRefresh = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取区块详情失败");
    }];
}

#pragma 转账
-(void)transferAction
{
    TransferViewController *viewController = [[TransferViewController alloc] init];
    viewController.tokenCoinModel = _tokenCoinModel;
    viewController.walletModel = _walletModel;
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma 收款
-(void)gatherAction
{
    AddressCodePayViewController *viewController = [[AddressCodePayViewController alloc] init];
    viewController.walletModel = _walletModel;
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
            connectNetwork = NO;
            //无网络视图
            if (recodeListCache == nil) {
                _infoTableView.hidden = YES;
                transferBT.hidden = YES;
                gatherBT.hidden = YES;
                _noNetworkView.hidden = NO;
            }
        }else{
            connectNetwork = YES;
            _infoTableView.hidden = NO;
            transferBT.hidden = NO;
            gatherBT.hidden = NO;
            _noNetworkView.hidden = YES;
        }
    }];
}

-(void)addNoNetworkView
{
    _noNetworkView = [[UIView alloc] initWithFrame:CGRectMake(0, -Size(20), kScreenWidth, kScreenHeight)];
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
    [self requestTransactionHash];
}

@end
