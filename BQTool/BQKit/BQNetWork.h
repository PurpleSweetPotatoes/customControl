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
 *  网络请求类(只处理json数据) 可选使用等待指示器
 */
@interface BQNetWork : NSObject
/**  带指示器的网络请求 */
+ (void)getDataWithUrl:(NSString *_Nullable)urlString
             parameter:(NSDictionary *_Nullable)parameter
      compeletedHandle:(void(^_Nullable)(id _Nullable content))handle;
+ (void)postDataWithUrl:(NSString *_Nullable)urlString
              parameter:(NSDictionary *_Nullable)parameter
       compeletedHandle:(void(^_Nullable)(id _Nullable content))handle;
/**  带指示器的网络请求 */
+ (void)animationGetDataWithUrl:(NSString *_Nullable)urlString
             parameter:(NSDictionary *_Nullable)parameter
      compeletedHandle:(void(^_Nullable)(id _Nullable content))handle;
+ (void)animationPostDataWithUrl:(NSString *_Nullable)urlString
                      parameter:(NSDictionary *_Nullable)parameter
               compeletedHandle:(void(^_Nullable)(id _Nullable content))handle;
/**  可配置请求头的网络请求 */
+ (void)asyncDataWithUrl:(NSString *_Nullable)urlString
               parameter:(NSDictionary *_Nullable)parameter
         headerParameter:(NSDictionary *_Nullable)headerParameter
             netWorkType:(NetWorkType)netWorkType
            hasAnimation:(BOOL)hasAnimation
        compeletedHandle:(void(^_Nullable)(id _Nullable content))handle;

/**  上传头像请求 block回传字典格式必须为@{"key":图片对应key值,"name":上传到服务器名字,"data":图片data数据} */
+ (void)postUploadWithUrl:(NSString *_Nullable)urlString
                parameter:(NSDictionary *_Nullable)parameter
                 picBlock:(NSDictionary *_Nullable(^_Nullable)())picBlock
              netWorkType:(NetWorkType)netWorkType
             hasAnimation:(BOOL)hasAnimation
         compeletedHandle:(void(^_Nullable)(id _Nullable content))handle;
@end

@interface BQActivityView : UIView
/**  显示活动指示器 */
+ (void)showActiviTy;
/**  关闭活动指示器 */
+ (void)hideActiviTy;
@end
