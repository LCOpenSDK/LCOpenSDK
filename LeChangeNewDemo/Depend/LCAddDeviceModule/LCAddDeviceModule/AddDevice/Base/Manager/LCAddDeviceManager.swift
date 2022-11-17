//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	设备添加管理类，单例

import Foundation
import NetworkExtension
import LCBaseModule
import LCNetworkModule
import UIKit


/// 配网类型
@objc public enum LCNetConfigMode: Int {
	case wifi
	case wired
	case softAp
	case simCard
    case qrCode
	case local /**< 猫眼类只支持本地配网 */
	case nbIoT /**< NB */
    case ble    // 蓝牙
//    case Bluetooth  //蓝牙-海外使用
//    case blueTooth /**<蓝牙 */
    /// iot有线
//    case iotLan
    /// iot软AP
    case iotWifi
    /// iot蓝牙
    case iotBluetooth
    /// iot4G
    case iot4G
    
    func name() -> String {
        switch self {
        case .wifi:
            return "wireless_add".lc_T
        case .wired:
            return "add_device_by_wired".lc_T
        case .softAp:
            return "soft_AP_addition".lc_T
        case .simCard:
            return "SIM卡添加"
        case .qrCode:
            return "二维码添加"
        case .local:
            return "本地配网"
        case .nbIoT:
            return "NB添加"
        case .ble:
            return "bluetooth_add".lc_T
//        case .iotLan:
//            return "iot_wired".lc_T
        case .iotWifi:
            return "iot_soft_AP".lc_T
        case .iotBluetooth:
            return "iot_bluetooth".lc_T
        case .iot4G:
            return "4G"
        default:
            return ""
        }
    }
}


@objc public enum LCNetConfigStrategy: Int {
    case defalult
    case fromOMS
    case fromNC
    case fromIPCOther
}

@objc public enum LCDeviceAccessType: Int {
	case p2p
	case easy4ip
	case paas
}

/// 网络连接类型：对应NC码
@objc public enum LCNetConnectType: Int {
	
	/// 没有NC码的
	case none
	
	/// 旧的声波算法
	case soundWave
	
	/// 优化声波算法
	case soundWaveV2
	
	/// 软AP
	case softAp
	
	/// 蓝牙
	case buleTooth
	
	static func convert(byNcCode ncCode: String) -> LCNetConnectType {
		var type: LCNetConnectType = .soundWave
		let scanner = Scanner(string: ncCode)
		var value: UInt32 = 0
		scanner.scanHexInt32(&value)
		
		// 按照3位十六进制表示
		// 按位与：二进制，最后一位为1即为新声波
		if (value & 0x01) == 1 {
			type = .soundWaveV2
		} else {
			type = .soundWave
		}
		
		return type
	}
    
    static func getWifiConfigModes(byNcCode ncCode: String) -> [LCNetConfigMode] {
        
        let scanner = Scanner(string: ncCode)
        var value: UInt32 = 0
        scanner.scanHexInt32(&value)
        
        var configModes: [LCNetConfigMode] = []
        if (value & 0b100) == 0b100 {
            configModes.append(.wifi)
        }
        
        if (value & 0b1000) == 0b1000 {
            configModes.append(.softAp)
        }
        
        if (value & 0b10000) == 0b10000 {
            configModes.append(.wired)
        }
        
        if (value & 0b100000) == 0b100000 {
//            configModes.append(.)//蓝牙？
        }
        
        if (value & 0b1000000) == 0b1000000 {
            configModes.append(.simCard)
        }

        if (value & 0b10000000) == 0b10000000 {
            configModes.append(.local)
        }

        if (value & 0b100000000) == 0b100000000 {
            configModes.append(.nbIoT)
        }
        
        return configModes
        
        
    }
}

public struct LCAddConfigTimeout {

	static let wifiConnect: Int = 120
	static let cloudConnect: Int = 60
	
	static let softApCloudConnect: Int = 120
	static let nbIoTCloudConnect: Int = 180
	static let initialSearch: Int = 30
	static let accessoryConnect: Int = 120
	
	/// p2p检查时间
	static let p2pCheckTime: Int = 50
	static let softApP2PCheckTime: Int = 100
}

@objc public class LCAddDeviceManager: NSObject {
	
	@objc public static let sharedInstance = LCAddDeviceManager()
	
	@objc public var deviceId: String = ""
    
    @objc public var productId: String? = "" //  iot设备产品型号
	
	@objc public var deviceModel: String = ""
	
    /// 二维码型号
	@objc public var deviceQRCodeModel: String?
    
