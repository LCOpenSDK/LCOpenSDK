//
//  Copyright 2011 boxedfolder.com. All rights reserved.
//

#import "UIDevice+DHHardware.h"
#include <sys/sysctl.h>

@implementation UIDevice (HardwareModel)

-(UIHardwareModel)hardwareModel
{
    NSString *hwString = [self modelIdentifier];

    if([hwString isEqualToString: @"i386"] || [hwString isEqualToString:@"x86_64"])   
        return UIHardwareModelSimulator;
    
// iPod
    if([hwString isEqualToString: @"iPod1,1"])
        return UIHardwareModeliPodTouch1G;
    if([hwString isEqualToString: @"iPod2,1"])
        return UIHardwareModeliPodTouch2G;
    if([hwString isEqualToString: @"iPod3,1"])
        return UIHardwareModeliPodTouch3G;
    if([hwString isEqualToString: @"iPod4,1"])
        return UIHardwareModeliPodTouch4G;
    
// iPad http://theiphonewiki.com/wiki/IPad
    if([hwString isEqualToString: @"iPad1,1"])
        return UIHardwareModeliPad;
    if([hwString isEqualToString: @"iPad2,1"])
        return UIHardwareModeliPad2Wifi;
    if([hwString isEqualToString: @"iPad2,2"])
        return UIHardwareModeliPad2GSM;
    if([hwString isEqualToString: @"iPad2,3"])
        return UIHardwareModeliPad2CDMA;
    if([hwString isEqualToString: @"iPad2,4"])
        return UIHardwareModeliPad2RevA;
    if ([hwString isEqualToString:@"iPad2,5"])
        return UIHardwareModeliPadMini1GWifi;
    if ([hwString isEqualToString:@"iPad2,6"])
        return UIHardwareModeliPadMini1GGSM;
    if ([hwString isEqualToString:@"iPad2,7"])
        return UIHardwareModeliPadMini1GGlobal;
    if([hwString isEqualToString: @"iPad3,1"])
        return UIHardwareModeliPad3Wifi;
    if([hwString isEqualToString: @"iPad3,2"])
        return UIHardwareModeliPad3GSM;
    if([hwString isEqualToString: @"iPad3,3"])
        return UIHardwareModeliPad3CDMA;
    if ([hwString isEqualToString:@"iPad3,4"])
        return UIHardwareModeliPad4Wifi;
    if ([hwString isEqualToString:@"iPad3,5"])
        return UIHardwareModeliPad4GSM;
    if ([hwString isEqualToString:@"iPad3,6"])
        return UIHardwareModeliPad4Global;
    if ([hwString isEqualToString:@"iPad4,1"])
        return UIHardwareModeliPadAirWifi;
    if ([hwString isEqualToString:@"iPad4,2"])
        return UIHardwareModeliPadAirCellular;
    if ([hwString isEqualToString:@"iPad5,1"])
        return UIHardwareModeliPadMini4GWifi;
    if ([hwString isEqualToString:@"iPad5,2"])
        return UIHardwareModeliPadMini4GCellular;
    if ([hwString isEqualToString:@"iPad5,3"])
        return UIHardwareModeliPadAir2Wifi;
    if ([hwString isEqualToString:@"iPad5,4"])
        return UIHardwareModeliPadAir2Cellular;
    if ([hwString isEqualToString:@"iPad6,3"])
        return UIHardwareModeliPadPro9_7Inch1GWifi;
    if ([hwString isEqualToString:@"iPad6,4"])
        return UIHardwareModeliPadPro9_7Inch1GCellular;
    if ([hwString isEqualToString:@"iPad6,7"])
        return UIHardwareModeliPadPro12_9Inch1GWifi;
    if ([hwString isEqualToString:@"iPad6,8"])
        return UIHardwareModeliPadPro12_9Inch1GCellular;
    
    
    // iPhone http://theiphonewiki.com/wiki/IPhone
//    if([hwString isEqualToString: @"iPhone1,1"])    
//        return UIHardwareModeliPhone1G;
//    if([hwString isEqualToString: @"iPhone1,2"])   
//        return UIHardwareModeliPhone3G;
//    if([hwString isEqualToString: @"iPhone2,1"])  
//        return UIHardwareModeliPhone3GS;
    if([hwString isEqualToString: @"iPhone3,1"]) 
        return UIHardwareModeliPhone4GSM;
    if([hwString isEqualToString: @"iPhone3,2"]) 
        return UIHardwareModeliPhone4GSMRevA;
    if ([hwString isEqualToString:@"iPhone3,3"])
        return UIHardwareModeliPhone4CDMA;
    if([hwString isEqualToString: @"iPhone4,1"]) 
        return UIHardwareModeliPhone4S;
    if([hwString isEqualToString: @"iPhone5,1"])
        return UIHardwareModeliPhone5GSM;
    if([hwString isEqualToString: @"iPhone5,2"])
        return UIHardwareModeliPhone5Global;
    if([hwString isEqualToString: @"iPhone5,3"])
        return UIHardwareModeliPhone5cGSM;
    if([hwString isEqualToString: @"iPhone5,4"])
        return UIHardwareModeliPhone5cGlobal;
    if([hwString isEqualToString: @"iPhone6,1"])
        return UIHardwareModeliPhone5sGSM;
    if([hwString isEqualToString: @"iPhone6,2"])
        return UIHardwareModeliPhone5sGlobal;
    if ([hwString isEqualToString:@"iPhone7,1"])
        return UIHardwareModeliPhone6Plus;
    if ([hwString isEqualToString:@"iPhone7,2"])
        return UIHardwareModeliPhone6;
    if ([hwString isEqualToString:@"iPhone8,1"])
        return UIHardwareModeliPhone6s;
    if ([hwString isEqualToString:@"iPhone8,2"])
        return UIHardwareModeliPhone6sPlus;
    if ([hwString isEqualToString:@"iPhone8,4"])
        return UIHardwareModeliPhoneSE;
    if ([hwString isEqualToString:@"iPhone9,1"])
        return UIHardwareModeliPhone7;
    if ([hwString isEqualToString:@"iPhone9,2"])
        return UIHardwareModeliPhone7Plus;
    if ([hwString isEqualToString:@"iPhone9,3"])
        return UIHardwareModeliPhone7;
    if ([hwString isEqualToString:@"iPhone9,4"])
        return UIHardwareModeliPhone7Plus;
    
    return UIHardwareModelUNKnow;
}

