//
//  Copyright © 2017 Imou. All rights reserved.
//

import UIKit

public extension UIFont {
    
    var lc_height: CGFloat {
        
        return " ".lc_height(font: self, width: 100)
    }
	
	var lc_aviailableFont: UIFont {
		
		var aviailableFont: UIFont?
		
		if #available(iOS 10, *) {
			// iOS之后的字体变大0.5
			let aviailableFontSize: CGFloat = pointSize + 0.5
			aviailableFont = UIFont(name: fontName, size: aviailableFontSize)
		}
		
		return aviailableFont ?? self
	}
	
	static func lc_fontOfSize(_ size: CGFloat) -> UIFont {
		
		return UIFont.systemFont(ofSize: size * 1.3)
	}
}
