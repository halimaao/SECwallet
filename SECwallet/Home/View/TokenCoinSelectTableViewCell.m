//
//  TokenCoinSelectTableViewCell.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/19.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "TokenCoinSelectTableViewCell.h"
#import "TokenCoinModel.h"

@interface TokenCoinSelectTableViewCell()

@property (nonatomic , strong) id object;
@property (nonatomic , strong) WalletModel *walletModel;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *subName;
@property (nonatomic, strong) UIButton *contract;
@property (nonatomic, strong) UIButton *selectBT;

@end

@implementation TokenCoinSelectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void) initView
{
    //图标
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(Size(10), (kTableCellHeight -Size(35))/2, Size(35), Size(35))];
    [self addSubview:_icon];
    
    //名称
    _name = [[UILabel alloc] initWithFrame:CGRectMake(_icon.maxX +Size(10), _icon.minY, Size(80), Size(15))];
    _name.textColor = TEXT_BLACK_COLOR;
    _name.font = SystemFontOfSize(18);
    [self addSubview:_name];
    
    _subName = [[UILabel alloc] initWithFrame:CGRectMake(_name.minX, _name.maxY, Size(135), Size(15))];
    _subName.textColor = TEXT_DARK_COLOR;
    _subName.font = SystemFontOfSize(13);
    [self addSubview:_subName];
    
    //合约
    _contract = [[UIButton alloc] initWithFrame:CGRectMake(_subName.minX -Size(2), _subName.maxY, _subName.width, _subName.height)];
    _contract.titleLabel.font = SystemFontOfSize(12);
    [_contract setTitleColor:TEXT_DARK_COLOR forState:UIControlStateNormal];
    [self addSubview:_contract];
    
    _selectBT = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -Size(55 +15), (kTableCellHeight -Size(37))/2, Size(55), Size(37))];
    [_selectBT setTitleColor:CLEAR_COLOR forState:UIControlStateNormal];
    [_selectBT addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectBT];
    _selectBT.hidden = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.object isMemberOfClass:[TokenCoinModel class]]) {
        TokenCoinModel *obj = self.object;
        _icon.image = [UIImage imageNamed:obj.icon];
        _name.text = obj.name;
        _subName.text = obj.subName;
        [_contract setTitle:obj.contract forState:UIControlStateNormal];
        [_selectBT setTitle:obj.name forState:UIControlStateNormal];

        if ([obj.name isEqualToString:@"CEC"] || [obj.name isEqualToString:@"ETH"]) {
            _selectBT.hidden = YES;
        }else{
            _selectBT.hidden = NO;
        }
        if ([_walletModel.tokenCoinList containsObject:obj.name]) {
            [_selectBT setBackgroundImage:[UIImage imageNamed:@"tokenCoinselect"] forState:UIControlStateNormal];
        }else{
            [_selectBT setBackgroundImage:[UIImage imageNamed:@"tokenCoinnoSelect"] forState:UIControlStateNormal];
        }
    }
}

-(void) fillCellWithObject:(id) object with:(WalletModel *)walletModel
{
    self.object = object;
    _walletModel = walletModel;
}

-(void)selectAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    /***********获取当前钱包信息***********/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* datapath = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
    NSMutableArray *list = [NSMutableArray array];
    list = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    for (int i = 0; i< list.count; i++) {
        WalletModel *model = list[i];
        if ([model.walletName isEqualToString:_walletModel.walletName]) {
            _walletModel = model;
        }
    }
    NSMutableArray *mutList = [NSMutableArray arrayWithArray:_walletModel.tokenCoinList];
    UIButton *bt = (UIButton *)sender;
    if (sender.selected) {
        if ([_walletModel.tokenCoinList containsObject:bt.titleLabel.text]) {
            [mutList removeObject:bt.titleLabel.text];
            [_selectBT setBackgroundImage:[UIImage imageNamed:@"tokenCoinnoSelect"] forState:UIControlStateNormal];
        }else{
            [mutList addObject:bt.titleLabel.text];
            [_selectBT setBackgroundImage:[UIImage imageNamed:@"tokenCoinselect"] forState:UIControlStateNormal];
        }
    }else{
        if ([_walletModel.tokenCoinList containsObject:bt.titleLabel.text]) {
            [mutList removeObject:bt.titleLabel.text];
            [_selectBT setBackgroundImage:[UIImage imageNamed:@"tokenCoinnoSelect"] forState:UIControlStateNormal];
        }else{
            [mutList addObject:bt.titleLabel.text];
            [_selectBT setBackgroundImage:[UIImage imageNamed:@"tokenCoinselect"] forState:UIControlStateNormal];
        }
    }
    /***********更新当前钱包信息***********/
    for (int i = 0; i< list.count; i++) {
        WalletModel *model = list[i];
        if ([model.walletName isEqualToString:_walletModel.walletName]) {
            [model setTokenCoinList:mutList];
            [list replaceObjectAtIndex:i withObject:model];
        }
    }
    //替换list中当前钱包信息
    NSMutableData* data = [NSMutableData data];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:list forKey:@"walletList"];
    [archiver finishEncoding];
    [data writeToFile:path atomically:YES];
        
}

@end
