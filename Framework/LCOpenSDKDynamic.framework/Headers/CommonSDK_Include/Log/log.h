/*************************************************************************
 ** 版权保留(C), 2001-2014, 浙江大华技术股份有限公司.
 ** 版权所有.
 **
 ** $Id$
 **
 ** 功能描述   : 日志打印，使用时候必须先调用setMobileLogLevel，否则无日志
 **
 ** 修改历史     : 2014年12月18日 zhu_long Modification
 *************************************************************************/

#ifndef __DAHUA_LCCommon_LOG_H__
#define __DAHUA_LCCommon_LOG_H__

#include <string>

#if defined(ANDROID) || defined(__android__) || defined(WIN32) || defined(WIN64)
typedef int ImouLogLevel;
#else
typedef enum _LogLevel
{
    logLevelFatal,         ///< 致命错误
    logLevelErr,           ///< 错误
    logLevelWarning,       ///< 可能导致出错
    logLevelInfo,          ///< 告知用户，当前运行状态
    logLevelDebug,         ///< 详细调试信息
    logLevelSecurityAll,   ///< 所有日志信息，但遮蔽敏感信息
    logLevelAll,           ///< 所有日志信息
} LogLevel;
typedef LogLevel ImouLogLevel;
#endif


#if defined(ANDROID) || defined(__android__)
#define LCLOG_API __attribute__((visibility("default")))
#else
#define LCLOG_API
#endif
static const int ImouLogLevelFatal = 0;         ///< 致命错误
static const int ImouLogLevelErr = 1;           ///< 错误
static const int ImouLogLevelWarning = 2;       ///< 可能导致出错
static const int ImouLogLevelInfo = 3;          ///< 告知用户，当前运行状态
static const int ImouLogLevelDebug = 4;         ///< 详细调试信息
static const int ImouLogLevelSecurityAll = 5;   ///< 所有日志信息，但遮蔽敏感信息
static const int ImouLogLevelAll = 6;           ///< 所有日志信息


typedef enum _LogFileMode
{
    LogFileModeNewFile,    ///< 新文件追加模式
    LogFileModeRollFile,   ///< 双文件滚动模式
    LogFileModeUnvalid,    ///< 非法写日志文件模式
} LogFileMode;

///\brief           进程启动时, 设置日志文件路径
///\param[in]       filename        带路径文件名
///\param[in]       maxSize         文件最大size
///\param[in]       mode            写文件模式
LCLOG_API void setMobileLogFile(const char *file, int maxSize, LogFileMode mode);

///\brief           设置日志输出等级(必须调用)
///\param[in]       level           设置打印日志等级,只打印等级以上的日志
///\param[in]       tag             tag为空时设置全部日志等级(禁止为NULL)
LCLOG_API void setMobileLogLevel(ImouLogLevel level, const char *tag);

///\brief           设置基础模块(如infra)日志输出等级
///\param[in]       level           设置打印日志等级,只打印等级以上的日志
LCLOG_API void setExtendLogLevel(ImouLogLevel level);

///\brief  获取(utilscomsdk)版本号信息
///\param[inout]    buff          版本号信息缓存
///\param[in]       buffSize      缓存长度
LCLOG_API void getUtilsComSdkVersion(char *buff, int buffSize);

#if defined(ANDROID) || defined(__android__) || defined(WIN32) || defined(WIN64)
#else
LCLOG_API void setMobileLogLevel(int level, const char *tag);
LCLOG_API void setExtendLogLevel(int level);
#endif

///\brief           日志打印函数, 内部函数，外部调用使用下面的日志实现宏(MOBILE_LOG_PRINT)
LCLOG_API void MobileLogPrintFull(const char *file, int line, const char *func, ImouLogLevel level, const char *tag, const char *format, ...);

///\brief           获取当前线程ID
LCLOG_API int getCurrentThreadId();

///\brief           日志实现宏
///\param[in] 'NULL'   保证以'NULL'结尾，内部结算可变参数个数使用  
#define MOBILE_LOG_PRINT(level, tag, format, ...) MobileLogPrintFull(__FILE__, __LINE__, __FUNCTION__, level, tag, format, ##__VA_ARGS__, NULL)

///\brief           日志宏调用
#define DEBUGF(TAG, FMT, ...)                                                       \
    {                                                                               \
        MOBILE_LOG_PRINT((ImouLogLevel)ImouLogLevelDebug, TAG, FMT, ##__VA_ARGS__); \
    }

#define INFOF(TAG, FMT, ...)                                                       \
    {                                                                              \
        MOBILE_LOG_PRINT((ImouLogLevel)ImouLogLevelInfo, TAG, FMT, ##__VA_ARGS__); \
    }

#define WARNF(TAG, FMT, ...)                                                          \
    {                                                                                 \
        MOBILE_LOG_PRINT((ImouLogLevel)ImouLogLevelWarning, TAG, FMT, ##__VA_ARGS__); \
    }

#define ERRORF(TAG, FMT, ...)                                                     \
    {                                                                             \
        MOBILE_LOG_PRINT((ImouLogLevel)ImouLogLevelErr, TAG, FMT, ##__VA_ARGS__); \
    }

#define FATALF(TAG, FMT, ...)                                                       \
    {                                                                               \
        MOBILE_LOG_PRINT((ImouLogLevel)ImouLogLevelFatal, TAG, FMT, ##__VA_ARGS__); \
    }

#define SECUR_START_STR "##SECUS!"
#define SECUR_END_STR "##SECUE!"
#define MARK_SECUR_CSTR(p) (std::string(SECUR_START_STR) + (std::string(std::string(p).size(), '*')) + std::string(SECUR_END_STR)).c_str()

LCLOG_API void LogInfraPrint(const char *tag, ImouLogLevel level, char *logInfraContent);

#endif /* __DAHUA_MOBILE_LOG_H_ */
