//
//  LCImplementObject.h
//  Pods
//
//  Created by jiangbin on 2017/11/6.
//
//  封装协议实现的类型，普通类、Storyboard加载等

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    /// 普通类
    LCImplementTypeNormal,

    /// Storyboard加载的
    LCImplementTypeStoryboard
    
} LCImplementType;

@interface LCImplementObject : NSObject

/// 实现的类型
@property (nonatomic, assign) LCImplementType implementType;

/// 实现的类
@property (nonatomic, strong) Class implementClass;

/// Storyboard
@property (nonatomic, copy) NSString *storyboardName;

/// Storyboard上类对应的标识
@property (nonatomic, copy) NSString *storyboardIdentifier;

@end
