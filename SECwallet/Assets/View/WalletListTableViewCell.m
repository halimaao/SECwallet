//
//  WalletListTableViewCell.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "WalletListTableViewCell.h"
#import "WalletModel.h"

@interface WalletListTableViewCell()

@property (nonatomic , strong) id object;

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIButton *adress;
@property (nonatomic, strong) UILabel *balance;
@property (nonatomic, strong) UILabel *balance_CNY;
@property (nonatomic, strong) UIImageView *backupIV;

@end

@implementation WalletListTableViewCell

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
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(Size(20), Size(15), Size(45), Size(45))];
    [self addSubview:_icon];
    
    //名称
    _name = [[UILabel alloc] initWithFrame:CGRectMake(_icon.maxX +Size(10), Size(10), Size(200), Size(20))];
    _name.textColor = TEXT_BLACK_COLOR;
    _name.font = SystemFontOfSize(18);
    [self addSubview:_name];
    
    //备份助记词
    _backupIV = [[UIImageView alloc]init];
    [self addSubview:_backupIV];
    
    _adress = [[UIButton alloc] initWithFrame:CGRectMake(_name.minX, _name.maxY, Size(200), _name.height)];
    _adress.titleLabel.font = SystemFontOfSize(15);
    [_adress setTitleColor:TEXT_DARK_COLOR forState:UIControlStateNormal];
    _adress.userInteractionEnabled = NO;
    [self addSubview:_adress];
    
    //余额
    _balance = [[UILabel alloc] initWithFrame:CGRectMake(0, kTableCellHeight -Size(25 +20), kScreenWidth -Size(30), Size(20))];
    _balance.textColor = TEXT_BLACK_COLOR;
    _balance.textAlignment = NSTextAlignmentRight;
    _balance.font = SystemFontOfSize(18);
    [self addSubview:_balance];
    
    _balance_CNY = [[UILabel alloc] initWithFrame:CGRectMake(0, _balance.maxY, _balance.width, _balance.height)];
    _balance_CNY.textColor = TEXT_DARK_COLOR;
    _balance_CNY.textAlignment = NSTextAlignmentRight;
    _balance_CNY.font = SystemFontOfSize(14);
//    [self addSubview:_balance_CNY];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.object isMemberOfClass:[WalletModel class]]) {
        WalletModel *obj = self.object;
        _icon.image = [UIImage imageNamed:obj.walletIcon];
        _name.text = obj.walletName;
        CGSize size = [obj.walletName calculateSize:SystemFontOfSize(18) maxWidth:kScreenWidth -Size(40)];
        _name.frame = CGRectMake(_icon.maxX +Size(10), Size(10), size.width, Size(20));
        //备份按钮
        if (obj.isBackUpMnemonic == NO) {
            _backupIV.frame = CGRectMake(_name.maxX +Size(10), _name.minY +Size(20 -18)/2, Size(50), Size(18));
            _backupIV.image = [UIImage imageNamed:@"backup2"];
        }
        [_adress setTitle:obj.address forState:UIControlStateNormal];
        _balance.text = [NSString stringWithFormat:@"%@ ETH",obj.balance];
        _balance_CNY.text = [NSString stringWithFormat:@"≈%@ CNY",obj.balance_CNY];
    }
}

-(void) fillCellWithObject:(id) object
{
    self.object = object;
}


@end
