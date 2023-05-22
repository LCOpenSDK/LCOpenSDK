//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	对LCUserDeviceBindInfo的字段扩展

import Foundation

enum LCDeviceBindStatus {
	case unbind
	case bindBySelf
	case bindByOther
}

extension LCUserDeviceBindInfo {
    class func lc_netConfigModes(wifiConfigMode: String, isIotDevice: Bool = false) -> [LCNetConfigMode] {
        var modes = Set<LCNetConfigMode>()
		if wifiConfigMode.count > 0 {
			for mode in wifiConfigMode.components(separatedBy: ",") {
                if isIotDevice {
                    if mode == "bluetooth" {
                        modes.insert(.iotBluetooth)
                    }
                    
                    if mode == "bluetoothBatch" {
                        modes.insert(.iotBluetooth)
                    }
                    
                    if mode == "4G" {
                        modes.insert(.iot4G)
                    }
                    
                    if mode == "lan" {
                        modes.insert(.iotLan)
                    }
                    
                    if mode == "wifi" {
                        modes.insert(.wifi)
                    }
                } else {
                    if mode == "SmartConfig" {
                        modes.insert(.smartConfig)
                    }
                    
                    if mode == "SoundWave" {
                        modes.insert(.soundWave)
                    }
                    
                    if mode == "SoundWaveV2" {
                        modes.insert(.soundWaveV2)
                    }
                    
                    if mode == "SoftAP" {
                        modes.insert(.softAp)
                    }
                    
                    if mode == "LAN" {
                        modes.insert(.lan)
                    }
                }
			}
		}
        return Array(modes)
	}
	
	func lc_support5GWifi() -> Bool {
        if wifiTransferMode == nil {
            return false
        }
		return wifiTransferMode.lc_caseInsensitiveContain(string: "5Ghz")
	}
	
	func lc_isSupportSoundWave() -> Bool {
		return wifiConfigMode != nil && wifiConfigMode.lc_caseInsensitiveContain(string: "SoundWave")
	}
	
	func lc_bindStatus() -> LCDeviceBindStatus {
		if bindStatus == nil || bindStatus.count == 0 || bindStatus.lc_caseInsensitiveContain(string: "unbind") {
			return .unbind
		}
		
		if bindStatus.lc_caseInsensitiveContain(string: "bindByMe") {
			return .bindBySelf
		}
		
		if bindStatus.lc_caseInsensitiveContain(string: "bindByOther") {
			return .bindByOther
		}
		
		return .unbind
	}
	
	func lc_isOnline() -> Bool {
		return status != nil && (status.lc_caseInsensitiveSame(string: "online") || status.lc_caseInsensitiveSame(string: "sleep"))
	}
	
	func lc_isExisted() -> Bool {
		return deviceExist != nil && deviceExist.lc_caseInsensitiveSame(string: "exist")
	}
	
	func lc_isAccesoryPart() -> Bool {
		return type != nil && type.lc_caseInsensitiveContain(string: "ap")
	}
	
//	func lc_accessType() -> LCDeviceAccessType {
//		if accessType == nil || accessType.count == 0 {
//			return .paas
//		}
//
//		var type = LCDeviceAccessType.paas
//		if accessType.lc_caseInsensitiveContain(string: "p2p") {
//			type = .p2p
//		} else if accessType.lc_caseInsensitiveContain(string: "easy4ip") {
//			type = .easy4ip
//		}
//
//		return type
//	}
}

// MARK: Extesion String
extension String {
	
	/// 忽略大小写的包含判断方法
	///
	/// - Parameter string: 是否包含的字符串
	/// - Returns: YES/NO
	func lc_caseInsensitiveContain(string: String) -> Bool {
		let upperSelf = self.uppercased()
		let result = upperSelf.contains(string.uppercased())
		return result
	}
	
	/// 忽略大小写的判断是否相等
	///
	/// - Parameter string: 是否包含的字符串
	/// - Returns: YES/NO
	func lc_caseInsensitiveSame(string: String?) -> Bool {
		if string == nil {
			return false
		}
		
		let upperSelf = self.uppercased()
		let result = upperSelf.caseInsensitiveCompare(string!.uppercased())
		return result == .orderedSame
	}
}
