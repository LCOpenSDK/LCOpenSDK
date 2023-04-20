//
//  Copyright © 2019 jm. All rights reserved.
//

import Foundation

protocol Arbitrary {
    static func arbitrary() -> Self
}

public extension Int {
    static func random(from: Int, to: Int) -> Int {
        return from + (Int(arc4random()) % (to - from))
    }
}

extension Character: Arbitrary {
    static func arbitrary() -> Character {
        return Character(UnicodeScalar(Int.random(from: 65, to: 90))!)
    }
}

extension String: Arbitrary {
    
    static func arbitrary() -> String {
        let randomLength = Int.random(from: 10, to: 24)
        let randomCharacters = tabulate(times: randomLength) { _ in
            Character.arbitrary()
        }
        return String(randomCharacters)
    }
    
    static func tabulate<T>(times: Int, transform: (Int) -> T) -> [T] {
        return (0..<times).map(transform)
    }
    
}
