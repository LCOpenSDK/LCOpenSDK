//
//  Copyright © 2020 jm. All rights reserved.
//

import UIKit

import Foundation

public extension Bundle {
    
    static var base_bundle: Bundle? = nil
    
    @objc class func demo_BaseBundle() -> Bundle? {

        if self.base_bundle == nil, let path = Bundle(for: LCBaseModule.classForCoder()).path(forResource: "LCBaseModuleBundle", ofType: "bundle") {
            self.base_bundle = Bundle(path: path)
        }
        
        return self.base_bundle
    }
}
