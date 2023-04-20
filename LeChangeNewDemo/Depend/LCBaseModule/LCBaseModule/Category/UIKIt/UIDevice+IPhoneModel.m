//
//  Copyright © 2015年 Imou. All rights reserved.
//

#import <LCBaseModule/UIDevice+IPhoneModel.h>
#import <sys/utsname.h>
#import <NetworkExtension/NetworkExtension.h>
#import <SystemConfiguration/CaptiveNetwork.h>


NSString *const Device_Type_Simulator = @"iPhone Simulator";
NSString *const Device_Type_iPod1 = @"iPod1";
NSString *const Device_Type_iPod2 = @"iPod2";
NSString *const Device_Type_iPod3 = @"iPod3";
NSString *const Device_Type_iPod4 = @"iPod4";
NSString *const Device_Type_iPod5 = @"iPod5";
NSString *const Device_Type_iPad2 = @"iPad2";
NSString *const Device_Type_iPad3 = @"iPad3";
NSString *const Device_Type_iPad4 = @"iPad4";
NSString *const Device_Type_iPhone4 = @"iPhone 4";
NSString *const Device_Type_iPhone4S = @"iPhone 4S";
NSString *const Device_Type_iPhone5 = @"iPhone 5";
NSString *const Device_Type_iPhone5S = @"iPhone 5S";
NSString *const Device_Type_iPhone5C = @"iPhone 5C";
NSString *const Device_Type_iPadMini1 = @"iPad Mini 1";
NSString *const Device_Type_iPadMini2 = @"iPad Mini 2";
NSString *const Device_Type_iPadMini3 = @"iPad Mini 3";
NSString *const Device_Type_iPadMini4 = @"iPad Mini 4";
NSString *const Device_Type_iPadAir1 = @"iPad Air 1";
NSString *const Device_Type_iPadAir2 = @"iPad Air 2";
NSString *const Device_Type_iPadPro = @"iPad Pro";
NSString *const Device_Type_iPhone6 = @"iPhone 6";
NSString *const Device_Type_iPhone6plus = @"iPhone 6 Plus";
NSString *const Device_Type_iPhone6S = @"iPhone 6S";
NSString *const Device_Type_iPhone6Splus = @"iPhone 6S Plus";
NSString *const Device_Type_iPhoneSE = @"iPhone SE";
NSString *const Device_Type_iPhone7 = @"iPhone 7";
NSString *const Device_Type_iPhone8 = @"iPhone 8";
NSString *const Device_Type_iPhone8Plus = @"iPhone 8 Plus";
NSString *const Device_Type_iPhoneX = @"iPhone X";
NSString *const Device_Type_iPhoneXS = @"iPhone XS";
NSString *const Device_Type_iPhoneXR = @"iPhone XR";
NSString *const Device_Type_iPhoneXSMAX = @"iPhone XS MAX";
NSString *const Device_Type_iPhone11 = @"iPhone 11";
NSString *const Device_Type_iPhone11Pro = @"iPhone 11 Pro";
NSString *const Device_Type_iPhone11ProMax = @"iPhone 11 Pro Max";
NSString *const Device_Type_Unrecognized = @"?unrecognized?";

@implementation UIDevice (IPhoneModel)

+ (iPhoneModel)lc_iPhonesModel {
    //bounds method gets the points not the pixels!!!
    CGRect rect = [[UIScreen mainScreen] bounds];

    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    //get current interface Orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    if (UIInterfaceOrientationUnknown == orientation) {
        return UnKnown;
    }
    
    if (UIInterfaceOrientationPortrait == orientation) {
        if (width ==  320.0f)
        {
            if (height == 480.0f)
            {
                return iPhone4;
            }
                return iPhone5;
        }
        else if (width == 375.0f)
            {
                return iPhone6;
            }
            else if (width == 414.0f)
            {
                return iPhone6Plus;
            }
        } else if (UIInterfaceOrientationLandscapeLeft == orientation || UIInterfaceOrientationLandscapeRight == orientation)
        {//landscape
            if (height == 320.0)
            {
                if (width == 480.0f)
                {
                    return iPhone4;
                }
                    return iPhone5;
            }
            else if (height == 375.0f)
            {
                return iPhone6;
            }
            else if (height == 414.0f)
            {
                return iPhone6Plus;
            }
        }

            return UnKnown;
        }

