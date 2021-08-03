//
//  Copyright © 2015 dahua. All rights reserved.
//

#import <LCBaseModule/DHUserManager.h>
#import <GTMBase64/GTMBase64.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDImageCache.h>
#import <LCBaseModule/DHFileManager.h>
#import <LCBaseModule/DHImageLoaderManager.h>
#import <LCBaseModule/DHModuleConfig.h>

@implementation DHUserManager

@synthesize language = _language, sound = _sound, timeFormat = _timeFormat, timezoneOffset = _timezoneOffset, bAlertBindEmail = _bAlertBindEmail;

static DHUserManager *userManager = nil;
+ (DHUserManager *)shareInstance
{
    if(userManager == nil)
    {
        userManager = [[DHUserManager alloc]init];
    }

    return userManager;
}

- (id)init
{
    if (self = [super init])
    {
        _isAllowCellularPlay = NO;
        _showExperiencePlanGuide = YES;
        _messageState = YES;
        _messageTime = @"00:00-23:59";
        _bAlertBindEmail = YES;
        _showSearchLightGuide = YES;
        _isShowUserExperiencePlan = NO;
        _isSupportAd = NO;
        _openUserExperience = NO;
        
        // 默认未开启调试模式
        _openDebugModeTime = 0;
    }
    
    return self;
}

//获取配置
- (void)getUserConfigFile
{
    // config
    NSString *configfilepath = [DHFileManager userConfigFilePath];
    NSString *configStr = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:configfilepath]
                                                   encoding:NSUTF8StringEncoding
                                                      error:NULL];
    
    NSData *desData = [GTMBase64 decodeString:configStr];
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:desData];
    
    id val = [dic objectForKey:@"showExperiencePlanGuide"];
    if (val != NULL) {
        _showExperiencePlanGuide = [val boolValue];
    }
    
    val = [dic objectForKey:@"isAllowCellularPlay"];
    if (val != NULL) {
        _isAllowCellularPlay = [val boolValue];
    }
    
    val = [dic objectForKey:@"messageState"];
    if (val != NULL) {
        _messageState = [val boolValue];
    }
    
    val = [dic objectForKey:@"messageTime"];
    if (val != NULL) {
        _messageTime = val;
    }
    
    val = [dic objectForKey:@"showSearchLightGuide"];
    if (val != NULL) {
        _showSearchLightGuide = [val boolValue];
    }
    
    val = [dic objectForKey:@"openUserExperience"];
    if (val != NULL) {
        _openUserExperience = [val boolValue];
    }

    val = [dic objectForKey:@"isShowUserExperiencePlan"];
    if (val != NULL) {
        _isShowUserExperiencePlan = [val boolValue];
    }
    
    
    val = [dic objectForKey:@"messageTime"];
    if (val != NULL) {
        _messageTime = val;
    }
    
    val = [dic objectForKey:@"isSupportAd"];
    if (val != NULL) {
        _isSupportAd = [val boolValue];
    }
    
    _countryCode = dic[@"countryCode"];
    _avatarUrl = dic[@"avatarUrl"];
    _avatarMd5 = dic[@"avatarMd5"];
    _nickname = dic[@"nickname"];
    _wxNickname = dic[@"wxNickname"];
    _fbNickname = dic[@"fbNickname"];
    _appleNickname = dic[@"appleNickname"];
    _phone = dic[@"phone"];
    _email = dic[@"email"];
    
    //时区数据
    _beginSummer = dic[@"beginSummer"];
    _endSummer = dic[@"endSummer"];
    _areaIndex = [dic[@"areaIndex"] intValue];
    _timeZoneIndex = [dic[@"timeZoneIndex"] intValue];
    _setDefault = [dic[@"setDefault"] boolValue];
    
    _mSSIDMutableArray = dic[@"mSSIDMutableArray"];
    _deviceVersionDictionary = dic[@"deviceVersionDictionary"];
    _timeFormat = dic[@"timeFormat"];
    _sound = dic[@"sound"];
    _timezoneOffset = [dic[@"timezoneOffset"] intValue];
    _bAlertBindEmail = [dic[@"bAlertBindEmail"] boolValue];
    _msgId = [dic[@"msgId"] longLongValue];
    _openDebugModeTime = [[dic objectForKey:@"openDebugModeTime"] doubleValue];
}

