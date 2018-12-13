//
//  EditAddressViewController.h
//  SECwallet
//
//  Created by 通证控股 on 2018/10/17.
//  Copyright © 2018年 通证控股. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressModel.h"

typedef enum {
    ManageAddressViewType_add = 1,
    ManageAddressViewType_edit = 2,
} ManageAddressViewType;

@interface ManageAddressViewController : BaseViewController

@property (nonatomic, assign) int manageAddressViewType;
@property (nonatomic, strong) AddressModel *currentModel;

@end
