//
//  Copyright © 2016 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import "UIButton+Helper.h"
#import <objc/runtime.h>

// 默认的按钮点击时间
static const NSTimeInterval defaultDuration = 0.0f;

// 记录是否忽略按钮点击事件，默认第一次执行事件
static BOOL _isIgnoreEvent = NO;

// 设置执行按钮事件状态
static void resetState()
{
    _isIgnoreEvent = NO;
}

@implementation UIButton (Helper)

@dynamic clickDurationTime;

+ (void)load
{
    //获取着两个方法
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    
    Method myMethod = class_getInstanceMethod(self, @selector(my_sendAction:to:forEvent:));
    SEL mySEL = @selector(my_sendAction:to:forEvent:);
    
    //添加方法进去
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    
    //如果方法已经存在了
    if (didAddMethod)
    {
        class_replaceMethod(self, mySEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }
    else{
        method_exchangeImplementations(systemMethod, myMethod);
        
    }
}

- (void)my_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    
    // 保险起见，判断下Class类型
    if ([self isKindOfClass:[UIButton class]])
    {
        
        //1. 按钮点击间隔事件
        self.clickDurationTime = self.clickDurationTime == 0 ? defaultDuration : self.clickDurationTime;
        
        //2. 是否忽略按钮点击事件
        if (_isIgnoreEvent)
        {
            //2.1 忽略按钮事件
            return;
        }
        else if(self.clickDurationTime > 0)
        {
            //2.2 不忽略按钮事件
            
            // 后续在间隔时间内直接忽略按钮事件
            _isIgnoreEvent = YES;
            
            // 间隔事件后，执行按钮事件
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.clickDurationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                resetState();
            });
            
            // 发送按钮点击消息
            [self my_sendAction:action to:target forEvent:event];
        }
        else
        {
            // 发送按钮点击消息
            [self my_sendAction:action to:target forEvent:event];
        }
        
    }
    else
    {
        [self my_sendAction:action to:target forEvent:event];
    }
}

#pragma mark - associate

- (void)setClickDurationTime:(NSTimeInterval)clickDurationTime
{
    objc_setAssociatedObject(self, @selector(clickDurationTime), @(clickDurationTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)clickDurationTime
{
    return [objc_getAssociatedObject(self, @selector(clickDurationTime)) doubleValue];
}

@end