- (void)saveUserConfigFile
{
    // config
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSNumber *showExperiencePlanGuide = [NSNumber numberWithBool:_showExperiencePlanGuide];
    [dic setObject:showExperiencePlanGuide forKey:@"showExperiencePlanGuide"];
    
    NSNumber *isAllowCellularPlayNumber = [NSNumber numberWithBool:_isAllowCellularPlay];
    [dic setObject:isAllowCellularPlayNumber forKey:@"isAllowCellularPlay"];
    
    NSNumber *showSearchLightGuide = [NSNumber numberWithBool:_showSearchLightGuide];
    [dic setObject:showSearchLightGuide forKey:@"showSearchLightGuide"];
    
    NSNumber *openUserExperienceNumber = [NSNumber numberWithBool:_openUserExperience];
    [dic setObject:openUserExperienceNumber forKey:@"openUserExperience"];
    
    NSNumber *messageState = [NSNumber numberWithBool:_messageState];
    [dic setObject:messageState forKey:@"messageState"];
    
    if (_openDebugModeTime > 0) {
        [dic setObject:[NSNumber numberWithDouble:_openDebugModeTime] forKey:@"openDebugModeTime"];
    }

    NSNumber *isShowUserExperiencePlanNumber = [NSNumber numberWithBool:_isShowUserExperiencePlan];
    [dic setObject:isShowUserExperiencePlanNumber forKey:@"isShowUserExperiencePlan"];

    NSNumber *isSupportAdNumber = [NSNumber numberWithBool:_isSupportAd];
    [dic setObject:isSupportAdNumber forKey:@"isSupportAd"];
    
    if (_openDebugModeTime > 0) {
        [dic setObject:[NSNumber numberWithDouble:_openDebugModeTime] forKey:@"openDebugModeTime"];
    }

    if(_messageTime.length > 0) {
        NSString * messageTime = [NSString stringWithFormat:@"%@",_messageTime];
        [dic setObject:messageTime forKey:@"messageTime"];
    }
    
    dic[@"countryCode"] = _countryCode;
    dic[@"nickname"] = _nickname;
    dic[@"avatarUrl"] = _avatarUrl;
    dic[@"avatarMd5"] = _avatarMd5;
    dic[@"wxNickname"] = _wxNickname;
    dic[@"fbNickname"] = _fbNickname;
    dic[@"appleNickname"] = _appleNickname;
    dic[@"phone"] = _phone;
    dic[@"email"] = _email;
    dic[@"language"] = _language;
    dic[@"timeFormat"] = _timeFormat;
    dic[@"sound"] = _sound;
    dic[@"timezoneOffset"] = [NSString stringWithFormat:@"%d",_timezoneOffset];
    dic[@"bAlertBindEmail"] = [NSString stringWithFormat:@"%d",_bAlertBindEmail];
    
    //时区设置；
    [dic setValue:_beginSummer forKey:@"beginSummer"];
    [dic setValue:_endSummer forKey:@"endSummer"];
    [dic setValue:@(_areaIndex) forKey:@"areaIndex"];
    [dic setValue:@(_timeZoneIndex) forKey:@"timeZoneIndex"];
    [dic setValue:@(_setDefault) forKey:@"setDefault"];
    
    [dic setValue:_mSSIDMutableArray forKey:@"mSSIDMutableArray"];
    [dic setValue:_deviceVersionDictionary forKey:@"deviceVersionDictionary"];
    [dic setValue:@(_msgId) forKey:@"msgId"];
    
    NSData *config2Data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    NSString *config2Str = [GTMBase64 stringByEncodingData:config2Data];
    [config2Str writeToFile:[DHFileManager userConfigFilePath]
                 atomically:YES
                   encoding:NSUTF8StringEncoding
                      error:NULL];
}

- (void)syncUserCountryInfo
{
    if(![DHUserManager shareInstance].countryCode || [DHUserManager shareInstance].countryCode.length == 0)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:@"PopCountryInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:@"PopCountryInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)clearCacheAvatar:(NSString *)avatarUrl completion:(void(^)(NSString *acheKey))completion
{
    NSString *cacheKey = [DHImageLoaderManager getImageCacheKey:_avatarUrl];
    //旧的头像地址对应的缓存key值
    [[SDImageCache sharedImageCache] removeImageForKey:cacheKey withCompletion:^{
        NSLog(@"DHUserManager::Delete cache avatar image %@", cacheKey);
        
        //为解决新旧头像地址不一致时【未设置时、已设置时，头像地址不同】，缓存key值不同的问题
        NSString *newCacheKey = [DHImageLoaderManager getImageCacheKey:avatarUrl];
        if (completion) {
            completion(newCacheKey);
        }
    }];
}

- (void)clearDiskAndCacheAvatar:(NSString *)avatarUrl completion:(void(^)(NSString *acheKey))completion {
    NSString *cacheKey = [DHImageLoaderManager getImageCacheKey:_avatarUrl];
    [[SDImageCache sharedImageCache] removeImageForKey:cacheKey fromDisk:YES withCompletion:^{
        NSLog(@"DHUserManager::Delete cache avatar image %@", cacheKey);
        
        //为解决新旧头像地址不一致时【未设置时、已设置时，头像地址不同】，缓存key值不同的问题
        NSString *newCacheKey = [DHImageLoaderManager getImageCacheKey:avatarUrl];
        if (completion) {
            completion(newCacheKey);
        }
    }];
}

