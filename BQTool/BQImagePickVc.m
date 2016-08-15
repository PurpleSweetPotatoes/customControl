//
//  BQImagePickVc.m
//  Test
//
//  Created by baiqiang on 16/7/26.
//  Copyright © 2016年 白强. All rights reserved.
//

#import "BQImagePickVc.h"

@interface BQImagePickVc ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/**  选取头像回调block */
@property (nonatomic, copy) void(^handleBlock)(UIImage *image);
/**  图片选择器 */
@property (nonatomic, strong) UIImagePickerController * picker;
@end

@implementation BQImagePickVc
- (void)showPickerImageMessageWihtVc:(UIViewController *)vc handleImage:(void (^)(UIImage *))handle{
    
    self.handleBlock = handle;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"选择图像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [alertVc addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self createImagePickerVcWithType:UIImagePickerControllerSourceTypeCamera presentedVc:vc];
            }]];
        }
        [alertVc addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self createImagePickerVcWithType:UIImagePickerControllerSourceTypePhotoLibrary presentedVc:vc];
        }]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [vc presentViewController:alertVc animated:YES completion:nil];
    }
}
- (void)createImagePickerVcWithType:(UIImagePickerControllerSourceType)type presentedVc:(UIViewController *)vc {
    self.picker.sourceType = type;
    [vc presentViewController:self.picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取编辑后的图片
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    if (self.handleBlock) {
        self.handleBlock(image);
    }
    [_picker dismissViewControllerAnimated:YES completion:nil];
}
- (UIImagePickerController *)picker {
    if (_picker == nil) {
        _picker = ({
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker;
        });
    }
    return _picker;
}
@end
