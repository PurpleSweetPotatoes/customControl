//
//  BQPay.m
//  Test-demo
//
//  Created by baiqiang on 17/2/21.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

#import "BQPay.h"
#import "BQAliPay.h"

@implementation BQPay
static BQPay * _instance;
+ (instancetype)sharedSNPay {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.wechatSDKIsRegiest = NO;//初始化的时候未注册
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

#pragma mark - public
+ (void)handleOpenUrl:(NSURL *)url {
    [BQAliPay handleOpenUrl:url];
}
+ (void)payWithType:(PayWay)type content:(id)content callBlock:(void (^)(NSError *))block {
    _instance.callBlock = block;
    if (type == AliPay) {
        [BQAliPay payWithOrderString:content callBlock:block];
    }else {
        
    }
}
+ (void)payWithType:(PayWay)type money:(NSString *)money orderId:(NSString *)orderId title:(NSString *)title desc:(NSString *)desc notiUrl:(NSString *)url callBlock:(void (^)(NSError *))block {
    if (type == AliPay) {
        [BQAliPay payWithMoney:money orderId:orderId title:title desc:desc notiUrl:url callBlock:block];
    }else {
        
    }
}
+ (NSError *)buildErrorWithCode:(NSInteger)code msg:(NSString *)msg {
    return [NSError errorWithDomain:msg code:code userInfo:nil];
}
#pragma mark - wechatDelegate
- (void)onResp:(BaseResp *)resp {
    BQPay * pay = _instance;
    if ([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
                if (pay.callBlock) {
                    pay.callBlock(nil);
                }
                break;
            default:
                if (pay.callBlock) {
                    pay.callBlock([BQPay buildErrorWithCode:resp.errCode msg:resp.errStr]);
                }
                break;
        }
    }else {
        if (pay.callBlock) {
            pay.callBlock([BQPay buildErrorWithCode:404 msg:@"支付类型错误"]);
        }
    }
}
@end