    /// 市场型号
	@objc public var deviceMarketModel: String?
	
	/// imei码【扫描解析出来】
	@objc public var imeiCode: String = ""
	
	/// 设备安全码【国内需要，扫描解析出来】
	@objc public var regCode: String? = ""
    
    /// NC吗【扫描解析出来】
    @objc public var ncCode: String? = ""
	
	/// 配网模式
    @objc public var netConfigMode: LCNetConfigMode = .wired
    
    /// 是否是扫码进入
    @objc public var isEnterByQrcode: Bool = false
	
	/// 网络连接类型
	@objc public var ncType: LCNetConnectType = .soundWave
	
	/// 支持的配网模式
	public var supportConfigModes = [LCNetConfigMode]()
	
    public var netConfigStrategy: LCNetConfigStrategy = .defalult
    
	/// 是否支持5G频段的wifi
	public var isSupport5GWifi: Bool = false
	
	/// 是否支持声波配对方式
	public var isSupportSoundWave: Bool = false
	
	/// 是否在线
	public var isOnline: Bool = false
	
	/// 是否配件
	public var isAccessory: Bool = false
	
	/// 选中的网关
	public var gatewayId: String = ""
	
	/// 从网关入口添加配件时，进入扫码二维码页面，gatewayId被reset了
	public var gatewayIdNeedReset: Bool = true
	
	/// 设备接入类型
	public var accessType: LCDeviceAccessType = .paas
	
	/// 设备品牌
	public var brand: String = ""
	
	/// 视频通道数（包括未接入的）
	public var channelNum: String = ""
	
	/// 统计使用：用来区分是否包含了局域网搜索流程
	public var isContainInitializeSearch: Bool = false
	
	/// 统计使用：用来区分是否走了配网流程，默认为true，只有扫码时设备在线的情况才不走
	public var isContainNetConfig: Bool = true
	
	/// 设备初始化的密码
	@objc public var initialPassword: String = ""
	
	@objc public var wifiSSID: String? = ""
	
	@objc public var wifiPassword: String? = ""
	
	/// 是否从离线配网入口进入
	@objc public var isEntryFromWifiConfig: Bool = false
	
	/// 能力集
	@objc public var abilities: String = ""
	
	/// 是否使用SC码方式进行添加（新方式）
	var isSupportSC: Bool = false
    
    /// 是否是手动输入的SC码
    var isManualInputSC: Bool = false
	
	
	//MARK: - Private
	
	/// 线程队列
	private var statusQueue = DispatchQueue(label: "com.lechagne.adddevice.status", attributes: .concurrent)
	
	/// 标记是否在获取状态
	private var isGettingStatus: Bool = false
	
	/// 标记是否取消
	private var isCanceled: Bool = false
	
	/// 标记是否在绑定中
	private var isInBinding: Bool = false
    /// 是否正在连接WiFi热点
    fileprivate var isConnectWiFiHotSpot: Bool = false
    
    
	// MARK: Methods
	
	public override init() {
		super.init()
	}
	
	/// 判断当前的添加的设备，是否已经在局域网搜索到
	@objc public func isDeviceFindInLocalNetwork() -> Bool {
		let device = LCNetSDKSearchManager.sharedInstance().getNetInfo(byID: deviceId)
		return device != nil
	}
	
	/// 获取当前操作的设备信息
	///
	/// - Returns: 设备信息
	public func getLocalDevice() -> ISearchDeviceNetInfo? {
		let device = LCNetSDKSearchManager.sharedInstance().getNetInfo(byID: deviceId)
		return device
	}
	
	public func reset() {
		supportConfigModes.removeAll()
		isSupport5GWifi = false
		isSupportSoundWave = false
		deviceModel = ""
		isOnline = false
		deviceQRCodeModel = ""
		deviceMarketModel = ""
		regCode = ""
		deviceId = ""
		netConfigMode = .wired
		initialPassword = ""
		wifiSSID = ""
		wifiPassword = ""
		if gatewayIdNeedReset {
			gatewayId = ""
		}
		accessType = .paas
		isEntryFromWifiConfig = false
		abilities = ""
		brand = ""
		isSupportSC = false
		ncType = .soundWave
		channelNum = ""
		isContainInitializeSearch = false
		isContainNetConfig = true
		imeiCode = ""
        isManualInputSC = false
        netConfigStrategy = .defalult
	}
	