- (void)downloadAvatar:(NSString *)avatarUrl
{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:avatarUrl] options:0  progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image) {
            //先清空旧的图片，再进行覆盖写入
            NSString *cacheKey = [DHImageLoaderManager getImageCacheKey:avatarUrl];
            [[SDImageCache sharedImageCache] removeImageForKey:cacheKey withCompletion:^{
                [[SDImageCache sharedImageCache] storeImageDataToDisk:data forKey:cacheKey];
            }];
        }
    }];
}

-(void)clearData
{
    NSString *userFilePath = [DHFileManager userFolder];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:userFilePath])
    {
        [fm removeItemAtPath:userFilePath error:nil];
    }
    userManager = nil;
}

#pragma mark - Set Properties
- (void)setIsSupportAd:(BOOL)isSupportAd {
    _isSupportAd = isSupportAd;
    [self saveUserConfigFile];
}

- (void)setEmail:(NSString *)email
{
	NSLog(@"🍎🍎🍎 %@:: Set email %@", NSStringFromClass([self class]), email);
    _email = email;
    [self saveUserConfigFile];
}

- (void)setPhone:(NSString *)phone
{
	NSLog(@"🍎🍎🍎 %@:: Set phone %@", NSStringFromClass([self class]), phone);
    _phone = phone;
    [self saveUserConfigFile];
}

- (void)setNickname:(NSString *)nickname
{
    _nickname = nickname;
    [self saveUserConfigFile];
}

- (void)setCountryCode:(NSString *)countryCode
{
    _countryCode = countryCode;
    [self saveUserConfigFile];
}

- (void)setAvatarUrl:(NSString *)avatarUrl
{
    _avatarUrl = avatarUrl;
    [self saveUserConfigFile];
}

- (void)setAvatarMd5:(NSString *)avatarMd5
{
    _avatarMd5 = avatarMd5;
    [self saveUserConfigFile];
}

- (void)setWxNickname:(NSString *)wxNickname
{
    _wxNickname = wxNickname;
    [self saveUserConfigFile];
}

- (void)setFbNickname:(NSString *)fbNickname
{
    _fbNickname = fbNickname;
    [self saveUserConfigFile];
}

- (void)setAppleNickname:(NSString *)appleNickname
{
    _appleNickname = appleNickname;
    [self saveUserConfigFile];
}

- (void)setLanguage:(NSString *)language
{
    _language = language;
    [self saveUserConfigFile];
}

- (void)setTimeFormat:(NSString *)timeFormat
{
    _timeFormat = timeFormat;
    [self saveUserConfigFile];
}

- (void)setSound:(NSString *)sound
{
    _sound = sound;
    [self saveUserConfigFile];
}

- (void)setTimezoneOffset:(int)timezoneOffset
{
    _timezoneOffset = timezoneOffset;
    [self saveUserConfigFile];
}

- (void)setBAlertBindEmail:(BOOL)bAlertBindEmail
{
    _bAlertBindEmail = bAlertBindEmail;
    [self saveUserConfigFile];
}

- (void)setMsgId:(int64_t)msgId{
    _msgId = msgId;
    [self saveUserConfigFile];
}

-(void)setIsAllowCellularPlay:(BOOL)isAllowCellularPlay
{
    _isAllowCellularPlay = isAllowCellularPlay;
    [self saveUserConfigFile];
}

- (void)setIsShowUserExperiencePlan:(BOOL)isShowUserExperiencePlan {
    _isShowUserExperiencePlan = isShowUserExperiencePlan;
    [self saveUserConfigFile];
}

- (void)setOpenDebugModeTime:(NSTimeInterval)openDebugModeTime {
    _openDebugModeTime = openDebugModeTime;
    [self saveUserConfigFile];
}

- (NSString *)language
{
	NSString *currentLanguage = [NSLocale preferredLanguages].firstObject;
	if ([currentLanguage hasPrefix:@"zh"]) {
		currentLanguage = [currentLanguage containsString:@"zh-Hant"] ? @"zh-TW" : @"zh-CN";
	}
	
	_language = currentLanguage;
    return _language;
}

- (NSString *)sound
{
    if (!_sound || [_timeFormat isEqualToString:@""])
    {
        _sound = @"";
    }
    return _sound;
}

- (NSString *)timeFormat
{
    if (!_timeFormat || [_timeFormat isEqualToString:@""])
    {
        _timeFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _timeFormat;
}

- (int)timezoneOffset
{
    if (_timezoneOffset == 0)
    {
        NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone] ;///获取当前时区信息
        NSInteger sourceGMTOffset = [destinationTimeZone secondsFromGMT];
        _timezoneOffset = (int)sourceGMTOffset;
    }
    return _timezoneOffset;
}

