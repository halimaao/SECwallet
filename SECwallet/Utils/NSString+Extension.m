//
//  NSString+Extension.m
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+(NSString *)jsonUtils:(id)stringValue
{
    NSString *string = [NSString stringWithFormat:@"%@", stringValue];
    
    if([string isEqualToString:@"<null>"])
    {
        string = @"";
    }
    
    if(string == nil)
    {
        string = @"";
    }
    
    if([string isEqualToString:@"(null)"])
    {
        string = @"";
    }
    
    if([string isEqualToString:@""])
    {
        string = @"";
    }
    
    if(string.length == 0)
    {
        string = @"";
    }
    
    return string;
}

/*
 * 判断字符串是否为空
 */
- (BOOL)isEmpty
{
    if ((self.length == 0) || (self == nil) || ([self isKindOfClass:[NSNull class]]) || ([self isEqual:[NSNull null]]) || ([self isEqualToString:@"(null)"]) || ([self isEqualToString:@"<null>"])) {
        return YES;
    }else {
        return NO;
    }
}

// 密码验证
+ (BOOL)validatePassword:(NSString *)password
{
//    NSString *passwordRegex = @"^[a-zA-Z0-9]{8,30}+$";
    //特殊字符仅包括：~`@#$%^&*-_=+|\?/()<>[]{},.;'!"
    NSString *passwordRegex = @"^[a-zA-Z0-9~!/@#$%^&#$%^&amp;*()-_=+\\|[{}];:\'\",&#$%^&amp;*()-_=+\\|[{}];:\'\",&lt;.&#$%^&amp;*()-_=+\\|[{}];:\'\",&lt;.&gt;/?]{8,30}+$";
    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    
    BOOL isMatch = [passwordPredicate evaluateWithObject:password];
    if (!isMatch) {
        return NO;
    }
    //是否是纯数字或纯字母
    if ([self isPureNumandCharacters:password] == YES || [self isPureLetters:password] == YES) {
        return NO;
    }
    
    return isMatch;
}

//是否是纯数字
+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

//是否是纯字母
+(BOOL)isPureLetters:(NSString*)str
{    
    for(int i=0;i<str.length;i++){
        unichar c=[str characterAtIndex:i];
        if((c<'A'||c>'Z')&&(c<'a'||c>'z'))
            return NO;
    }
    return YES;
}

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(16[0-9])|(17[0-9])|(18[0,0-9]|(19[0-9])))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//固话验证
+ (BOOL) validateAreaTel:(NSString *)areaTel;
{
    NSString *phoneRegex = @"^((0\\d{2,3})-)(\\d{7,8})(-(\\d{3,}))?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:areaTel];
}

// 把手机号第4-7位变成星号
+(NSString *)phoneNumToAsterisk:(NSString*)phoneNum
{
    if (phoneNum.length >7) {
        return [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
    }else{
        return nil;
    }
}

//邮箱验证
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 把邮箱@前面变成星号
+(NSString*)emailToAsterisk:(NSString *)email
{
    NSArray *arr = [email componentsSeparatedByString:@"@"];
    NSString *str = [arr objectAtIndex:0];
    return [email stringByReplacingCharactersInRange:NSMakeRange(str.length, email.length-str.length) withString:@"****"];
}

/**
 * 功能:判断是否在地区码内
 *
 * 参数:地区码
 */
+(BOOL)areaCode:(NSString *)code
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        return NO;
    }
    return YES;
}

/**
 * 功能:获取指定范围的字符串
 *
 * 参数:字符串的开始下标
 *
 * 参数:字符串的结束下标
 */
+(NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger)value1 Value2:(NSInteger)value2;
{
    return [str substringWithRange:NSMakeRange(value1,value2)];
}

/**
 * 功能:验证身份证是否合法
 *
 * 参数:输入的身份证号
 */
