//
//  Copyright © 2017年 dahua. All rights reserved.
//

import Foundation

extension LCProgressHUD {
    static func showAtKeyWindow() {
        LCProgressHUD.show(on: UIApplication.shared.keyWindow)
    }
    
    static func removeFormKeyWindow() {
        LCProgressHUD.hideAllHuds(UIApplication.shared.keyWindow)
    }
}