- (UIHardwareFamily) deviceFamily
{
    NSString *modelIdentifier = [self modelIdentifier];
    if ([modelIdentifier hasPrefix:@"iPhone"])
        return UIHardwareFamilyiPhone;
    if ([modelIdentifier hasPrefix:@"iPod"])
        return UIHardwareFamilyiPod;
    if ([modelIdentifier hasPrefix:@"iPad"])
        return UIHardwareFamilyiPad;
    if ([modelIdentifier hasPrefix:@"AppleTV"])
        return UIHardwareFamilyAppleTV;
    return UIHardwareFamilyUnknown;
}

-(UIHardwareType)hardwareType
{
    /*
     UIHardwareModeliPhone1G,
     UIHardwareModeliPhone3G,
     UIHardwareModeliPhone3GS,
     不支持了 直接略过
     */
    
    UIHardwareModel model = [self hardwareModel];
    if (model == UIHardwareModelUNKnow)
    {
        return UIHardwareTypeUnKnown;
    }
    else if (model == UIHardwareModelSimulator)
    {
        return UIHardwareTypeSimulator;
    }
    else if (model == UIHardwareModeliPhone4GSM ||
             model == UIHardwareModeliPhone4GSMRevA ||
             model == UIHardwareModeliPhone4CDMA)
    {
        return UIHardwareTypeiPhne4;
    }
    else if (model == UIHardwareModeliPhone4S)
    {
        return UIHardwareTypeiPhne4s;
    }
    else if (model == UIHardwareModeliPhone5GSM||
             model == UIHardwareModeliPhone5Global)
    {
        return UIHardwareTypeiPhne5;
    }
    else if (model == UIHardwareModeliPhone5cGSM||
             model == UIHardwareModeliPhone5cGlobal)
    {
        return UIHardwareTypeiPhne5c;
    }
    else if (model == UIHardwareModeliPhone5sGSM||
             model == UIHardwareModeliPhone5sGlobal)
    {
        return UIHardwareTypeiPhne5c;
    }
    else if (model == UIHardwareModeliPhone6Plus)
    {
        return UIHardwareTypeiPhne6Plus;
    }
    else if (model == UIHardwareModeliPhone6)
    {
        return UIHardwareTypeiPhne6;
    }
    else if (model == UIHardwareModeliPhone6s)
    {
        return UIHardwareTypeiPhne6s;
    }
    else if (model == UIHardwareModeliPhone6sPlus)
    {
        return UIHardwareTypeiPhne6sPlus;
    }
    else if (model == UIHardwareModeliPhoneSE)
    {
        return UIHardwareTypeiPhneSE;
    }
    else if (model == UIHardwareModeliPhone7)
    {
        return UIHardwareTypeiPhne7;
    }
    else if (model == UIHardwareModeliPhone7Plus)
    {
        return UIHardwareTypeiPhne7Plus;
    }
    
    return UIHardwareTypeUnKnown;
}


#pragma mark - 
- (NSString *)getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

- (NSString *)modelIdentifier
{
    return [self getSysInfoByName:"hw.machine"];
}
@end
