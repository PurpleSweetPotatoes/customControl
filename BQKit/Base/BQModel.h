//
//  BQModel.h
//  MyCocoPods
//
//  Created by baiqiang on 16/10/28.
//  Copyright © 2016年 baiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQModel : NSObject
+ (NSMutableArray *)mallocWithArray:(NSArray<NSDictionary *> *)array;
+ (instancetype)mallocWithDict:(NSDictionary *)infoDict __attribute__((objc_requires_super));
@end
