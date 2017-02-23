//
//  BQPayConfig.h
//  Test-demo
//
//  Created by baiqiang on 17/2/21.
//  Copyright © 2017年 baiqiang. All rights reserved.
//
#import "WXApiObject.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

#pragma mark -----支付类型-----
typedef NS_ENUM (NSUInteger, PayWay) {
    Pay_WeChat,
    Pay_AliPay
};

#pragma mark ----支付宝-------
//应用注册scheme,在info.plist定义URL types
static NSString * const AlipayScheme = @"";
//商户申请的appId
static NSString * const AliPayAppID = @"";
// 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
// 如果商户两个都设置了，优先使用 rsa2PrivateKey
static NSString * const rsa2PrivateKey = @"";
static NSString * const rsaPrivateKey = @"";
//支付结果后台通知地址
static NSString * const AliPayNotiUrl = @"";

#pragma mark ----微信支付------
//APPID
static NSString * const APP_ID = @"";
//商户号
static NSString * const MCH_ID = @"";
//商户API密钥
static NSString * const PARTNER_ID = @"";
//支付结果后台通知地址
static NSString * const WeChatNotiUrl = @"";
