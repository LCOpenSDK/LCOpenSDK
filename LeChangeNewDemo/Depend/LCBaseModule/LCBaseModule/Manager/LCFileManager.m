//
//  Copyright © 2017 Imou. All rights reserved.
//

#import <LCBaseModule/LCFileManager.h>
#import <LCBaseModule/LCDateFormatter.h>
#import <LCBaseModule/NSDate+LeChange.h>
#import "LCModule.h"

#define kConfigFile                 @"config.plist"
#define kUserGiudeFile              @"userGuideConfig.plist"
#define kUserAndServiceConfigFile   @"userandserviceconfigfile.plist"
#define ktabBarListFile             @"tabBarList.plist"

/// 加密保存的用户信息、配置文件
#define kUserConfigFile_encrypt     @"userConfigFile"

/// 主程序数据库
#define kMainDBFileName				@"SMB.sqlite"

/// 企业级别数据库
#define kCropDBFileName				@"Crop.sqlite"

/// 轻应用级别数据库
#define kMiniAppDBFileName			@"MiniApp.sqlite"

/// 手动抓图文件夹名称
#define CAPTURES    				@"captures"

/// 封面图文件夹名称
#define THUMBS      				@"thumbs"

@implementation LCFileManager

+ (NSString *)capturesFolder {
	NSString *folderPath = [[self userFolder] stringByAppendingPathComponent:CAPTURES];
	return folderPath;
}

+ (NSString *)userthumbsFolderPath {
	NSString *folderPath = [[self userFolder] stringByAppendingPathComponent:THUMBS];
	return folderPath;
}

