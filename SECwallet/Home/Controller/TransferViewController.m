//
//  TransferViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/15.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "TransferViewController.h"
#import "CommonHtmlShowViewController.h"
#import "TradeDetailView.h"
#import "AddressListViewController.h"
#import "ethers/Account.h"
#import "ethers/JsonRpcProvider.h"
#import "ethers/SecureData.h"

#define kTableCellHeight Size(45)

@interface TransferViewController ()<UITableViewDelegate,UITableViewDataSource,TradeDetailViewDelegate,UITextFieldDelegate,AddressListViewControllerDelegate>
{
    UIScrollView *addressContentView;
    UITextField *addressTF;
    UITextField *moneyTF;
    UITextField *tipTF;   //备注
    UILabel *gasLb;
}

@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) TradeDetailView *tradeDetailView;
@property (nonatomic,strong)UISlider *gasSlider;

@property (nonatomic, assign) NSUInteger nonce;

@end

@implementation TransferViewController

//------- 懒加载 -------//
- (TradeDetailView *)tradeDetailView {
    if (!_tradeDetailView) {
        _tradeDetailView = [[TradeDetailView alloc]init];
        _tradeDetailView.delegate = self;
    }
    return _tradeDetailView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavgationItemTitle:[NSString stringWithFormat:@"%@转账",_tokenCoinModel.name]];
    [self addInfoTableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboardAction)];
    [self.view addGestureRecognizer:tap];
    
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
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Size(200))];
    /*****************下一步*****************/
    CGFloat padddingLeft = Size(20);
    UIButton *creatBT = [[UIButton alloc] initWithFrame:CGRectMake(padddingLeft, Size(100), kScreenWidth - 2*padddingLeft, Size(45))];
    [creatBT goldBigBtnStyle:@"下一步"];
    [creatBT addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:creatBT];
    
    return footView;
}

-(void)sliderValueChanged:(UISlider *)paramSender
{
    [self dismissKeyboardAction];
    if ([paramSender isEqual:_gasSlider]) {
        gasLb.text = [NSString stringWithFormat:@"%.8f eth",paramSender.value];
    }
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
        //地址薄
        UIButton *addressListBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -Size(20 +15), (kTableCellHeight -Size(20))/2, Size(20), Size(20))];
        [addressListBtn setBackgroundImage:[UIImage imageNamed:@"contact"] forState:UIControlStateNormal];
        [addressListBtn addTarget:self action:@selector(addressListBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:addressListBtn];
        addressContentView = [[UIScrollView alloc]initWithFrame:CGRectMake(Size(15), 0, kScreenWidth -Size(15 +45), kTableCellHeight)];
        addressContentView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        [cell.contentView addSubview:addressContentView];
        addressTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, addressContentView.width, kTableCellHeight)];
        addressTF.font = SystemFontOfSize(16);
        addressTF.textColor = TEXT_BLACK_COLOR;
        addressTF.delegate = self;
        addressTF.keyboardType = UIKeyboardTypeNamePhonePad;
        addressTF.placeholder = @"收款人钱包地址";
        [addressContentView addSubview:addressTF];
        
    }else if (indexPath.row == 1) {
        moneyTF = [[UITextField alloc]initWithFrame:CGRectMake(Size(15), 0, addressTF.width, kTableCellHeight)];
        moneyTF.font = SystemFontOfSize(16);
        moneyTF.textColor = TEXT_BLACK_COLOR;
        moneyTF.placeholder = @"转账金额";
        moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
        [cell.contentView addSubview:moneyTF];
        
    }else if (indexPath.row == 2) {
        tipTF = [[UITextField alloc]initWithFrame:CGRectMake(moneyTF.minX, 0, kScreenWidth-Size(15*2), kTableCellHeight)];
        tipTF.font = SystemFontOfSize(16);
        tipTF.textColor = TEXT_BLACK_COLOR;
        tipTF.placeholder = @"备注";
        [cell.contentView addSubview:tipTF];
    }
    return cell;
}

#pragma UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGSize size = [textField.text calculateSize:SystemFontOfSize(16) maxWidth:kScreenWidth*2];
    if (size.width > kScreenWidth -Size(75)) {
        addressTF.frame = CGRectMake(0, 0, size.width, kTableCellHeight);
        [addressContentView setContentSize:CGSizeMake(size.width+Size(10), kTableCellHeight)];
    }else{
        addressTF.frame = CGRectMake(0, 0, kScreenWidth -Size(15 +45), kTableCellHeight);
        [addressContentView setContentSize:CGSizeMake(kScreenWidth -Size(15 +45), kTableCellHeight)];
    }
}

