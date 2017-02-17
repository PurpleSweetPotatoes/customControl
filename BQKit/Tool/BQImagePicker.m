//
//  BQImagePicker.m
//  NavgationBar-Test
//
//  Created by baiqiang on 16/10/17.
//  Copyright © 2016年 baiqiang. All rights reserved.
//

#import "BQImagePicker.h"

@interface BQImagePicker()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/**  选取头像回调block */
@property (nonatomic, copy) void(^handleBlock)(UIImage *image);
/**  图片选择器 */
@property (nonatomic, strong) UIImagePickerController * picker;
/**  裁剪比例 */
@property (nonatomic, assign) ClipSizeType type;
@end

@implementation BQImagePicker
#pragma mark - Class Method
+  (instancetype)allocWithZone:(struct _NSZone *)zone {
    static BQImagePicker * imagePicker;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imagePicker = [super allocWithZone:zone];
    });
    return imagePicker;
}
+ (void)showPickerImageWithHandleImage:(void (^)(UIImage *))handle {
    [self showPickerImageWithClipType:ClipSizeTypeNone handleImage:handle];
}
+ (void)showPickerImageWithClipType:(ClipSizeType)type handleImage:(void (^)(UIImage *))handle {
    BQImagePicker * picker = [[self alloc] init];
    picker.handleBlock = handle;
    picker.type = type;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"选择图像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [alertVc addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [picker createImagePickerVcWithType:UIImagePickerControllerSourceTypeCamera];
            }]];
        }
        [alertVc addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [picker createImagePickerVcWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        }]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [[picker currentViewController] presentViewController:alertVc animated:YES completion:nil];
    }
}
#pragma mark - create Class

#pragma mark - Live Cycle

#pragma mark - instancetype Method
- (void)createImagePickerVcWithType:(UIImagePickerControllerSourceType)type{
    self.picker.sourceType = type;
    self.picker.allowsEditing = self.type == ClipSizeTypeNone;
    [[self currentViewController] presentViewController:self.picker animated:YES completion:nil];
}
- (UIViewController *)currentViewController {
    UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}
#pragma mark - LoadNetWrokData

#pragma mark - button Action

#pragma mark - Delegate Method
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取编辑后的图片
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    if (self.type != ClipSizeTypeNone) {
        __weak typeof(self) weakSelf = self;
        [picker dismissViewControllerAnimated:YES completion:^{
            [weakSelf showClipVcWithImage:image];
        }];
    }else {
        [picker dismissViewControllerAnimated:YES completion:nil];
        if (self.handleBlock != nil) {
            self.handleBlock(image);
        }
    }
}
- (void)showClipVcWithImage:(UIImage *)image {
    __weak typeof(self) weakSelf = self;
    [BQDisImageView showClipViewWithImage:image clipSize:self.type callBack:^(UIImage *image) {
        weakSelf.handleBlock(image);
    }];
}
#pragma mark - View Create

#pragma mark - set Method

#pragma mark - get Method
- (UIImagePickerController *)picker {
    if (_picker == nil) {
        _picker = ({
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker;
        });
    }
    return _picker;
}
@end


@interface BQDisImageView ()
/**  图片视图 */
@property (nonatomic, strong) UIImageView *imageView;
/**  背景视图 */
@property (nonatomic, strong) UIView *backView;
/**  图片 */
@property (nonatomic, strong) UIImage *image;
/**  框位置 */
@property (nonatomic, strong) CAShapeLayer * clipLayer;
/**  回调函数 */
@property (nonatomic, copy) void(^callBack)(UIImage * image);
@end

@implementation BQDisImageView

#pragma mark - 类方法
+ (void)showClipViewWithImage:(UIImage *)image clipSize:(ClipSizeType)type callBack:(void (^)(UIImage *))callBack {
    BQDisImageView * disImage = [[self alloc] initWithImage:image clipSize:type];
    disImage.callBack = callBack;
    [[UIApplication sharedApplication].keyWindow addSubview:disImage];
}
#pragma mark - 创建方法
- (instancetype)initWithImage:(UIImage *)image clipSize:(ClipSizeType)size{
    self = [super init];
    if (self != nil) {
        self.image = image;
        [self initUI];
        self.clipLayer = [CAShapeLayer layer];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width / 4;
        CGFloat height = 0;
        if (size == ClipSizeTypeOneScaleOne) {
            width = width * 4 / 3;
            height = width;
        }else if (size == ClipSizeTypeTwoScaleOne) {
            height = width;
            width *= 2;
        }else {
            height = width * 2;
            width *= 3;
        }
        
        UIColor * layerColor = [UIColor greenColor];
        self.clipLayer.frame = CGRectMake(0, 0, width, height);
        self.clipLayer.position = self.center;
        self.clipLayer.borderWidth = 1.0f;
        self.clipLayer.borderColor = layerColor.CGColor;
        CGFloat spacing = 20;
        UIBezierPath * path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(0, 20)];
        [path addLineToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(spacing, 0)];
        
        [path moveToPoint:CGPointMake(width - spacing, 0)];
        [path addLineToPoint:CGPointMake(width, 0)];
        [path addLineToPoint:CGPointMake(width, spacing)];
        
        [path moveToPoint:CGPointMake(width, height - spacing)];
        [path addLineToPoint:CGPointMake(width, height)];
        [path addLineToPoint:CGPointMake(width - spacing, height)];
        
        [path moveToPoint:CGPointMake(20, height)];
        [path addLineToPoint:CGPointMake(0, height)];
        [path addLineToPoint:CGPointMake(0, height - 20)];
        
        self.clipLayer.path = path.CGPath;
        self.clipLayer.lineWidth = 3.0f;
        self.clipLayer.strokeColor = layerColor.CGColor;
        self.clipLayer.fillColor = [UIColor clearColor].CGColor;
        
        [self.layer addSublayer:self.clipLayer];
    }
    return self;
}

