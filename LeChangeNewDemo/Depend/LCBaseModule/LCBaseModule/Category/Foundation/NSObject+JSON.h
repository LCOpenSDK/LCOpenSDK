//
//  Copyright © 2017年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSON)

/**
 对象转JSON字符串

 @return 非JSON对象，返回nil；成功转换，返回对应的值
 */
- (NSString *)lc_jsonString;

@end




@interface NSString (JSON)

/**
 JSON串转化为对象
 
 @return 转换返回对应的值
 */
- (id)lc_jsonObject;

/**
 JSON串转化为字典对象
 
 @return 转换返回对应的值
 */
- (NSDictionary *)lc_jsonDictionary;

/**
 JSON串转换为数组

 @return 转换返回对应的值
 */
- (NSArray *)lc_jsonArray;

@end
