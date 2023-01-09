//
//  Copyright © 2017年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//
#import "LCModuleConfig.h"
#import "UIColor+LeChange.h"
#import "UIColor+HexString.h"

int g_configDistributionVersion = -1;

@interface LCModuleConfig()
@end

@implementation LCModuleConfig

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static LCModuleConfig *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[LCModuleConfig alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self loadConfigPlist];
    }
    
    return self;
}

- (void)loadConfigPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"LCModuleConfig" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    _dicConfigs = [[NSMutableDictionary alloc] initWithDictionary:dic];
}


- (NSDictionary *)shareSheetType
{
    NSDictionary *dicConfig = [_dicConfigs objectForKey:@"ShareSheetType"];
    return [self generateDictionaryContainColor:dicConfig];
}

- (BOOL)isShareEnable {

    
    return ![self isGeneralVersion];
}

- (BOOL)isChinaMainland {
    NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"GLOBAL_JOINT_CURRENT_MODE"];
    return index == 0;
}

- (BOOL)isShowAllRecord {
    id value = [_dicConfigs valueForKey:@"isShowAllRecord"];
    return [value boolValue];
}

- (BOOL)isShowCollectionMaskView {
    NSDictionary *maskView = [_dicConfigs valueForKey:@"MaskView"];
    id value = [maskView valueForKey:@"isShowCollection"];
    
    return [value boolValue];
}

- (BOOL)isShowAllRecordMaskView {
    NSDictionary *maskView = [_dicConfigs valueForKey:@"MaskView"];
    id value = [maskView valueForKey:@"isShowAllRecord"];
    
    return [value boolValue];
}

- (BOOL)isShowMoveAreaMaskView {
    NSDictionary *maskView = [_dicConfigs valueForKey:@"MaskView"];
    id value = [maskView valueForKey:@"isShowMoveArea"];
    
    return [value boolValue];
}

- (BOOL)isShowLinkAgeMaskView {
    NSDictionary *maskView = [_dicConfigs valueForKey:@"MaskView"];
    id value = [maskView valueForKey:@"isShowLinkage"];
    
    return [value boolValue];
}

- (BOOL)isShowWeatherMaskView {
    NSDictionary *maskView = [_dicConfigs valueForKey:@"MaskView"];
    id value = [maskView valueForKey:@"isShowWeather"];
    
    return [value boolValue];
}

- (BOOL)isShowDialogMaskView {
    NSDictionary *maskView = [_dicConfigs valueForKey:@"MaskView"];
    id value = [maskView valueForKey:@"isShowDialog"];
    
    return [value boolValue];
}

- (NSInteger)ptzPanelStyle {
    id value = [_dicConfigs valueForKey:@"PTZPanelStyle"];
    return [value integerValue];
}

- (UIColor *)playOperateBgColor {
    return [self private_colorWithKey:@"PlayOperateBgColor"];
}

- (UIColor *)liveMonitorDateBarColor {
    return [self private_colorWithKey:@"LiveMonitorDateBarColor"];
}

- (UIColor *)navigationTextColor
{
    return [self private_colorWithKey:@"NavigationTextColor"];
}

- (UIColor *)navigationBarColor
{
    return [self private_colorWithKey:@"NavigationBarColor"];
}


- (UIColor *)themeColor {
    return [self private_colorWithKey:@"ThemeColor"];
}

- (UIColor *)buyCloudTipColor {
    return [self private_colorWithKey:@"BuyCloudTipColor"];
}

- (UIColor *)zoomFocusProgressBarColor {
    return [self private_colorWithKey:@"ZoomFocusProgressBarColor"];
}

- (UIColor *)confirmButtonColor {
    return [self private_colorWithKey:@"ConfirmButtonColor"];
}

- (UIColor *)themeSecondColor {
    return [self private_colorWithKey:@"ThemeSecondColor"];
}

- (NSDictionary *)commonButtonConfig
{
    NSDictionary *dicConfig = [_dicConfigs objectForKey:@"CommonButtonConfig"];
    return [self generateDictionaryContainColor:dicConfig];
}

- (NSDictionary *)generateDictionaryContainColor:(NSDictionary *)dicOrigin
{
    NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithCapacity:2];
    
    for (NSString *key in dicOrigin.allKeys) {
        UIColor *color = [self private_colorWithKey:key value:dicOrigin[key]];
        
        if (color) {
            [dicResult setObject:color forKey:key];
        } else {
            [dicResult setObject:dicOrigin[key] forKey:key];
        }
    }
    return dicResult;
}



#pragma mark - Prvivate
- (UIColor *)private_colorWithKey:(NSString *)key value:(id)value
{
    UIColor *color;
    NSString *uppercaseString = [key uppercaseString];
    
    //将带有Color的转换成Color
    if ([uppercaseString containsString:@"COLOR"] && [value isKindOfClass:[NSString class]]) {
        color = [UIColor lc_colorWithHexString:(NSString *)value];
        
        //兼容颜色转换错误
        if (color == nil) {
            color = [UIColor lccolor_c43];
        }
    }
    
    return color;
}

- (UIColor *)private_colorWithKey:(NSString *)key
{
    NSDictionary *colors = [_dicConfigs valueForKey:@"Color"];
    NSString *colorString = [colors valueForKey:key];
    
    return [UIColor lc_colorWithHexString:colorString];
}

//MARK: - Extension
- (CGFloat)commonButtonCornerRadius
{
    NSNumber *radius = [self commonButtonConfig][@"cornerRadius"];
    return radius ? radius.floatValue : 5;
}

- (UIColor *)commonButtonColor
{
    UIColor *color = [self commonButtonConfig][@"backgroundColor"];
    return color ? : [UIColor lccolor_c1];
}

- (NSString *)serviceCall
{
	//SMB Todo::
	return @"0123456789";
}

@end
