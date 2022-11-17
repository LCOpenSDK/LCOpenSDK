//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MethodSwizzle)

+ (void)swizzleInstanceMethod:(SEL)origSelector withMethod:(SEL)newSelector;

+ (void)swizzleInstanceMethod:(SEL)origSelector withMethod:(SEL)newSelector withClass:(Class)cls;

+ (void)swizzleClassMethod:(SEL)origSelector withMethod:(SEL)newSelector;

+ (void)swizzleClassMethod:(SEL)origSelector withMethod:(SEL)newSelector withClass:(Class)cls;

@end

NS_ASSUME_NONNULL_END
