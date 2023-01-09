//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	离线配网

import UIKit

@objc class LCOfflineWifiConfigHelper: NSObject {

	@objc public static let sharedInstance = LCOfflineWifiConfigHelper()
	
	private var configImpl: LCOfflineWifiConfigProtocol?
	
	@objc public func setup(wifiConfig: LCOfflineWifiConfigProtocol) {
		self.configImpl = wifiConfig
	}
	
	// MARK: LCOfflineWifiConfigProtocol
	func updateDeviceInfo(deviceId: String, byPassword devicePassword: String) {
		self.configImpl?.updateDeviceInfo(deviceId: deviceId, byPassword: devicePassword)
	}
	
	func savePasswordInCache(deviceId: String, password: String) {
		self.configImpl?.savePasswordInCache(deviceId: deviceId, password: password)
	}
	
	func backToMainController() {
		self.configImpl?.backToMainController()
	}
}
