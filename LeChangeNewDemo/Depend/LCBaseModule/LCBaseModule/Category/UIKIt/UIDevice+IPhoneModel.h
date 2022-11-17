//
//  Copyright © 2015年 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(char, iPhoneModel){//0~3
    iPhone4,//320*480
    iPhone5,//320*568
    iPhone6,//375*667
    iPhone6Plus,//414*736
    UnKnown
};

@interface UIDevice (IPhoneModel)

+ (iPhoneModel)lc_iPhonesModel;



+ (NSString *)lc_iPhoneType;

+ (BOOL)lc_isIphoneX;

/**
 获取设备的mac地址
 
 @return mac地址
 */
+ (NSString *)lc_getMacAddress;



@end
