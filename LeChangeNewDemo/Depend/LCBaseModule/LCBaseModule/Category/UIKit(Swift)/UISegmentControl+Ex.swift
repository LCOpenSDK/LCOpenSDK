//
//  Copyright © 2016年 Imou. All rights reserved.
//

import UIKit

public extension UISegmentedControl {
    
    /// 设置圆角样式
    ///
    /// - Parameter tintColor: 选中的颜色，默认为淡橙色
    @objc func lc_roundStyle(tintColor: UIColor = UIColor.lccolor_c0()) {
        self.layer.borderColor = tintColor.cgColor
        self.tintColor = tintColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = self.bounds.height / 2.0
        self.layer.masksToBounds = true
    }
    
}
