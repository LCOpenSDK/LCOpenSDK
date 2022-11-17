//
//  Copyright © 2018年 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extern)

/**
 *  改变行间距
 */
+ (void)lc_changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)lc_changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)lc_changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
