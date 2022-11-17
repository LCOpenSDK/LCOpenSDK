//
//  Copyright © 2016 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LCLogManager : NSObject

@property (nonatomic)BOOL isLogging;                             //是否处于日志导出状态
@property (nonatomic)CGFloat maxLogSize;                         //单个文件容量
@property (nonatomic)BOOL isCycle;                               //是否循环写文件
@property (strong, nonatomic, readonly) NSString *logDirectory;  //日志文件所在文件夹

//单例
+ (instancetype)shareInstance;

//开始生成日志文件
- (void)startFileLog;

//停止生成日志文件
- (void)endFileLog;

//获取日志文件
- (NSString *)getLogFilePath;

//删除日志文件
- (BOOL)removeSendLogFile;


@end
