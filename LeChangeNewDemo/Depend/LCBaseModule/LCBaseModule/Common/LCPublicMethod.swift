//
//  Copyright © 2019 jm. All rights reserved.
//

import Foundation

/// 是否iPhoneX系列设备
public var lc_isiPhoneX: Bool {
    
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else {
            return identifier
        }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    // 截取机型版本号
    guard let model = identifier.split(separator: ",").first else {
        return false
    }
    let modelString = String(model)
    var modelNumber: String = "0"
    if modelString.count > 6 {
        modelNumber = String(modelString.suffix(modelString.count - 6))
    }
    /**
     @"iPhone10,3"  iPhone X
     @"iPhone10,6"  iPhone X
     @"iPhone11,8"  iPhone XR
     @"iPhone11,2"  iPhone XS
     @"iPhone11,4"  iPhone XS Max
     @"iPhone11,6"  iPhone XS Max
     */
    if identifier == "iPhone10,3" || identifier == "iPhone10,6" || Int(modelNumber) ?? 0 >= 11 {
        return true
    }
    return false
}
