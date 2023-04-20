//
//  Copyright © 2017 Imou. All rights reserved.
//

import Foundation

public extension Array {
    
    
    /// 合并数组，并去除重复元素
    ///
    /// - Parameter other: 其他数组
    /// - Returns: 新的合并数组
    static func lc_unionArray<T>(_ a: [T]?, _ b: [T]?) -> [T]? {
        
        if a == nil {
            return b
        }
        
        if b == nil {
            return a
        }
        
        var result = Array<T>(a!)
        
        for item in b! {
            result.append(item)
        }
        
        return result
    }

}
