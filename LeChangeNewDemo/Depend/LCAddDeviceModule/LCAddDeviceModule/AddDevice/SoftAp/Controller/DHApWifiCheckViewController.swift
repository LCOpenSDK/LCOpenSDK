//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	软AP热点连接检查

import UIKit
import LCBaseModule

class DHApWifiCheckViewController: DHGuideBaseViewController {

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
    
	/// wifiName视图
    private var wifiNameView: UIImageView?
    
	private var wifiNameLabel: UILabel?
    /// 手动选择按钮
    private var selectWifiButton: UIButton?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        
		self.setupWifiName()
		self.baseAddOMSIntroductionObserver()
		self.adjustContraints()
		self.checkWifi()
        self.refreshTipText()
        
        if #available(iOS 11.0, *) {
            self.autoConnectHotspot()
        }
        
        //【*】兼容iOS13，只有当WiFi名称匹配时，才做搜索操作
        self.appBecomeActive()
        
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.addNetworkObserver()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    

	
	func setupWifiName() {
		if wifiNameView == nil {
			wifiNameView = UIImageView(image: UIImage(named: "adddevice_netsetting_connectwifi_config"))
			guideView.topImageView.addSubview(wifiNameView!)
			
			wifiNameView?.snp.makeConstraints({ (make) in
				make.size.equalTo(CGSize(width: 255, height: 62))
				make.centerX.equalTo(guideView)
				make.top.equalTo(guideView).offset(150)
			})
			
			wifiNameLabel = UILabel()
			wifiNameLabel?.textColor = UIColor.dhcolor_c2()
			wifiNameLabel?.font = UIFont.dhFont_t3()
			wifiNameView?.addSubview(wifiNameLabel!)
	
			wifiNameLabel?.snp.makeConstraints({ (make) in
				make.height.centerY.equalTo(wifiNameView!)
				make.left.equalTo(wifiNameView!).offset(25)
				make.right.equalTo(wifiNameView!).offset(-65)
			})
		}
	}

	func adjustContraints() {
		self.guideView.topImageView.contentMode = .scaleAspectFit
        if dh_screenHeight < 667 {
            self.guideView.updateTopImageViewConstraint(top: 0, width: 355, maxHeight: 355 * (300.0 / 375.0))
            guideView.topTipLabel.font = UIFont.dhFont_t3()
            guideView.descriptionLabel.font = UIFont.dhFont_t5()
        } else {
            self.guideView.updateTopImageViewConstraint(top: 0, width: 375, maxHeight: 300)
        }
        
        guideView.updateDetailButtonlConstraint(bottom: -10)
	}
	
	func addNetworkObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(networkChanged), name: NSNotification.Name(rawValue: "LCNotificationWifiNetWorkChange"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(checkWifi), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
	}
	
	@objc func networkChanged() {
         //判断apWifi名称与实际的是否一致: 国内全名称判断，海外判断是否包含deviceId
         let predicateWifiName = DHModuleConfig.shareInstance().isLeChange ? getApWifiName() : DHAddDeviceManager.sharedInstance.deviceId.uppercased()
         let wifiSSID = DHMobileInfo.sharedInstance().wifissid
         
         print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder))::Networkchanged...current:\(wifiSSID ?? "")")
         //【*】兼容处理：iOS13下可能存在ssid获取不到的情况
        if wifiSSID != nil, wifiSSID != getApWifiName() {
             if wifiSSID!.contains(predicateWifiName) {
                 LCProgressHUD.show(on: self.view)
             }
         }
         
         checkWifi()
	}
    
    @objc func appBecomeActive() {
        let predicateWifiName = DHModuleConfig.shareInstance().isLeChange ? getApWifiName() : DHAddDeviceManager.sharedInstance.deviceId.uppercased()
        let wifiSSID = DHMobileInfo.sharedInstance().wifissid
        
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
        
        let manager = DHAddDeviceManager.sharedInstance
        let softApWifiName = manager.getIntroductionParser()?.softApGuideInfo.wifiName ?? DHOMSSoftApGuideDefault.wifiname
        var predicateWifiName = softApWifiName
        var prefix = manager.deviceModel
        if let index = softApWifiName.lastIndex(of: "-") { //避免出现 Ring-V2-XXXX的情况
            prefix = String(softApWifiName.prefix(upTo: index))
        }
        
        if manager.getIntroductionParser()?.softApGuideInfo.wifiModelVersion?.lowercased() == "v1" {
            //国内：设备型号-deviceId后4位； 海外：设备型号-deviceId，
            if DHModuleConfig.shareInstance().isLeChange {
                predicateWifiName = prefix + "-" + manager.deviceId.suffix(4).uppercased()
            } else {
                predicateWifiName = prefix + "-" + manager.deviceId.uppercased()
            }
            return predicateWifiName
        } else if manager.getIntroductionParser()?.softApGuideInfo.wifiModelVersion?.lowercased() == "v2"{
            //国内：设备型号-deviceId后4位； 海外：设备型号-deviceId，
            predicateWifiName = prefix + "-" + manager.deviceId.uppercased()
            return predicateWifiName
        } else {
            return "DAP-" + manager.deviceId
        }
        
    }

	@objc private func checkWifi() {
        
        //3.13.3小版本需求
        let manager = DHAddDeviceManager.sharedInstance
        if let wifiModelVersion = manager.getIntroductionParser()?.softApGuideInfo.wifiModelVersion, wifiModelVersion.count != 0 {
            wifiNameLabel?.text = DHAddDeviceManager.sharedInstance.getIntroductionParser()?.softApGuideInfo.wifiName ?? DHOMSSoftApGuideDefault.wifiname
        } else {
            
            wifiNameLabel?.text = "DAP-XXXX"
        }
		
//		//非WIFI状态下，不处理
//		guard DHNetWorkHelper.sharedInstance().emNetworkStatus == .reachableViaWiFi else {
//			return
//		}
//		
//		//判断apWifi名称与实际的是否一致: 国内全名称判断，海外判断是否包含deviceId
//		let predicateWifiName = DHModuleConfig.shareInstance().isLeChange ? getApWifiName() : DHAddDeviceManager.sharedInstance.deviceId.uppercased()
//		let wifiSSID = DHMobileInfo.sharedInstance().wifissid
//        
//		// 可能会出现ssid为空的情况
//		guard wifiSSID != nil, wifiSSID!.uppercased().contains(predicateWifiName.uppercased()) else {
//			return
//		}
//		
		// 防止多次Push
		if isWifiChecked == true {
			return
		}
        
		self.isWifiChecked = true
		
		//DTS000450176，切换到后台，停止了局域网搜索，可能会导致搜索不到设备
		DHNetSDKSearchManager.sharedInstance()?.startSearch()
		
		//WIFI连接上后，搜索2s，判断初始化状态：
        LCProgressHUD.show(on: self.view)
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let device = DHAddDeviceManager.sharedInstance.getLocalDevice() {
                if true == DHAddDeviceManager.sharedInstance.isSupportSC {
                    self.pushScDeviceNextPage(deviceIsInited: device.deviceInitStatus == .init)
                } else {
                   
                    if device.deviceInitStatus == .unInit {
                        //【*】未初始初始化，跳转初始化搜索界面
                        self.basePushToInitializeSearchVC()
                    } else if device.deviceInitStatus == .noAbility, DHModuleConfig.shareInstance().isLeChange {
                        //【*】没有初始化能力集的，国内跳转局域网搜索（后面会赋值admin密码）；海外跳转登录
                        self.basePushToInitializeSearchVC()
                    } else {
                        //【*】已初始化的跳转登录
                        self.pushToApLoginVC()
                    }
                }
                LCProgressHUD.hideAllHuds(self.view)
            } else {
                if true == DHAddDeviceManager.sharedInstance.isSupportSC {
                    //没找到设备，继续轮询
                    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
                    timer.schedule(wallDeadline: .now(), repeating: 2.0)
                    var repeatCount = 15
                    timer.setEventHandler(handler: {
                        repeatCount -= 1
                        if repeatCount == 0 {
                            timer.cancel()
                            LCProgressHUD.hideAllHuds(self.view)
                            print("⚠️⚠️⚠️\(NSStringFromClass(self.classForCoder))...获取设备信息失败，")
                            return
                        }
                        if let device = DHAddDeviceManager.sharedInstance.getLocalDevice() {
                            //SC设备软AP配网
                            timer.cancel()
                            self.pushScDeviceNextPage(deviceIsInited: device.deviceInitStatus == .init)
                            LCProgressHUD.hideAllHuds(self.view)
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
    // MARK: sc设备软AP配网
    func autoConnectHotspot() {
        //sc设备自动连接热点
        guideView.descriptionLabel.text = "ip_device_connect_and_goto_next".lc_T
        guideView.topTipLabel.attributedText = nil
        guideView.topTipLabel.text = "add_device_wait_to_connect_wifi".lc_T
        guideView.detailButton.isHidden = true
        //SC设备软AP配网
        let predicateWifiName = DHModuleConfig.shareInstance().isLeChange ? getApWifiName() : DHAddDeviceManager.sharedInstance.deviceId.uppercased()
        LCProgressHUD.show(on: self.view)
        DHAddDeviceManager.sharedInstance.autoConnectHotSpot(wifiName: predicateWifiName, password: DHAddDeviceManager.sharedInstance.initialPassword, completion: { (success) in
            
            LCProgressHUD.hideAllHuds(self.view)
            if success {
                DHMobileInfo.sharedInstance().wifissid = predicateWifiName
                self.autoConnectHotSpotFailed = false
                self.checkWifi()
                print("连接sc设备热点成功")
            } else {
                print("⚠️⚠️⚠️\(NSStringFromClass(self.classForCoder))...连接热点失败")
                self.autoConnectHotSpotFailed = true
            }
            
            self.refreshTipText()
        })
    }
    
    func autoConnectWifiFailedChanged() {
        
        if true == autoConnectHotSpotFailed {
            _ = tipText()
            // 自动连接失败.
            if self.selectWifiButton == nil {
                self.selectWifiButton = UIButton(type: .system)
                guideView.addSubview(self.selectWifiButton!)
                self.selectWifiButton?.layer.borderWidth = 1
                self.selectWifiButton?.layer.borderColor = UIColor.dhcolor_c8().cgColor
                self.selectWifiButton?.setTitle("add_device_connect_goto_select_wifi".lc_T, for: .normal)
                self.selectWifiButton?.layer.cornerRadius = DHModuleConfig.shareInstance().commonButtonCornerRadius()
                self.selectWifiButton?.backgroundColor = UIColor.dhcolor_c43()
                self.selectWifiButton?.setTitleColor(UIColor.dhcolor_c2(), for: .normal)
                self.selectWifiButton?.snp.makeConstraints({ (make) in
                    make.bottom.right.equalTo(self.guideView).offset(-20)
                    make.left.equalTo(self.guideView).offset(20)
                    make.height.equalTo(40)
                })
                self.selectWifiButton?.addTarget(self, action: #selector(gotoSettingPage), for: .touchUpInside)
                
                guideView.detailButton.snp.remakeConstraints { (make) in
                    make.leading.equalTo(guideView).offset(15)
                    make.top.equalTo(guideView.descriptionLabel.snp.bottom).offset(5)
                    make.bottom.lessThanOrEqualTo(guideView).offset(-5)
                    make.centerX.equalTo(guideView)
                }
            }
            
            guideView.detailButton.snp.remakeConstraints { (make) in
                make.leading.equalTo(guideView).offset(13)
                make.top.equalTo(guideView.topTipLabel.snp.bottom).offset(5)
                make.bottom.lessThanOrEqualTo(guideView).offset(-5)
                make.centerX.equalTo(guideView)
            }
            
           
            

            //SC自动连接的失败页面   中间有关于热点密码
            if true == DHAddDeviceManager.sharedInstance.isSupportSC {
                self.guideView.detailButton.isHidden = false
                self.guideView.descriptionLabel.isHidden = true
            } else {
                //非SC自动连接页面  中间是连接后将自动下一步
                self.guideView.detailButton.isHidden = true
                self.guideView.descriptionLabel.isHidden = false
            }

            
        } else {
          
            
            

        }
    }
    
    // MARK: sc device connect hotspot
    
	private func pushToApLoginVC() {
		let controller = DHAuthPasswordViewController.storyboardInstance()
		controller.presenter = DHApAuthPasswordPresenter(container: controller)
		self.navigationController?.pushViewController(controller, animated: true)
	}
    
    private func pushScDeviceNextPage(deviceIsInited: Bool) {
        
        
        if deviceIsInited {
            //【*】已初始化的跳转登录
            LCProgressHUD.show(on: self.view)
            let helper = DHAuthPassworHelper()
            
            if let device = DHAddDeviceManager.sharedInstance.getLocalDevice() {
                helper.authByNetSDK(password: DHAddDeviceManager.sharedInstance.initialPassword, device: device, success: { loginHandle in
                    LCProgressHUD.hideAllHuds(self.view)
                    
                    let controller = DHApWifiSelectViewController.storyboardInstance()
                    controller.scDeviceIsInited = deviceIsInited
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                }) { (description) in
                    LCProgressHUD.hideAllHuds(self.view)
                
                let controller = DHAuthPasswordViewController.storyboardInstance()
                let presenter = DHApAuthPasswordPresenter(container: controller)
                presenter.scDeviceIsInited = true
                controller.presenter = presenter
                self.navigationController?.pushViewController(controller, animated: true)
                }
            }
            
        } else {
            let controller = DHApWifiSelectViewController.storyboardInstance()
            controller.scDeviceIsInited = deviceIsInited
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func pushToApWifiSelectVC() {
        let controller = DHApWifiSelectViewController.storyboardInstance()
        self.navigationController?.pushViewController(controller, animated: true)
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
        let scCode = DHAddDeviceManager.sharedInstance.initialPassword
        guideView.errorButton.isHidden = true;
        //IOS11之前不能自动连接WIFI 文案是固定的
        if true == DHAddDeviceManager.sharedInstance.isSupportSC {
            
            //有SC码情况下 扫码
            if scCode.count != 0 && DHAddDeviceManager.sharedInstance.isEnterByQrcode {
                let str = String(format: "add_device_connect_accode_ap_hotpot_and_back".lc_T, arguments: [predicateWifiName])
                guideView.setTopTipLabel(text: str, underlineString: scCode, shouldCopy: true) {
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = scCode
                    LCProgressHUD.showMsg("device_manager_copy_success".lc_T)
                }
            } else {
                //有SC码情况下 手动添加 或者 无SC码
                let str = String(format: "add_device_connect_accode_ap_hotpot_and_back".lc_T, arguments: [predicateWifiName])
                guideView.setTopTipLabel(text: str, underlineString: "安全验证码")
            }
            
        } else {
            let str = String(format: "add_device_connect_ap_hotpot_and_back".lc_T, arguments: [predicateWifiName])
            guideView.topTipLabel.dh_setAttributedText(text: str, font: UIFont.dhFont_t1())
            
            guideView.detailButton.isHidden = true
        }
        
        if self.selectWifiButton == nil {
            self.selectWifiButton = UIButton(type: .system)
            guideView.addSubview(self.selectWifiButton!)
            self.selectWifiButton?.layer.borderWidth = 1
            self.selectWifiButton?.layer.borderColor = UIColor.dhcolor_c8().cgColor
            self.selectWifiButton?.setTitle("add_device_connect_goto_select_wifi".lc_T, for: .normal)
            self.selectWifiButton?.layer.cornerRadius = DHModuleConfig.shareInstance().commonButtonCornerRadius()
            self.selectWifiButton?.backgroundColor = UIColor.dhcolor_c43()
            self.selectWifiButton?.setTitleColor(UIColor.dhcolor_c2(), for: .normal)
            self.selectWifiButton?.snp.makeConstraints({ (make) in
                make.bottom.right.equalTo(self.guideView).offset(-20)
                make.left.equalTo(self.guideView).offset(20)
                make.height.equalTo(40)
            })
            self.selectWifiButton?.addTarget(self, action: #selector(gotoSettingPage), for: .touchUpInside)
            
            guideView.detailButton.snp.remakeConstraints { (make) in
                make.leading.equalTo(guideView).offset(15)
                make.top.equalTo(guideView.descriptionLabel.snp.bottom).offset(5)
                make.bottom.lessThanOrEqualTo(guideView).offset(-5)
                make.centerX.equalTo(guideView)
            }
        }
    }
    
    func refreshTipText() {
        
        //IOS11
        if #available(iOS 11.0, *) { } else {
            
            tipbeforeIOS11()
            return
        }
        
        let predicateWifiName = self.getApWifiName()
        let scCode = DHAddDeviceManager.sharedInstance.initialPassword

        if DHAddDeviceManager.sharedInstance.isSupportSC == true {
            //自动连接失败
            if autoConnectHotSpotFailed == true {
                if scCode.count != 0 && DHAddDeviceManager.sharedInstance.isEnterByQrcode {//支持SC码的时候  扫码进入 二维码中有SC 展示真实的热点、有下划线、支持复制
                    let str = String(format: "add_device_wait_to_connect_wifi_failed_sc".lc_T, arguments: [predicateWifiName])
                    
                    //没有安全码的清空下  展示“安全验证码”、无下划线、不支持复制
                    //支持SC码的时候 手动输入的 展示“安全验证码”、无下划线、不支持复制
                    
                    guideView.setTopTipLabel(text: str, underlineString: scCode, shouldCopy: true) {
                        if DHAddDeviceManager.sharedInstance.isEnterByQrcode {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = scCode
                            LCProgressHUD.showMsg("device_manager_copy_success".lc_T)
                        }
                    }
                    guideView.errorButton.isHidden = false
                } else {
                    let str = String(format: "add_device_wait_to_connect_wifi_failed_sc".lc_T, arguments: [predicateWifiName])
                    guideView.setTopTipLabel(text: str, underlineString: "安全验证码")
                    
                }
               
            }
            
        } else if autoConnectHotSpotFailed == true {
            //IOS11以上不支持SC码的设备 自动连接失败的情况
            let str = String(format: "add_device_wait_to_connect_wifi_failed".lc_T, arguments: [predicateWifiName])
            
            
            guideView.errorButton.titleLabel?.font = UIFont.dhFont_t1()
            guideView.topTipLabel.dh_setAttributedText(text: str, font: UIFont.dhFont_t1())
            guideView.errorButton.isHidden = false
        }
        
    }
	
	// MARK: DHGuideBaseVCProtocol
	override func tipText() -> String? {
        
        
		return nil
	}
	
	override func tipImageName() -> String? {
		return "adddevice_netsetting_connectwifi"
	}
	
	override func descriptionText() -> String? {
		return "add_device_connect_and_goto_next".lc_T
	}
	
	override func isCheckHidden() -> Bool {
		return true
	}
	
    override func detailText() -> String? {
        
        if true == DHAddDeviceManager.sharedInstance.isSupportSC {
            return "add_device_about_wifi_pwd".lc_T
        } else {
            return "add_device_goto_connect_wifi".lc_T
        }
        
    }
    
	override func isDetailHidden() -> Bool {
        return false
	}
	
	override func isNextStepHidden() -> Bool {
		return true
	}
    
	// MARK: DHAddBaseVCProtocol

	override func needUpdateCurrentOMSIntroduction() {
		setupWifiName()
	}
    
    override func doDetail() {
        print("DHApWifiCheckViewController doDetail")
        if true == DHAddDeviceManager.sharedInstance.isSupportSC {
            let vc = DHHotSpotViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.gotoSettingPage()
        }
    }
    
    override func doError() {
        let vc = LCDeviceAddErrorController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