#pragma mark 下一步
-(void)nextAction
{
    addressTF.text = @"0xfa9461cc20fbb1b0937aa07ec6afc5e660fe2afd";
    [self dismissKeyboardAction];
    if (addressTF.text.length == 0) {
        [self hudShowWithString:@"请输入收款人钱包地址" delayTime:1.5];
        return;
    }
    //判断扫描的是否为钱包地址(前缀是0x并且长度为42位)
    if (!([addressTF.text hasPrefix:@"0x"] && addressTF.text.length == 42)) {
        [self hudShowWithString:@"地址不正确，请重新输入" delayTime:1.5];
        return;
    }
    if ([addressTF.text isEqualToString:_walletModel.address]) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"同一地址之间不能转账哦" message:@"您的收款地址和当前钱包地址一致" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alertView show];
        return;
    }
    if (moneyTF.text.length == 0) {
        [self hudShowWithString:@"请输入转账金额" delayTime:1.5];
        return;
    }
    if ([moneyTF.text floatValue] == 0) {
        [self hudShowWithString:@"转账金额不能为零" delayTime:1.5];
        return;
    }
    if ([moneyTF.text floatValue] > [_tokenCoinModel.tokenNum floatValue]) {
        [self hudShowWithString:@"代币余额不足，无法转账" delayTime:1.5];
        return;
    }
    if ([_walletModel.balance floatValue] == 0) {
        [self hudShowWithString:@"钱包余额不足，无法转账" delayTime:1.5];
        return;
    }
    
    NSString *gasStr = [gasLb.text componentsSeparatedByString:@"eth"].firstObject;
    [self.tradeDetailView initTradeDetailViewWith:addressTF.text payAddress:_walletModel.address gasPrice:gasStr sum:moneyTF.text tokenName:_tokenCoinModel.name];
}

