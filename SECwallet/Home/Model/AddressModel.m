//
//  AddressModel.m
//  SECwallet
//
//  Created by 通证控股 on 2018/10/17.
//  Copyright © 2018年 通证控股. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

- (AddressModel*)initWithName:(NSString *)name
                     andPhone:(NSString *)phone
                   andAddress:(NSString *)address
                     andEmail:(NSString *)email
                    andRemark:(NSString *)remark
{
    if (self = [super init]) {
        _name = name;
        _phone = phone;
        _address = address;
        _email = email;
        _remark = remark;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.remark forKey:@"remark"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"] ;
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.remark = [aDecoder decodeObjectForKey:@"remark"];
    }
    return self;
}

@end
