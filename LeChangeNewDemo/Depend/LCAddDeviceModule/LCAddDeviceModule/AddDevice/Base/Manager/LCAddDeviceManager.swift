//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	设备添加管理类，单例

import Foundation
import NetworkExtension
import LCBaseModule
import LCNetworkModule
import UIKit

//非iot设备
//LAN                      有线
//SIMCard              Sim卡
//SoftAP                 软AP
//SoundWave         声波
//SmartConfig        SmartConfig方式
//QRCode                二维码
//SoundWaveV2     声波V2版本，优化声波算法
//
//
//iot设备
//wifi
//bluetooth              蓝牙
//bluetoothBatch    蓝牙
//4G                         4G卡
//lan                         有线
//vlog                       热点直连
//sim                        SIM卡
//accessory             配件
//lanWeak                弱绑定 有线
//EZ                          声波快连

/// 配网类型
public enum LCNetConfigMode: Int {
    // 此处屏蔽掉的枚举类型为当前不支持类型
    // 非IoT设备
    case lan = 0//"LAN"
//    case simCard = "SIMCard"
    case softAp //= "SoftAP"
    case soundWave //= "SoundWave"
    case soundWaveV2 //= "SoundWaveV2"
    case smartConfig //= "SmartConfig"
//    case qrCode = "QRCode"
    // IoT设备
//    case iotWifi = "wifi"
    case iotBluetoothBatch //= "bluetoothBatch"
    case iotBluetooth //= "bluetooth"
    case iot4G //= "4G"
    case iotLan //= "lan"
    case wifi
//    case vlog = "vlog"
//    case sim = "sim"
//    case accessory = "accessory" // 配件
//    case lanWeak = "lanWeak"  // 弱绑定 有线
//    case EZ = "EZ"  // 声波快连
    
    func name() -> String {
        switch self {
        case .soundWave, .soundWaveV2, .smartConfig:
            return "wireless_add".lc_T()
        case .lan, .iotLan:
            return "add_device_by_wired".lc_T()
        case .softAp:
            return "soft_AP_addition".lc_T()
        case .iotBluetooth, .iotBluetoothBatch:
            return "iot_bluetooth".lc_T()
        case .iot4G:
            return "4G"
        case .wifi:
            return "wifi"
        }
    }
    
    static func netConfigMode(type: String, isIOT: Bool) -> LCNetConfigMode {
        if isIOT {
            if type == "bluetoothBatch" {
                return .iotBluetoothBatch
            }
            
            if type == "bluetooth" {
                return .iotBluetooth
            }
            
            if type == "4G" {
                return .iot4G
            }
            
            if type == "lan" {
                return .iotLan
            }
            
            if type == "wifi" {
                return .wifi
            }
            
            return .iotLan
        } else {
            if type == "LAN" {
                return .lan
            }
            if type == "SoftAP" {
                return .softAp
            }
            if type == "SoundWave" {
                return .soundWave
            }
            if type == "SoundWaveV2" {
                return .soundWaveV2
            }
            
            if type == "SmartConfig" {
                return .smartConfig
            }
            
            return .lan
        }
    }
}

@objc public enum LCDeviceAccessType: Int {
	case p2p
	case easy4ip
	case paas
}

public struct LCAddConfigTimeout {
	static let wifiConnect: Int = 120
	static let cloudConnect: Int = 60
	
	static let softApCloudConnect: Int = 120
	static let nbIoTCloudConnect: Int = 180
	static let initialSearch: Int = 30
	static let accessoryConnect: Int = 120
}

@objcMembers public class LCAddDeviceManager: NSObject {
	
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
    public var netConfigMode: LCNetConfigMode = .lan
    
    /// 是否是扫码进入
    @objc public var isEnterByQrcode: Bool = false
	
	/// 支持的配网模式
	public var supportConfigModes = [LCNetConfigMode]()
    
    /// 支持有线添加
    public func supportWired() -> Bool {
        return self.supportConfigModes.contains(.lan) || self.supportConfigModes.contains(.iotLan)
    }
    
    /// 当前是有线添加
    public func isWired() -> Bool {
        return self.netConfigMode == .lan || self.netConfigMode == .iotLan
    }
    