    public func getUnBindDeviceInfo(deviceId: String, productId: String?, qrModel: String?, ncCode: String?, marketModel: String?, imeiCode: String?, success: @escaping (LCUserDeviceBindInfo, Bool) -> (), failure:@escaping (LCError) -> ()) {
        LCAddDeviceInterface.unBindDeviceInfo(forDevice: deviceId, productId: productId, deviceModel: qrModel, deviceName: marketModel ?? "", ncCode:ncCode ?? "", success: { (deviceInfo) in
            self.deviceQRCodeModel = qrModel
            self.deviceMarketModel = marketModel
            self.deviceId = deviceId
            self.imeiCode = imeiCode ?? ""
            self.ncCode = ncCode ?? ""
            self.setup(deviceInfo: deviceInfo)
            success(deviceInfo, true)
        }) { (error) in
            self.deviceId = deviceId
            failure(error)
        }
    }

	public func setup(deviceInfo: LCUserDeviceBindInfo) {
        //之前的地方 可能已经被NC码写过  这里用接口中的wifiConfigMode覆盖
        /*现在NC码判断在平台来做,客户端通过返回的wifiConfigMode判断*/
//        //如果只有一个qrcode  那么不要去掉  否则 先清除
//        if !(supportConfigModes.count == 1 && supportConfigModes.contains(.qrCode)) {
//            supportConfigModes.removeAll()
//        }
        supportConfigModes.removeAll()
        supportConfigModes.append(contentsOf: deviceInfo.lc_netConfigModes())
        
        //如果平台返回的wifiConfigMode 有值  以平台为准
        if let configModes = deviceInfo.wifiConfigMode, configModes.count > 0 {
            self.netConfigStrategy = .fromOMS
        }
        
		isSupport5GWifi = deviceInfo.lc_support5GWifi()
		isSupportSoundWave = deviceInfo.lc_isSupportSoundWave()
		deviceModel = deviceInfo.deviceModel
		isOnline = deviceInfo.lc_isOnline()
		isAccessory = deviceInfo.lc_isAccesoryPart()
		abilities = deviceInfo.ability
		brand = deviceInfo.brand
		channelNum = deviceInfo.channelNum ?? ""
		
		//解析新的声波配对
		if deviceInfo.wifiConfigMode.lc_caseInsensitiveContain(string: "SoundWaveV2") {
			ncType = .soundWaveV2
		}
		
		/*不在通用流程中解析SC码能力，只在手动输入时进行解析*/
		//解析SC码
		if deviceInfo.ability.lc_caseInsensitiveContain(string: "SCCode") ||
			deviceInfo.wifiConfigMode.lc_caseInsensitiveContain(string: "SCCode") {
			isSupportSC = true
		}
       
		//【*】特殊处理：根据NC码，是否支持声波配对
		if ncType == .soundWaveV2 {
			isSupportSoundWave = true
		}
		
		//【*】特殊处理：1、支持SC码的，接入类型强制修改为paas; 2、接入配置为paas的，强制修改
		if isSupportSC {
			accessType = .paas
		} else {
			accessType = deviceInfo.lc_accessType()
		}
	}
	
	// MARK: - 获取在线状态
    public func getDeviceStatus(success: @escaping (LCUserDeviceBindInfo) -> (), failure: @escaping (LCError) -> ()) {
        statusQueue.async {
            if self.isGettingStatus || self.isCanceled {
                print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder))::Return getting status...")
                return
            }
            
