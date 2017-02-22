//
//  BQPay.h
//  Test-demo
//
//  Created by baiqiang on 17/2/21.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQPayConfig.h"

@interface BQPay : NSObject<WXApiDelegate>
@property (nonatomic, assign)  BOOL wechatSDKIsRegiest;
@property (nonatomic, copy)  void (^callBlock)(NSError *error);
+ (instancetype)sharedSNPay;
+ (void)handleOpenUrl:(NSURL *)url;

/**
 服务器预支付时调用

 @param type    支付方式
 @param content 支付参数(微信为字典，支付宝为签名字符串)
 @param block   支付结果回调
 */
+ (void)payWithType:(PayWay)type
            content:(id)content
          callBlock:(void (^)(NSError *error))block;


/**
 客户端发起预支付时调用（需配置BQPayConfig信息）

 @param type    支付方式
 @param money   支付价格(单位为元)
 @param orderId 订单号
 @param title   订单名称
 @param desc    订单描述
 @param url     支付后台回调地址(向后台传输支付结果)
 @param block   支付结果回调
 */
+ (void)payWithType:(PayWay)type
              money:(NSString *)money
            orderId:(NSString *)orderId
              title:(NSString *)title
               desc:(NSString *)desc
            notiUrl:(NSString *)url
          callBlock:(void (^)(NSError *error))block;


/**
 错误信息构建

 @param code 代码值
 @param msg  信息
 */
+ (NSError *)buildErrorWithCode:(NSInteger)code msg:(NSString *)msg;
@end
