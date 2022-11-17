//
//  Copyright © 2016 Imou. All rights reserved.
//
//  常量和全局函数

import UIKit
import AFNetworking

public typealias lc_closure = () -> ()
public typealias lc_boolClosure = (Bool) -> ()
public typealias lc_stringClosure = (String) -> ()
public typealias lc_intClosure = (Int) -> ()

public let lc_animDuratuion: TimeInterval = 0.3

/// 主窗口
public var lc_keyWindow: UIWindow? {
    return UIApplication.shared.keyWindow
}

/// 屏幕宽度
public var lc_screenWidth: CGFloat {
    return min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
}

/// 屏幕高度
public var lc_screenHeight: CGFloat {
    return max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
}

// 状态栏高度
public var LC_statusBarHeight: CGFloat {
	return lc_isiPhoneX ? 44 : 20
}

// 导航栏高度
public let lc_navBarHeight: CGFloat = 44

// 导航栏加状态栏高度
public var LC_navViewHeight: CGFloat {
	return UIApplication.shared.statusBarFrame.height + lc_navBarHeight
}

// 底部安全间隔
public var LC_bottomSafeMargin: CGFloat {
	return lc_isiPhoneX ? 34 : 0
}

/// 延迟函数
public func  lc_delay(_ seconds: Double, closure: @escaping lc_closure) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
}

/// 同步锁🔐
public func  lc_synchronizd(lock: AnyObject, closure:() -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

/// 根据iPhone6缩放尺寸
public func lc_scaleSize(_ size: CGFloat) -> CGFloat {
	return lc_screenHeight / 667 * size
}

