//
//  BQImagePickVc.h
//  Test
//
//  Created by baiqiang on 16/7/26.
//  Copyright © 2016年 白强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BQImagePickVc : NSObject
- (void)showPickerImageMessageWihtVc:(UIViewController *)vc handleImage:(void(^)(UIImage *image))handle;
@end