+ (NSString *)lc_iPhoneType
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{
                              @"i386"      : Device_Type_Simulator,
                              @"x86_64"    : Device_Type_Simulator,
                              @"iPod1,1"   : Device_Type_iPod1,
                              @"iPod2,1"   : Device_Type_iPod2,
                              @"iPod3,1"   : Device_Type_iPod3,
                              @"iPod4,1"   : Device_Type_iPod4,
                              @"iPod5,1"   : Device_Type_iPod5,
                              @"iPad2,1"   : Device_Type_iPad2,
                              @"iPad2,2"   : Device_Type_iPad2,
                              @"iPad2,3"   : Device_Type_iPad2,
                              @"iPad2,4"   : Device_Type_iPad2,
                              @"iPad2,5"   : Device_Type_iPadMini1,
                              @"iPad2,6"   : Device_Type_iPadMini1,
                              @"iPad2,7"   : Device_Type_iPadMini1,
                              @"iPhone3,1" : Device_Type_iPhone4,
                              @"iPhone3,2" : Device_Type_iPhone4,
                              @"iPhone3,3" : Device_Type_iPhone4,
                              @"iPhone4,1" : Device_Type_iPhone4S,
                              @"iPhone5,1" : Device_Type_iPhone5,
                              @"iPhone5,2" : Device_Type_iPhone5,
                              @"iPhone5,3" : Device_Type_iPhone5C,
                              @"iPhone5,4" : Device_Type_iPhone5C,
                              @"iPad3,1"   : Device_Type_iPad3,
                              @"iPad3,2"   : Device_Type_iPad3,
                              @"iPad3,3"   : Device_Type_iPad3,
                              @"iPad3,4"   : Device_Type_iPad4,
                              @"iPad3,5"   : Device_Type_iPad4,
                              @"iPad3,6"   : Device_Type_iPad4,
                              @"iPhone6,1" : Device_Type_iPhone5S,
                              @"iPhone6,2" : Device_Type_iPhone5S,
                              @"iPad4,1"   : Device_Type_iPadAir1,
                              @"iPad4,2"   : Device_Type_iPadAir1,
                              @"iPad4,4"   : Device_Type_iPadMini2,
                              @"iPad4,5"   : Device_Type_iPadMini2,
                              @"iPad4,6"   : Device_Type_iPadMini2,
                              @"iPad4,7"   : Device_Type_iPadMini3,
                              @"iPad4,8"   : Device_Type_iPadMini3,
                              @"iPad4,9"   : Device_Type_iPadMini3,
                              @"iPad5,1"   : Device_Type_iPadMini4,
                              @"iPad5,2"   : Device_Type_iPadMini4,
                              @"iPad5,3"   : Device_Type_iPadAir2,
                              @"iPad5,4"   : Device_Type_iPadAir2,
                              @"iPad6,3"   : Device_Type_iPadPro,
                              @"iPad6,4"   : Device_Type_iPadPro,
                              @"iPad6,7"   : Device_Type_iPadPro,
                              @"iPad6,8"   : Device_Type_iPadPro,
                              @"iPhone7,1" : Device_Type_iPhone6plus,
                              @"iPhone7,2" : Device_Type_iPhone6,
                              @"iPhone8,1" : Device_Type_iPhone6S,
                              @"iPhone8,2" : Device_Type_iPhone6Splus,
                              @"iPhone8,4" : Device_Type_iPhoneSE,
                              @"iPhone9,1" : Device_Type_iPhone7,
                              @"iPhone9,2" : Device_Type_iPhone7,
                              @"iPhone9,3" : Device_Type_iPhone7,
                              @"iPhone9,4" : Device_Type_iPhone7,
                              @"iPhone10,1" : Device_Type_iPhone8,
                              @"iPhone10,2" : Device_Type_iPhone8Plus,
                              @"iPhone10,3" : Device_Type_iPhoneX,
                              @"iPhone10,4" : Device_Type_iPhone8,
                              @"iPhone10,5" : Device_Type_iPhone8Plus,
                              @"iPhone10,6" : Device_Type_iPhoneX,
							  @"iPhone11,2" : Device_Type_iPhoneXS,
							  @"iPhone11,4" : Device_Type_iPhoneXSMAX,
							  @"iPhone11,6" : Device_Type_iPhoneXSMAX,
							  @"iPhone11,8" : Device_Type_iPhoneXR,
                              @"iPhone12,1" : Device_Type_iPhone11,
                              @"iPhone12,3" : Device_Type_iPhone11Pro,
                              @"iPhone12,5" : Device_Type_iPhone11ProMax,
                              @"x86_64" : Device_Type_Simulator,
                              @"i386" : Device_Type_Simulator
                              
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    if(deviceName){
        return deviceName;
    }
	
	if(code) {
		return code;
	}
	
    return Device_Type_Unrecognized;
}


+ (BOOL)lc_isIphoneX
{
    BOOL iPhoneXSeries = NO;
    
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    
    return iPhoneXSeries;
}

+ (NSString *)lc_getMacAddress {
    NSArray *array = CFBridgingRelease(CNCopySupportedInterfaces());
    NSDictionary *info = nil;
    for (NSString *interface in array) {
        info = CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)interface));
        if (info &&[info count]) {
            break;
        }
    }
    return info[@"BSSID"];
}


@end
