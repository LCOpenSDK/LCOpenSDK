//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	对LCUserDeviceBindInfo的字段扩展

import Foundation

enum DHDeviceBindStatus {
	case unbind
	case bindBySelf
	case bindByOther
}

extension DHUserDeviceBindInfo {
	
	func dh_netConfigModes() -> [DHNetConfigMode] {
		var modes = [DHNetConfigMode]()
		if let configModes = self.wifiConfigMode, configModes.count > 0 {
			for mode in configModes.components(separatedBy: ",") {
				if mode.dh_caseInsensitiveContain(string: "SmartConfig") || mode.dh_caseInsensitiveContain(string: "SoundWave") {
					if modes.contains(.wifi) == false { //防止重复添加
						modes.append(.wifi)
					}
				}
				
				if mode.dh_caseInsensitiveContain(string: "SoftAP") {
					modes.append(.softAp)
				}
				
				if mode.dh_caseInsensitiveContain(string: "LAN") {
					modes.append(.wired)
				}
				
				if mode.dh_caseInsensitiveContain(string: "SIMCard") {
					modes.append(.simCard)
				}
				
				if mode.dh_caseInsensitiveSame(string: "Location") {
					modes.append(.local)
				}
				
				if mode.dh_caseInsensitiveSame(string: "NBIOT") {
					modes.append(.nbIoT)
				}
				
                if mode.dh_caseInsensitiveSame(string: "Bluetooth") {
                    modes.append(.ble)
                }
                
			}
		} else {
            modes.append(.wifi)
            modes.append(.wired)
            modes.append(.softAp)
        }
		
		if DHAddDeviceTest.openTest {
			modes.append(.nbIoT)
		}
	
		return modes
	}
	
	func dh_support5GWifi() -> Bool {
        if wifiTransferMode == nil {
            return false
        }
		return wifiTransferMode.dh_caseInsensitiveContain(string: "5Ghz")
	}
	
	func dh_isSupportSoundWave() -> Bool {
		//TEST::!!!
		if DHAddDeviceTest.openTest {
			return DHAddDeviceTest.testSoundWave
		}
		
		return wifiConfigMode != nil && wifiConfigMode.dh_caseInsensitiveContain(string: "SoundWave")
	}
	
	func dh_bindStatus() -> DHDeviceBindStatus {
		
		if bindStatus == nil || bindStatus.count == 0 || bindStatus.dh_caseInsensitiveContain(string: "unbind") {
			return .unbind
		}
		
		if bindStatus.dh_caseInsensitiveContain(string: "bindByMe") {
			return .bindBySelf
		}
		
		if bindStatus.dh_caseInsensitiveContain(string: "bindByOther") {
			return .bindByOther
		}
		
		return .unbind
	}
	
	func dh_isOnline() -> Bool {
		return status != nil && status.dh_caseInsensitiveSame(string: "online")
	}
	
	func dh_isExisted() -> Bool {
		return deviceExist != nil && deviceExist.dh_caseInsensitiveSame(string: "exist")
	}
	
	func dh_isAccesoryPart() -> Bool {
		return type != nil && type.dh_caseInsensitiveContain(string: "ap")
	}
	
	func dh_accessType() -> DHDeviceAccessType {
		if accessType == nil || accessType.count == 0 {
			return .paas
		}
		
		var type = DHDeviceAccessType.paas
		if accessType.dh_caseInsensitiveContain(string: "p2p") {
			type = .p2p
		} else if accessType.dh_caseInsensitiveContain(string: "easy4ip") {
			type = .easy4ip
		}
		
		return type
	}
}

// MARK: Extesion String
extension String {
	
	/// 忽略大小写的包含判断方法
	///
	/// - Parameter string: 是否包含的字符串
	/// - Returns: YES/NO
	func dh_caseInsensitiveContain(string: String) -> Bool {
		let upperSelf = self.uppercased()
		let result = upperSelf.contains(string.uppercased())
		return result
	}
	
	/// 忽略大小写的判断是否相等
	///
	/// - Parameter string: 是否包含的字符串
	/// - Returns: YES/NO
	func dh_caseInsensitiveSame(string: String?) -> Bool {
		if string == nil {
			return false
		}
		
		let upperSelf = self.uppercased()
		let result = upperSelf.caseInsensitiveCompare(string!.uppercased())
		return result == .orderedSame
	}
}
