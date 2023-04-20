//
//  Copyright © 2019 jm. All rights reserved.
//

import UIKit

public extension UIScreen {
    
    /// 顶部安全区域
    ///
    /// - Returns: height
    static func topSafeAreaSpace() -> Float {
        return UIDevice.lc_isIphoneX() ? 44.0 : 20.0
    }
    
    
    /// 底部安全区域
    ///
    /// - Returns: height
    static func bottomSafeAreaSpace() -> Float {
        return UIDevice.lc_isIphoneX() ? 34.0 : 0
    }
    
    
    /// 状态栏及navigation总高度
    ///
    /// - Returns: height
    static func statusAndNavigationBarHeight() -> Float {
        return topSafeAreaSpace() + 44.0
    }
    
    
    /// tabbr高度
    ///
    /// - Returns: height
    static func tabBarHeight() -> Float {
        return bottomSafeAreaSpace() + 49.0
    }
    
}

