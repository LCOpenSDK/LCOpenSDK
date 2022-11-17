//
//  Copyright © 2017 Imou. All rights reserved.
//
//  实现按钮扩展，按钮旋转翻页

import UIKit

public extension UIButton {
	
    /// 按钮翻转
    ///
    /// - Parameter imageString: 翻转后的图片
	func lc_rotate(to imageString: String, callBack: lc_closure? = nil) {
        
        self.isUserInteractionEnabled = false
        lc_delay(lc_animDuratuion) {
            self.isUserInteractionEnabled = true
        }
    
        self.lc_transitionAnimation(type: .oglFlip, direction: .fromLeft, duration: lc_animDuratuion)
        
        self.setImage(UIImage(named: imageString), for: .normal)
		
		if let callBack = callBack {
			
			lc_delay(lc_animDuratuion) {
				callBack()
			}
		}
    }
    
}
