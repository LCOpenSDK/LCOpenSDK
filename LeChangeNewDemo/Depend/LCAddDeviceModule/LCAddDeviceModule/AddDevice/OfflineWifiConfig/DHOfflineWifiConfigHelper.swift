//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	离线配网

import UIKit

@objc class DHOfflineWifiConfigHelper: NSObject {

	@objc public static let sharedInstance = DHOfflineWifiConfigHelper()
	
	private var configImpl: DHOfflineWifiConfigProtocol?
	
	@objc public func setup(wifiConfig: DHOfflineWifiConfigProtocol) {
		self.configImpl = wifiConfig
	}
	
	// MARK: DHOfflineWifiConfigProtocol
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
