/***************************************************
 ** 版权保留(C), 2001-2017, 浙江大华技术股份有限公司.
 ** 版权所有.
 **
 ** $Id$
 **
 ** 功能描述   : 转码回调接口定义
 **
 ** 修改历史   : 2017年5月17日 28966 Modification
 ****************************************************/
#ifndef __DAHUA_LCCommon_IOCCONVERTLISTENER_H__
#define __DAHUA_LCCommon_IOCCONVERTLISTENER_H__

#import <Foundation/Foundation.h>

@protocol IOCConvertListener <NSObject>

@optional

/**
 * 转码进度回调函数
 *
 * @param progress  [in] 进度
 *
 */
- (void) onConvertProgress:(NSInteger)progress;

/**
 * 转码错误回调接口
 *
 * @param errorCode [in] 错误码
 *
 */
- (void) onConvertError:(NSInteger)errorCode;

@end

#endif