            self.isGettingStatus = true
            LCAddDeviceInterface.unBindDeviceInfo(forDevice: self.deviceId, productId: self.productId, deviceModel: self.deviceQRCodeModel, deviceName: self.deviceMarketModel ?? "", ncCode: self.ncCode ?? "", success: { (deviceInfo) in
                // 更新设备状态
                self.setup(deviceInfo: deviceInfo)
                success(deviceInfo)
                self.isGettingStatus = false
            }) { (error) in
                failure(error)
                self.isGettingStatus = false
            }
        }
    }
	
	public func stopGetDeviceStatus() {
		self.isCanceled = false
	}
	
	// MARK: - 绑定设备
	/// 绑定设备
	///
	/// - Parameters:
	///   - devicePassword: 设备密码
	///   - code: 安全码【国内】
	///   - deviceKey: 设备随机码【国内】
	///   - success: 成功，返回相应的信息 LCBindDeviceSuccess
	///   - failure: 失败
	public func bindDevice(devicePassword: String, code: String? = nil, deviceKey: String? = nil, success: @escaping () -> (), failure: @escaping (LCError) -> ()) {
		//SMB使用code，且用明文处理
        LCAddDeviceInterface.bindDevice(withDevice: self.deviceId, productId: self.productId, code: devicePassword.count > 0 ? devicePassword : (code ?? ""), success: {
            //发送更新列表通知
            self.postUpdateDeviceNotification()
            success()
        }) { (error) in
            failure(error)
        }
    }
    
    public func addPlicy(success: @escaping () -> (), failure: @escaping (LCError) -> ()) {
        LCAddDeviceInterface.addPolicy(withDevice: self.deviceId) {
            self.postUpdateDeviceNotification()
            success()
        } failure: { (error) in
            failure(error)
        }
    }
	
    public func getDeviceInfoAfterBind(success: @escaping (LCBindDeviceSuccess) -> (), failure: @escaping (LCError) -> ()) {
        let info = LCDeviceInfo()
        info.deviceId = LCAddDeviceManager.sharedInstance.deviceId
        info.productId = LCAddDeviceManager.sharedInstance.productId ?? ""
        let deviceArr = NSArray.init(array: [info])
        LCDeviceManagerInterface.listDeviceDetailBatch(deviceArr as! [LCDeviceInfo], success: { (deviceInfoArr) in
            let deviceInfo = deviceInfoArr[0] as! LCDeviceInfo
            let successInfo = LCBindDeviceSuccess()
            successInfo.deviceName = deviceInfo.name
            success(successInfo)
        }, failure: { (error) in
            failure(error)
        })
    }
    
	// MARK: - App引导文案
	public func getIntroductionParser() -> LCIntroductionParser? {
		guard self.deviceMarketModel != nil else {
			return nil
		}
		
		return LCOMSConfigManager.sharedManager.getIntroductionParser(marketModel: self.deviceMarketModel!)
	}
	
	public func isIntroductionUpdating() -> Bool {
		guard self.deviceMarketModel != nil else {
			return false
		}
		
		return LCOMSConfigManager.sharedManager.dicIntroductionStatus[self.deviceMarketModel!] ?? false
	}
	
	// MARK: - 通知
	public func postUpdateDeviceNotification(isWifiConfig: Bool = false) {
		let did = gatewayId.count > 0 ? gatewayId : deviceId
	}
}

extension LCAddDeviceManager {
    //LCAddDeviceManager.sharedInstance.initialPassword
    public func autoConnectHotSpot(wifiName ssid: String?, password: String?, completion: @escaping((Bool) -> Void)) {
        print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder)):: ssid:\(ssid ?? ""), password:\(password ?? "")")
        
        guard let _ = ssid, let _ = password else {
            completion(false)
            return
        }
        
        //加入热点
        if #available(iOS 11.0, *) {
            
            
            // 如果已经在连接WiFi、下次回调不执行
            guard self.isConnectWiFiHotSpot == false else {
                completion(false)
                return
            }
            var configuration: NEHotspotConfiguration!
            
            if password?.length == 0 {
                configuration = NEHotspotConfiguration(ssid: ssid!)
            } else {
                configuration = NEHotspotConfiguration(ssid: ssid!, passphrase: password!, isWEP: false)
            }
            
            NEHotspotConfigurationManager.shared.getConfiguredSSIDs { (wifiList) in
                if wifiList.contains(ssid!) {
                    NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: ssid!)
                }
                
                // 标记
                self.isConnectWiFiHotSpot = true
                NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
                    // 结束标记
                    self.isConnectWiFiHotSpot = false
                    if let err = error {
                        print("LCAddDeviceManager:: NEHotspotConfigurationManager error: \(err.localizedDescription)")
                        if err._code == NEHotspotConfigurationError.alreadyAssociated.rawValue {
                            // 该错误已连上路由器，当做成功
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } else {
                        
                        LCNetWorkHelper.sharedInstance().fetchCurrentWiFiSSID({ (currentSSID) in
                            print("LCAddDeviceManager:: NEHotspotConfigurationManager apply succeed, with current wifi:\(currentSSID ?? "")")
                            //连接成功后，wifi实际连接可能较慢，如果立马去取，则会导致获取到的ssid为空； 不能据此判断连接失败
                            //需要在上层代码中监听WiFi变更的状态，并进行局域网搜索
                            guard let curSSID = currentSSID else {
                                completion(false)
                                return
                            }
                            if(ssid?.compare(curSSID).rawValue == 0) {
                                print("LCAddDeviceManager:: NEHotspotConfigurationManager really succeed...")
                                completion(true)
                            } else {
                                print("LCAddDeviceManager:: NEHotspotConfigurationManager really failed...")
                                completion(false)
                            }
                        })
                    }
                }
            }
        } else {
            print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder)):: not ios 11...")
            completion(false)
        }
    }
    
    func gotoConfigWifi() {
        guard let url = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
     
}
