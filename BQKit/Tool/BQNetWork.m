//
//  BQNetWork.m
//  网络请求封装
//
//  Created by baiqiang on 15/12/2.
//  Copyright © 2015年 baiqiang. All rights reserved.
//


#import "BQNetWork.h"
#import "BQTools.h"
#import "Reachability.h"

static CGFloat const timeOutInterval = 15.0f;
static NSDictionary * _hearders;
typedef NS_ENUM(NSUInteger, NetWorkType) {
    POST,
    GET,
    PUT
};

@implementation BQNetWork

+ (void)postUrl:(NSString *)urlString parameter:(NSDictionary *)parameter compeleted:(void (^)(id _Nullable))handle {
    NSMutableURLRequest *request = [self configRequestWithUrl:urlString parameter:parameter netWorkType:POST];
    [self asyncDataWithRequest:request compeletedHandle:handle];
}
+ (void)getUrl:(NSString *)urlString parameter:(NSDictionary *)parameter compeleted:(void (^)(id _Nullable))handle {
    NSMutableURLRequest *request = [self configRequestWithUrl:urlString parameter:parameter netWorkType:GET];
    [self asyncDataWithRequest:request compeletedHandle:handle];
}

+ (NSMutableURLRequest *)configRequestWithUrl:(NSString *)urlString
                                    parameter:(NSDictionary *)parameter
                                  netWorkType:(NetWorkType)netWorkType
{
    NSLog(@"******* 网络请求 *******\nurl: %@\nparams: %@",urlString, parameter);
    NSMutableURLRequest *request;
    if (netWorkType == GET) {
        NSURL *url = [self addUrlString:urlString parameter:parameter];
        request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"GET";
    }else if (netWorkType == POST){
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        request.HTTPBody = [[self stringWithDictionary:parameter] dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPMethod = @"POST";
    }
    if (_hearders) {
        [_hearders enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([request.allHTTPHeaderFields.allKeys containsObject:key]) {
                [request setValue:obj forHTTPHeaderField:key];
            }else {
                [request addValue:obj forHTTPHeaderField:key];
            }
        }];
    }
    request.timeoutInterval = timeOutInterval;
    return request;
}

+ (void)asyncDataWithRequest:(NSMutableURLRequest *)request
            compeletedHandle:(void (^)(id _Nullable))handle {
    if (![self isExistenceNetwork]) {
        NSLog(@"当前网络无法链接上Internet");
        return;
    }
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self loadData:data response:response error:error handle:handle];
    }];
    [dataTask resume];
}
+ (void)postUploadWithUrl:(NSString *_Nullable)urlString
                parameter:(NSDictionary *_Nullable)parameter
                 picBlock:(NSDictionary *_Nullable(^_Nullable)())picBlock
               compeleted:(void(^_Nullable)(id _Nullable content))handle; {
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [self configPostImageURLWithString:urlString parameters:parameter picBlock:picBlock];
    request.HTTPMethod = @"POST";
    [[session uploadTaskWithRequest:request fromData:request.HTTPBody completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self loadData:data response:response error:error handle:handle];
    }] resume];
}

+ (void)loadData:(NSData * _Nullable)data response:(NSURLResponse * _Nullable)response error:(NSError * _Nullable)error handle:(void(^)(id _Nullable))handle {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error == nil) {
            NSError *error;
            id content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (error) {
                content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }
            if (content == nil) {
                [BQTools showMessageWithTitle:@"数据信息错误" content:@"无法解析后台返回数据!"];
            }
            handle(content);
        }else {
            [BQTools showMessageWithTitle:@"提示" content:[self getStringMessageFromErrorInfo:error] buttonTitles:@[@"确定"] clickedHandle:nil];
        }
    });
}
+ (NSMutableURLRequest *)configPostImageURLWithString:(NSString *)string parameters:(NSDictionary *)parameters picBlock:(NSDictionary *_Nullable(^_Nullable)())picBlock {
    NSLog(@"******* 网络请求 *******\nurl: %@\nparams: %@",string, parameters);
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"boundary";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:15];
    //分界线 --boundary
    NSString *boundary = [NSString stringWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 boundary--
    NSString *endMPboundary = [NSString stringWithFormat:@"%@--",boundary];
    //http body的字符串
    NSMutableString *body = [NSMutableString string];
    //参数的集合的所有key的集合
    NSArray *keys = [parameters allKeys];
    
    //遍历keys
    for (int i = 0; i < [keys count]; i ++) {
        //得到当前key
        NSString *key = [keys objectAtIndex:i];
        //添加分界线，换行
        [body appendFormat:@"%@\r\n", boundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[parameters objectForKey:key]];
    }
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n", boundary];
    NSDictionary *dict = nil;
    if (picBlock != nil) {
        dict = picBlock();
    }
    if (dict != nil) {
        //声明file字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",dict[@"key"],dict[@"name"]];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
    }
    //声明结束符：--boundary--
    NSString *end = [NSString stringWithFormat:@"\r\n%@",endMPboundary];
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData = [NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //得到图片的data
    NSData* data = dict[@"data"];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--boundary--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%ld", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    
    return request;
}

+ (void)configHttpHearders:(NSDictionary *)hearders {
    if (_hearders != hearders) {
        _hearders = hearders;
    }
}

//get请求url编码拼接
+ (NSURL *)addUrlString:(NSString *)urlString parameter:(NSDictionary *)dic {
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@?",urlString];
    [string appendString:[self stringWithDictionary:dic]];
    return [NSURL URLWithString:string];
}

//将传入字典参数字符拼接
+ (NSString *)stringWithDictionary:(NSDictionary *)dic{
    NSMutableString *string = [NSMutableString string];
    for (NSString *key in dic) {
        id value = dic[key];
        if ([dic[key] isKindOfClass:[NSNumber class]]) {
            value = [NSString stringWithFormat:@"%@",dic[key]];
        }
        [string appendFormat:@"&%@=%@",key,[BQNetWork urlEncodeString:value]];
    }
    return string;
}
//中文编码成url
+ (NSString *)urlEncodeString:(NSString *)string
{
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    NSString *result = [string  stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    return result;
}
+ (NSString *)getStringMessageFromErrorInfo:(NSError *)error {
    NSString *message = nil;
    switch (error.code) {
        case -1001:
            message = @"请求超时,请稍后再试";
            break;
        case -1003:
            message = @"不能找到服务器,请稍后再试";
            break;
        case -1004:
            message = @"不能链接到服务器,请检查网络";
            break;
        default:
            message = @"网络错误,请检查网络设置";
            break;
    }
    return message;
}
#pragma mark - 网络畅通判断
+ (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch([reachability currentReachabilityStatus]){
            case NotReachable: isExistenceNetwork = FALSE;
            break;
            case ReachableViaWWAN: isExistenceNetwork = TRUE;
            break;
            case ReachableViaWiFi: isExistenceNetwork = TRUE;
            break;
    }
    return isExistenceNetwork;
}
@end
