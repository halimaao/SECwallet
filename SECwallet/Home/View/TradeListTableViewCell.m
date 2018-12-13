//
//  TradeListTableViewCell.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/11.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "TradeListTableViewCell.h"
#import "TradeModel.h"

@interface TradeListTableViewCell()

@property (nonatomic , strong) id object;

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIButton *address;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *sum;
@property (nonatomic, strong) UILabel *pendingLb;

@end

@implementation TradeListTableViewCell

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
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(Size(15), (kTableCellHeight -Size(25))/2, Size(25), Size(25))];
    [self addSubview:_icon];
    
    //地址
    _address = [[UIButton alloc] initWithFrame:CGRectMake(_icon.maxX +Size(5), _icon.minY -Size(3), Size(100), Size(15))];
    _address.titleLabel.font = SystemFontOfSize(14);
    [_address setTitleColor:TEXT_BLACK_COLOR forState:UIControlStateNormal];
    _address.userInteractionEnabled = NO;
    [self addSubview:_address];
    
    //时间
    _time = [[UILabel alloc] initWithFrame:CGRectMake(_address.minX, _address.maxY, Size(200), _address.height)];
    _time.textColor = TEXT_BLACK_COLOR;
    _time.font = SystemFontOfSize(14);
    [self addSubview:_time];
    
    //额度
    _sum = [[UILabel alloc] initWithFrame:CGRectMake(_address.maxX, _address.minY, kScreenWidth -_address.maxX -Size(15), _address.height)];
    _sum.textColor = TEXT_BLACK_COLOR;
    _sum.textAlignment = NSTextAlignmentRight;
    _sum.font = SystemFontOfSize(14);
    [self addSubview:_sum];
    
    _pendingLb = [[UILabel alloc] initWithFrame:CGRectMake(_sum.minX, _sum.maxY, _sum.width, _sum.height)];
    _pendingLb.textColor = TEXT_DARK_COLOR;
    _pendingLb.textAlignment = NSTextAlignmentRight;
    _pendingLb.font = SystemFontOfSize(14);
    [self addSubview:_pendingLb];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.object isMemberOfClass:[TradeModel class]]) {
        TradeModel *obj = self.object;
        
        //类型（1转入 2转出）
        if (obj.type == 1) {
            _icon.image = [UIImage imageNamed:@"gatherIcon"];  //转入
            [_address setTitle:obj.transferAddress forState:UIControlStateNormal];
            _time.text = obj.time;
             _sum.text = [NSString stringWithFormat:@"+%@ SEC",obj.sum];
            //设置不同字体颜色
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:_sum.text];
            [attStr addAttribute:NSForegroundColorAttributeName value:COLOR(33, 163, 72, 1) range:NSMakeRange(0, _sum.text.length -3)];
            _sum.attributedText = attStr;
  
        }else{
            _icon.image = [UIImage imageNamed:@"transferIcon"];  //转出
            [_address setTitle:obj.gatherAddress forState:UIControlStateNormal];
            _time.text = obj.time;
            _sum.text = [NSString stringWithFormat:@"-%@ SEC",obj.sum];
            //设置不同字体颜色
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:_sum.text];
            [attStr addAttribute:NSForegroundColorAttributeName value:COLOR(222, 57, 57, 1) range:NSMakeRange(0, _sum.text.length -3)];
            _sum.attributedText = attStr;
        }
        
        //交易状态(1成功 0失败 2打包中)
        if (obj.status == 0) {
            _icon.image = [UIImage imageNamed:@"fail"];
            //设置不同字体颜色
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:_sum.text];
            [attStr addAttribute:NSForegroundColorAttributeName value:TEXT_DARK_COLOR range:NSMakeRange(0, _sum.text.length -3)];
            _sum.attributedText = attStr;
        }
        if (obj.status == 2) {
            _pendingLb.text = @"打包中";
        }
    }
}

-(void) fillCellWithObject:(id) object
{
    self.object = object;
}

@end
