//
//  AddressModel.h
//  SECwallet
//
//  Created by 通证控股 on 2018/10/17.
//  Copyright © 2018年 通证控股. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *name;        //姓名
@property (nonatomic, copy) NSString *phone;       //电话
@property (nonatomic, copy) NSString *address;     //钱包地址
@property (nonatomic, copy) NSString *email;       //邮箱
@property (nonatomic, copy) NSString *remark;      //备注

- (AddressModel*)initWithName:(NSString *)name
                     andPhone:(NSString *)phone
                   andAddress:(NSString *)address
                     andEmail:(NSString *)email
                    andRemark:(NSString *)remark;

@end
