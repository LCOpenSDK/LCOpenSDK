//
//  Copyright © 2017 dahua. All rights reserved.
//
//  实现按钮扩展，按钮旋转翻页

import UIKit

public extension UIButton {
	
    /// 按钮翻转
    ///
    /// - Parameter imageString: 翻转后的图片
	func lc_rotate(to imageString: String, callBack: dh_closure? = nil) {
        
        self.isUserInteractionEnabled = false
        dh_delay(dh_animDuratuion) {
            self.isUserInteractionEnabled = true
        }
    
        self.lc_transitionAnimation(type: .oglFlip, direction: .fromLeft, duration: dh_animDuratuion)
        
        self.setImage(UIImage(named: imageString), for: .normal)
		
		if let callBack = callBack {
			
			dh_delay(dh_animDuratuion) {
				callBack()
			}
		}
    }
    
}
