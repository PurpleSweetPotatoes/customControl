//
//  BQWeakProxy.m
//  TableViewTest
//
//  Created by baiqiang on 16/5/18.
//  Copyright © 2016年 白强. All rights reserved.
//

#import "BQWeakProxy.h"
#import <objc/runtime.h>

@implementation BQWeakProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}
+ (instancetype)proxyWithTarget:(id)target {
    return [[BQWeakProxy alloc] initWithTarget:target];
}
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _target;
}
- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (NSUInteger)hash {
    return [_target hash];
}
- (Class)superclass {
    return [_target superclass];
}
- (Class)class {
    return [_target class];
}
- (BOOL)isEqual:(id)object {
    return [_target isEqual:object];
}
- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}
- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}
- (BOOL)isProxy {
    return YES;
}
- (NSString *)description {
    return [_target description];
}
- (NSString *)debugDescription {
    return [_target debugDescription];
}

@end
