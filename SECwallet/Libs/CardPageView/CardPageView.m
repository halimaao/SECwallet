//
//  CardPage.m
//  CardPage
//
//  Created by ymj_work on 16/5/22.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import "CardPageView.h"
#import "CollectionFlowLayout.h"
#import "CollectionViewCell.h"
#import "WalletModel.h"

#define COUNT  10

@interface CardPageView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    float cellWidth;
    float cellHeight;
    float itemSpacing;
}

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSArray *walletArray;

@property (nonatomic,assign) CGRect collectionViewRect;
@property (nonatomic,assign) CGRect pageControlRect;

@end

@implementation CardPageView

- (id)initWithFrame:(CGRect)frame withWalletList:(NSArray *)walletList;

{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR(242, 242, 242, 1);
        [self initData];
        cellWidth = self.frame.size.width -Size(25 *2);
        cellHeight = self.frame.size.height -Size(15);
        itemSpacing = Size(5);
        _walletArray = walletList;
        
        [self initSubviews];
    }
    return self;
}

-(void)initData
{
    _collectionViewRect = CGRectMake(0, Size(12), self.frame.size.width, self.frame.size.height -Size(15));
    _pageControlRect = CGRectMake(0, _collectionViewRect.origin.y +_collectionViewRect.size.height -Size(15), kScreenWidth, Size(15));
}

-(void)initSubviews{
    
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

-(UICollectionView*)collectionView{
    //自定义UICollectionViewFlowLayout
    UICollectionViewFlowLayout *layout = [[CollectionFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = itemSpacing;
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
    //初始化collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:_collectionViewRect collectionViewLayout:layout];
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    _collectionView.backgroundColor = CLEAR_COLOR;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    return _collectionView;
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (_walletArray.count == 1) {
        return UIEdgeInsetsMake(0, Size(25), 0, Size(25));
    }else{
        return UIEdgeInsetsMake(0, Size(15), 0, Size(15));
    }
}

-(UIPageControl*)pageControl{
    _pageControl = [[UIPageControl alloc]initWithFrame:_pageControlRect];
    _pageControl.numberOfPages = _walletArray.count > COUNT ? COUNT : _walletArray.count;  //固定
    [_pageControl setPageIndicatorTintColor:COLOR(216, 206, 193, 1)];
    [_pageControl setCurrentPageIndicatorTintColor:COLOR(186, 139, 81, 1)];
    return _pageControl;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _walletArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    WalletModel *model = _walletArray[indexPath.row];
    
    //随机分配背景
    NSString *bkgStr;
    if (indexPath.row == 0 || (indexPath.row)%3 == 0) {
        bkgStr = @"walletBkg0";
    }
    if (indexPath.row == 1 || (indexPath.row-1)%3 == 0) {
        bkgStr = @"walletBkg1";
    }
    if (indexPath.row == 2 || (indexPath.row-2)%3 == 0) {
        bkgStr = @"walletBkg2";
    }
    cell.bkgIV.image = [UIImage imageNamed:bkgStr];
    
    cell.headerIV.image = [UIImage imageNamed:model.walletIcon];
    CGSize size = [model.walletName calculateSize:SystemFontOfSize(16) maxWidth:cell.frame.size.width];
    cell.nameLb.frame = CGRectMake((cellWidth -size.width)/2, cell.headerIV.maxY +Size(2), size.width, Size(25));
    cell.nameLb.text = model.walletName;
    //备份按钮
    cell.backupBT.frame = CGRectMake(cell.nameLb.maxX +Size(10), cell.nameLb.minY +Size(25 -18)/2, Size(50), Size(18));
    if (model.isBackUpMnemonic == NO) {
        cell.backupBT.hidden = NO;
        [cell.backupBT addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.backupBT.tag = 1000;
    }else{
        cell.backupBT.hidden = YES;
    }
    
    [cell.addressBT setTitle:model.address forState:UIControlStateNormal];
    cell.totalSumLb.text = [NSString stringWithFormat:@"≈%@",model.balance];
    [cell.addressBT addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addressBT.tag = 1001;
    
    [cell.addBT addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addBT.tag = 1002;
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = (scrollView.contentOffset.x+self.bounds.size.width/2)/cellWidth;

    if (_walletArray.count > COUNT) {
        if (index < COUNT-1) {
            _pageControl.currentPage = index;  //0~8
        }else if (index >= COUNT-1 && index < _walletArray.count-1) {
            _pageControl.currentPage = COUNT-2; //8~(COUNT-1)都是8
        }else{
            _pageControl.currentPage = COUNT-1; //最后一个是9
        }
    }else{
        _pageControl.currentPage = index;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //滑动结束时显示
    int index = (scrollView.contentOffset.x+self.bounds.size.width/2)/(cellWidth+itemSpacing);
    [self.delegate refreshWallet:index clearCache:YES];
    
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* datapath = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
    NSMutableArray *walletList = [NSMutableArray array];
    walletList = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    _walletArray = walletList;
}

-(void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1000:
            //助记词备份事件
        {
            [self.delegate backUpMnemonicAction];
        }
            break;
        case 1001:
            //二维码收款事件
        {
            [self.delegate showAddressCodeAction];
        }
            break;
        case 1002:
            //添加代币事件
        {
            [self.delegate addTokenCoinAction];
        }
            break;
        default:
            break;
    }
}

@end
