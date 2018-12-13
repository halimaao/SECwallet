//
//  ImageDownloader.h
//  CarPooling
//
//  Created by KAI on 15-1-31.
//  Copyright (c) 2015年 KAI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDownloaderDelegate.h"

@class Globals;

@interface ImageDownloader : NSObject

@property (nonatomic, retain) NSObject *imageKey;
@property (nonatomic, assign) id<ImageDownloaderDelegate>	delegate;
@property (nonatomic) BOOL monitorEnabled;

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *downloadData;
@property (nonatomic, retain) UIImage *downloadImage;

@property (nonatomic,assign) NSUInteger viewTag;

@property (nonatomic,retain) NSMutableString *imageFilePath;
@property (nonatomic) BOOL isMessageImage;
@property (nonatomic, readonly) NSInteger totalBytes;

- (void)startDownload:(NSString *)urlMain;
- (void)cancelDownload;

@end

