//
//  Copyright 2011 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//设备的类型
typedef NS_ENUM(NSUInteger, UIHardwareModel)
{
    UIHardwareModelUNKnow = 1,
	UIHardwareModelSimulator,
//	UIHardwareModeliPhone1G,
//	UIHardwareModeliPhone3G,
//	UIHardwareModeliPhone3GS,
    
    //ipohne4
	UIHardwareModeliPhone4GSM,
	UIHardwareModeliPhone4GSMRevA,
    UIHardwareModeliPhone4CDMA,
    //iphone4s
    UIHardwareModeliPhone4S,
    //iphone5
	UIHardwareModeliPhone5GSM,
    UIHardwareModeliPhone5Global,
    //iphone5c
	UIHardwareModeliPhone5cGSM,
    UIHardwareModeliPhone5cGlobal,
    //iphone5s
	UIHardwareModeliPhone5sGSM,
    UIHardwareModeliPhone5sGlobal,
    
    UIHardwareModeliPhone6Plus,
    UIHardwareModeliPhone6,
    UIHardwareModeliPhone6s,
    UIHardwareModeliPhone6sPlus,
    UIHardwareModeliPhoneSE,
    UIHardwareModeliPhone7,
    UIHardwareModeliPhone7Plus,
    
/*******ipod*****/
    UIHardwareModeliPodTouch1G,
    UIHardwareModeliPodTouch2G,
    UIHardwareModeliPodTouch3G,
    UIHardwareModeliPodTouch4G,
    UIHardwareModeliPodTouch5G,

    /*******ipad*****/
    UIHardwareModeliPad,
    UIHardwareModeliPad2Wifi,
    UIHardwareModeliPad2GSM,
    UIHardwareModeliPad2CDMA,
    UIHardwareModeliPad2RevA,
    
    UIHardwareModeliPadMini1GWifi,
    UIHardwareModeliPadMini1GGSM,
    UIHardwareModeliPadMini1GGlobal,
    
    UIHardwareModeliPad3Wifi,
    UIHardwareModeliPad3GSM,
    UIHardwareModeliPad3CDMA,
    
    UIHardwareModeliPad4Wifi,
    UIHardwareModeliPad4GSM,
    UIHardwareModeliPad4Global,
    
    UIHardwareModeliPadAirWifi,
    UIHardwareModeliPadAirCellular,
    UIHardwareModeliPadMini4GWifi,
    UIHardwareModeliPadMini4GCellular,
    UIHardwareModeliPadAir2Wifi,
    UIHardwareModeliPadAir2Cellular,
    UIHardwareModeliPadPro9_7Inch1GWifi,
    UIHardwareModeliPadPro9_7Inch1GCellular,
    UIHardwareModeliPadPro12_9Inch1GWifi,
    UIHardwareModeliPadPro12_9Inch1GCellular,
    
} ;


typedef NS_ENUM(NSUInteger, UIHardwareFamily) {
    UIHardwareFamilyiPhone,
    UIHardwareFamilyiPod,
    UIHardwareFamilyiPad,
    UIHardwareFamilyAppleTV,
    UIHardwareFamilyUnknown,
};

//设备的类型 例如UIHardwareTypeiPhne6 不包含制式 这里只写了常用的手机的  其它的可以用UIHardwareModel进行判断
typedef NS_ENUM(NSUInteger, UIHardwareType) {
    UIHardwareTypeUnKnown,
    UIHardwareTypeSimulator,
    UIHardwareTypeiPhne4,
    UIHardwareTypeiPhne4s,
    UIHardwareTypeiPhne5,
    UIHardwareTypeiPhne5c,
    UIHardwareTypeiPhne5s,
    UIHardwareTypeiPhne6,
    UIHardwareTypeiPhne6Plus,
    UIHardwareTypeiPhne6s,
    UIHardwareTypeiPhne6sPlus,
    UIHardwareTypeiPhneSE,
    UIHardwareTypeiPhne7,
    UIHardwareTypeiPhne7Plus
};
@interface UIDevice (HardwareModel) 


/**
 *	Returns hardware id of device instance
 */
- (UIHardwareModel)hardwareModel;

- (UIHardwareType)hardwareType;

- (UIHardwareFamily) deviceFamily;
@end
