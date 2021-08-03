//
//  Bundle+Base.swift
//  DHBaseModule
//
//  Created by imou on 2020/4/1.
//  Copyright © 2020 jm. All rights reserved.
//

import UIKit

extension Bundle {
    
    static var base_bundle: Bundle? = nil
    
    @objc public class func dh_baseBundle() -> Bundle? {

        if self.base_bundle == nil, let path = Bundle(for: DHBaseModule.classForCoder()).path(forResource: "DHBaseModuleBundle", ofType: "bundle") {
            self.base_bundle = Bundle(path: path)
        }
        
        return self.base_bundle
    }
}