- (BOOL)bAlertBindEmail
{
    if (_bAlertBindEmail)
    {
        return !(_email.length > 0);
    }
    else
    {
        return _bAlertBindEmail;
    }
}

- (void)setOpenUserExperience:(BOOL)openUserExperience {
	_openUserExperience = openUserExperience;
	[self saveUserConfigFile];
}

- (BOOL)openDebugMode {
    if (_openDebugModeTime <= 0) {
        // 没有开启时间，直接返回false
        return false;
    }
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval oneDay = 24*60*60;
    if (currentTime - _openDebugModeTime > oneDay) {
        // 超过一天，开关关闭
        _openDebugModeTime = 0;
        return false;
    }else {
        // 开关为开启状态
        return true;
    }
}

#pragma mark - Device

- (BOOL)deviceCanUpdateWithDeviceId:(NSString *)deviceId currentVersion:(NSString *)currentVersion newVersion:(NSString *)newVersion {
    BOOL canUpdate = YES;
    if(_deviceVersionDictionary == nil) {
        _deviceVersionDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    
    NSString *oldVersion = [_deviceVersionDictionary objectForKey:deviceId];
    
    if (oldVersion == NULL) {
        oldVersion = currentVersion;
        [_deviceVersionDictionary setValue:currentVersion forKey:deviceId];
        [self saveUserConfigFile];
    }
    
    if ([oldVersion isEqualToString:newVersion]) {
        canUpdate =  NO;
    }
    
    return canUpdate;
}

- (void)deviceAddIgnoreVersionWithDeviceId:(NSString *)deviceId version:(NSString *)version {
    [_deviceVersionDictionary setValue:version forKey:deviceId];
    [self saveUserConfigFile];
}

#pragma mark - SSID
- (BOOL)ssidIsSaved:(NSString *)ssid
{
	if (_mSSIDMutableArray.count == 0)
	{
		return NO;
	}
	
	BOOL isSaved = NO;
	for (NSDictionary *dict in _mSSIDMutableArray)
	{
		NSString *mSSID = dict[@"mSSID"];
		if ([mSSID isEqualToString:ssid])
		{
			isSaved = YES;
			break;
		}
	}
	
	return isSaved;
}

- (NSString *)ssidPwdBy:(NSString *)ssid {
	if (_mSSIDMutableArray.count == 0) {
		return nil;
	}
	
	NSString *ssidPwd = nil;
	for (NSDictionary *dict in _mSSIDMutableArray)
	{
		NSString *mSSID = dict[@"mSSID"];
		if ([mSSID isEqualToString:ssid])
		{
			ssidPwd = dict[@"mSSIDPWD"];
			break;
		}
	}
	
	return ssidPwd;
}

- (void)addSSID:(NSString *)ssid ssidPwd:(NSString *)ssidPwd
{
	if (ssid == nil) {
		ssid = @"";
	}
	
	if (ssidPwd == nil) {
		ssidPwd = @"";
	}
	
	NSDictionary *dict = @{@"mSSID":ssid, @"mSSIDPWD":ssidPwd};
	
	if (_mSSIDMutableArray == nil)
	{
		_mSSIDMutableArray = [NSMutableArray arrayWithCapacity:3];
	}
	
	//如果有相同的，先删除旧的
	if ([self ssidPwdBy:ssid]) {
		[self removeSSID:ssid];
	}
	
	[_mSSIDMutableArray addObject:dict];
	[self saveUserConfigFile];
}

- (void)removeSSID:(NSString *)ssid
{
	if (_mSSIDMutableArray.count == 0)
	{
		return;
	}
	
	NSDictionary *ssidDict = [NSDictionary dictionary];
	for (NSDictionary *dict in _mSSIDMutableArray)
	{
		NSString *mSSID = dict[@"mSSID"];
		if ([mSSID isEqualToString:ssid])
		{
			ssidDict = dict;
			break;
		}
	}
	
	[_mSSIDMutableArray removeObject:ssidDict];
	[self saveUserConfigFile];
}

- (void)clearCachedSSID {
	[_mSSIDMutableArray removeAllObjects];
	[self saveUserConfigFile];
}

- (void)resetMemoryCache {
	_email = @"";
	_phone = @"";
	_nickname = @"";
	_avatarMd5 = @"";
	_avatarUrl = @"";
	_countryCode = @"";
	_fbNickname = @"";
    _openUserExperience = NO;
    _isSupportAd = NO;
	_showExperiencePlanGuide = YES;
	[_mSSIDMutableArray removeAllObjects];
}

@end

