1.依赖框架
libsqlite3
libc++
libz
CoreMotion
CFNetwork
CoreText
CoreGraphics
CoreTelephony
QuartzCore
SystemConfiguration

2.openssl/asn1.h not found 问题方案
 在Build Setting --> Header Search Paths 中添加路径:"$(SRCROOT)/PayTool/SDK/AliPaySDK" AliPaySDK为对应的工程路径 使用recursive选项

3.scheme url 添加
AliPay scheme 的url 为 BQPayConfig中AlipayScheme对应字符串
WeChat scheme 的url 为 BQPayConfig中APP_ID对应字符串

4.支付结果回调
application: handleOpenURL:方法中实现[BQPay handleOpenUrl:]

5.如客户端自行构建支付请在BQPayCOnfig中配置相关信息
