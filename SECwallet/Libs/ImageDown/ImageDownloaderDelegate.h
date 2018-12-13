//
//  ImageDownloaderDelegate.h
//  CarPooling
//
//  Created by KAI on 15-1-31.
//  Copyright (c) 2015年 KAI. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageDownloaderDelegate <NSObject>

@required
- (void)imageDidLoad:(NSObject*)imageKey viewTag:(NSUInteger)viewTag;

@optional
- (void)imageDidDownloadRemote:(NSObject *)imageKey;

- (void)imageDidLoad:(NSObject *)imageKey bytes:(NSInteger)bytes total:(NSInteger)total;

@end
