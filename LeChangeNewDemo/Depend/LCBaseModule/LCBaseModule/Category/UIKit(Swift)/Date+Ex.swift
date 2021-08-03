//
//  Copyright © 2017 dahua. All rights reserved.
//

import UIKit

public extension Date {

    static func lc_time(time: TimeInterval, format: String) -> String {
        
        let formatter = DHDateFormatter()
        formatter.dateFormat = format
        let date = Date(timeIntervalSince1970: time)
        
        return formatter.string(from: date)
    }
    
    func lc_string(_ format: String) -> String? {
		let dateFormatter = DHDateFormatter()
		dateFormatter.dateFormat = format
		
        return dateFormatter.string(from: self)
    }
    
    var lc_dayString: String {
        return self.lc_string("yyyy-MM-dd") ?? "2020-12-12"
    }
    
}
