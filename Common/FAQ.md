
### 常见问题 | [FAQ](FAQ-ENGLISH.md)

- 1.门铃的接听流程

	[Android](../Android/docs/觅睿科技Android%20SDK接入指南.md#631-门铃接听流程)
	[iOS](../iOS/docs/觅睿科技iOS%20SDK接入指南.md#724-门铃接听流程)

- 2.设备升级流程

	[Android](../Android/docs/觅睿科技Android%20SDK接入指南.md#94-升级设备固件)
	[iOS](../iOS/docs/觅睿科技iOS%20SDK接入指南.md#716-固件升级)

- 3.云存储支付

	Android：详见MeariSDKDemo

	iOS：
	
	```
    1.可以根据设备列表里的camera.info.cloudState的判断当前设备的云存储服务状态
    2.可以通过cloudGetStatusWithDeviceID 获取云存储服务的类型以及定价
    3.支持试用和激活码购买云存储
	AliWeb网页支付流程：
	1.根据云存储服务的价格计算最终价格
	2.调用cloudGetAlipayHtmlWithDeviceID 获取支付宝支付网页
	3.加载支付宝网页进行支付
	4.在工程的info的URL Type 中增加URL Schemes为自己应用BundleID 监听Appdelegate中 
  application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options    
  通过url参数判断是否支付成功 
  
	Paypal网页支付流程：
	
	1.初始化paypal SDK (导入pod 'Braintree/PayPal')
	
 	   - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [BTAppSwitch setReturnURLScheme:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]];
        return YES;
	    }
	
 	info.plist中加入
     <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>com.venmo.touch.v2</string>
    </array>
    
	2.根据云存储服务的价格计算最终价格
	3.调用cloudGetPayPalTokenSuccess 获取支付paypal token
	4.初始化paypal支付环境
	5.调用requestOneTimePayment 进行支付 获取支付凭证
	6.调用cloudCreateOrderWithDeviceID 向服务器校验是否支付成功
 
	具体可以参考demo
	```

- 4.设备的报警间隔如何设置

	[Android](../Android/docs/觅睿科技Android%20SDK接入指南.md#9520-报警频率设置)
 	[iOS](../iOS/docs/觅睿科技iOS%20SDK接入指南.md#7143-报警间隔)

- 5.设备的回放时长如何设置

	[Android](../Android/docs/觅睿科技Android%20SDK接入指南.md#9522-SD卡录像类型和时间设置)
	[iOS](../iOS/docs/觅睿科技iOS%20SDK接入指南.md#752-设置回放时长)
