#import <Foundation/Foundation.h>


@protocol IOCDirectDevDiscoveryListener <NSObject>

-(bool) enableDahuaSearch;
	
-(void) onIoTDev:(NSString*)JsonDevinfo;
	
-(void) onDahuaDev:(NSString*)JsonDevinfo;

-(void) onError:(int) err;

@end



@interface OCDevDiscoveryManager : NSObject

 /**
 * 设置监听回调
 *
 * @param listener [in] 回调函数指针
 */
-(void) Setlistener:(id<IOCDirectDevDiscoveryListener>) listener;

/**
* 设置过滤参数
*
* @param jsonFliter [in] 过滤信息
*/
-(void) setFliter:(NSString*) jsonFliter;
 /**
 * 开启设备搜索
 *
 * @param ip [in] 本机局域网IP
 * 成功 true 失败 false
 */	
-(bool) Start:(NSString*) ip;

 /**
 * 关闭设备搜索
 */	
-(void) Stop;

@end

