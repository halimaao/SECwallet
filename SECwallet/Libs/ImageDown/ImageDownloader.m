//
//  ImageDownloader.m
//  CarPooling
//
//  Created by KAI on 15-1-31.
//  Copyright (c) 2015年 KAI. All rights reserved.
//

#import "ImageDownloader.h"

#import "AppDelegate.h"
#import "PathService.h"

@implementation ImageDownloader

- (id)init {
    self = [super init];
    if (self) {
        self.imageFilePath = [NSMutableString stringWithCapacity:10];
        _monitorEnabled = FALSE;
        _totalBytes = 0;
    }
    return self;
}

- (void)startDownload:(NSString *)urlMain {
    if (urlMain == nil || [urlMain isEqualToString:@""]) {
        return;
    }
    _downloadData = [[NSMutableData alloc] init];
    //是否是bundle里面的图像，如果不以http等前缀开头，而且可以直接从bundle里面找到，那肯定是bundle图像
    //之所以要进一步判断它的存在性，是因为图像短信里面也只存了本地图像的文件名而已，而这一部分图像虽然不以http之类的前缀开头，但也不是bundle图像，不应该去bundle里面找
    BOOL isBundleImage = (![urlMain hasPrefix:@"http"] && ![urlMain hasPrefix:@"www"] && ![urlMain hasPrefix:@"pic"] && [UIImage imageNamed:urlMain]);
    if (isBundleImage) {
        _downloadImage = [UIImage imageNamed:urlMain];
        if ([(NSObject *)_delegate respondsToSelector:@selector(imageDidLoad:viewTag:)]) {
            [_delegate imageDidLoad:_imageKey viewTag:_viewTag];
        }
    } else {
        NSString *imageFileName = [PathService fileNameForUrlStr:urlMain];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *imageFilePath = [PathService filePathWidthFileName:[NSString stringWithFormat:@"img%@",imageFileName]];
        [_imageFilePath setString:imageFilePath];
        if ([fileManager fileExistsAtPath:imageFilePath]) { //本地读取
            _downloadImage = [[UIImage alloc] initWithContentsOfFile:_imageFilePath];
            if ([(NSObject *)_delegate respondsToSelector:@selector(imageDidLoad:viewTag:)]) {
                [_delegate imageDidLoad:_imageKey viewTag:_viewTag];
            }
        } else { //开始下载
            if (_connection) {
                [_connection cancel];
                _connection = nil;
            }
            
            NSURL *url = [NSURL URLWithString:[urlMain stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"GET"];
            _connection = [NSURLConnection connectionWithRequest:request delegate:self];
            if (_monitorEnabled && [(NSObject *)_delegate respondsToSelector:@selector(imageDidDownloadRemote:)]) {
                [_delegate imageDidDownloadRemote:_imageKey];
            }
        }
    }
}

- (void)cancelDownload {
    [_connection cancel];
    _connection = nil;
    _downloadData = nil;
    _monitorEnabled = FALSE;
    _delegate = nil;
    _totalBytes = 0;
}

#pragma mark NSURLConnection delegate Methods
- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        _totalBytes = [[dictionary objectForKey:@"Content-Length"] intValue];
    }
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data {
    [_downloadData appendData:data];
    
    if (_monitorEnabled && [(NSObject *)_delegate respondsToSelector:@selector(imageDidLoad:bytes:total:)]) {
        [_delegate imageDidLoad:_imageKey bytes:[_downloadData length] total:_totalBytes];
    }
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
    if (_connection) {
        [_connection cancel];
        _connection = nil;
    }
    _downloadData = nil;
    _downloadImage = nil;
    _monitorEnabled = FALSE;
    _totalBytes = 0;
    if ([(NSObject *)_delegate respondsToSelector:@selector(imageDidLoad:viewTag:)]) {
        [_delegate imageDidLoad:_imageKey viewTag:_viewTag];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection {
    _downloadImage = [[UIImage alloc] initWithData:_downloadData];
    _downloadData = nil;
    _monitorEnabled = FALSE;
    _totalBytes = 0;
    if (_downloadImage != nil) {
        [_connection cancel];
        _connection = nil;
        //存入本地
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:_imageFilePath] == FALSE){
            NSString *ext = [_imageFilePath pathExtension];
            if([ext isEqualToString:@"jpg"]){
                NSData *pngData = UIImagePNGRepresentation(_downloadImage);
                if([pngData writeToFile:_imageFilePath atomically:YES] == TRUE){
                    NSLog(@"succeed");
                } else {
                    NSLog(@"no succeed");
                }
            }else{
                if([UIImageJPEGRepresentation(_downloadImage,1.0f)
                    writeToFile:_imageFilePath atomically:YES] == TRUE){
                }
            }
        }
        if (_delegate && [(NSObject *)_delegate respondsToSelector:@selector(imageDidLoad:viewTag:)]) {
            [_delegate imageDidLoad:_imageKey viewTag:_viewTag];
        }
    } else {
        //如果下载的数据不是图像，则以空值代替
        [_connection cancel];
        _connection = nil;
        if (!_delegate) {
            return;
        }
        if ([(NSObject *)_delegate respondsToSelector:@selector(imageDidLoad:viewTag:)]) {
            [_delegate imageDidLoad:_imageKey viewTag:_viewTag];
        }
    }
}

@end