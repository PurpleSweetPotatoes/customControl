//
//  BQNetWork.h
//  网络请求封装
//
//  Created by baiqiang on 15/12/2.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NetWorkType) {
    netWorkTypePost,
    netWorkTypeGet
};

/**
 *  网络请求类 默认带有等待指示器
 */
@interface BQNetWork : NSObject

/**  网络请求 */
+ (void)asyncDataWithUrl:(NSString *_Nullable)urlString
               parameter:(NSDictionary *_Nullable)parameter
             netWorkType:(NetWorkType)netWorkType
            hasAnimation:(BOOL)hasAnimation
        compeletedHandle:(void(^_Nullable)(id _Nullable content,BOOL success))handle;

/**  可配置请求头的网络请求 */
+ (void)asyncDataWithUrl:(NSString *_Nullable)urlString
               parameter:(NSDictionary *_Nullable)parameter
         headerParameter:(NSDictionary *_Nullable)headerParameter
             netWorkType:(NetWorkType)netWorkType
            hasAnimation:(BOOL)hasAnimation
        compeletedHandle:(void(^_Nullable)(id _Nullable content,BOOL success))handle;

/**  参数做json编码的网络请求 */
+ (void)postDataParameterWithUrl:(NSString *_Nullable)urlString
                       parameter:(NSDictionary *_Nullable)parameter
                 headerParameter:(NSDictionary *_Nullable)headerParameter
                    hasAnimation:(BOOL)hasAnimation
                compeletedHandle:(void(^_Nullable)(id _Nullable content,BOOL success))handle;

/**  上传头像请求 block回传字典格式必须为@{"key":图片对应key值,"name":上传到服务器名字,"data":图片data数据} */
+ (void)postUploadWithUrl:(NSString *_Nullable)urlString
                parameter:(NSDictionary *_Nullable)parameter
                 picBlock:(NSDictionary *_Nullable(^_Nullable)())picBlock
              netWorkType:(NetWorkType)netWorkType
             hasAnimation:(BOOL)hasAnimation
         compeletedHandle:(void(^_Nullable)(id _Nullable content,BOOL success))handle;


@end
