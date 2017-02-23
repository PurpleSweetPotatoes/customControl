//
//  BQPay.m
//  Test-demo
//
//  Created by baiqiang on 17/2/21.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

#import "BQPay.h"
#import "BQAliPay.h"
#import "BQWeChatPay.h"

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
    [BQPay sharedSNPay].callBlock = block;
    if (type == AliPay) {
        [BQAliPay payWithOrderString:content];
    }else {
        [BQWeChatPay payWithOrderDict:content];
    }
}
+ (void)payWithType:(PayWay)type money:(NSString *)money orderId:(NSString *)orderId title:(NSString *)title desc:(NSString *)desc notiUrl:(NSString *)url callBlock:(void (^)(NSError *))block {
    [BQPay sharedSNPay].callBlock = block;
    if (type == AliPay) {
        [BQAliPay payWithMoney:money orderId:orderId title:title desc:desc];
    }else {
        [BQWeChatPay payWithMoney:money orderId:orderId title:title desc:desc];
    }
}
+ (NSError *)buildErrorWithCode:(NSInteger)code msg:(NSString *)msg {
    return [NSError errorWithDomain:msg code:code userInfo:nil];
}
#pragma mark - wechatDelegate
- (void)onResp:(BaseResp *)resp {
    void (^block)(NSError *) = [BQPay sharedSNPay].callBlock;
    NSLog(@"WeChatPay ===>  code = %d, content = %@",resp.errCode, resp.errStr);
    if (!block) {
        return;
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
                block(nil);
                break;
            default:
                block([BQPay buildErrorWithCode:resp.errCode msg:resp.errStr]);
                break;
        }
    }else {
        block([BQPay buildErrorWithCode:404 msg:@"支付类型错误"]);
    }
}
@end
