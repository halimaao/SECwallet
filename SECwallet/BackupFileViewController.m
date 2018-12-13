//
//  BackupFileViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/9.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "BackupFileViewController.h"
#import "DWTagList.h"
#import "RootViewController.h"

@interface BackupFileViewController ()<DWTagListDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) DWTagList *tagList;  // 云标签
@property (nonatomic, copy) NSMutableArray *selectTagList;
@property (nonatomic, strong) DWTagList *showTagList;

@end

@implementation BackupFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavgationItemTitle:@"备份助记词"];
    [self setupUI];
    _selectTagList = [NSMutableArray array];
}

-(void)setupUI
{
    UILabel *titLb = [[UILabel alloc]initWithFrame:CGRectMake(0, Size(30), kScreenWidth, Size(25))];
    titLb.font = BoldSystemFontOfSize(18);
    titLb.textColor = TEXT_GOLD_COLOR;
    titLb.textAlignment = NSTextAlignmentCenter;
    titLb.text = @"确认你的钱包助记词";
    [self.view addSubview:titLb];
    
    UILabel *remindLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(20), titLb.maxY +Size(10), kScreenWidth -Size(20)*2, Size(40))];
    remindLb.font = SystemFontOfSize(16);
    remindLb.textColor = TEXT_DARK_COLOR;
    remindLb.numberOfLines = 2;
    remindLb.text = @"请按照顺序点击助记词，以确认你备份的助记词正确。";
    [self.view addSubview:remindLb];
    
    UIView *bkgView = [[UIView alloc]initWithFrame:CGRectMake(remindLb.minX, remindLb.maxY +Size(20), remindLb.width, Size(135))];
    bkgView.backgroundColor = DARK_COLOR;
    bkgView.layer.cornerRadius = Size(5);
    [self.view addSubview:bkgView];
    _showTagList = [[DWTagList alloc]initWithFrame:CGRectMake(Size(30), remindLb.maxY +Size(20) +Size(20), kScreenWidth - Size(30)*2, Size(120))];
    [_showTagList setTagBackgroundColor:WHITE_COLOR];
    _showTagList.textColor = TEXT_BLACK_COLOR;
    _showTagList.cornerRadius = Size(5);
    [_showTagList setTagHighlightColor:WHITE_COLOR];
    [_showTagList setTagDelegate:self];
    [self.view addSubview:_showTagList];
    
    _tagList = [[DWTagList alloc] initWithFrame:CGRectMake(Size(20), bkgView.maxY +Size(20), kScreenWidth - Size(20)*2, Size(120))];
    [_tagList setTagBackgroundColor:COLOR(209, 163, 101, 1)];
    [_tagList setTagHighlightColor:COLOR(200,3,16,1)];
    _tagList.cornerRadius = Size(5);
    NSArray *tagArr = [_walletModel.mnemonicPhrase componentsSeparatedByString:@" "];
    //打乱数组顺序
    tagArr = [tagArr sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    [_tagList setTags:tagArr andSelectTags:@[]];
    [_tagList setTagDelegate:self];
    [self.view addSubview:_tagList];
    
    /*****************确认*****************/
    UIButton *nextBT = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth -Size(155))/2, _tagList.maxY +Size(10), Size(155), Size(45))];
    [nextBT goldBigBtnStyle:@"确认"];
    [nextBT addTarget:self action:@selector(comfirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBT];
}

#pragma mark DWTagListDelegate
- (void)selectedDWTagList:(DWTagList *)tagList tag:(NSString *)tagName tagIndex:(NSInteger)tagIndex;
{
    if (tagList == _tagList) {
        if (![_selectTagList containsObject:tagName]) {
            [_selectTagList addObject:tagName];
            [_showTagList setTags:_selectTagList andSelectTags:@[]];
            
            NSArray *tagArr = [_walletModel.mnemonicPhrase componentsSeparatedByString:@" "];
            //打乱数组顺序
            tagArr = [tagArr sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
                int seed = arc4random_uniform(2);
                if (seed) {
                    return [str1 compare:str2];
                } else {
                    return [str2 compare:str1];
                }
            }];
            [_tagList setTags:tagArr andSelectTags:_selectTagList];
            
        }
    }else if (tagList == _showTagList) {
        //删除
        [_selectTagList removeObject:tagName];
        [_showTagList setTags:_selectTagList andSelectTags:@[]];
        NSArray *tagArr = [_walletModel.mnemonicPhrase componentsSeparatedByString:@" "];
        //打乱数组顺序
        tagArr = [tagArr sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
            int seed = arc4random_uniform(2);
            if (seed) {
                return [str1 compare:str2];
            } else {
                return [str2 compare:str1];
            }
        }];
        [_tagList setTags:tagArr andSelectTags:_selectTagList];
    }
}

-(void)comfirmAction
{
    NSArray *tagArr = [_walletModel.mnemonicPhrase componentsSeparatedByString:@" "];
    if (tagArr.count > _selectTagList.count) {
        [self hudShowWithString:@"助记词填写不完整" delayTime:2];
        return;
    }
    NSString *tagStr = [_selectTagList componentsJoinedByString:@" "];
    if ([tagStr isEqualToString:_walletModel.mnemonicPhrase]) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"是否删除本地助记词" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alertView show];

    }else{
        [self hudShowWithString:@"助记词顺序不正确" delayTime:2];
    }
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
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
                [model setIsBackUpMnemonic:1];
                if (model.isFromMnemonicImport == YES) {
                    [model setIsFromMnemonicImport:0];
                }
                [list replaceObjectAtIndex:i withObject:model];
            }
        }
        //替换list中当前钱包信息
        NSMutableData* data = [NSMutableData data];
        NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:list forKey:@"walletList"];
        [archiver finishEncoding];
        [data writeToFile:path atomically:YES];
        //进入首页
        RootViewController *controller = [[RootViewController alloc] init];
        AppDelegateInstance.window.rootViewController = controller;
        [AppDelegateInstance.window makeKeyAndVisible];
        
        /*************创建钱包成功后删除之前代币数据缓存*************/
        [CacheUtil clearTokenCoinTradeListCacheFile];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletInfoUI object:nil];
    }
}

@end
