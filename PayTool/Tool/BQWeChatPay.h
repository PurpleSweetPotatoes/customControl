//
//  BQWeChatPay.h
//  Test-demo
//
//  Created by baiqiang on 17/2/22.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQWeChatPay : NSObject

+ (void)handleOpenUrl:(NSURL *)url;

/**
 服务器预支付时调用
 
 @param orderDict   订单信息字典
 @param block       支付结果回调
 */
+ (void)payWithOrderDict:(NSDictionary *)orderDict
               callBlock:(void (^)(NSError *error))block;


/**
 微信支付
 
 @param money   单位:分
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
