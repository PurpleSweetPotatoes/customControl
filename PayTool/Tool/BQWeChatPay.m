//
//  BQWeChatPay.m
//  Test-demo
//
//  Created by baiqiang on 17/2/22.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

#import "BQWeChatPay.h"
#import "BQPay.h"
#import <CommonCrypto/CommonDigest.h>

static NSString *const WeChatPayHttpRequestUrl = @"https://api.mch.weixin.qq.com/pay/unifiedorder";

@interface BQWeChatPay () <NSXMLParserDelegate>
{
    NSString *xmlContentString;
    NSXMLParser *xmlParser;
    NSMutableDictionary *xmlDic;
}
@property (nonatomic, strong) NSDictionary *signDic;

@end

@interface NSString (WeChat)
@property (nonatomic, strong, readonly) NSString *md5;
+ (NSString *)timestamp;
+ (NSString *)randString;
@end

@implementation BQWeChatPay

+ (void)handleOpenUrl:(NSURL *)url {
    if ([url.scheme isEqualToString:APP_ID]) {
        [WXApi handleOpenURL:url delegate:[BQPay sharedSNPay]];
    }
}
+ (void)payWithOrderDict:(NSDictionary *)orderDict callBlock:(void (^)(NSError *))block {
    PayReq *request = [[PayReq alloc] init];
    request.openID = [orderDict objectForKey:@"appid"];
    request.partnerId = [orderDict objectForKey:@"mch_id"];
    request.prepayId = [orderDict objectForKey:@"prepay_id"];
    request.package = @"Sign=WXPay";
    request.nonceStr = [orderDict objectForKey:@"nonce_str"];
#warning 具体字段key根据服务器返回为准
    request.timeStamp = [orderDict[@"timestamp"] intValue];
    request.sign = [orderDict objectForKey:@"paySign"];;
    // 调用微信
    [WXApi sendReq:request];
}
+ (void)payWithMoney:(NSString *)money orderId:(NSString *)orderId title:(NSString *)title desc:(NSString *)desc notiUrl:(NSString *)url callBlock:(void (^)(NSError *))block {
    //注册微信SDK
    if (![BQPay sharedSNPay].wechatSDKIsRegiest) {
        [BQPay sharedSNPay].wechatSDKIsRegiest = YES;
        [WXApi registerApp:APP_ID withDescription:[NSBundle mainBundle].bundleIdentifier];
    }
    //检查微信是否安装
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"支付失败" message:@"请先安装微信客户端" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    //微信支付金额单位为分
    money = [NSString stringWithFormat:@"%d",[money intValue] * 100];
    NSMutableDictionary *signDic = [self buildSignDictionaryWithAppId:APP_ID mchId:MCH_ID desc:desc price:money notiUrl:url orderId:orderId];
    NSString *xml = [self buildRequestXMLWithDic:signDic];
    
    [[self new] requestPayInfoWithXml:xml];
}
//请求统一支付
- (void)requestPayInfoWithXml:(NSString *)xml {
    NSData *httpRequestBody = [xml dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:WeChatPayHttpRequestUrl]];
    request.HTTPBody = httpRequestBody;
    request.HTTPMethod = @"POST";
    [request setValue:@"UTF-8" forHTTPHeaderField:@"charset"];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler: ^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        [self XMLDataCoverToDic:data];
        NSLog(@"统一下单返回的结果：%@", xmlDic);
        //判断返回的许可
        if ([[xmlDic objectForKey:@"result_code"] isEqualToString:@"SUCCESS"] && [[xmlDic objectForKey:@"return_code"] isEqualToString:@"SUCCESS"]) {
            PayReq *request = [[PayReq alloc] init];
            request.openID = [xmlDic objectForKey:@"appid"];
            request.partnerId = [xmlDic objectForKey:@"mch_id"];
            request.prepayId = [xmlDic objectForKey:@"prepay_id"];
            request.package = @"Sign=WXPay";
            request.nonceStr = [xmlDic objectForKey:@"nonce_str"];
            //将当前时间转化成时间戳
            request.timeStamp = [NSString timestamp].intValue;
            // 签名加密
            request.sign = [BQWeChatPay createMD5SignWithPrepayId:request.prepayId packageId:request.package randStr:request.nonceStr timestamp:request.timeStamp];
            // 调用微信
            [WXApi sendReq:request];
        }else {
            //支付出错
            if ([BQPay sharedSNPay].callBlock) {
                [BQPay sharedSNPay].callBlock([BQPay buildErrorWithCode:[xmlDic[@"err_code"] integerValue] msg:xmlDic[@"err_code_des"]]);
            }
        }
    }] resume];
}

//xml转换成字典
- (void)XMLDataCoverToDic:(NSData *)data {
    xmlDic = [NSMutableDictionary dictionary];
    xmlParser = [[NSXMLParser alloc] initWithData:data];
    [xmlParser setDelegate:self];
    [xmlParser parse];
}

//支付字典转换成xml
+ (NSString *)buildRequestXMLWithDic:(NSMutableDictionary *)dic {
    NSMutableString *reqPars = [NSMutableString string];
    //生成签名
    NSString *sign = [self createMd5Sign:dic];
    //生成xml的package
    NSArray *keys = [dic allKeys];
    [reqPars appendString:@"<xml>\n"];
    for (NSString *key in keys) {
        [reqPars appendFormat:@"<%@>%@</%@>\n", key, [dic objectForKey:key], key];
    }
    [reqPars appendFormat:@"<sign>%@</sign>\n</xml>", sign];
    
    return [NSString stringWithString:reqPars];
}
//构建需要支付的字段
+ (NSMutableDictionary *)buildSignDictionaryWithAppId:(NSString *)appId mchId:(NSString *)mchId desc:(NSString *)desc price:(NSString *)price notiUrl:(NSString *)notiUrl orderId:(NSString *)orderId {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"appid"] = appId;
    dic[@"mch_id"] = mchId;
    dic[@"nonce_str"] = [NSString randString];
    dic[@"body"] = desc;
    dic[@"out_trade_no"] = orderId;
    dic[@"total_fee"] = price;
    dic[@"spbill_create_ip"] = @"8.8.8.8";
    dic[@"notify_url"] = notiUrl;
    dic[@"trade_type"] = @"APP";
    return dic;
}
//读统一前面返回的数据进行md5签名
+ (NSString *)createMD5SignWithPrepayId:(NSString *)prepayId packageId:(NSString *)packageId randStr:(NSString *)randStr timestamp:(UInt32)timestamp {
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:APP_ID forKey:@"appid"];
    [signParams setObject:randStr forKey:@"noncestr"];
    [signParams setObject:packageId forKey:@"package"];
    [signParams setObject:MCH_ID forKey:@"partnerid"];
    [signParams setObject:prepayId forKey:@"prepayid"];
    [signParams setObject:[NSString stringWithFormat:@"%u", timestamp] forKey:@"timestamp"];
    return [self createMd5Sign:signParams];
}

//读数据进行排序和MD5签名
+ (NSString *)createMd5Sign:(NSMutableDictionary *)dict {
    NSMutableString *contentString  = [NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator: ^NSComparisonResult (id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            ) {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", PARTNER_ID];
    //得到MD5 sign签名
    return contentString.md5;
}
@end

@implementation NSString (WeChat)
- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}
+ (NSString *)timestamp {
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
}
+ (NSString *)randString {
    return [NSString timestamp].md5;
}

@end
