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

//正式服务器
//#define BaseServerUrl   @"https://rinkeby.infura.io/v3/5802e1ef289d4fefac7a51b4acef0461"
//#define LocalServerUrl   @"http://103.60.111.204:3000/"
////合约地址
//#define CECtoken  @"0xdb8a2a6bed731a8486879829e15aa18d7aaf77f4"
//#define ETHtoken  @"0x5a3f404e2b687f94fcff550a69eb077cdd963236"
//#define SECtoken  @"0xc6689eb9a6d724b8d7b1d923ffd65b7005da1b62"
//#define INTtoken  @"0x0b76544f6c413a555f309bf76260d1e02377c02a"

// 测试服务器
#define BaseServerUrl   @"http://35.158.171.46:3002/"
#define LocalServerUrl  @"http://103.60.111.204:3000/"
#define MoreServerUrl   @"https://rinkeby.etherscan.io/tx/"
//合约地址
//#define CECtoken  @"0xdb8a2a6bed731a8486879829e15aa18d7aaf77f4"
//#define ETHtoken  @"0x5a3f404e2b687f94fcff550a69eb077cdd963236"
//#define SECtoken  @"0x5c40eF6f527f4FbA68368774E6130cE6515123f2"  //？？？
//#define INTtoken  @"0xd68ba7734753e2eE54103116323aBA2D94C78dC5"  //？？？

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
