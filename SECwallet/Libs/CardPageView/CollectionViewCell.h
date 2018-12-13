//
//  CollectionViewCell.h
//  CollectionCardPage
//
//  Created by ymj_work on 16/5/28.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *bkgIV;    //背景图
@property (nonatomic,strong) UIImageView *headerIV;
@property (nonatomic,strong) UILabel* nameLb;
@property (nonatomic,strong) UIButton* backupBT;  //备份按钮
@property (nonatomic,strong) UIButton* addressBT;  //地址
@property (nonatomic,strong) UILabel* totalSumLb;  //总资产
@property (nonatomic,strong) UIButton *addBT;     //添加代币按钮


@end