+(BOOL)validateIdCard:(NSString *)idCard
{
    //判断位数
    if ([idCard length] < 15 ||[idCard length] > 18) {
        return NO;
    }
    
    NSString *carid = idCard;
    long lSumQT =0;
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    
    NSMutableString *mString = [NSMutableString stringWithString:idCard];
    if ([idCard length] == 15) {
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    
    //判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    
    if (![self areaCode:sProvince]) {
        return NO;
    }
    
    //判断年月日是否有效
    
    //年份
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    //月份
    int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
    //日
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    
    if (date == nil) {
        return NO;
    }
    
    const char *PaperId  = [carid UTF8String];
    
    //检验长度
    if( 18 != strlen(PaperId)) return -1;
    //校验数字
    for (int i=0; i<18; i++)
    {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    //验证最末的校验码
    for (int i=0; i<=16; i++)
    {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17] )
    {
        return NO;
    }
    
    return YES;
}

// 把身份证号第11-14位变成星号
+(NSString*)idCardToAsterisk:(NSString *)idCardNum
{
    return [idCardNum stringByReplacingCharactersInRange:NSMakeRange(10, 4) withString:@"****"];
}

// 把钱包地址第9-56位变成星号
+(NSString *)addressToAsterisk:(NSString *)address
{
    NSString *str1 = [address substringWithRange:NSMakeRange(0,8)];
    NSString *str2 = [address substringWithRange:NSMakeRange(address.length-8,8)];
    return [NSString stringWithFormat:@"%@...%@",str1,str2];
}

//通过文本宽度计算高度
-(CGSize) calculateSize:(UIFont *)font maxWidth:(CGFloat)width
{
    CGSize size = CGSizeMake(width,1000);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect rect =  [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    return CGSizeMake(rect.size.width, rect.size.height);
}

//重写containsString方法，兼容8.0以下版本
- (BOOL)containsString:(NSString *)aString NS_AVAILABLE(10_10, 8_0){
    if ([aString isEmpty]) {
        return NO;
    }
    if ([self rangeOfString:aString].location != NSNotFound) {
        return YES;
    }
    return NO;
}

//截取小数点位数（不进行四舍五入）
+(NSString *)notRounding:(CGFloat)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

#pragma mark - 返回时间戳
+ (NSString *)timestampChange:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSString *timeSp = [NSString stringWithFormat:@"%lo",(long)[date timeIntervalSince1970]];
    return timeSp;
}

#pragma mark - date返回日期字符串
+ (NSString *)getDateStr:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    return dateStr;
}

#pragma mark - 时间戳13位转10位
+ (NSString *)convertTimeStampsToString:(NSNumber *)timestamp
{
    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
    [stampFormatter setDateFormat:@"yyyy-MM-dd HH:ss"];
    //以 1970/01/01 GMT为基准，然后过了secs秒的时间
    NSDate *stampDate = [NSDate dateWithTimeIntervalSince1970:timestamp.longValue/1000.0];
    return [stampFormatter stringFromDate:stampDate];
}

#pragma mark - 时间戳转化时间
+ (NSString *)timestampChangeTime:(NSString *)timestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *netDate = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue]];
//    //解决相差8小时
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: netDate];
//    NSDate *localeDate = [netDate  dateByAddingTimeInterval: interval];
    
    return [formatter stringFromDate:netDate];
}

