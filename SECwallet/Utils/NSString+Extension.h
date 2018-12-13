//
//  NSString+Extension.h
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/*
 * 字符串解析
 */
+(NSString *)jsonUtils:(id)stringValue;

/*
 * 判断字符串是否为空
 */
- (BOOL)isEmpty;

// 手机号码验证
+(BOOL)validateMobile:(NSString *)mobile;

//固话验证
+ (BOOL) validateAreaTel:(NSString *)areaTel;

// 把手机号第4-7位变成星号
+(NSString *)phoneNumToAsterisk:(NSString*)phoneNum;

// 邮箱验证
+(BOOL)validateEmail:(NSString *)email;

// 把邮箱@前面变成星号
+(NSString*)emailToAsterisk:(NSString *)email;

// 判断是否是身份证号码
+(BOOL)validateIdCard:(NSString *)idCard;

// 把身份证号第5-14位变成星号
+(NSString *)idCardToAsterisk:(NSString *)idCardNum;

// 把钱包地址第9-56位变成星号
+(NSString *)addressToAsterisk:(NSString *)address;

// 密码验证
+(BOOL)validatePassword:(NSString *)password;

//通过文本宽度计算高度
-(CGSize) calculateSize:(UIFont *)font maxWidth:(CGFloat)width;

//重写containsString方法，兼容8.0以下版本
- (BOOL)containsString:(NSString *)aString NS_AVAILABLE(10_10, 8_0);

//截取小数点位数（不进行四舍五入）
+(NSString *)notRounding:(CGFloat)price afterPoint:(int)position;

#pragma mark - 返回时间戳
+ (NSString *)timestampChange:(NSDate *)date;

#pragma mark - 时间戳13位转10位
+ (NSString *)convertTimeStampsToString:(NSNumber *)timestamp;

#pragma mark - 时间戳转化时间
+ (NSString *)timestampChangeTime:(NSString *)timestamp;

#pragma mark - 计算两个时间之间倒计时
+ (NSString *)getSurplusDate:(NSString *)startTimeStr andEndTimeStr:(NSString *)endTimeStr;

#pragma mark - date返回日期字符串
+ (NSString *)getDateStr:(NSDate *)date;

//字典格式的字符串转换成字典
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;
// 字典转json字符串方法
+(NSString *)convertToJsonData:(NSDictionary *)dict;

//格式化html文本，替换成字符串
+(NSString *)filterHTML:(NSString *)html;

//颜色值#ffffff转UIColor
+ (UIColor*)colorWithHexString:(NSString*)stringToConvert;
//指定范围文字颜色
+(NSMutableAttributedString *)differentColorWithRange:(NSRange)range textColor:(UIColor *)color text:(NSString *)string;

//包含中文YES
+(BOOL)IsChinese:(NSString *)string;

#pragma mark - 生成二维码
+ (UIImage *)twoDimensionCodeWithUrl:(NSString *)url;

//生成随机字符串
+ (NSString *)getRandomStringWithNum:(NSInteger)num;

// 16进制转10进制
+ (NSString *)hex_10_numberFromString:(NSString *)aHexString;

//十进制准换为十六进制字符串
+ (NSString *)hex_16_StringFromDecimal:(NSInteger)decimal;

//字符串后面补零操作
+(NSString *)addZero:(NSString *)str withLength:(NSInteger)length;

//去掉字符串前面的0
+(NSString*)getTheCorrectNum:(NSString*)tempString;

//字符串取wei操作且去尾数零并保留小数位数
+(NSString *)decimal:(NSString *)decimalStr wei:(NSInteger)wei withDigit:(NSInteger)digit;

@end
