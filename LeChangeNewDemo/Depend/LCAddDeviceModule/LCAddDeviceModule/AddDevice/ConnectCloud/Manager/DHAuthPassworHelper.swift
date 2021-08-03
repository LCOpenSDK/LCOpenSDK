//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	海外检验设备密码：软AP添加使用NetSDK进行检验（同一局域网），其他使用OCInterface+LCSDK方式进行

import UIKit

enum DHAuthPasswordType {
	case netsdk
	case lcsdk
	case paas
}

class DHAuthPassworHelper: NSObject {

	func authByNetSDK(password: String, device: ISearchDeviceNetInfo, gatewayIP: String? = nil, success: @escaping (_ loginHandle: Int) -> (), failure: @escaping (_ description: String) -> ()) {
		DispatchQueue.global().async {
			let ip = gatewayIP ?? device.deviceIP
            DHNetSDKHelper.loginWithHighLevelSecurity(byIp: ip, port: 37_777, username: "admin", password: password, success: success) { (description) in
                failure(description!)
            }
		}
    }
}