#pragma mark - 计算两个时间之间倒计时
+ (NSString *)getSurplusDate:(NSString *)startTimeStr andEndTimeStr:(NSString *)endTimeStr
{
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
//    [formatter setTimeZone:timeZone];
    
    NSDateFormatter *dm = [[NSDateFormatter alloc] init];
    [dm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [dm dateFromString:startTimeStr];
    
    NSDate *endDate = [dm dateFromString:endTimeStr];
    
    long time = (long)[endDate timeIntervalSince1970] - [startDate timeIntervalSince1970];
    
    int syTime = (int)time/3600;
    int syMinute = (int)(time - syTime * 3600)/60;
    int sySecond = (int)(time - syTime * 3600 - syMinute * 60);
    
    return [NSString stringWithFormat:@"%d:%d:%d",syTime,syMinute,sySecond];
}

//字典格式的字符串转换成字典
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

// 字典转json字符串方法
+(NSString *)convertToJsonData:(NSDictionary *)dict {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

//格式化html文本，替换成字符串
+(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

//颜色值#ffffff转UIColor
+ (UIColor*)colorWithHexString:(NSString*)stringToConvert
{
    
    if([stringToConvert hasPrefix:@"#"])
    {
        stringToConvert = [stringToConvert substringFromIndex:1];
    }
    NSScanner*scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if(![scanner scanHexInt:&hexNum])
    {
        return nil;
    }
    
    int r = (hexNum >>16) &0xFF;
    int g = (hexNum >>8) &0xFF;
    int b = (hexNum) &0xFF;
    return[UIColor colorWithRed:r /255.0f
                          green:g /255.0f
                           blue:b /255.0f
                          alpha:1.0f];
    
}
//指定区域颜色
+(NSMutableAttributedString *)differentColorWithRange:(NSRange)range textColor:(UIColor *)color text:(NSString *)string
{
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:string];
    [noteStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    return noteStr;
}

+(BOOL)IsChinese:(NSString *)string
{
    for(int i=0; i< [string length];i++){
        int a = [string characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 生成二维码
+ (UIImage *)twoDimensionCodeWithUrl:(NSString *)url
{
    // 1.将字符串转换成NSData
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
    // 2.创建二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 3.恢复默认
    [filter setDefaults];
    // 4.给滤镜设置数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 5.获取滤镜输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 6.此时生成的还是CIImage，可以通过下面方式生成一个固定大小的UIImage
    CGFloat size = Size(185);
    CGRect extent = CGRectIntegral(outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 7.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 8.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


+ (NSString *)getRandomStringWithNum:(NSInteger)num
{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < num; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

//十进制转换为十六进制字符串
+ (NSString *)hex_16_StringFromDecimal:(NSInteger)decimal
{
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
            case 10:
                letter =@"a"; break;
            case 11:
                letter =@"b"; break;
            case 12:
                letter =@"c"; break;
            case 13:
                letter =@"d"; break;
            case 14:
                letter =@"e"; break;
            case 15:
                letter =@"f"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            break;
        }
    }
    return hex;
}

//字符串后面补零操作
+(NSString *)addZero:(NSString *)str withLength:(NSInteger)length
{
    NSString *string = nil;
    if (str.length==length) {
        return str;
    }
    if (str.length<length) {
        NSUInteger inter = length-str.length;
        for (int i=0;i< inter; i++) {
            string = [NSString stringWithFormat:@"%@0",str];
            str = string;
        }
    }
    return string;
}

/**************************************************十六进制换算十进制**************************************************/
// 16进制计算结果
+ (NSString *)hex_10_numberFromString:(NSString *)aHexString {
    NSString *baseNum = @"4294967296"; //16的8次方结果
    NSArray *dataArr = [self getStrArr:aHexString];
    NSString *numStr = @"0";
    // 把数据分组，每8位一组
    NSInteger group = ceilf([dataArr count] / 8.0);
    for (NSInteger i = 0; i < group; i++) {
        NSString *tmpNumStr = @"";
        if (i == 0) {
            tmpNumStr = [aHexString substringWithRange:NSMakeRange(0, dataArr.count%8)];
            if (dataArr.count % 8 == 0) {
                tmpNumStr = [aHexString substringWithRange:NSMakeRange(0, 8)];
            }
        } else {
            tmpNumStr = [aHexString substringWithRange:NSMakeRange(dataArr.count%8 + (i-1)*8, 8)];
        }
        tmpNumStr = [NSString stringWithFormat:@"%@", [self get16String:tmpNumStr]];
        NSInteger j = group - 1 - i;
        for (NSInteger ii = 0; ii < j; ii++) {
            tmpNumStr = [self bigNunMulti:tmpNumStr other:baseNum];
        }
        numStr = [self bigNumAdd:numStr other:tmpNumStr];
    }
    return [self getString:numStr removeStartChar:@"0"];
}

// 16进制数转换成10进制（数比较小，不会溢出的情况下，大数不能使用该方法）
+ (NSNumber *)get16String:(NSString *)aHexString{
    // 为空,直接返回.
    if (nil == aHexString){
        return nil;
    }
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    //将整数转换为NSNumber,存储到数组中,并返回.
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    return hexNumber;
}

// 去掉字符串前面的指定字符
+ (NSString *)getString:(NSString *)str removeStartChar:(NSString *)removeStr {
    NSString *newStr = str;
    NSInteger count = str.length;
    for (NSInteger i = 0; i < count; i++) {
        if ([[newStr substringToIndex:1] isEqualToString:removeStr]) {
            newStr = [newStr substringFromIndex:1];
        } else {
            break;
        }
    }
    return newStr;
}

// 把字符串转换成一个个字符的数组
+ (NSMutableArray *)getStrArr:(NSString *)str {
    NSMutableArray *s = [NSMutableArray array];
    for (NSUInteger i = 0; i < str.length; i++) {
        [s addObject:[str substringWithRange:NSMakeRange(i, 1)]];
    }
    return s;
}

//字符串反转
+ (NSMutableArray *)reverseStr:(NSString *)str {
    NSMutableArray *s = [NSMutableArray array];
    for (NSUInteger i = str.length; i > 0; i--) {
        [s addObject:[str substringWithRange:NSMakeRange(i-1, 1)]];
    }
    return s;
}

// 2个大数相加
+ (NSString *)bigNumAdd:(NSString *)str1  other:(NSString *)str2 {
    NSMutableArray *reverseStr1Arr = [self reverseStr:str1];
    NSMutableArray *reverseStr2Arr = [self reverseStr:str2];
    NSInteger num = 0;
    NSMutableArray *numArr = [NSMutableArray array];
    [numArr addObject:@"0"];
    for (NSInteger index = 0; index < MAX(reverseStr1Arr.count, reverseStr2Arr.count); index++) {
        if (numArr.count - 1 == index) {
            [numArr addObject:@"0"];
        }
        if (index < MIN(reverseStr1Arr.count, reverseStr2Arr.count)) {
            num = [reverseStr1Arr[index] integerValue] + [reverseStr2Arr[index] integerValue];
        } else {
            if (reverseStr1Arr.count > reverseStr2Arr.count) {
                num = [reverseStr1Arr[index] integerValue];
            } else {
                num = [reverseStr2Arr[index] integerValue];
            }
        }
        NSString *numIndex = numArr[index];
        num += [numIndex integerValue];
        numArr[index] = [NSString stringWithFormat:@"%ld", (num  % 10)];
        num = num / 10;
        numArr[index + 1] = [NSString stringWithFormat:@"%ld", num];
    }
    return [self getStrFromArr:numArr];
}

// 2个大数相乘
+ (NSString *)bigNunMulti:(NSString *)str1 other:(NSString *)str2 {
    NSMutableArray *reverseStr1Arr = [self reverseStr:str1];
    NSMutableArray *reverseStr2Arr = [self reverseStr:str2];
    NSInteger num = 0;
    NSMutableArray *numArr = [NSMutableArray array];
    for (int i = 0; i < reverseStr1Arr.count + reverseStr2Arr.count; i++) {
        [numArr addObject:@"0"];
    }
    for (NSInteger str1Index = 0; str1Index < str1.length; str1Index++) {
        NSInteger str2Index = 0;
        for (str2Index = 0; str2Index < str2.length; str2Index++) {
            NSInteger numIJ = [numArr[str1Index + str2Index] integerValue];
            num += numIJ + [reverseStr1Arr[str1Index] integerValue] * [reverseStr2Arr[str2Index] integerValue];
            numArr[str1Index + str2Index] = [NSString stringWithFormat:@"%ld", (num % 10)];
            num = num / 10;
        }
        while (num) {
            NSInteger old = [numArr[str1Index + str2Index] integerValue];
            numArr[str1Index + str2Index] = [NSString stringWithFormat:@"%ld", (old + num % 10)];
            num = num / 10;
        }
    }
    return [self getStrFromArr:numArr];
}

// 把字符数组组合成字符串
+ (NSString *)getStrFromArr:(NSArray *)strArr {
    NSString *newStr = @"";
    for (NSInteger i = strArr.count - 1; i >= 0; i--) {
        newStr = [newStr stringByAppendingString:strArr[i]];
    }
    return newStr;
}
/**************************************************十六进制换算十进制**************************************************/

//去掉字符串前面的0
+(NSString*) getTheCorrectNum:(NSString*)tempString
{
    while ([tempString hasPrefix:@"0"])
    {
        tempString = [tempString substringFromIndex:1];
    }
    return tempString;
}

//字符串取wei操作且去尾数零并保留小数位数
+(NSString *)decimal:(NSString *)decimalStr wei:(NSInteger)wei withDigit:(NSInteger)digit
{
    NSMutableString *mutStr = [[NSMutableString alloc]init];
    if (decimalStr.length > 0) {
        if (decimalStr.length > wei) {
            mutStr = [[NSMutableString alloc]initWithString:decimalStr];
            [mutStr insertString:@"." atIndex:decimalStr.length -wei];
        }else{
            mutStr = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"0.%@",decimalStr]];
            long lengh = wei -decimalStr.length;
            //循环补0
            for (int i = 0; i< lengh; i++) {
                [mutStr insertString:@"0" atIndex:2];
            }
        }
        //如果字符串末尾是0则删除0
        NSArray *arrStr = [mutStr componentsSeparatedByString:@"."];
        NSString *firstStr = arrStr.firstObject;
        NSString *lastStr = arrStr.lastObject;
        while ([lastStr hasSuffix:@"0"]) {
            lastStr = [lastStr substringToIndex:(lastStr.length-1)];
        }
        //如果字符串末尾全是0则直接返回不保留小数点
        if (lastStr.length == 0) {
            mutStr = [NSMutableString stringWithFormat:@"%@",firstStr];
        }else{
            mutStr = [NSMutableString stringWithFormat:@"%@.%@",firstStr,lastStr];
            if (digit > 0 && lastStr.length > digit) {
                //截取digit位
                lastStr = [lastStr substringWithRange:NSMakeRange(0,digit)];
                mutStr = [NSMutableString stringWithFormat:@"%@.%@",firstStr,lastStr];
            }
        }
        
    }else{
        mutStr = [NSMutableString stringWithFormat:@"%@",@"0"];
    }
    
    return mutStr;
}

@end
