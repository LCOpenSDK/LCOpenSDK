//
//  Copyright © 2016 Imou. All rights reserved.
//
#define TIMER_INTERVAL 120.0    //120秒判断一次文件是否超过最大容量

#import "LCLogManager.h"

@interface LCLogManager()
{
    NSTimer * _timer;            //计时器
    
    NSString * _currentPath;     //当前日志文件完整路径
    
    NSInteger _index;            //日志文件索引
    
    NSString *_logFilePath;      //日志文件所在文件夹路径
}


@end
@implementation LCLogManager

#pragma mark - 🍎override method
- (instancetype)init
{
    if (self = [super init]) {
        _isLogging = NO;
        _maxLogSize = 0.1;
        _index = 0;
        _isCycle = NO;
    }
    return self;
}


#pragma mark - 🍊singleton
static LCLogManager *instance;
+ (instancetype)shareInstance
{
    if (nil == instance)
    {
        instance = [[LCLogManager alloc]init];
    }
    return instance;
}


#pragma mark - public method
- (void)startFileLog {
    //1.更新状态
    _isLogging = YES;
    
    //2.创建新日志文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    NSString *mainDirectory = [docDirectory stringByAppendingPathComponent:@"AppLog"];
    
    if(![[NSFileManager defaultManager]fileExistsAtPath:mainDirectory isDirectory:nil])
    {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:mainDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        
        NSLog(@"%@", error);
    }
    
    NSString *logDir = [mainDirectory stringByAppendingPathComponent:@"Log"];
    if(![[NSFileManager defaultManager]fileExistsAtPath:logDir isDirectory:nil])
    {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:logDir withIntermediateDirectories:YES attributes:nil error:&error];
        NSLog(@"%@", error);
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yy_MM_dd_HH_mm_ss"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString * logDirectory = [logDir stringByAppendingPathComponent:dateStr];
    NSLog(@"-----%@",logDirectory);
    [[NSFileManager defaultManager] createDirectoryAtPath:logDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    _logDirectory = logDirectory;
    
    //3.开启定时器
    if (nil == _timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL
                                                  target:self
                                                selector:@selector(timerTick)
                                                userInfo:nil
                                                 repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        //第一次手动写入，之后每120秒定时器判断一次文件是否超过阈值
        [self directLogInIndex:_index];
    }
    
}

- (void)endFileLog {
    //1.更新状态
    _isLogging = NO;
    
    //1.销毁定时器
    [_timer invalidate];
    _timer = nil;
    
    //2.停止写入
    int result = fclose(stdout);
    int result2 = fclose(stderr);
    
}

- (BOOL)removeSendLogFile {
    //删除日志文件
    if (_logDirectory) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:_logDirectory error:&error];
        NSLog(@"%@", error);
        if (error == nil) {
            //恢复默认
            _logDirectory = nil;
            _index = 0;
            return YES;
        }
        return NO;
    }
    return NO;
    
}

- (NSString *)getLogFilePath {
    return _logDirectory == nil? nil : _logDirectory;
}

#pragma mark - private method
//写入日志文件
- (void)directLogInIndex:(NSInteger )idx {
    //如果已经连接XCode调试则不输出到文件
    if(isatty(STDOUT_FILENO)) {
        return ;
    }
    
    NSString *fileName = [NSString stringWithFormat:@"log%ld.txt", (long)_index];
    NSString *logPath = [_logDirectory stringByAppendingPathComponent:fileName];
    
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "w+", stdout);
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "w+", stderr);
  
    _currentPath = logPath;
}


//计算单个文件的大小
- (float)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        float size = [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/(1024.0*1024);
        return size;
    }
    return 0;
}

#pragma mark - 🍉Timer Action
- (void)timerTick {
    if([self fileSizeAtPath:_currentPath]>_maxLogSize)
    {
        if (_isCycle)
        {
            _index = !_index;
        }
        else
        {
            _index ++ ;
        }
        [self directLogInIndex:_index];
    }
}

@end