-(void)tipBtnAction
{
    [self dismissKeyboardAction];
    CommonHtmlShowViewController *viewController = [[CommonHtmlShowViewController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.commonHtmlShowViewType = CommonHtmlShowViewType_RgsProtocol;
    viewController.titleStr = @"什么是GAS费用？";
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma TradeDetailViewDelegate
-(void)clickFinish
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入钱包密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *pswTF = alertController.textFields.firstObject;
        if (pswTF.text.length == 0) {
            [self hudShowWithString:@"密码不能为空" delayTime:1];
            return;
        }else{
            if ([pswTF.text isEqualToString:_walletModel.loginPassword]) {
                /***************************开始转账****************************/
                [self createLoadingView:@"正在转账..."];
                __block Account *a;
                __block JsonRpcProvider *e = [[JsonRpcProvider alloc]initWithChainId:ChainIdHomestead url:[NSURL URLWithString:BaseServerUrl]];
                NSData *jsonData = [_walletModel.keyStore dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                //地址
                __block NSString *addressStr = [NSString stringWithFormat:@"0x%@",dic[@"address"]];
                __block Transaction *transaction = [Transaction transactionWithFromAddress:[Address addressWithString:addressStr]];
                //1 account自己解密
                NSLog(@"1 开始新建钱包");
                __block Signature *signature;
//                NSString *r_str;NSString *s_str;NSString *v_str;
                [Account decryptSecretStorageJSON:_walletModel.keyStore password:_walletModel.walletPassword callback:^(Account *account, NSError *NSError) {
                    if (NSError == nil){
                        a = account;
                        transaction.nonce = 1;  //????
                        NSLog(@"4 开始获取gasPrice");
                        transaction.gasPrice = [BigNumber bigNumberWithDecimalString:@"0"];
                        transaction.toAddress = [Address addressWithString:addressTF.text];
                        //转账金额
                        BigNumber *b = [BigNumber bigNumberWithDecimalString:moneyTF.text];
                        transaction.value = b;
                        //如果是eth转账
                        transaction.gasLimit = [BigNumber bigNumberWithDecimalString:@"0"];
                        transaction.data = [SecureData secureDataWithCapacity:0].data;
                        //签名
                        [a sign:transaction];
                        //发送
//                        NSData *signedTransaction = [transaction serialize];
                        NSLog(@"6 开始转账");
                        signature = transaction.signature;
                        NSLog(@"\n%@\n%@\n%d",[SecureData dataToHexString:signature.r],[SecureData dataToHexString:signature.s],signature.v);
                        
                    }else{
                        NSLog(@"密码错误");
                    }
                }];
                
                
                //地址去掉0x
                NSString *from = [_walletModel.address componentsSeparatedByString:@"x"].lastObject;
                NSString *to = [addressTF.text componentsSeparatedByString:@"x"].lastObject;
                NSString *value = [NSString hex_16_StringFromDecimal:[moneyTF.text integerValue]];
                value = moneyTF.text;
                NSString *timestamp = [NSString stringWithFormat:@"%0.f",[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000];
                NSDictionary *data = @{@"v":@(signature.v),@"r":[[SecureData dataToHexString:signature.r] componentsSeparatedByString:@"x"].lastObject,@"s":[[SecureData dataToHexString:signature.s] componentsSeparatedByString:@"x"].lastObject};
                NSString *inputData = tipTF.text.length > 0 ? tipTF.text : @"";
                
                //            timestamp: 1543457005562, // number
                //            from: 'fa9461cc20fbb1b0937aa07ec6afc5e660fe2afd', // 40 bytes address
                //            to: '8df9628de741b3d42c6f4a29ed4572b0f05fe8b4', // 40 bytes address
                //            value: '110.5235', // string
                //            gasLimit: '0', // string, temporarily set to 0
                //            gas: '0', // string, temporarily set to 0
                //            gasPrice: '0', // string, temporarily set to 0
                //            inputData: 'Sec test transaction', // string, user defined extra messages
                //            data: {
                //            v: 28, // number
                //            r: 'f17c29dd068953a474675a65f59c75c6189c426d1c60f43570cc7220ca3616c3', // 64 bytes string
                //            s: '54f9ff243b903b7419dd566f277eedadf6aa55161f5d5e42005af29b14577902' // 64 bytes string
                //            }
                
                data = @{@"v":@(28
                             ),@"r":@"f17c29dd068953a474675a65f59c75c6189c426d1c60f43570cc7220ca3616c3",@"s":@"54f9ff243b903b7419dd566f277eedadf6aa55161f5d5e42005af29b14577902"};
                from = @"fa9461cc20fbb1b0937aa07ec6afc5e660fe2afd";
                to = @"8df9628de741b3d42c6f4a29ed4572b0f05fe8b4";
                value = @"110.5235";
                timestamp = @"1543457005562";
                inputData = @"Sec test transaction";
                
                AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:BaseServerUrl]];
                [client invokeMethod:@"sec_sendRawTransaction" withParameters:@[@{@"timestamp":@([timestamp integerValue]),
                                                                                  @"from":from,
                                                                                  @"to":to,
                                                                                  @"value":value,
                                                                                  @"gasLimit":@"0",
                                                                                  @"gas":@"0",
                                                                                  @"gasPrice":@"0",
                                                                                  @"inputData":inputData,
                                                                                  @"data":data}] requestId:@(1) success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                      NSDictionary *dic = responseObject;
                                                                                      NSInteger status = [dic[@"status"] integerValue];
                                                                                      if (status == 1) {
                                                                                          [self hiddenLoadingView];
                                                                                          [self hudShowWithString:@"转账成功" delayTime:3];
                                                                                          //延迟执行
                                                                                          [self performSelector:@selector(delayMethod) withObject:nil afterDelay:4.0];
                                                                                      }
                                                                                      
                                                                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                      [self hiddenLoadingView];
                                                                                      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"转账失败" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                                                                                      [alert show];
                                                                                  }];
                
                
                
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

-(void)delayMethod
{
    int sum = [_tokenCoinModel.tokenNum intValue] - [moneyTF.text intValue];
    _tokenCoinModel.tokenNum = [NSString stringWithFormat:@"%d",sum];
    [self backAction];
}
#pragma 地址薄
-(void)addressListBtnAction
{
    [self dismissKeyboardAction];
    AddressListViewController *controller = [[AddressListViewController alloc]init];
    controller.delegate = self;
    controller.isDelegate = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 点击空白处收回键盘
-(void)dismissKeyboardAction
{
    [addressTF resignFirstResponder];
    [moneyTF resignFirstResponder];
    [tipTF resignFirstResponder];
}

#pragma AddressListViewControllerDelegate
-(void)sendScanCode:(NSString *)codeStr
{
    if ([codeStr containsString:@"###"]) {
        NSArray *arr = [codeStr componentsSeparatedByString:@"###"];
        addressTF.text = arr[0];
        moneyTF.text = arr[1];
    }else{
        addressTF.text = codeStr;
    }
    CGSize size = [addressTF.text calculateSize:SystemFontOfSize(16) maxWidth:kScreenWidth*2];
    addressTF.frame = CGRectMake(0, 0, size.width+Size(10), kTableCellHeight);
    [addressContentView setContentSize:CGSizeMake(size.width, kTableCellHeight)];
}

@end
