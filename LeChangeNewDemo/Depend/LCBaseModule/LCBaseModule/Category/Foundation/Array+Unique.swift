//
//  Copyright © 2019 Imou. All rights reserved.
//

import Foundation

public extension Array where Element: Hashable {
    var unique: [Element] {
        var uniq = Set<Element>()
        uniq.reserveCapacity(self.count)
        return self.filter {
            return uniq.insert($0).inserted
        }
    }
}
