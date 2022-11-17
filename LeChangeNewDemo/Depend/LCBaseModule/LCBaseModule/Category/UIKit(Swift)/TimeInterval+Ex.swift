//
//  Copyright © 2017 Imou. All rights reserved.
//

import Foundation

public extension TimeInterval {
    
    var lc_secondString: String {
		
		let timeGMT = TimeInterval((Int(self) + TimeZone.current.secondsFromGMT()) % (24 * 3_600))
		// 小于1970时认为是绝对时间
		let time = self < NSTimeIntervalSince1970 ? self : timeGMT
		
        let hour = Int(time) / 3_600 % 24
        let minute = Int(time) % 3_600 / 60
        let second = Int(time) % 60
		
        return String(format: "%.2d:%.2d:%.2d", hour, minute, second)
    }
}
