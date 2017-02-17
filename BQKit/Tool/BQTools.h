//
//  BQTools.h
//  Test
//
//  Created by baiqiang on 16/7/1.
//  Copyright © 2016年 白强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BQTools : NSObject
/**  警告消息展示 */
+ (void)showMessageWithTitle:(NSString * _Nullable)title
                     content:(NSString * _Nullable)content;
/**  警告消息展示，带点击回调 */
+ (void)showMessageWithTitle:(NSString * _Nullable)title
                     content:(NSString * _Nullable)content
               handle:(void(^ _Nullable)())clickedBtn;
/**  警告消息展示,自定义按钮名称带按钮事件 */
+ (void)showMessageWithTitle:(NSString * _Nullable)title
                     content:(NSString * _Nullable)content
                buttonTitles:(NSArray <NSString *> * _Nullable)titles
               clickedHandle:(void(^ _Nullable)(NSInteger index))clickedBtn;
/**  警告消息展示,自定义按钮名称带按钮事件、警告框弹出完成回调 */
+ (void)showMessageWithTitle:(NSString * _Nullable)title
                     content:(NSString * _Nullable)content
                buttonTitles:(NSArray <NSString *> * _Nullable)titles
               clickedHandle:(void(^ _Nullable)(NSInteger index))clickedBtn
            compeletedHandle:(void(^ _Nullable)())handle;

/**  归档处理操作 */
+ (void)encodeWithObject:(NSObject * _Nullable)encodeObject withcoder:(NSCoder * _Nullable)aCoder;

/**  解档处理操 */
+ (void)unencodeWithObject:(NSObject * _Nullable)unarchObject withcoder:(NSCoder * _Nullable)aDecoder;

/**  将对象转化为字符串 */
+ (NSString * _Nullable)jsonStringWithObject:(id _Nullable)object;

/**  将字典值转化为String类型 */
+ (NSMutableDictionary * _Nullable)valuesForamtToStringWithDict:(NSDictionary * _Nullable)dict;

/**  将数组值转化为String类型 */
+ (NSMutableArray * _Nullable)valuesForamtToStringWithArray:(NSArray * _Nullable)array;

/**  获取当前控制器 */
+ (UIViewController * _Nullable)currentViewController;

/**  获取当前APP版本号 */
+ (NSString * _Nullable)currentSystemVersion;

/**  获取APP的标示符 */
+ (NSString * _Nullable)currentBundleIdentifier;

/**  利用钥匙串保存数据 */
+ (BOOL)saveKeychainWithData:(NSData * _Nullable)data;

/**  加载钥匙串数据 */
+ (NSData * _Nullable)loadKeyChainValue;

/**  删除钥匙串数据 */
+ (BOOL)deleteKeyChainValue;

/**  随机色 */
+ (UIColor * _Nullable)randomColor;

@end

