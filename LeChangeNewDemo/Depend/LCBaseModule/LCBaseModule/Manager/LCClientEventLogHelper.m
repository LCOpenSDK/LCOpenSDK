//
//  Copyright © 2019 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import <LCBaseModule/LCClientEventLogHelper.h>
#import <LCBaseModule/UIDevice+IPhoneModel.h>
#import <LCBaseModule/LCFileManager.h>
#import <LCBaseModule/NSString+SHA256.h>
#import <LCBaseModule/NSData+SHA256.h>
#import <LCBaseModule/NSObject+JSON.h>
#import <LCBaseModule/LCUserManager.h>
#import <LCBaseModule/NSString+LeChange.h>

#import <LCBaseModule/LCUserInfo.h>
#import <LCBaseModule/LCError.h>

static NSInteger upperId = 0;

@interface LCClientEventLogHelper ()

@property (nonatomic, strong) NSMutableArray<LCUserEventLogReport *> *logArray;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, copy) NSString *cacheFileName;
@property (nonatomic, assign) BOOL isUploading;
@end

@implementation LCClientEventLogHelper

+ (LCClientEventLogHelper *)shareInstance
{
    static dispatch_once_t onceToken;
    static LCClientEventLogHelper *manager = nil;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[self alloc] init];
        }
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {

        self.lock = [[NSLock alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

- (void)uploadLogs:(NSArray *)logs success:(void(^)(void))success{
    
    if (logs.count <= 0) {
        return;
    }
    
    if (self.isUploading == false) {
        self.isUploading = true;
        //需要完善上报处理
//        NSArray *copyArray = [logs copy];
//        [LCCommonInterface saas_clientEventLog:copyArray success:^{
//            self.isUploading = false;
//            NSLog(@"💚💚💚💚log upload success");
//            [self.lock lock];
//            [self.logArray removeObjectsInArray:copyArray];
//            [self.lock unlock];
//            if (success) {
//                success();
//            }
//        } failure:^(LCError *error) {
//            self.isUploading = false;
//            NSLog(@"💚💚💚💚log upload fail");
//            NSLog(@"💚💚💚💚 error = %@",error);
//        }];
    }
}

- (void)addClientEventLog:(NSString *)name conent:(NSDictionary *)contentDic {
    //打开调试模式才开始上报
    if ([LCUserManager shareInstance].openDebugMode == false) {
        return;
    }
    NSString *encodeStr = [[contentDic lc_jsonString] lc_base64String];

    LCUserEventLogReport *log = [LCUserEventLogReport new];
    log._id = name;
    log.content = encodeStr;
    
    [self.lock lock];
    [self.logArray addObject:log];
    [self.lock unlock];
    
    // 日志多余10条，上传
    if (self.logArray.count >= 10) {
        NSLog(@"%s: upload client log", __func__);
        [self.lock lock];
        NSArray *uploadArray = nil;
        if (self.logArray.count >= 10) {
            uploadArray = [self.logArray subarrayWithRange:NSMakeRange(0, 10)];
        }
        [self.lock unlock];
        [self uploadLogs:uploadArray success:nil];
    }
}

- (void)addClientEventLogForJson:(NSString *)json {
    
    if (json == nil || [json length] <= 0) {
        return;
    }
    //打开调试模式才开始上报
    if ([LCUserManager shareInstance].openDebugMode == false) {
        return;
    }
    NSDictionary *jsonDic = [json lc_jsonDictionary];
    NSString *type = jsonDic[@"type"];
    if (type && [jsonDic isKindOfClass:[NSDictionary class]]) {
        [self addClientEventLog:type conent:jsonDic];
    }
}

- (NSString *)getRequestId {
    NSString *mac = [UIDevice lc_getMacAddress];
    //补充实际的userId
    NSInteger userId = 0;
    NSString *currentTime = [self getCurrentSystemTimeMillis];
    NSString *requestId = [NSString stringWithFormat:@"%@%ld%@%@%ld",@"public-cloud-request",(long)userId, mac, currentTime, (long)upperId++];
    // 需要经过加密
    NSData *decryptData = [requestId lc_MD5Data];
    return [decryptData lc_convertToHexString];
}

// 获取当期时间的时间戳  毫秒级别
- (NSString *)getCurrentSystemTimeMillis {
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%.lf", (double)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
}

#pragma mark - 缓存

- (void)applicationWillTerminate:(NSNotification *)noti {
    
    // 缓存日志
    [self archiveLogsToFile];
}

- (void)uploadCacheLog {
    
    //打开调试模式才开始上报
    if ([LCUserManager shareInstance].openDebugMode == false) {
        return;
    }
    NSString *cacheFilePath = [self cacheFilePathForCacheName:self.cacheFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath] == YES) {
        NSArray *logs = [NSKeyedUnarchiver unarchiveObjectWithFile:cacheFilePath];
        if (logs) {
            [self uploadLogs:logs success:^{
                NSError *error;
                [[NSFileManager defaultManager] removeItemAtPath:cacheFilePath error:&error];
            }];
        }
    }
}

- (void)archiveLogsToFile {
    
    //打开调试模式才进行归档
    if ([LCUserManager shareInstance].openDebugMode == false) {
        return;
    }
    if (self.logArray.count > 0) {
        NSString *cacheFilePath = [self cacheFilePathForCacheName:self.cacheFileName];
        [NSKeyedArchiver archiveRootObject:self.logArray toFile:cacheFilePath];
    }
}

// 缓存文件的位置
- (NSString *)cacheFilePathForCacheName:(NSString *)cacheName {
    
    if (cacheName == nil || cacheName.length == 0) {
        return nil;
    }
    NSString *folder = [[LCFileManager supportFolder] stringByAppendingPathComponent:@"cache/clientLog"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:folder] == NO) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *fileName = [folder stringByAppendingPathComponent:cacheName];
    return fileName;
}


#pragma mark - 属性懒加载

- (NSMutableArray *)logArray {
    if (_logArray == nil) {
        _logArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _logArray;
}

- (NSString *)cacheFileName {
    if (_cacheFileName == nil) {
        
        _cacheFileName = @"client_log";
    }
    return _cacheFileName;
}

@end
