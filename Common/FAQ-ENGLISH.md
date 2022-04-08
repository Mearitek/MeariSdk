
### FAQ | [常见问题](FAQ.md)

- 1.The answering process of the doorbell

	[Android](../Android/docs/Meari%20Android%20SDK%20Guide.md#631-Doorbell-Answering-Process)
	[iOS](../iOS/docs/MeariKit%20SDK%20Instruction.md#724-Doorbell-answering-process)
- 2.Device upgrade process

	[Android](../Android/docs/Meari%20Android%20SDK%20Guide.md#94-Upgrade-Device-Firmware)
	[iOS](../iOS/docs/MeariKit%20SDK%20Instruction.md#716-Firmware-upgrade)
- 3.cloud storage payment

	Android：See MeariSDKDemo for details
	
	iOS：
	
	```
	1.You can judge the cloud storage service status of the current device according to camera.info.cloudState in the device list
    	2.You can get the type and pricing of cloud storage services through cloudGetStatusWithDeviceID
   	3.Support trial and activation code to purchase cloud storage
	Alipay Web payment process：
	1.Calculate the final price based on the price of the cloud storage service
	2.Call cloudGetAlipayHtmlWithDeviceID to get the Alipay payment webpage
	3.Load Alipay webpage to pay
	4.Add URL Schemes to the URL Type of the project's info to monitor the Appdelegate for your own application BundleID
	  application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options    
	  Determine whether the payment is successful through the url parameter
  
	Paypal web payment process:
	
	1.Initialization paypal SDK (Add pod 'Braintree/PayPal')
	
 	   - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [BTAppSwitch setReturnURLScheme:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]];
        return YES;
	    }
	
 	info.plist Add:
     <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>com.venmo.touch.v2</string>
    </array>
    
	2.Calculate the final price based on the price of the cloud storage service
	3.Call cloudGetPayPalTokenSuccess to get payment paypal token
	4.Initialize the paypal payment environment
	5.Call requestOneTimePayment for payment Get payment voucher
	6.Call cloudCreateOrderWithDeviceID to check with the server whether the payment is successful
 
	For details, please refer to the demo
	```

	
- 4.How to set the alarm interval of the device

	[Android](../Android/docs/Meari%20Android%20SDK%20Guide.md#9520-Alarm-frequency-setting)
	[iOS](../iOS/docs/MeariKit%20SDK%20Instruction.md#7143-alarm-interval)
- 5.How to set the playback duration of the device
	
	[Android](../Android/docs/Meari%20Android%20SDK%20Guide.md#9522-SD-card-recording-type-and-time-setting)
	[iOS](../iOS/docs/MeariKit%20SDK%20Instruction.md#752-Set-playback-duration)
