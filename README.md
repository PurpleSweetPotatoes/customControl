customControl
========
####关于代码
这些代码为从学习iOS来到现在实际项目开发中，精炼出来的封装代码,使用相对简单，由于所做的项目开发难度相对较小，所以这里封装的一些都属于常用的小工具。希望能给大家带来便利。下面是几个具体封装类的使用方法
####BQScreenAdaptation.h
此类主要是为了屏幕适配所写，使用的原理为等比例适配。不同于传统的等比例适配，笔者的等比例全部是基于屏幕宽度来进行等比例计算。经过两个项目的编写发现使用此类的好处在与可以直接适配iPhone的所有机型分辨率。由于全部以宽来进行等比例所以布局出来的高度可能会超出实际屏幕高度。在这里笔者的解决方案为设计一个容器视图(scrollView)用以添加界面，若布局后的视图超出屏幕只需要再设置容器视图的画布展示大小即可。

    /**
    将IPHONE_WIDTH改为对应设计图的宽度
    在使用的时候直接使用BQAdaptationFrame函数
    还原为其设计图上的坐标位置，需要除以BQAdaptationWidth()
    */
    #define IPHONE_WIDTH 375
    在此类中添写View和CALayer的类目，可以用top、left、right、bottom等访问对应的orign.x、orign.y、width、height等属性
####BQNetWork.h
网络请求类,笔者个人封装的网络请求，使用简单方便。功能不如AFNetwork强大，但胜在简便，轻量。使用方法如下所示

    /**  网络请求 */
    + (void)asyncDataWithUrl:(NSString *_Nullable)urlString
               parameter:(NSDictionary *_Nullable)parameter
             netWorkType:(NetWorkType)netWorkType
            hasAnimation:(BOOL)hasAnimation
        compeletedHandle:(void(^_Nullable)(id _Nullable content,BOOL success))handle;
    /**  可配置请求头的网络请求 */
    + (void)asyncDataWithUrl:(NSString *_Nullable)urlString
               parameter:(NSDictionary *_Nullable)parameter
         headerParameter:(NSDictionary *_Nullable)headerParameter
             netWorkType:(NetWorkType)netWorkType
            hasAnimation:(BOOL)hasAnimation
        compeletedHandle:(void(^_Nullable)(id _Nullable content,BOOL success))handle;
    /**  上传头像请求 block回传字典格式必须为@{"key":图片对应key值,"name":上传到服务器名字,"data":图片data数据} */
    + (void)postUploadWithUrl:(NSString *_Nullable)urlString
                parameter:(NSDictionary *_Nullable)parameter
                 picBlock:(NSDictionary *_Nullable(^_Nullable)())picBlock
              netWorkType:(NetWorkType)netWorkType
             hasAnimation:(BOOL)hasAnimation
         compeletedHandle:(void(^_Nullable)(id _Nullable content,BOOL success))handle;     
####BQImagePicker
图片选择器，自动判断是否支持照相功能

    //此处若不使用自定义裁剪方式、则使用showPickerImageWithHandleImage方法，默认使用系统裁剪方式
    [BQImagePicker showPickerImageWithClipType:ClipSizeTypeTwoScaleOne handleImage:^(UIImage *image) {
        NSLog(@"%@",image);
    }];
####BQTools
    /**  消息展示带按钮事件 */
    + (void)showMessageWithTitle:(NSString * _Nullable)title
                         content:(NSString * _Nullable)content
                    buttonTitles:(NSArray <NSString *> * _Nullable)titles
                clickedHandle:(void(^ _Nullable)(NSInteger index))clickedBtn;
    /**  消息展示带按钮事件、完成事件 */
    + (void)showMessageWithTitle:(NSString * _Nullable)title
                         content:(NSString * _Nullable)content
                    buttonTitles:(NSArray <NSString *> * _Nullable)titles
                   clickedHandle:(void(^ _Nullable)(NSInteger index))clickedBtn
                compeletedHandle:(void(^ _Nullable)())handle;
    /**  归档处理操作 */
    + (void)encodeWithObject:(NSObject * _Nullable)encodeObject 
                   withcoder:(NSCoder * _Nullable)aCoder;
    /**  解档处理操 */
    + (void)unencodeWithObject:(NSObject * _Nullable)unarchObject 
                     withcoder:(NSCoder * _Nullable)aDecoder;
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
####BQPopView
仿照UIAlertView界面所写提示框，在展示后自动消失。不影响控制器的跳转
####NSString+safe.h
关于NSString加密解密处理的方法类目,包含有MD5和SHA散列加密，另含NSSrring和NSData的Base64加密解密
####BQKit
其中BQWeakProxy和BQFPSLabel为模仿YYKit所写的虚拟代理类和帧数检测类，用以防止循环引用所和检测刷新频率使用。BQTextFieldView为所写的一个文本框视图，效果图如下
  
![xiaoguo.gif](http://oblos8tvd.bkt.clouddn.com/xiaoguo.gif)
####新添加UIButton UITableView UIImageView类目


一句代码完成button视图及文本的布局

    [btn adjustLabAndImageLocation:BQBtnLocationType_imageTopLabBottom];

一句代码完成ImageView的展示及手势操作

    [imageView canShowImage];
    
TableView类目默认添加无数据占位图,如需关闭占位图只需要调用closeHolderImage方法即可


后期有新的封装会持续加入，若代码中有何不妥之处欢迎指出。

