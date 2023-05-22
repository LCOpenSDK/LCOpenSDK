//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	软AP热点连接检查

import UIKit
import LCBaseModule
import LCOpenSDKDynamic

class LCApWifiCheckViewController: LCAddBaseViewController, LCAddGuideViewDelegate {
    func guideView(view: LCAddGuideView, action: LCAddGuideActionType) {
        if action == .next {
        }
        if action == .detail {
            LCSheetGuideView(title: "add_device_network_config_guide_tips".lc_T(), message: "add_device_network_config_guide_alert".lc_T(), image: UIImage(lc_named: "adddevice_netsetting_guide_reset"), cancelButtonTitle: "Alert_Title_Button_Confirm1".lc_T()).show()
        }
    }
    
    private let guideView: LCAddGuideView = LCAddGuideView.xibInstance()
    
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	/// 用来标记自动跳转，防止多次push
	private var isWifiChecked: Bool = false
	///用来标记是否自动连接热点失败
    private var autoConnectHotSpotFailed: Bool = false {
        didSet {
            self.autoConnectWifiFailedChanged()
        }
    }
 
    private var searchedDevice: LCOpenSDK_SearchDeviceInfo?
	
	override func viewDidLoad() {
		super.viewDidLoad()
        self.title = ""
        self.view.addSubview(guideView)
        guideView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        guideView.topImageView.image = UIImage(lc_named: "adddevice_softap_hotspot")
        guideView.topTipLabel.text = "add_device_hot_spot".lc_T()
        guideView.descriptionLabel.text = "add_device_softap_connect_hotspot_des".lc_T()
        guideView.nextButton.isHidden = true
        guideView.detailButton.isHidden = true
        
		self.setupWifiName()
		self.checkWifi()
        self.refreshTipText()
        if #available(iOS 11.0, *) {
            self.autoConnectHotspot()
        }
        //【*】兼容iOS13，只有当WiFi名称匹配时，才做搜索操作
        self.appBecomeActive()
	}
    
    override func leftActionType() -> LCAddBaseLeftAction {
        return .quit
    }
	
    override func isLeftActionShowAlert() -> Bool {
        return true
    }
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.addNetworkObserver()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}

	func setupWifiName() {
	}
	
	func addNetworkObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(networkChanged), name: NSNotification.Name(rawValue: "LCNotificationWifiNetWorkChange"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(checkWifi), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
	}
	
	@objc func networkChanged() {
         //判断apWifi名称与实际的是否一致: 国内全名称判断，海外判断是否包含deviceId
         let predicateWifiName = LCModuleConfig.shareInstance().isChinaMainland ? getApWifiName() : LCAddDeviceManager.sharedInstance.deviceId.uppercased()
         let wifiSSID = LCMobileInfo.sharedInstance().wifissid
         
         print(" \(Date()) \(NSStringFromClass(self.classForCoder))::Networkchanged...current:\(wifiSSID ?? "")")
         //【*】兼容处理：iOS13下可能存在ssid获取不到的情况
        if wifiSSID != nil, wifiSSID != getApWifiName() {
             if wifiSSID!.contains(predicateWifiName) {
                 LCProgressHUD.show(on: self.view)
             }
         }
         
         checkWifi()
	}
    
    @objc func appBecomeActive() {
        let predicateWifiName = LCModuleConfig.shareInstance().isChinaMainland ? getApWifiName() : LCAddDeviceManager.sharedInstance.deviceId.uppercased()
        let wifiSSID = LCMobileInfo.sharedInstance().wifissid
        //【*】兼容处理：只有Wifi能正常获取到，才进行搜索
        if wifiSSID != nil, wifiSSID?.contains(predicateWifiName) == true {
            checkWifi()
        }
    }
	
    private func getApWifiName() -> String {
        /*
         V3.13.3 小版本
         这里要要判断 SoftAPModeWifiVersion
         * 无 -> DAP-SN
         * V1 ->  老的流程  平台获取如G2-XXXX 那么久是G2-SN后四位
         * V2 ->  如果平台给的是AAA-XXXX 那就是AAA-SN匹配  (Imou-XXXX)
         */
        
        let manager = LCAddDeviceManager.sharedInstance
        let softApWifiName = manager.softAPModeWifiVersion
        var predicateWifiName = manager.softAPModeWifiName
        var prefix = manager.deviceModel
        print(" \(#function):: softApWifiName: \(softApWifiName)")
        if let index = softApWifiName.lastIndex(of: "-") { //避免出现 Ring-V2-XXXX的情况
            prefix = String(softApWifiName.prefix(upTo: index))
            print(" \(#function):: prefix: \(prefix)")
        }
        
        if softApWifiName.lowercased() == "v1" {
            //国内：设备型号-deviceId后4位； 海外：设备型号-deviceId，
            if LCModuleConfig.shareInstance().isChinaMainland {
                predicateWifiName = prefix + "-" + manager.deviceId.suffix(4).uppercased()
            } else {
                predicateWifiName = prefix + "-" + manager.deviceId.uppercased()
            }
            return predicateWifiName
        } else if softApWifiName.lowercased() == "v2" {
            //国内、海外：统一，设备型号-deviceId
            predicateWifiName = prefix + "-" + manager.deviceId.uppercased()
            return predicateWifiName
        } else {
            return "DAP" + "-" + manager.deviceId.uppercased()
        }
        
        return prefix + "-" + manager.deviceId.uppercased()
    }

	@objc private func checkWifi() {
        if let productId = LCAddDeviceManager.sharedInstance.productId, productId.length > 0 {
            self.startSearchingWithWifi()
        } else {
            self.startSearchingWithAp()
        }
	}
    
    func startSearchingWithAp() {
        // 防止多次Push
        if isWifiChecked == true {
            return
        }
        
        self.isWifiChecked = true

        LCOpenSDK_SearchDevices.share().start(withDeviceId: LCAddDeviceManager.sharedInstance.deviceId, timeOut: 120) {[weak self] searchDeviceInfo in
            self?.searchedDevice = searchDeviceInfo
            LCOpenSDK_SearchDevices.share().stop()
        }

        //WIFI连接上后，搜索2s，判断初始化状态：
        LCProgressHUD.show(on: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let device = self.searchedDevice {
                if true == LCAddDeviceManager.sharedInstance.isSupportSC {
                    self.pushScDeviceNextPage(deviceIsInited: device.deviceInitStatus == .init)
                } else {
                    if device.deviceInitStatus == .unInit {
                        //【*】未初始初始化，跳转初始化搜索界面
                        self.basePushToInitializeSearchVC()
                    } else if device.deviceInitStatus == .noAbility, LCModuleConfig.shareInstance().isChinaMainland {
                        //【*】没有初始化能力集的，国内跳转局域网搜索（后面会赋值admin密码）；海外跳转登录
                        self.basePushToInitializeSearchVC()
                    } else {
                        //【*】已初始化的跳转登录
                        self.pushToApLoginVC()
                    }
                }
                LCProgressHUD.hideAllHuds(self.view)
            } else {
                if true == LCAddDeviceManager.sharedInstance.isSupportSC {
                    //没找到设备，继续轮询
                    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
                    timer.schedule(wallDeadline: .now(), repeating: 2.0)
                    var repeatCount = 30
                    timer.setEventHandler(handler: { [weak self] in
                        repeatCount -= 1
                        if repeatCount == 0 {
                            timer.cancel()
                            LCProgressHUD.hideAllHuds(self?.view)
                            print("获取设备信息失败")
                            self?.isWifiChecked = false
                            return
                        }
                        if let device = self?.searchedDevice {
                            //SC设备软AP配网
                            timer.cancel()
                            self?.pushScDeviceNextPage(deviceIsInited: device.deviceInitStatus == .init)
                            LCProgressHUD.hideAllHuds(self?.view)
                        }
                    })
                    timer.resume()
                } else {
                    self.basePushToInitializeSearchVC()
                    LCProgressHUD.hideAllHuds(self.view)
                }
            }
        }
    }
    
    func startSearchingWithWifi() {
        // 防止多次Push
        if isWifiChecked == true {
            return
        }
        
        self.isWifiChecked = true
        
        LCProgressHUD.show(on: self.view)
        LCOpenSDK_IotApConfig.startAsyncIotApConfig((LCAddDeviceManager.sharedInstance.wifiSSID ?? ""), wifiPwd: LCAddDeviceManager.sharedInstance.wifiPassword, productId: (LCAddDeviceManager.sharedInstance.productId ?? ""), deviceId: LCAddDeviceManager.sharedInstance.deviceId) {[weak self] success, errorMessage in
            LCProgressHUD.hideAllHuds(self?.view)
            self?.isWifiChecked = false
            if success == false {
                print("设备配网失败")
            } else {
               // 链接云平台
                self?.basePushToConnectCloudVC()
            }
        }
    }
    
    // MARK: sc设备软AP配网
    func autoConnectHotspot() {
        //SC设备软AP配网
        let predicateWifiName = getApWifiName()
        LCProgressHUD.show(on: self.view)
        LCAddDeviceManager.sharedInstance.autoConnectHotSpot(wifiName: predicateWifiName, password: LCAddDeviceManager.sharedInstance.initialPassword, completion: { (success) in
            if success {
                LCMobileInfo.sharedInstance().wifissid = predicateWifiName
                self.autoConnectHotSpotFailed = false
                self.checkWifi()
                print("连接sc设备热点成功")
            } else {
                LCProgressHUD.hideAllHuds(self.view)
                print("\(NSStringFromClass(self.classForCoder))...连接热点失败")
                self.autoConnectHotSpotFailed = true
            }
            self.refreshTipText()
        })
    }
    
    func autoConnectWifiFailedChanged() {
        if true == autoConnectHotSpotFailed {
            // 自动连接失败.
//            if self.selectWifiButton == nil {
//                self.selectWifiButton = UIButton(type: .system)
//                guideView.addSubview(self.selectWifiButton!)
//                self.selectWifiButton?.layer.borderWidth = 1
//                self.selectWifiButton?.layer.borderColor = UIColor.lccolor_c8().cgColor
//                self.selectWifiButton?.setTitle("add_device_connect_goto_select_wifi".lc_T(), for: .normal)
//                self.selectWifiButton?.layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
//                self.selectWifiButton?.backgroundColor = UIColor.lccolor_c43()
//                self.selectWifiButton?.setTitleColor(UIColor.lccolor_c2(), for: .normal)
//                self.selectWifiButton?.snp.makeConstraints({ (make) in
//                    make.bottom.right.equalTo(self.guideView).offset(-20)
//                    make.left.equalTo(self.guideView).offset(20)
//                    make.height.equalTo(40)
//                })
//                self.selectWifiButton?.addTarget(self, action: #selector(gotoSettingPage), for: .touchUpInside)
//            }
            
            //SC自动连接的失败页面   中间有关于热点密码
            if true == LCAddDeviceManager.sharedInstance.isSupportSC {
                self.guideView.descriptionLabel.isHidden = true
            } else {
                //非SC自动连接页面  中间是连接后将自动下一步
                self.guideView.descriptionLabel.isHidden = false
            }
        } else {
        }
    }
    
    // MARK: sc device connect hotspot
    
	private func pushToApLoginVC() {
		let controller = LCAuthPasswordViewController.storyboardInstance()
		controller.presenter = LCApAuthPasswordPresenter(container: controller)
		self.navigationController?.pushViewController(controller, animated: true)
	}
    
    private func pushScDeviceNextPage(deviceIsInited: Bool) {
        if deviceIsInited {
            //【*】已初始化的跳转登录
            LCProgressHUD.show(on: self.view)
            let helper = LCAuthPassworHelper()
            if let device = self.searchedDevice {
                helper.authByNetSDK(password: LCAddDeviceManager.sharedInstance.initialPassword, device: device, success: { loginHandle in
                    LCProgressHUD.hideAllHuds(self.view)
                    let controller = LCApWifiSelectViewController()
                    controller.scDeviceIsInited = deviceIsInited
                    controller.searchedDevice = self.searchedDevice
                    self.navigationController?.pushViewController(controller, animated: true)
                }) { (description) in
                    LCProgressHUD.hideAllHuds(self.view)
                    let controller = LCAuthPasswordViewController.storyboardInstance()
                    let presenter = LCApAuthPasswordPresenter(container: controller)
                    presenter.scDeviceIsInited = true
                    presenter.searchedDevice = self.searchedDevice
                    controller.presenter = presenter
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        } else {
            let controller = LCApWifiSelectViewController()
            controller.searchedDevice = self.searchedDevice
            controller.scDeviceIsInited = deviceIsInited
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func gotoSettingPage() {
        let url = URL.init(string: UIApplicationOpenSettingsURLString)!
        if #available(iOS 10.0, *) {
            //先判断是否有iOS10SDK的方法，如果有，则实现iOS10的跳转
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            // Fallback on earlier versions
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    private func tipbeforeIOS11() {
        let predicateWifiName = self.getApWifiName()
        let scCode = LCAddDeviceManager.sharedInstance.initialPassword
        guideView.errorButton.isHidden = true;
        //IOS11之前不能自动连接WIFI 文案是固定的
        if true == LCAddDeviceManager.sharedInstance.isSupportSC {
            //有SC码情况下 扫码
            if scCode.count != 0 && LCAddDeviceManager.sharedInstance.isEnterByQrcode {
                let str = String(format: "add_device_connect_ap_hotpot_and_back".lc_T(), arguments: [predicateWifiName])
                guideView.setTopTipLabel(text: str, underlineString: scCode, shouldCopy: true) {
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = scCode
                    LCProgressHUD.showMsg("device_manager_copy_success".lc_T())
                }
            } else {
                //有SC码情况下 手动添加 或者 无SC码
                let str = String(format: "add_device_connect_ap_hotpot_and_back".lc_T(), arguments: [predicateWifiName])
                guideView.setTopTipLabel(text: str, underlineString: "")
            }
            
        } else {
            let str = String(format: "add_device_connect_ap_hotpot_and_back".lc_T(), arguments: [predicateWifiName])
            guideView.topTipLabel.lc_setAttributedText(text: str, font: UIFont.lcFont_t1())
            guideView.detailButton.isHidden = true
        }
        
//        if self.selectWifiButton == nil {
//            self.selectWifiButton = UIButton(type: .system)
//            guideView.addSubview(self.selectWifiButton!)
//            self.selectWifiButton?.layer.borderWidth = 1
//            self.selectWifiButton?.layer.borderColor = UIColor.lccolor_c8().cgColor
//            self.selectWifiButton?.setTitle("add_device_connect_goto_select_wifi".lc_T(), for: .normal)
//            self.selectWifiButton?.layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
//            self.selectWifiButton?.backgroundColor = UIColor.lccolor_c43()
//            self.selectWifiButton?.setTitleColor(UIColor.lccolor_c2(), for: .normal)
//            self.selectWifiButton?.snp.makeConstraints({ (make) in
//                make.bottom.right.equalTo(self.guideView).offset(-20)
//                make.left.equalTo(self.guideView).offset(20)
//                make.height.equalTo(40)
//            })
//            self.selectWifiButton?.addTarget(self, action: #selector(gotoSettingPage), for: .touchUpInside)
//        }
    }
    
    
    func refreshTipText() {
        //IOS11
        if #available(iOS 11.0, *) { } else {
            tipbeforeIOS11()
            return
        }
        let predicateWifiName = self.getApWifiName()
        let scCode = LCAddDeviceManager.sharedInstance.initialPassword
        if LCAddDeviceManager.sharedInstance.isSupportSC == true {
            //自动连接失败
            if autoConnectHotSpotFailed == true {
                if scCode.count != 0 && LCAddDeviceManager.sharedInstance.isEnterByQrcode {//支持SC码的时候  扫码进入 二维码中有SC 展示真实的热点、有下划线、支持复制
                    let str = String(format: "add_device_wait_to_connect_wifi_failed_sc".lc_T(), arguments: [predicateWifiName])
                    
                    //没有安全码的清空下  展示“安全验证码”、无下划线、不支持复制
                    //支持SC码的时候 手动输入的 展示“安全验证码”、无下划线、不支持复制
                    
                    guideView.setTopTipLabel(text: str, underlineString: scCode, shouldCopy: true) {
                        if LCAddDeviceManager.sharedInstance.isEnterByQrcode {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = scCode
                            LCProgressHUD.showMsg("device_manager_copy_success".lc_T())
                        }
                    }
                    guideView.errorButton.isHidden = false
                } else {
                    let str = String(format: "add_device_wait_to_connect_wifi_failed_sc".lc_T(), arguments: [predicateWifiName])
                    guideView.setTopTipLabel(text: str, underlineString: "")
                }
            }
        } else if autoConnectHotSpotFailed == true {
            //IOS11以上不支持SC码的设备 自动连接失败的情况
            let str = String(format: "add_device_wait_to_connect_wifi_failed".lc_T(), arguments: [predicateWifiName])
            guideView.errorButton.titleLabel?.font = UIFont.lcFont_t1()
            guideView.topTipLabel.lc_setAttributedText(text: str, font: UIFont.lcFont_t1())
            guideView.errorButton.isHidden = false
        }
    }
}


