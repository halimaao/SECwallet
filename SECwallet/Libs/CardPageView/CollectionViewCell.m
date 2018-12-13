//
//  CollectionViewCell.m
//  CollectionCardPage
//
//  Created by ymj_work on 16/5/22.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景图
        _bkgIV = [[UIImageView alloc] initWithFrame:self.bounds];
        _bkgIV.layer.cornerRadius = Size(5);
        _bkgIV.layer.masksToBounds = YES;
        [self.contentView addSubview:_bkgIV];
        
        //头像
        _headerIV = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width -Size(40))/2, Size(8), Size(40), Size(40))];
        [self.contentView addSubview:_headerIV];
        
        _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(10), 0, Size(150), Size(40))];
        _nameLb.font = SystemFontOfSize(16);
        _nameLb.textColor = WHITE_COLOR;
        _nameLb.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLb];
        
        _backupBT = [[UIButton alloc]initWithFrame:CGRectMake(_nameLb.maxX +Size(10), _nameLb.minY +Size(25 -18)/2, Size(50), Size(18))];
        [_backupBT setBackgroundImage:[UIImage imageNamed:@"backup1"] forState:UIControlStateNormal];
        [self.contentView addSubview:_backupBT];
        
        //地址
        _addressBT = [[UIButton alloc]initWithFrame:CGRectMake(self.width/4, _nameLb.maxY +Size(40), self.width/2, Size(15))];
        _addressBT.titleLabel.font = SystemFontOfSize(12);
        [_addressBT setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        [_addressBT setImage:[UIImage imageNamed:@"codeIcon"] forState:UIWindowLevelNormal];
        _addressBT.contentEdgeInsets = UIEdgeInsetsMake(0, -Size(10), 0, 0);
        _addressBT.imageEdgeInsets = UIEdgeInsetsMake(0, _addressBT.titleLabel.width + self.width/2, 0, -_addressBT.titleLabel.width - self.width/2);
        _addressBT.titleEdgeInsets = UIEdgeInsetsMake(0, -_addressBT.currentImage.size.width, 0, _addressBT.currentImage.size.width);
        _addressBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.contentView addSubview:_addressBT];
        
        _totalSumLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(10), _addressBT.maxY, self.width, Size(30))];
        _totalSumLb.font = SystemFontOfSize(28);
        _totalSumLb.textColor = WHITE_COLOR;
        [self.contentView addSubview:_totalSumLb];
        //描述
        UILabel *desLb = [[UILabel alloc]initWithFrame:CGRectMake(_totalSumLb.minX, _totalSumLb.maxY, _totalSumLb.width, Size(10))];
        desLb.font = SystemFontOfSize(12);
        desLb.textColor = WHITE_COLOR;
        desLb.text = @"总资产";
        [self.contentView addSubview:desLb];

        //添加按钮
        _addBT = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width -Size(20 +10), self.frame.size.height -Size(55), Size(20), Size(20))];
        [_addBT setBackgroundImage:[UIImage imageNamed:@"addIcon"] forState:UIControlStateNormal];
//        [self.contentView addSubview:_addBT];
        
    }
    return self;
}

@end

