//
//  BQModel.m
//  MyCocoPods
//
//  Created by baiqiang on 16/10/28.
//  Copyright © 2016年 baiqiang. All rights reserved.
//

#import "BQModel.h"
#import <objc/runtime.h>

@implementation BQModel

+ (instancetype)mallocWithDict:(NSDictionary *)infoDict {
    BQModel * model = [self new];
    unsigned int ivarCount = 0;
    //获取传入类成员变量列表
    Ivar *ivarArray = class_copyIvarList(model.class, &ivarCount);
    //设置遍历数组次数
    unsigned int count = ivarCount;
    //循环遍历数组
    for (int i = 0; i < count; i ++) {
        //得到变量名字
        const char *name = ivar_getName(ivarArray[i]);
        //char* 转化为 NSString 类型
        NSString *ivarKey = [[NSString stringWithUTF8String:name] substringFromIndex:1];
        if (infoDict[ivarKey] != nil) {
            [model setValue:infoDict[ivarKey] forKey:ivarKey];
        }
    }
    free(ivarArray);
    return model;
}
@end
