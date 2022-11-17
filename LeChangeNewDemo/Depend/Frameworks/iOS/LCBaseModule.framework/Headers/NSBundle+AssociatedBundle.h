//
//  NSBundle+AssociatedBundle.h
//  LCBaseModule
//
//  Created by hehe on 2021/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (AssociatedBundle)
+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName;
@end

NS_ASSUME_NONNULL_END
