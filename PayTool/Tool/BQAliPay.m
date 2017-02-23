//
//  BQAliPay.m
//  Test-demo
//
//  Created by baiqiang on 17/2/21.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

#import "BQAliPay.h"
#import "BQPay.h"
#import "Order.h"
#import "RSADataSigner.h"

@implementation BQAliPay
+ (void)handleOpenUrl:(NSURL *)url {
//    [url.scheme isEqualToString:AlipayScheme]
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback: ^(NSDictionary *resultDic) {
            //APP支付结果回调
            void (^block)(NSError *) = [BQPay sharedSNPay].callBlock;
            NSString *resStr = resultDic[@"memo"];
            NSInteger resCode = [resultDic[@"resultStatus"] integerValue];
            NSString *errorMsg = resCode != 9000 ? resStr : nil;
            if (block) {
                if (resCode == 9000) {
                    block(nil);
                }
                else {
                    block([BQPay buildErrorWithCode:resCode msg:errorMsg]);
                }
            }
        }];
    }
}
+ (void)payWithOrderString:(NSString *)orderString {
    if (orderString != nil) {
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:AlipayScheme callback: ^(NSDictionary *resultDic) {
            //网页支付结果回调
            void (^block)(NSError *) = [BQPay sharedSNPay].callBlock;
            NSLog(@"AliPay ===> resultDic = %@", resultDic);
            if (!block) {
                return;
            }
            NSString *statuCode = resultDic[@"resultStatus"];
            if ([statuCode isEqualToString:@"9000"]) {
                //支付成功
                block(nil);
            }else {
                block([BQPay buildErrorWithCode:statuCode.integerValue msg:resultDic[@"memo"]]);
            }
        }];
    }
}
+ (void)payWithMoney:(NSString *)money orderId:(NSString *)orderId title:(NSString *)title desc:(NSString *)desc {
    if ([AliPayAppID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"缺少appId或者私钥。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    order.app_id = AliPayAppID;
    order.method = @"alipay.trade.app.pay";
    order.charset = @"utf-8";
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    order.version = @"1.0";
    order.notify_url = AliPayNotiUrl;
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = desc;
    order.biz_content.subject = title;
    order.biz_content.out_trade_no = orderId; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = money; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    //如果加签成功，则继续执行支付
    if (signedString) {
        // 将签名成功字符串格式化为订单字符串
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        [self payWithOrderString:orderString];
    }
}
@end
