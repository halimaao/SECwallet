//
//  UIView+Category.h
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

@property (nonatomic, assign, readonly, getter=getMinY) CGFloat minY;

@property (nonatomic, assign, readonly, getter=getMidY) CGFloat midY;

@property (nonatomic, assign, readonly, getter=getMaxY) CGFloat maxY;

@property (nonatomic, assign, readonly, getter=getMinX) CGFloat minX;

@property (nonatomic, assign, readonly, getter=getMidX) CGFloat midX;

@property (nonatomic, assign, readonly, getter=getMaxX) CGFloat maxX;

@property (nonatomic, assign, readonly, getter=getWidth) CGFloat width;

@property (nonatomic, assign, readonly, getter=getHeight) CGFloat height;

@end
