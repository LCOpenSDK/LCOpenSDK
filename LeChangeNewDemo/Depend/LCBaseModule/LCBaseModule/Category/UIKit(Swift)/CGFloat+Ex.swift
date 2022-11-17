//
//  Copyright © 2017 Imou. All rights reserved.
//

import Foundation

public extension CGFloat {
	
	var lc_streamString: String {
		
		var result = ""
		
		if self < (1_024 * 1_024 * 0.1) {
			// KB
			let size: CGFloat = self / 1_024
			result = String(format: "%.2fKB", size)
		} else if self < (1_024 * 1_024 * 1_024) {
			// MB
			let size: CGFloat = self / 1_024 / 1_024
			result = String(format: "%.2fMB", size)
		} else {
			// GB
			let size: CGFloat = self / 1_024 / 1_024 / 1_024
			result = String(format: "%.2fGB", size)
		}
		
		return result
	}
	
	var lc_intFloat: CGFloat {
		return CGFloat(Int(self))
	}
	
}
