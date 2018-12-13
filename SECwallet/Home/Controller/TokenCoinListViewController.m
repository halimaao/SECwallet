//
//  TokenCoinListViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/19.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "TokenCoinListViewController.h"
#import "TokenCoinSelectTableViewCell.h"
#import "TokenCoinModel.h"

@interface TokenCoinListViewController()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArrays;  //列表列表
    BOOL isRefresh;
}
@property (nonatomic, strong) UITableView *infoTableView;

@end

@implementation TokenCoinListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavgationItemTitle:@"添加资产"];
    _dataArrays = [NSMutableArray array];
//    TokenCoinModel *model1 = [[TokenCoinModel alloc]init];
//    model1.icon = @"ETH";
//    model1.name = @"ETH";
//    model1.subName = @"Ethereum";
//    model1.contract = CECtoken;
//    TokenCoinModel *model2 = [[TokenCoinModel alloc]init];
//    model2.icon = @"CEC";
//    model2.name = @"CEC";
//    model2.subName = @"CEC";
//    model2.contract = ETHtoken;
//    TokenCoinModel *model3 = [[TokenCoinModel alloc]init];
//    model3.icon = @"SEC";
//    model3.name = @"SEC";
//    model3.subName = @"Social Ecommerce Chain";
//    model3.contract = SECtoken;
//    TokenCoinModel *model4 = [[TokenCoinModel alloc]init];
//    model4.icon = @"INT";
//    model4.name = @"INT";
//    model4.subName = @"INT chain";
//    model4.contract = INTtoken;
//    [_dataArrays addObjectsFromArray:@[model1,model2,model3,model4]];
    
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
    return _dataArrays.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? Size(8) :0.1f;
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
    //每个单元格的视图
    static NSString *itemCell = @"cell_item";
    TokenCoinSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil)
    {
        cell = [[TokenCoinSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TokenCoinModel *obj = _dataArrays[indexPath.row];
    [cell fillCellWithObject:obj with:_walletModel];
    
    return cell;
}

-(void)viewWillDisappear:(BOOL)animated
{
    //判断代币列表是否有变化，有变化则通知刷新数据
    /***********获取最新钱包信息***********/
    WalletModel *currentModel = [[WalletModel alloc]init];
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* datapath = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
    NSMutableArray *list = [NSMutableArray array];
    list = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    for (int i = 0; i< list.count; i++) {
        WalletModel *model = list[i];
        if ([model.walletName isEqualToString:_walletModel.walletName]) {
            currentModel = model;
        }
    }
    NSMutableArray *mutList = [NSMutableArray arrayWithArray:currentModel.tokenCoinList];
    if (mutList.count != _walletModel.tokenCoinList.count) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletPageView object:nil];
    }
    
    [super viewWillDisappear:animated];
}

@end