#pragma mark - 实例方法

- (void)initUI{
    
    self.backgroundColor = [UIColor grayColor];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    self.frame = CGRectMake(0, 0, width, height);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.userInteractionEnabled = YES;
    imageView.frame = CGRectMake(0, 0, width, imageView.image.size.height * width / imageView.image.size.width);
    imageView.center = self.center;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerChange:)];
    [imageView addGestureRecognizer:pan];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerChange:)];
    [imageView addGestureRecognizer:pinch];
    self.imageView = imageView;
    [self addSubview:imageView];
    
    [self createBtnWithFrame:CGRectMake(40, height - 70, 50, 30) title:@"取消" tag:100];
    [self createBtnWithFrame:CGRectMake(width - 90, height - 70, 50, 30) title:@"裁剪" tag:101];
}
- (void)createBtnWithFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag {
    UIButton  * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = frame;
    backBtn.backgroundColor = self.backgroundColor;
    backBtn.tag = tag;
    [backBtn setTitle:title forState:UIControlStateNormal];
    [self addSubview:backBtn];
}
#pragma mark - 事件响应方法
- (void)gestureRecognizerChange:(UIGestureRecognizer*)gesture{
    // 拖拽
    if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gesture;
        static CGPoint startCenter;
        if (pan.state == UIGestureRecognizerStateBegan) {
            startCenter = self.imageView.center;
        }
        else if (pan.state == UIGestureRecognizerStateChanged) {
            // 此处必须从self.view中获取translation，因为translation和view的transform属性挂钩，若transform改变了则translation也会变
            CGPoint translation = [pan translationInView:self];
            self.imageView.center = CGPointMake(startCenter.x + translation.x, startCenter.y + translation.y);
        }
        else if (pan.state == UIGestureRecognizerStateEnded) {
            startCenter = CGPointZero;
            if (self.imageView.frame.origin.x > self.clipLayer.frame.origin.x) {
                [UIView animateWithDuration:0.1 animations:^{
                    CGRect frame = self.imageView.frame;
                    frame.origin.x = self.clipLayer.frame.origin.x;
                    self.imageView.frame = frame;
                }];
            }
            if (CGRectGetMaxX(self.imageView.frame) < CGRectGetMaxX(self.clipLayer.frame)) {
                [UIView animateWithDuration:0.1 animations:^{
                    CGRect frame = self.imageView.frame;
                    frame.origin.x = CGRectGetMaxX(self.clipLayer.frame) - frame.size.width;
                    self.imageView.frame = frame;
                }];
            }
            if (self.imageView.frame.origin.y > self.clipLayer.frame.origin.y) {
                [UIView animateWithDuration:0.1 animations:^{
                    CGRect frame = self.imageView.frame;
                    frame.origin.y = self.clipLayer.frame.origin.y;
                    self.imageView.frame = frame;
                }];
            }
            if (CGRectGetMaxY(self.imageView.frame) < CGRectGetMaxY(self.clipLayer.frame)) {
                [UIView animateWithDuration:0.1 animations:^{
                    CGRect frame = self.imageView.frame;
                    frame.origin.y = CGRectGetMaxY(self.clipLayer.frame) - frame.size.height;
                    self.imageView.frame = frame;
                }];
            }
        }
    }
    // 缩放
    else {
        UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer *)gesture;
        static CGFloat startScale;
        if (pinch.state == UIGestureRecognizerStateBegan) {
            startScale = pinch.scale;
        }
        else if (pinch.state == UIGestureRecognizerStateChanged) {
            CGFloat scale = (pinch.scale - startScale) +1;
            self.imageView.transform = CGAffineTransformScale(self.imageView.transform, scale, scale);
            startScale = pinch.scale;
        }
        else if (pinch.state == UIGestureRecognizerStateEnded) {
            startScale = 1;
            if (self.imageView.frame.size.width < self.clipLayer.bounds.size.width || self.imageView.frame.size.height < self.clipLayer.bounds.size.height) {
                
                [UIView animateWithDuration:0.1 animations:^{
                    self.imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.imageView.image.size.height * self.bounds.size.width / self.imageView.image.size.width);
                    self.imageView.center = self.center;
                }];
                
            }
        }
    }
}
- (void)bottomBtnAction:(UIButton *)btn {
    if (btn.tag == 101) {
        self.clipLayer.hidden = YES;
        CGFloat scale = [UIScreen mainScreen].scale;
        UIGraphicsBeginImageContextWithOptions(self.bounds.size,NO,scale);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        UIImage * image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(self.clipLayer.frame.origin.x * scale, self.clipLayer.frame.origin.y * scale, self.clipLayer.frame.size.width * scale, self.clipLayer.frame.size.height * scale))];
        UIGraphicsEndImageContext();
        if (self.callBack != nil) {
            self.callBack(image);
        }
    }
    [self removeFromSuperview];
}
#pragma mark - Method

#pragma mark - set方法

#pragma mark - get方法

@end
