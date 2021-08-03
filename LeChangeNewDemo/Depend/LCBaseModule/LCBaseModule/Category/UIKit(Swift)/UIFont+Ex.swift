//
//  Copyright © 2017 dahua. All rights reserved.
//

import UIKit

public extension UIFont {
    
    var dh_height: CGFloat {
        
        return " ".dh_height(font: self, width: 100)
    }
	
	var dh_aviailableFont: UIFont {
		
		var aviailableFont: UIFont?
		
		if #available(iOS 10, *) {
			// iOS之后的字体变大0.5
			let aviailableFontSize: CGFloat = pointSize + 0.5
			aviailableFont = UIFont(name: fontName, size: aviailableFontSize)
		}
		
		return aviailableFont ?? self
	}
	
	static func dh_fontOfSize(_ size: CGFloat) -> UIFont {
		
		return UIFont.systemFont(ofSize: size * 1.3)
	}
}
