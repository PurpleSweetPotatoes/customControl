//
//  BQNetWork.h
//  网络请求封装
//
//  Created by baiqiang on 15/12/2.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  网络请求类 可选使用等待指示器
 */
@interface BQNetWork : NSObject

+ (void)postUrl:(NSString *_Nullable)urlString
      parameter:(NSDictionary *_Nullable)parameter
     compeleted:(void(^_Nullable)(id _Nullable content))handle;

+ (void)getUrl:(NSString *_Nullable)urlString
     parameter:(NSDictionary *_Nullable)parameter
    compeleted:(void(^_Nullable)(id _Nullable content))handle;

/** 配置请求头设置 */
+ (void)configHttpHearders:(NSDictionary * _Nullable)hearders;

/**  上传头像请求 block回传字典格式必须为@{"key":图片对应key值,"name":上传到服务器名字,"data":图片data数据} */
+ (void)postUploadWithUrl:(NSString *_Nullable)urlString
            parameter:(NSDictionary *_Nullable)parameter
             picBlock:(NSDictionary *_Nullable(^_Nullable)())picBlock
           compeleted:(void(^_Nullable)(id _Nullable content))handle;
@end

