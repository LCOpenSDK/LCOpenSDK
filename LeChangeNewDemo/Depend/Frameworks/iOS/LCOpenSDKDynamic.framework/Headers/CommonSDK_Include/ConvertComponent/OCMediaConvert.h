/***************************************************
 ** 版权保留(C), 2001-2017, 浙江大华技术股份有限公司.
 ** 版权所有.
 **
 ** $Id$
 **
 ** 功能描述   : 转码接口封装
 **
 ** 修改历史   : 2017年5月17日 28966 Modification
 ****************************************************/

#import <Foundation/Foundation.h>
#import "IOCConvertListener.h"

@interface OCMediaConvert : NSObject

/**
 * 开始转码
 * @param srcFile 原始文件名（带路径）
 * @param dstFile 目的文件名（带路径）
 * @param mediaType 见枚举
      typedef enum
      {
	    CONVERT_DAV = 0,
	    CONVERT_MP4,
	    CONVERT_AVI,
	    CONVERT_ASF,
	    CONVERT_FLV,
	    CONVERT_MOV,
	    CONVERT_MP464,
	    CONVERT_MOV64,
	    CONVERT_MP4NOSEEK,
   	    CONVERT_WAV
      }CONVERT_MEDIA_TYPE;
 * @return 是否成功
 * -1:否
 * else: 是
 */
- (int) startConvert:(NSString*)srcFile dst:(NSString*)dstFile mediaType:(NSInteger)mediaType;

/**
 * 停止转吗
 *
 * @return 是否成功
 * -1:否
 * else: 是
**/
- (int) stopConvert;

/**
 * 设置转码回调
 *
 * @param listener 回调监听
 *
 **/
- (void) setListener:(id<IOCConvertListener>)listener;

@end

