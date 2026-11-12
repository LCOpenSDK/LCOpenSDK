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

@interface OCMediaProcessor : NSObject

/**
 * 开始转码
 * @param filePath  文件名（带路径）
 * @param streamType  视频文件类型，目前只支持mp4后期可扩展， 目前不生效，填0即可
 *
 * @return >=0: 获取文件时长， < 0 获取时长出错， 可使用上层时间
 */
+(int) getFileDuration:(NSString*)filePath StreamType:(NSInteger)streamType;

/** 
 * Description: 合并多个Mp4文件
 *  1. 生成一个新的Mp4文件名与filePath参数指定的文件名一致，
 *  2. 合并过程中，如果出现错误，则返回错误码，并删除已经合并临时生成的文件，输入的文件不会被删除
 * Parameters:
 * - taskId: 任务ID，用于取消任务，必须大于0
 * - filePath: 文件路径，用于指定合并的文件名，同时用于指定合并后的文件名
 *   其余需要合并的文件会按照扩展规则由组件库查找，如 输入 xxx.mp4，则组件库会查找 xxx_1.mp4, xxx_2.mp4...等文件进行合并
 * Return:
 * - 0: 合并成功, <0: 合并失败, 需要删除临时生成的文件
 * Note: 合并过程中，如果出现错误，则返回错误码，并删除已经合并临时生成的文件，原始输入的文件不会被删除
 */
+(int) combineMp4Files: (int)taskId FilePath:(NSString*)filePath;

/**
 * 取消合并Mp4文件
 * @param taskId 任务ID
 * @return 0 取消请求已发出
 *         MP4_PARSER_ERR_NOT_FOUND(-7) 任务不存在
 */
+(int) cancelCombineMp4Files:(int)taskId;

@end