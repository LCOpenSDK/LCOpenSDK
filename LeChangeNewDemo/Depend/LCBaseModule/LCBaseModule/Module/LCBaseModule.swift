//
//  Copyright © 2018年 jm. All rights reserved.
//

import UIKit

class LCBaseModule: NSObject, LCModuleProtocol {

	func moduleInit() {
		registerVideoDecrptionAlertHelper()
	}
	
	func registerVideoDecrptionAlertHelper() {
		if let cls = NSClassFromString("LCVideoDecrytionAlertView") {
			LCModule.registerService(IVideoDecrytionAlertHelper.self, implClass: cls)
		}
	}
}
