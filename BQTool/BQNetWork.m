//
//  BQNetWork.m
//  网络请求封装
//
//  Created by baiqiang on 15/12/2.
//  Copyright © 2015年 baiqiang. All rights reserved.
//


#import "BQNetWork.h"
#import "BQTools.h"

static CGFloat const timeOutInterval = 15.0f;
@interface BQActivityView : UIView
/**  显示活动指示器 */
+ (void)showActiviTy;
/**  关闭活动指示器 */
+ (void)hideActiviTy;
@end

@implementation BQNetWork

+ (void)asyncDataWithUrl:(NSString *)urlString
               parameter:(NSDictionary *)parameter
             netWorkType:(NetWorkType)netWorkType
            hasAnimation:(BOOL)hasAnimation
        compeletedHandle:(void (^)(id _Nullable, BOOL))handle
{
    NSMutableURLRequest *request = [self configRequestWithUrl:urlString parameter:parameter headerParameter:nil netWorkType:netWorkType];
    [self asyncDataWithRequest:request hasAnimation:hasAnimation compeletedHandle:^(id  _Nullable content, BOOL success) {
        if (handle != nil) {
            handle(content,success);
        }
    }];
}
+ (void)asyncDataWithUrl:(NSString *)urlString
               parameter:(NSDictionary *)parameter
         headerParameter:(NSDictionary *)headerParameter
             netWorkType:(NetWorkType)netWorkType
            hasAnimation:(BOOL)hasAnimation
        compeletedHandle:(void (^)(id _Nullable, BOOL))handle {
    NSMutableURLRequest * request = [self configRequestWithUrl:urlString parameter:parameter headerParameter:headerParameter netWorkType:netWorkType];
    [self asyncDataWithRequest:request hasAnimation:hasAnimation compeletedHandle:^(id _Nullable content, BOOL success) {
        handle(content, success);
    }];
}

+ (NSMutableURLRequest *)configRequestWithUrl:(NSString *)urlString
                                    parameter:(NSDictionary *)parameter
                              headerParameter:(NSDictionary *)headerParameter
                                  netWorkType:(NetWorkType)netWorkType
{
    NSLog(@"\nURL地址:%@\n请求参数:\n%@\n请求方式:%@",urlString,parameter,netWorkType == netWorkTypeGet ? @"GET" : @"POST");
    NSMutableURLRequest *request;
    if (netWorkType == netWorkTypeGet) {
        NSURL *url = [self addUrlString:urlString parameter:parameter];
        request = [NSMutableURLRequest requestWithURL:url];
    }else {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        request.HTTPBody = [[self stringWithDictionary:parameter] dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPMethod = @"POST";
    }
    [headerParameter enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([request.allHTTPHeaderFields.allKeys containsObject:key]) {
            [request setValue:obj forHTTPHeaderField:key];
        }else {
            [request addValue:obj forHTTPHeaderField:key];
        }
    }];
    request.timeoutInterval = timeOutInterval;
    return request;
}
+ (void)postDataParameterWithUrl:(NSString *)urlString
                       parameter:(NSDictionary *)parameter
                 headerParameter:(NSDictionary *_Nullable)headerParameter
                    hasAnimation:(BOOL)hasAnimation
                compeletedHandle:(void (^)(id _Nullable, BOOL))handle {
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [headerParameter enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([request.allHTTPHeaderFields.allKeys containsObject:key]) {
            [request setValue:obj forHTTPHeaderField:key];
        }else {
            [request addValue:obj forHTTPHeaderField:key];
        }
    }];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = timeOutInterval;
    [self asyncDataWithRequest:request hasAnimation:hasAnimation compeletedHandle:^(id  _Nullable content, BOOL success) {
        handle(content, success);
    }];
}

+ (void)asyncDataWithRequest:(NSMutableURLRequest *)request
                hasAnimation:(BOOL)hasAnimation
            compeletedHandle:(void (^)(id _Nullable, BOOL))handle {
    if (hasAnimation == YES) {
        [BQActivityView showActiviTy];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (hasAnimation == YES) {
                [BQActivityView hideActiviTy];
            }
            if (error == nil) {
                NSLog(@"asyncUrl : %@",response.URL);
                NSError *error;
                id content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if (error) {
                    NSLog(@"数据json转化错误:%@",error.localizedDescription);
                    handle(data, YES);
                }else {
                    content = [BQTools valuesForamtToStringWithDict:content];
                    handle(content,YES);
                }
            }else {
                [BQTools showMessageWithTitle:@"温馨提示" content:[self getStringMessageFromErrorInfo:error]];
                handle(data, NO);
            }
        });
    }];
    [dataTask resume];
}

