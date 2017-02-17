//
//  BQWeakProxy.h
//  TableViewTest
//
//  Created by baiqiang on 16/5/18.
//  Copyright © 2016年 白强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQWeakProxy : NSProxy
/**  代理者 */
@property (nonatomic, weak, readonly) id target;

/**
 *  初始化一个空壳对象
 *  @param target 代理者
 *  @return 空壳对象
 */
- (instancetype)initWithTarget:(id)target;

/**
 *  初始化一个空壳对象
 *
 *  @param target 代理者
 *
 *  @return 空壳对象
 */
+ (instancetype)proxyWithTarget:(id)target;
@end