    /// 支持软AP添加
    public func supportSoftAP() -> Bool {
        return self.supportConfigModes.contains(.softAp)
    }
    
    /// 当前是软AP添加
    public func isSoftAP() -> Bool {
        return self.netConfigMode == .softAp
    }
    
    /// 支持无线添加
    public func supportWifi() -> Bool {
        return self.supportConfigModes.contains(.soundWave) || self.supportConfigModes.contains(.soundWaveV2) || self.supportConfigModes.contains(.smartConfig)
    }
    
    /// 当前是无线添加
    public func isWireless() -> Bool {
        return self.netConfigMode == .soundWave || self.netConfigMode == .soundWaveV2 || self.netConfigMode == .smartConfig
    }

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
    /// 软Ap添加版本
    @objc public var softAPModeWifiVersion: String = ""
    /// 软Ap热点名
    @objc public var softAPModeWifiName: String = ""
    
    
	// MARK: Methods
	
	public override init() {
		super.init()
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
		netConfigMode = .lan
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
		channelNum = ""
		imeiCode = ""
        isManualInputSC = false
        softAPModeWifiVersion = ""
        softAPModeWifiName = ""
	}
	
    public func getUnBindDeviceInfo(deviceId: String, productId: String?, qrModel: String?, ncCode: String?, marketModel: String?, imeiCode: String?, success: @escaping (LCUserDeviceBindInfo, Bool) -> (), failure:@escaping (LCError) -> ()) {
        LCAddDeviceInterface.unBindDeviceInfo(forDevice: deviceId, productId: productId, deviceModel: qrModel, deviceName: marketModel ?? "", ncCode:ncCode ?? "", success: { (deviceInfo) in
            self.deviceQRCodeModel = qrModel
            self.deviceMarketModel = marketModel
            self.deviceId = deviceInfo.deviceId.uppercased()
            self.productId = deviceInfo.productId
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
        supportConfigModes.removeAll()
        // 设置支持配网方式
        supportConfigModes.append(contentsOf: LCUserDeviceBindInfo.lc_netConfigModes(wifiConfigMode: deviceInfo.wifiConfigMode, isIotDevice: deviceInfo.isIotDevice()))
        // 设置默认配网方式
        if deviceInfo.isIotDevice() {
            if let configMode = deviceInfo.defaultWifiConfigMode, configMode.length > 0 {
                netConfigMode = LCNetConfigMode.netConfigMode(type: configMode, isIOT: true)
            } else {
                if supportConfigModes.contains(.iotBluetooth) {
                    netConfigMode = .iotBluetooth
                } else if supportConfigModes.contains(.wifi) {
                    netConfigMode = .wifi
                } else if supportConfigModes.contains(.iot4G) {
                    netConfigMode = .iot4G
                } else {
                    netConfigMode = .iotLan
                }
            }
        } else {
            if let configMode = deviceInfo.defaultWifiConfigMode, configMode.length > 0 {
                netConfigMode = LCNetConfigMode.netConfigMode(type: configMode, isIOT: false)
            } else {
                if supportConfigModes.contains(.softAp) {
                    netConfigMode = .softAp
                } else if supportConfigModes.contains(.soundWaveV2) {
                    netConfigMode = .soundWaveV2
                } else if supportConfigModes.contains(.soundWave) {
                    netConfigMode = .soundWave
                } else if supportConfigModes.contains(.smartConfig) {
                    netConfigMode = .smartConfig
                } else {
                    netConfigMode = .lan
                }
            }
        }
        
		isSupport5GWifi = deviceInfo.lc_support5GWifi()
		isSupportSoundWave = deviceInfo.lc_isSupportSoundWave()
		deviceModel = deviceInfo.deviceModel
		isOnline = deviceInfo.lc_isOnline()
		isAccessory = deviceInfo.lc_isAccesoryPart()
		abilities = deviceInfo.ability
		brand = deviceInfo.brand
		channelNum = deviceInfo.channelNum ?? ""
		
		/*不在通用流程中解析SC码能力，只在手动输入时进行解析*/
		//解析SC码
		if deviceInfo.ability.lc_caseInsensitiveContain(string: "SCCode") {
			isSupportSC = true
		}
	}
    
    public func refreshData(deviceInfo: LCUserDeviceBindInfo) {
        isSupport5GWifi = deviceInfo.lc_support5GWifi()
        isSupportSoundWave = deviceInfo.lc_isSupportSoundWave()
        deviceModel = deviceInfo.deviceModel
        isOnline = deviceInfo.lc_isOnline()
        isAccessory = deviceInfo.lc_isAccesoryPart()
        abilities = deviceInfo.ability
        brand = deviceInfo.brand
        channelNum = deviceInfo.channelNum ?? ""
        
        /*不在通用流程中解析SC码能力，只在手动输入时进行解析*/
        //解析SC码
        if deviceInfo.ability.lc_caseInsensitiveContain(string: "SCCode") {
            isSupportSC = true
        }
    }
    
    // 切换配网方式到有线配网
    public func changeNetConfigToWired() -> LCNetConfigMode {
        var netConfig: LCNetConfigMode = .lan
        if let productID = self.productId, productID.length > 0 {
            netConfig = .iotLan
        } else {
            netConfig = .lan
        }
        let oldNetConfigMode = LCAddDeviceManager.sharedInstance.netConfigMode
        LCAddDeviceManager.sharedInstance.netConfigMode = netConfig
        return oldNetConfigMode
    }
    
    // 切换配网方式到无线配网，返回原有配网方式
    public func changeNetConfigToWireless() -> LCNetConfigMode {
        var netConfig: LCNetConfigMode = .lan
        if let productID = self.productId, productID.length > 0 {
            if supportConfigModes.contains(.iot4G) {
                netConfig = .iot4G
            } else if supportConfigModes.contains(.iotBluetooth) {
                netConfig = .iotBluetooth
            } else if supportConfigModes.contains(.wifi) {
                netConfig = .wifi
            }
        } else {
            if supportConfigModes.contains(.soundWaveV2) {
                netConfig = .soundWaveV2
            } else if supportConfigModes.contains(.soundWave) {
                netConfig = .soundWave
            } else if supportConfigModes.contains(.smartConfig) {
                netConfig = .smartConfig
            }
        }
        let oldNetConfigMode = LCAddDeviceManager.sharedInstance.netConfigMode
        LCAddDeviceManager.sharedInstance.netConfigMode = netConfig
        return oldNetConfigMode
    }
    
    // 切换配网方式到有线配网
    public func changeNetConfigToSoftAP() -> LCNetConfigMode {
        let oldNetConfigMode = LCAddDeviceManager.sharedInstance.netConfigMode
        LCAddDeviceManager.sharedInstance.netConfigMode = .softAp
        return oldNetConfigMode
    }

	// MARK: - 获取在线状态
    public func getDeviceStatus(success: @escaping (LCUserDeviceBindInfo) -> (), failure: @escaping (LCError) -> ()) {
        statusQueue.async {
            if self.isGettingStatus || self.isCanceled {
                print(" \(NSStringFromClass(self.classForCoder))::Return getting status...")
                return
            }
            self.isGettingStatus = true
            LCAddDeviceInterface.unBindDeviceInfo(forDevice: self.deviceId, productId: self.productId, deviceModel: self.deviceQRCodeModel, deviceName: self.deviceMarketModel ?? "", ncCode: self.ncCode ?? "", success: { (deviceInfo) in
                // 更新设备状态
                self.refreshData(deviceInfo: deviceInfo)
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
            success()
        }) { (error) in
            failure(error)
        }
    }
    
    public func addPlicy(success: @escaping () -> (), failure: @escaping (LCError) -> ()) {
        LCAddDeviceInterface.addPolicy(withDevice: self.deviceId) {
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
}

extension LCAddDeviceManager {
    //LCAddDeviceManager.sharedInstance.initialPassword
    public func autoConnectHotSpot(wifiName ssid: String?, password: String?, completion: @escaping((Bool) -> Void)) {
        print(" \(Date()) \(NSStringFromClass(self.classForCoder)):: ssid:\(ssid ?? ""), password:\(password ?? "")")
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
            print(" \(Date()) \(NSStringFromClass(self.classForCoder)):: not ios 11...")
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
