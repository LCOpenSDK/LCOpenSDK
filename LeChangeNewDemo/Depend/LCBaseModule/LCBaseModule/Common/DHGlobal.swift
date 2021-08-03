//
//  Copyright © 2016 dahua. All rights reserved.
//
//  常量和全局函数

import UIKit
import AFNetworking

public typealias dh_closure = () -> ()
public typealias dh_boolClosure = (Bool) -> ()
public typealias dh_stringClosure = (String) -> ()
public typealias dh_intClosure = (Int) -> ()

public let dh_animDuratuion: TimeInterval = 0.4

public let dh_legalPassword = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!#$%()*+,-./<=>?@[\\]^_`{|}~"

/// 除【 ’】【‘’】【；】【：】【&】【空格】 "[^'\\\"\\;\\:\\& ]"
public let dh_legalPasswordRegEx = "^[A-Za-z0-9!#%,<=>@_~`\\-\\.\\/\\(\\)\\*\\+\\?\\$\\[\\]\\\\\\^\\{\\}\\|]$"
//对应的plist文件中为：^[A-Za-z0-9!#%,<=>@_~`\-\.\/\(\)\*\+\?\$\[\]\\^\{\}\|]$

public let dh_legalValidCode = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"

/// 主窗口
public var dh_keyWindow: UIWindow? {
    return UIApplication.shared.keyWindow
}



/// 5s及以下机型判断
public var dh_isPhone5s: Bool {
	return dh_screenWidth <= dh_screenWidth_5s
}

/// 5s的屏幕宽度
public var dh_screenWidth_5s: CGFloat {
	return 320
}

/// 屏幕宽度
public var dh_screenWidth: CGFloat {
    return min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
}

/// 屏幕高度
public var dh_screenHeight: CGFloat {
    return max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
}

// 状态栏高度
public var dh_statusBarHeight: CGFloat {
	return dh_isiPhoneX ? 44 : 20
}

// 导航栏高度
public let dh_navBarHeight: CGFloat = 44

// 导航栏加状态栏高度
public var dh_navViewHeight: CGFloat {
	return UIApplication.shared.statusBarFrame.height + dh_navBarHeight
}

// Tabbar高度
public var dh_tabBarHeight: CGFloat {
	return dh_isiPhoneX ? (49 + 34) : 49
}

// 底部安全间隔
public var dh_bottomSafeMargin: CGFloat {
	return dh_isiPhoneX ? 34 : 0
}

// 左右安全间隔
public var dh_landscapeSafeMargin: CGFloat {
	return dh_isiPhoneX ? 44 : 0
}

// 视频左右安全间隔
public var dh_landscapeVideoSafeMargin: CGFloat {
	return dh_isiPhoneX ? 64 : 0
}

// 底部安全间隔
public var dh_landscapeBottomSafeMargin: CGFloat {
	return dh_isiPhoneX ? 21 : 0
}

// 顶底部安全间隔
public var dh_topSafeMargin: CGFloat {
	return dh_isiPhoneX ? 24 : 0
}

/// 屏幕方向
public var dh_screenOrientation: UIInterfaceOrientation {
    return UIApplication.shared.statusBarOrientation
}

/// 是否竖屏
public var dh_isAppProtrait: Bool {
    let orientation = UIApplication.shared.statusBarOrientation
    return UIInterfaceOrientationIsPortrait(orientation)
}

/// 是否横屏
public var dh_isAppLandscape: Bool {
    let orientation = UIApplication.shared.statusBarOrientation
    return UIInterfaceOrientationIsLandscape(orientation)
}

/// 命名空间
public var dh_nameSpace: String? {
    return Bundle.main.infoDictionary!["CFBundleExecutable"] as? String
}

/// 命名空间
public var dh_appName: String? {
	 return Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String
}

// 网络状态
public var dh_networkStatus: AFNetworkReachabilityStatus {
    return DHNetWorkHelper.sharedInstance().emNetworkStatus
}

// iPhone5适配比例
public var heightScare: CGFloat {
    return dh_isPhone5s ? 0.75 : 1
}

/// 自定义带索引的for_in，⚠️中途无法通过return退出
public func  dh_for<T>(_ items: [T]?, closure: (T, Int) -> Void) {
    
    if items == nil {
        return
    }
    
	var index = 0
    
    for item in items! {
        closure(item, index)
        index += 1
    }  
}

/// 延迟函数
public func  dh_delay(_ seconds: Double, closure: @escaping dh_closure) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
}

/// 同步锁🔐
public func  dh_synchronizd(lock: AnyObject, closure:() -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

/// 根据iPhone6缩放尺寸
public func  dh_scaleSize(_ size: CGFloat) -> CGFloat {
	return dh_screenHeight / 667 * size
}

/// 根据iPhone6缩放尺寸，取最小值
public func  dh_scaleMinSize(_ size: CGFloat) -> CGFloat {
	 return min(size, dh_scaleSize(size))
}

/// 根据iPhone6缩放尺寸，取最大值
public func  dh_scaleMaxSize(_ size: CGFloat) -> CGFloat {
	return max(size, dh_scaleSize(size))
}

/// 设置状态栏背景颜色
public func  dh_setStatusBarBackgroundColor(_ color: UIColor) {
	
	if let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIView {
		// 获取statusBarWindow
		if let statusBar = statusBarWindow.value(forKey: "statusBar") as? UIView {
			// 获取statusBar
			statusBar.backgroundColor = color
		}
	}
}


/// Inline functions
public func  dh_printDeinit(_ className: Any) {
    debugPrint("🍻🍻🍻", "Deinit Success:", className)
}
