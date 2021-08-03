//
//  Copyright © 2018年 jm. All rights reserved.
//

import UIKit

class LCBaseModule: NSObject, DHModuleProtocol {

	func moduleInit() {
		registerVideoDecrptionAlertHelper()
	}
	
	func registerVideoDecrptionAlertHelper() {
		if let cls = NSClassFromString("LCVideoDecrytionAlertView") {
			DHModule.registerService(IVideoDecrytionAlertHelper.self, implClass: cls)
		}
	}
}
