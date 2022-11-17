//
//  Copyright © 2017 Imou. All rights reserved.
//

import Foundation

public extension Dictionary {
    
    mutating func lc_exchangeValue(_ key1: Dictionary.Key, _ key2: Dictionary.Key) {
        let temp = self[key1]
        self[key1] = self[key2]
        self[key2] = temp
    }
    
}
