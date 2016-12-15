//
//  UITableView+Extend.m
//  tableViewTest
//
//  Created by MAC on 16/12/14.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "UITableView+Extend.h"
#import <objc/runtime.h>

static const char * kPlaceHolderkey = "kPlaceHolderkey";

@implementation UITableView (Extend)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method loadData = class_getInstanceMethod(self, @selector(reloadData));
        Method new_loadData = class_getInstanceMethod(self, @selector(re_loadData));
        method_exchangeImplementations(loadData, new_loadData);
    });
}

- (void)re_loadData {
    [self re_loadData];
    
    if (![self placeHolderView].superview) return;
    
    BOOL showHolder = NO;
    NSInteger sectionNum = [self numberOfSections];
    for (NSInteger i = 0; i < sectionNum; ++i) {
        NSInteger cellNum = [self numberOfRowsInSection:i];
        if (cellNum > 0) {
            showHolder = YES;
            break;
        }
    }
    [self changeDisplay:showHolder];
}
- (void)changeDisplay:(BOOL)showHolder {
    UIView *mj_footView = [self valueForKey:@"mj_footer"];
    [self placeHolderView].hidden = showHolder;
    if (mj_footView) {
        mj_footView.hidden = !showHolder;
    }
}
- (UIImageView *)placeHolderView {
    UIImageView * holderView = objc_getAssociatedObject(self,kPlaceHolderkey);
    if (holderView == nil) {
        holderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablePlaceHolder"]];
        holderView.center = CGPointMake(self.bounds.size.width * 0.5, 30 + holderView.bounds.size.height * 0.5);
        [self addSubview:holderView];
        objc_setAssociatedObject(self, kPlaceHolderkey, holderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return holderView;
}

- (void)closeHolderImage {
    UIImageView * holderView = [self placeHolderView];
    if (holderView.superview) {
        [holderView removeFromSuperview];
    }
}
@end
