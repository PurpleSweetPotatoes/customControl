//
//  BQAliPay.h
//  Test-demo
//
//  Created by baiqiang on 17/2/21.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQAliPay : NSObject

+ (void)handleOpenUrl:(NSURL *)url;

/**
 服务器预支付时调用
 
 @param orderString 订单字符串
 @param block       支付结果回调
 */
+ (void)payWithOrderString:(NSString *)orderString
                 callBlock:(void (^)(NSError *error))block;


/**
 支付宝支付
 
 @param money   单位:元
 @param orderId 订单号
 @param title   订单名称
 @param desc    订单描述
 @param url     支付后台回调地址(向后台传输支付结果)
 @param block   支付结果回调
 */
+ (void)payWithMoney:(NSString *)money
             orderId:(NSString *)orderId
               title:(NSString *)title
                desc:(NSString *)desc
             notiUrl:(NSString *)url
           callBlock:(void (^)(NSError *error))block;
@end
