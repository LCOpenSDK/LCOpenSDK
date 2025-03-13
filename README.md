LCOpenSDK is a tripartite library provided by Imou Open Platform to third-party developers. Developers can use the SDK to develop iOS applications. The APIs it includes are mainly the binding of Imou and Dahua devices, real-time preview, video playback, etc.
  
#### Installation with CocoaPods

To integrate LCOpenSDK into your Xcode project using CocoaPods, specify it in your Podfile:

pod 'LCOpenSDK', '~> 3.12.08'

#### Use configuration
You need to add configuration information before use, otherwise an error will occur.   

 * LCAddDeviceModule.xcodeproj
 * LCBaseModule.xcodeproj

Build Settings -> Framework Search Paths

Add value "$(PODS_ROOT)/LCOpenSDK/Framework"