+ (NSString *)thumbFilePathWithChannel:(NSString *)deviceId channelId:(NSString *)channelId {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *pError;
	
	NSString *strThumbsPath = [self userthumbsFolderPath];
	[fileManager createDirectoryAtPath:strThumbsPath withIntermediateDirectories:YES attributes:nil error:&pError];
	NSString *desFolder = [NSString stringWithFormat:@"%@/%@/", strThumbsPath, deviceId];
	[fileManager createDirectoryAtPath:desFolder withIntermediateDirectories:YES attributes:nil error:&pError];
	NSString *desPath = [desFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png", channelId.intValue]];
	return desPath;
}

+ (NSString *)configFilePath {
    NSString *documentDirectory = [self supportFolder];
    return [documentDirectory stringByAppendingPathComponent:kConfigFile];
}

+ (NSString *)userAndServiceConfigFilePath {
    NSString *documentDirectory = [self supportFolder];
    return [documentDirectory stringByAppendingPathComponent:kUserAndServiceConfigFile];
}

+ (NSString *)userFolder {
    NSString *supportFolder = [self supportFolder];
    //不再区分用户
    //NSString *userPath = [supportFolder stringByAppendingPathComponent: userIdStr];
    NSString *userPath = supportFolder;
                          
    BOOL isDirect = NO;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:userPath isDirectory:&isDirect];
    
    if (!(isDirExist && isDirect)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return userPath;
}

+ (NSString *)userConfigFilePath {
    NSString *documentDirectory = [self userFolder];
    return [documentDirectory stringByAppendingPathComponent:kUserConfigFile_encrypt];
}

+ (NSString *)userGuideFilePath {
    NSString *documentDirectory = [self userFolder];
    return [documentDirectory stringByAppendingPathComponent:kUserGiudeFile];
}

//MARK: - 抓图/封面图路径
+ (NSString*)screenshotFilePath:(NSString*)devcieId {
    NSString *strCapturePath = [LCFileManager captureAndRecordPathWithSuffix:@"Photo"];
    
    LCDateFormatter *format = [[LCDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *localString = [format stringFromDate:[NSDate date]];
    
    NSTimeInterval time = [[NSDate date]timeIntervalSince1970];
    NSString *strTime = [self formattedNameOfTime:time];
    
    NSString *strFileName = [NSString stringWithFormat:@"%@_%@_NL_L%@.jpg", localString, devcieId, strTime];
    
    //Capture to path
    NSString *strFilePath = [strCapturePath stringByAppendingPathComponent:strFileName];
    
    return strFilePath;
}

+ (NSString*)screenshotThumbFilePath:(NSString*)devcieId {
    NSError *pError;
    
    NSString *strCapturePath = [LCFileManager captureAndRecordPathWithSuffix:@"Photo"];
    NSString *strThumbPath = [strCapturePath stringByAppendingPathComponent:@"thumbnails"];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:strThumbPath withIntermediateDirectories:YES attributes:nil error:&pError];
    
    LCDateFormatter *format = [[LCDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *localString = [format stringFromDate:[NSDate date]];
    
    NSTimeInterval time = [[NSDate date]timeIntervalSince1970];
    NSString *strTime = [self formattedNameOfTime:time];
    NSString *strFileName = [NSString stringWithFormat:@"%@_%@_NL_L%@.jpg", localString, devcieId, strTime];
    
    NSString *thumbFileName = [strThumbPath stringByAppendingPathComponent:strFileName];
    
    return thumbFileName;
}

+ (NSString*)videotapeFilePath:(NSString*)devcieId {
    NSString *identifier = devcieId;
    
    NSString *strCapturePath = [self captureAndRecordPathWithSuffix:@"Video"];
    
    LCDateFormatter *format = [[LCDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *localString = [format stringFromDate:[NSDate date]];
    
    NSString *originFilePath = [NSString stringWithFormat:@"%@_%@", localString, identifier];
    NSString *tempFilePath = [strCapturePath stringByAppendingPathComponent:originFilePath];
    
    return tempFilePath;
}

+ (NSString *)videotapeThumbFilePath:(NSString *)devcieId {
    NSString *identifier = devcieId;
    NSError *pError;
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *strCapturePath = [self captureAndRecordPathWithSuffix:@"Video"];
    NSString *strThumbPath = [strCapturePath stringByAppendingPathComponent:@"thumbnails"];
    [fileManage createDirectoryAtPath:strThumbPath withIntermediateDirectories:YES attributes:nil error:&pError];
    
    LCDateFormatter *format = [[LCDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *localString = [format stringFromDate:[NSDate date]];
    NSString *strFileName = [NSString stringWithFormat:@"%s_%@.jpg", [localString UTF8String], identifier];
    NSString *strFilePath = [strThumbPath stringByAppendingPathComponent:strFileName];
    
    return strFilePath;
}

+ (NSString*)collectionThumbFilePath {
	
	NSString *documentDic = [self userFolder];
	NSString *collectionDic = [documentDic stringByAppendingPathComponent:@"play_module_video_collection_title"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:collectionDic]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:collectionDic withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	NSString *thumbFileName = [NSString stringWithFormat:@"temp.jpg"];
	
	NSString *result = [collectionDic stringByAppendingPathComponent:thumbFileName];
	
	return result;
}

+ (NSString *)supportFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = paths[0];
    
    NSString *supportDirectory = [libraryDirectory stringByAppendingPathComponent:@"Support"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:supportDirectory]) {
        [[NSFileManager defaultManager]  createDirectoryAtPath:supportDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return supportDirectory;
}

#pragma mark - 融合二期
+ (NSString *)myFileImageDir {
    NSString *miniAppFolder = [self userFolder];
    NSString *mdeiaPath = [miniAppFolder stringByAppendingPathComponent:@"Media"];
    return [mdeiaPath stringByAppendingPathComponent:@"Photo"];
}

//录像文件夹
+ (NSString *)myFileVideoDir {
	NSString *miniAppFolder = [self userFolder];
	NSString *mdeiaPath = [miniAppFolder stringByAppendingPathComponent:@"Media"];
    return [mdeiaPath stringByAppendingPathComponent:@"Video"];
}

//MARK: - Video/File Name
+ (NSString *)videoNameWithPath:(NSString *)filepath {
	//'#'到'.'之间的字符串为customName
	NSRange startRange = [filepath rangeOfString:@"#"];
	NSRange endRange = [filepath rangeOfString:@".mp4"];
	
	if (startRange.length == 0) {
		NSArray *attributeInfos = [self attributedInfos:filepath];
		if (attributeInfos.count > 1) {
			NSString *prefix = attributeInfos[0];
			NSInteger startTime = [attributeInfos[1]integerValue];
			NSDate *date = [NSDate dateWithTimeIntervalSince1970:startTime];
			NSString *year = [NSString stringWithFormat:@"%02d", (int)(date.year - 2015) + 1 ];
			NSString *suffix = [date lc_stringOfDateWithFormator:@"MMddHHmmss"];
			NSString *fullTitle = [NSString stringWithFormat:@"%@%@%@", prefix, year, suffix];
			return fullTitle;
		}
		
		NSLog(@"Error_Filepath:%@", filepath);
		return nil;
	}
	
	//从filepath中查找
	if (endRange.length && endRange.location > startRange.location) {
		NSRange subRange = NSMakeRange(startRange.location + 1, endRange.location - startRange.location - 1);
		return [filepath substringWithRange:subRange];
	}
	
	return nil;
}

#pragma mark - 缓存相关
+ (NSArray *)thumbFolderPaths {
	NSMutableArray *paths = [NSMutableArray new];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *supportFolder = [LCFileManager supportFolder];
	NSArray *subPaths = [fileManager contentsOfDirectoryAtPath:supportFolder error:nil];
	
	for (NSString *path in subPaths) {
		NSString *userDirectory = [supportFolder stringByAppendingPathComponent: path];
		BOOL isDirectory = FALSE;
		[fileManager fileExistsAtPath:userDirectory isDirectory:&isDirectory];
		NSInteger userId = [path integerValue];
		
		//遍历Support目录下，以userId开头的文件夹，找到每个文件夹对应的thumb抓图路径
		if (isDirectory && userId > 0) {
			NSString *thumbDirectory = [userDirectory stringByAppendingPathComponent: THUMBS];
			[paths addObject:thumbDirectory];
			//NSLog(@"%@", thumbDirectory);
		}
	}
	return paths;
}

+ (void)clearCache {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *thumbPaths = [self thumbFolderPaths];
	for (NSString *path in thumbPaths) {
		[fileManager removeItemAtPath:path error:nil];
	}
	
	//增加tmp文件夹的清除
	NSArray *tmpPaths = [fileManager contentsOfDirectoryAtPath:NSTemporaryDirectory() error:nil];
	for (NSString *path in tmpPaths) {
		NSString *subPath = [NSTemporaryDirectory() stringByAppendingPathComponent:path];
		[fileManager removeItemAtPath:subPath error:nil];
	}
}

+ (BOOL)removeFileAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

//MARK: - Private
+ (NSString *)captureAndRecordPathWithSuffix:(NSString *)suffix {
    //Create Media/Photo folder
    NSString* strMediaCenterPath = nil;
    NSString *documentsDirectory = [LCFileManager userFolder];
    strMediaCenterPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Media/%@", suffix]];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSError *pError;
    [fileManage createDirectoryAtPath:strMediaCenterPath withIntermediateDirectories:YES attributes:nil error:&pError];
    
    //Create Meida/Photo/yyyyMMdd folder(Pictures grouped by date)
    LCDateFormatter *format = [[LCDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    NSString *localString = [format stringFromDate:[NSDate date]];
    NSString *strCapturePath = [strMediaCenterPath stringByAppendingPathComponent:localString];
    [fileManage createDirectoryAtPath:strCapturePath withIntermediateDirectories:YES attributes:nil error:&pError];
    
    //返回xxxx/Media/Photo/20160524
    return strCapturePath;
}


+ (NSString *)formattedNameOfTime:(NSTimeInterval)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *year = [NSString stringWithFormat:@"%02d", (int)(date.year - 2015) + 1 ];
    NSString *suffix = [date lc_stringOfDateWithFormator:@"MMddHHmmss"];
    NSString *fullTitle = [NSString stringWithFormat:@"%@%@", year, suffix];
    return fullTitle;
}

+ (NSArray *)attributedInfos:(NSString *)filepath {
	NSString *pattern = @"[CL]_\\d+_\\d+";
	NSError *error = nil;
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
																		   options:NSRegularExpressionCaseInsensitive
																			 error:&error];
	if (filepath.length == 0) {
		return nil;
	}
	
	NSTextCheckingResult *result = [regex firstMatchInString:filepath options:0 range:NSMakeRange(0, filepath.length)];
	if (result == nil) {
		return nil;
	}
	
	NSString *subString = [filepath substringWithRange:result.range];
	NSArray *attribute = [subString componentsSeparatedByString:@"_"];
	return attribute;
}


@end
