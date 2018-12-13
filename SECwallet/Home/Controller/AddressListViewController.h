//
//  AddressListViewController.h
//  SECwallet
//
//  Created by 通证控股 on 2018/10/17.
//  Copyright © 2018年 通证控股. All rights reserved.
//

#import "BaseViewController.h"

@protocol AddressListViewControllerDelegate;

@interface AddressListViewController : BaseViewController

@property (nonatomic, assign) BOOL isDelegate;
@property (nonatomic, weak)id<AddressListViewControllerDelegate> delegate;

@end

@protocol AddressListViewControllerDelegate <NSObject>

//扫码返回事件
-(void)sendScanCode:(NSString *)codeStr;

//cell点击返回事件
-(void)sendAddress:(NSString *)address;

@end

