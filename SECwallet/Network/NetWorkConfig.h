//
//  NetWorkConfig.h
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#ifndef NetWorkConfig_h
#define NetWorkConfig_h

#import "AFNetworking.h"
#import "AFJSONRPCClient.h"

// 测试服务器
#define BaseServerUrl   @"http://35.158.171.46:3002/"
#define LocalServerUrl  @"http://103.60.111.204:3000/"
#define MoreServerUrl   @"https://rinkeby.etherscan.io/tx/"

/**************AppStore链接参数*****************/
#define APP_URL                  @"http://itunes.apple.com/lookup?id=1246034586"
#define APP_DownloadUrl          @"http://itunes.apple.com/lookup?id=1246034586"
/**************友盟统计参数*****************/
#define KUmengStatisticsKey          @"593617a7734be43d57000899"

/**************QQ参数*****************/
#define kQQAppId              @"1106134965"    //十六进制：41EE47B5
#define kQQAPPKEY             @"Txuekxyg0x6I8WUq"

/**************微信参数*****************/
#define kWXAppId              @"wxb73b6f34f5797f2f"
#define kWXAPPSECRET          @"901fd30bd7360221320b87554b32e30e"

/**************腾讯Bugly参数*****************/
#define kBuglyAppId           @"fca27e4847"



#endif /* NetWorkConfig_h */
