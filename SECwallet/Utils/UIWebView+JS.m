//
//  UIWebView+JS.m
//  汇银
//
//  Created by 李小斌 on 14-12-2.
//  Copyright (c) 2014年 7ien. All rights reserved.
//

#import "UIWebView+JS.h"

#import "NSString+Extension.h"

@implementation UIWebView (JS)

-(void) loadHTMLString:(NSString *)content
{
    NSString *strValue =  [NSString jsonUtils:content];
    
    strValue = [strValue stringByReplacingOccurrencesOfString: @"\n" withString:@"<br/>"];
    strValue = [self replaceStr:@"[w][i][d][t][h][:](\\d+\\.?\\d+)[p][t][;]" withReplacedStr:strValue withPlaceStr:@""];
    strValue = [self replaceStr:@"(font-size: )(\\d+px)" withReplacedStr:strValue withPlaceStr:@"$114pt"];
    
    NSMutableString *data_content = [NSMutableString stringWithString:@""];
    [data_content appendString:@"<!DOCTYPE html>"];
    [data_content appendString:@"<html>"];
    [data_content appendString:@"<head>"];
    [data_content appendString:@"<meta charset=\"utf-8\">"];
    if (IS_iPhone4 || IS_iPhone5) {
        [data_content appendString:@"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0, minimum-scale=0.1, maximum-scale=0.5,user-scalable=yes\" />"];
    }else{
        [data_content appendString:@"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0, minimum-scale=0.1, maximum-scale=2.0,user-scalable=yes\" />"];
    }
    
    [data_content appendString:@"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />"];
    [data_content appendString:@"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />"];
    [data_content appendString:@"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />"];
    [data_content appendString:@"<style>table{width:100%;}</style>"];
    [data_content appendString:@"<title>webview</title>"];
    [data_content appendString:[NSString stringWithFormat:@"<base href=\"%@\" />", BaseServerUrl]];
    [data_content appendString:@"</head>"];
    [data_content appendString:@"<body>"];
    
    [data_content appendString:@"<div style=\"line-height:1.5em;color:#404040;padding:0 0 0 0\">"];
    
    [data_content appendString:strValue];
    
    [data_content appendString:@"</div>"];
    
    [data_content appendString:@"<script type=\"text/javascript\">"];
    [data_content appendString:@"var imgArray = document.getElementsByTagName(\"img\");"];
    [data_content appendString:@"var length = imgArray.length;"];
    [data_content appendString:@"var s = \"\";"];
    [data_content appendString:@"for(var i = 0; i < length; i++){"];
    [data_content appendString:@"var img = imgArray[i];"];
    [data_content appendString:@"var srcUrl = img.src;"];
    [data_content appendString:@"var srcUrl = document.getElementsByTagName(\"img\");"];
    [data_content appendString:@"if(srcUrl.indexOf('common/kindeditor/plugins/emoticons') > 0){"];
    // 如果是表情图片
    [data_content appendString:@"}else{"];
    // 表示不是表情图片.
    [data_content appendString:@"img.style.width = \"100%\";"];
    [data_content appendString:@"img.style.height = \"auto\";"];
    
    [data_content appendString:@"}"];
    [data_content appendString:@"}"];
    [data_content appendString:@"</script>"];
    
    [data_content appendString:@"</body>"];
    [data_content appendString:@"</html>"];
    
    [self loadHTMLString:data_content baseURL:nil];
}


-(void) loadHTMLStringWhitoutWrap:(NSString *)content
{
    NSString *strValue =  [NSString jsonUtils:content];
    strValue = [self replaceStr:@"[w][i][d][t][h][:](\\d+\\.?\\d+)[p][t][;]" withReplacedStr:strValue withPlaceStr:@""];
    NSMutableString *data_content = [NSMutableString stringWithString:@""];
    [data_content appendString:@"<!DOCTYPE html>"];
    [data_content appendString:@"<html>"];
    [data_content appendString:@"<head>"];
    [data_content appendString:@"<meta charset=\"utf-8\">"];
    [data_content appendString:@"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0, minimum-scale=0.1, maximum-scale=2.0,user-scalable=yes\" />"];
    [data_content appendString:@"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />"];
    [data_content appendString:@"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />"];
    [data_content appendString:@"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />"];
    //    [data_content appendString:@"<style>img{width:100%;}</style>"];
    [data_content appendString:@"<style>table{width:100%;}</style>"];
    [data_content appendString:@"<title>webview</title>"];
    [data_content appendString:[NSString stringWithFormat:@"<base href=\"%@\" />", BaseServerUrl]];
    [data_content appendString:@"</head>"];
    [data_content appendString:@"<body>"];
    
    [data_content appendString:@"<div style=\"line-height:1.5em;color:#404040;padding:0 0 0 0\">"];
    
    [data_content appendString:strValue];
    
    [data_content appendString:@"</div>"];
    
    [data_content appendString:@"<script type=\"text/javascript\">"];
    [data_content appendString:@"var imgArray = document.getElementsByTagName(\"img\");"];
    [data_content appendString:@"var length = imgArray.length;"];
    [data_content appendString:@"var s = \"\";"];
    [data_content appendString:@"for(var i = 0; i < length; i++){"];
    [data_content appendString:@"var img = imgArray[i];"];
    [data_content appendString:@"var srcUrl = img.src;"];
    [data_content appendString:@"if(srcUrl.indexOf('common/kindeditor/plugins/emoticons') > 0){"];
    // 如果是表情图片
    [data_content appendString:@"}else{"];
    // 表示不是表情图片.
    [data_content appendString:@"img.style.width = \"100%\";"];
    [data_content appendString:@"img.style.height = \"auto\";"];
    
    [data_content appendString:@"}"];
    [data_content appendString:@"}"];
    [data_content appendString:@"</script>"];
    
    [data_content appendString:@"</body>"];
    [data_content appendString:@"</html>"];
    
    [self loadHTMLString:data_content baseURL:nil];
}


-(NSString*)replaceStr:(NSString*)regexPattern withReplacedStr:(NSString*)str withPlaceStr:(NSString*)pstr{
    NSMutableString *value = [[NSMutableString alloc] initWithString:str];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:0 error:nil];
    [regex replaceMatchesInString:value options:0 range:NSMakeRange(0, [str length]) withTemplate:pstr];
    return value;
}




@end
