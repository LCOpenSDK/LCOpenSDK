LCOpenSDK is a tripartite library provided by Imou Open Platform to third-party developers. Developers can use the SDK to develop iOS applications. The APIs it includes are mainly the binding of Imou and Dahua devices, real-time preview, video playback, etc.
  
#### Installation with CocoaPods

To integrate LCOpenSDK into your Xcode project using CocoaPods, specify it in your Podfile:

pod 'LCOpenSDK', '~> 3.10.0'

#### Use configuration
You need to add configuration information before use, otherwise an error will occur.   
•Path：Build Setting->Search Paths->Framework  Search Paths    
 Add：   
 $(PROJECT_DIR)/Pods/LCOpenSDK/Framework.  
•Path：Build Setting->Search Paths->Header Search Paths.  
 Add：   
$(PROJECT_DIR)/Pods/LCOpenSDK/Framework/LCOpenSDKDynamic.framework/Headers
$(PROJECT_DIR)/Pods/LCOpenSDK/Framework/LCOpenSDKDynamic.framework/Headers/LCOpenSDK
$(PROJECT_DIR)/Pods/LCOpenSDK/Framework/LCOpenSDKDynamic.framework/Headers/LCOpenNetSDK
$(PROJECT_DIR)/Pods/LCOpenSDK/Framework/LCOpenSDKDynamic.framework/Headers/LCOpenApi