+ (void)postUploadWithUrl:(NSString *_Nullable)urlString
                parameter:(NSDictionary *_Nullable)parameter
                 picBlock:(NSDictionary *_Nullable(^_Nullable)())picBlock
              netWorkType:(NetWorkType)netWorkType
             hasAnimation:(BOOL)hasAnimation
         compeletedHandle:(void(^_Nullable)(id _Nullable content,BOOL success))handle {
    if (hasAnimation == YES) {
        [BQActivityView showActiviTy];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [self configPostImageURLWithString:urlString parameters:parameter picBlock:picBlock];
    request.HTTPMethod = netWorkType == netWorkTypePost? @"POST" : @"GET";
    [[session uploadTaskWithRequest:request fromData:request.HTTPBody completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (hasAnimation == YES) {
                [BQActivityView hideActiviTy];
            }
            if (error == nil) {
                NSLog(@"asyncUrl : %@",response.URL);
                NSError *error;
                id content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if (error) {
                    NSLog(@"数据json转化错误:%@",error.localizedDescription);
                    handle(data, YES);
                }else {
                    handle(content,YES);
                }
            }else {
                [BQTools showMessageWithTitle:@"温馨提示" content:[self getStringMessageFromErrorInfo:error]];
                handle(data, NO);
            }
        });
    }] resume];
}

/**  配置上传请求体格式,此处为图片上传请求体格式 */
+ (NSMutableURLRequest *)configPostImageURLWithString:(NSString *)string parameters:(NSDictionary *)parameters picBlock:(NSDictionary *_Nullable(^_Nullable)())picBlock {
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
        //声明字段，文件名
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
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    
    return request;
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
    NSString *result = [string  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet symbolCharacterSet]];
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
@end




static BQActivityView *activiyView;

@interface BQActivityView ()
@property (nonatomic, strong) CAReplicatorLayer *reaplicator;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) CALayer *showlayer;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSInteger showTimes;
@end

@implementation BQActivityView

+ (void)showActiviTy {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (activiyView == nil) {
            CGRect rect = [UIScreen mainScreen].bounds;
            activiyView = [[BQActivityView alloc] initWithFrame:rect];
            activiyView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        }
    });
    activiyView.showTimes += 1;
    
    activiyView.alpha = 1;
}

+ (void)hideActiviTy {
    if (activiyView.showTimes > 0) {
        activiyView.showTimes -= 1;
    }
    if (activiyView.showTimes == 0){
        [UIView animateWithDuration:0.25f animations:^{
            activiyView.alpha = 0;
        }];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showTimes = 0;
        [self.contentView addSubview:self.label];
        [self.contentView.layer addSublayer:self.reaplicator];
        [self addSubview:self.contentView];
        [self startAnimation];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.alpha = 0;
    }
    return self;
}
- (void)startAnimation {
    
    //对layer进行动画设置
    CABasicAnimation *animaiton = [CABasicAnimation animation];
    //设置动画所关联的路径属性
    animaiton.keyPath = @"transform.scale";
    //设置动画起始和终结的动画值
    animaiton.fromValue = @(1);
    animaiton.toValue = @(0.1);
    //设置动画时间
    animaiton.duration = 1.0f;
    //填充模型
    animaiton.fillMode = kCAFillModeForwards;
    //不移除动画
    animaiton.removedOnCompletion = NO;
    //设置动画次数
    animaiton.repeatCount = INT_MAX;
    //添加动画
    [self.showlayer addAnimation:animaiton forKey:@"anmation"];
}
- (UIView *)contentView {
    if (_contentView == nil) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        contentView.layer.cornerRadius = 10.0f;
        contentView.layer.borderColor = [UIColor colorWithWhite:0.926 alpha:1.000].CGColor;
        contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        contentView.layer.shadowOpacity = 0.1;
        contentView.layer.shadowOffset = CGSizeMake(1, 1);
        contentView.center = self.center;
        contentView.backgroundColor = [UIColor whiteColor];
        _contentView = contentView;
    }
    return _contentView;
}
- (UILabel *)label {
    if (_label == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.reaplicator.frame), CGRectGetWidth(self.contentView.frame), 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        _label = label;
    }
    return _label;
}
- (CAReplicatorLayer *)reaplicator{
    if (_reaplicator == nil) {
        int numofInstance = 10;
        CGFloat duration = 1.0f;
        //创建repelicator对象
        CAReplicatorLayer *repelicator = [CAReplicatorLayer layer];
        //设置其位置
        repelicator.bounds = CGRectMake(0, 0, 50, 50);
        repelicator.position = CGPointMake(self.contentView.bounds.size.width * 0.5, self.contentView.bounds.size.height * 0.5);
        //需要生成多少个相同实例
        repelicator.instanceCount = numofInstance;
        //代表实例生成的延时时间;
        repelicator.instanceDelay = duration / numofInstance;
        //设置每个实例的变换样式
        repelicator.instanceTransform = CATransform3DMakeRotation(M_PI * 2.0 / 10.0, 0, 0, 1);
        //创建repelicator对象的子图层，repelicator会利用此子图层进行高效复制。并绘制到自身图层上
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 8, 8);
        //子图层的仿射变换是基于repelicator图层的锚点，因此这里将子图层的位置摆放到此锚点附近。
        CGPoint point = [repelicator convertPoint:repelicator.position fromLayer:self.layer];
        layer.position = CGPointMake(point.x, point.y - 20);
        layer.backgroundColor = MainThemeColor.CGColor;
        layer.cornerRadius = 5;
        layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
        _showlayer = layer;
        //将子图层添加到repelicator上
        [repelicator addSublayer:layer];
        _reaplicator = repelicator;
    }
    return _reaplicator;
}
@end