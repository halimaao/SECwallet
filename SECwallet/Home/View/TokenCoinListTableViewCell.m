//
//  ItemListTableViewCell.m
//  TOP_zrt
//
//  Created by Laughing on 16/5/23.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import "TokenCoinListTableViewCell.h"
#import "TokenCoinModel.h"

@interface TokenCoinListTableViewCell()

@property (nonatomic , strong) id object;

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *balance;
@property (nonatomic, strong) UILabel *balance_CNY;

@end

@implementation TokenCoinListTableViewCell

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
    _name = [[UILabel alloc] initWithFrame:CGRectMake(_icon.maxX +Size(10), _icon.minY, Size(80), _icon.height)];
    _name.textColor = TEXT_BLACK_COLOR;
    _name.font = SystemFontOfSize(18);
    [self addSubview:_name];
    
    //额度
    _balance = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth -Size(200 +10), Size(10), Size(200), Size(20))];
    _balance.textColor = TEXT_BLACK_COLOR;
    _balance.textAlignment = NSTextAlignmentRight;
    _balance.font = BoldSystemFontOfSize(16);
    [self addSubview:_balance];
    
    //余额
    _balance_CNY = [[UILabel alloc] initWithFrame:CGRectMake(_balance.minX, _balance.maxY, _balance.width, Size(20))];
    _balance_CNY.textColor = TEXT_DARK_COLOR;
    _balance_CNY.textAlignment = NSTextAlignmentRight;
    _balance_CNY.font = SystemFontOfSize(13);
//    [self addSubview:_balance_CNY];
 
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.object isMemberOfClass:[TokenCoinModel class]]) {
        TokenCoinModel *obj = self.object;
        _icon.image = [UIImage imageNamed:obj.icon];
        _name.text = obj.name;
        _balance.text = obj.tokenNum;
        _balance_CNY.text = [NSString stringWithFormat:@"≈￥%@",obj.balance_CNY];
    }
}

-(void) fillCellWithObject:(id) object
{
    self.object = object;
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing: editing animated: YES];
    if (editing) {
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString: @"Reorder"].location != NSNotFound) {
                for (UIView * subview in view.subviews) {
                    if ([subview isKindOfClass: [UIImageView class]]) {
                        ((UIImageView *)subview).image = [UIImage imageNamed: @""];
                    }
                }
            }
        }
    }
}

@end
