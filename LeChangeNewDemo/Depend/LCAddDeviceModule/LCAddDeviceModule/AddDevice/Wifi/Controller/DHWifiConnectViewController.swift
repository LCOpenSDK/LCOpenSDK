//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//    WIFI配置：设备连接WIFI

import UIKit
import MediaPlayer

class DHWifiConnectViewController: DHAddBaseViewController, DHCycleTimerViewDelegate, DHWifiConnectFailureVCProtocol {
    
    public static func storyboardInstance() -> DHWifiConnectViewController {
        let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.dh_addDeviceBundle())
        guard let controller = storyboard.instantiateViewController(withIdentifier: "DHWifiConnectViewController") as? DHWifiConnectViewController else {
            return DHWifiConnectViewController()
        }
        return controller
    }
    
    var showPlayAudio: Bool = true
    var descriptionContent: String = "add_device_adjust_phone_volume_to_hear_bugu".lc_T
    let tipContent: String = "add_device_listen_wifi_pwd_error_tip".lc_T
    
    lazy var wifiPassWordBtn: UIButton = {
        let btn: UIButton = UIButton(frame: CGRect(x: 0, y: 20, width: 50, height: 22))
        btn.backgroundColor = UIColor.clear
        btn.titleLabel?.font = UIFont.dhFont_t3()
        if dh_screenHeight < 667 {
            btn.titleLabel?.font = UIFont.dhFont_t5()
        }
        
        btn.setTitle(tipContent, for: .normal)
        btn.setTitleColor(UIColor.dhcolor_c0(), for: .normal)
        btn.addTarget(self, action: #selector(jumpWifiPassword), for: .touchUpInside)
        return btn
    }()
    
    @IBOutlet weak var wifiStrengthView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cycleTimerView: DHCycleTimerView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    private var audioPlayer: AVAudioPlayer?
    private var isDeviceFound: Bool = false
    private var failureVc: DHWifiConnectFailureViewController?
    
    /// 开启音频前手机的音量
    private var defaultVolume: Float = 0.5
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dhcolor_c43()
        
        // Do any additional setup after loading the view.
		imageView.image = UIImage(named: "adddevice_netsetting_connectrouter")
        setupCustumContents()
        configCycleTimerView()
        configWifiStrengthView()
        registerNotification()
        startSmartConfig()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
		
		//恢复默认的音频类型
		try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        stopSmartConfig()
        stopAudio()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		
		//设置音频类型
		try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
	
        if cycleTimerView.currentTime > 0, cycleTimerView.currentTime < cycleTimerView.maxTime {
            self.startSmartConfig()
        }
    }
    
    private func setupCustumContents() {
        contentLabel.textColor = UIColor.dhcolor_c2()
        detailLabel.textColor = UIColor.dhcolor_c5()
        let content = "add_device_connect_router_please_wait".lc_T
        contentLabel.dh_setAttributedText(text: content, font: UIFont.dhFont_t1())
        
        let detail = descriptionContent
        detailLabel.dh_setAttributedText(text: detail, font: UIFont.dhFont_t3())
        
        if dh_screenHeight < 667 {
            contentLabel.dh_setAttributedText(text: content, font: UIFont.dhFont_t2())
            detailLabel.dh_setAttributedText(text: detail, font: UIFont.dhFont_t5())
        }
        
        ///国内乐橙配对路由器等待页面下方增加提示语，并能跳转到输入WIFI密码页面
        if DHModuleConfig.shareInstance().isLeChange {
            self.view.addSubview(wifiPassWordBtn)
            wifiPassWordBtn.snp.makeConstraints({ (make) in
                make.centerX.equalTo(self.view)
                make.bottom.equalTo(self.view).offset(-dh_bottomSafeMargin)
            })
        }
    }
    
    @objc private func jumpWifiPassword() {
        for controller in baseStackControllers() {
            DHUserManager.shareInstance().removeSSID(DHAddDeviceManager.sharedInstance.wifiSSID)
            if controller is DHWifiPasswordViewController {
                self.navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    private func configCycleTimerView() {
        cycleTimerView.maxTime = DHAddConfigTimeout.wifiConnect
        cycleTimerView.delegate = self
        weak var weakSelf = self
        cycleTimerView.timeout = {
            weakSelf?.stopSmartConfig()
            weakSelf?.stopAudio()
        }
    }
    
    private func configWifiStrengthView() {
        let imageNames = ["adddevice_netsetting_connectrouter_1",
                          "adddevice_netsetting_connectrouter_2",
                          "adddevice_netsetting_connectrouter_3",
                          "adddevice_netsetting_connectrouter_4"]
        
        var images = [UIImage]()
        for name in imageNames {
            if let image = UIImage(named: name) {
                images.append(image)
            }
        }
        
        wifiStrengthView.animationImages = images
        wifiStrengthView.animationDuration = 1.5
        wifiStrengthView.animationRepeatCount = 0
    }
    
    private func registerNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleInterruption(_:)), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        
    }
    
    // MARK: - handleInterruption
    
    @objc func handleInterruption(_ notification: Notification) {
        guard let interruptionType = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt else {
            return
        }
        if interruptionType == AVAudioSessionInterruptionType.began.rawValue {
            // started
            //self.audioPlayer?.pause()
        } else if interruptionType == AVAudioSessionInterruptionType.ended.rawValue {
            //self.audioPlayer?.play()
        }
        
    }
    
    // MARK: - SmartConfig
    private func startSmartConfig() {
        
        if cycleTimerView.currentTime > 0, cycleTimerView.currentTime < cycleTimerView.maxTime {
            cycleTimerView.resumeTimer()
        } else {
            cycleTimerView.startTimer()
        }
        
        wifiStrengthView.startAnimating()
		smartConfig(openAudio: showPlayAudio)
    }
	
    private func stopSmartConfig() {
        LCSmartConfig.shareInstance().stop()
        cycleTimerView.stopTimer()
        wifiStrengthView.stopAnimating()
    }
    
    // MARK: - Audio
	private func smartConfig(openAudio: Bool) {
		let manager = DHAddDeviceManager.sharedInstance
		let fskMode: DHFSKMode = manager.ncType == .soundWaveV2 ? .new : .old
        LCSmartConfig.shareInstance().start(withDevice: manager.deviceId,
                                                ssid: manager.wifiSSID,
                                            password: manager.wifiPassword,
                                            security: "",
                                            fskMode: fskMode)
		//不需要开启音频，直接return
//		if openAudio == false {
//			return
//		}
//
//        if self.audioPlayer == nil {
//            if let path = wavePath, path.count > 0 {
//                let fileUrl = URL(fileURLWithPath: path)
//                self.audioPlayer = try? AVAudioPlayer(contentsOf: fileUrl)
//                self.audioPlayer?.numberOfLoops = -1
//                self.audioPlayer?.prepareToPlay()
//            }
//        }
//
//        self.audioPlayer?.play()
    }
    
    private func stopAudio() {
//        self.audioPlayer?.stop()
//        self.audioPlayer = nil
    }
    
    
    // MARK: - Find Device Process
	private func findDevice() {
        print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder))::Device found...")
		isDeviceFound = true
        stopSmartConfig()
        stopAudio()
        uploadWifiPairInfo()
		DHAddDeviceManager.sharedInstance.stopGetDeviceStatus()
		
		//【*】在线或者支持sc码的，配网后，直接跳转连接云平台即可
		//【*】其他需要跳转旧的初始化流程
		if DHAddDeviceManager.sharedInstance.isSupportSC {
			basePushToConnectCloudVC()
		} else {
			basePushToInitializeSearchVC()
		}
    }
    
    //上报WIFI配对信息
    private func uploadWifiPairInfo() {
		
		/* SMB 不上报 */
    }
    
    // MARK: - DHAddBaseVCProtocol
    override func leftActionType() -> DHAddBaseLeftAction {
        return .quit
    }
    
    override func isLeftActionShowAlert() -> Bool {
        return true
    }
    
    override func isRightActionHidden() -> Bool {
        return false
    }
    
    override func rightActionType() -> [DHAddBaseRightAction] {
        if failureVc != nil {
            var actions: [DHAddBaseRightAction] = [.restart]
            if DHAddDeviceManager.sharedInstance.supportConfigModes.contains(.wired) &&
                DHAddDeviceManager.sharedInstance.supportConfigModes.contains(.wifi) {
                if DHAddDeviceManager.sharedInstance.netConfigMode == .wifi {
                    actions.append(.switchToWired)
                } else if DHAddDeviceManager.sharedInstance.netConfigMode == .wired {
                    actions.append(.switchToWireless)
                }
            }
            
            return actions
        } else {
            return [.restart]
        }
    }
}

extension DHWifiConnectViewController {
    
    // MARK: - DHCycleTimerViewDelegate
    func cycleTimerView(cycleView: DHCycleTimerView, tick: Int) {
        let deviceId = DHAddDeviceManager.sharedInstance.deviceId
        let device = DHNetSDKSearchManager.sharedInstance().getNetInfo(byID: deviceId)
		guard isDeviceFound == false else {
			return
		}
		
		//【*】判断局域网是否搜索到
        if device != nil, deviceId == DHAddDeviceManager.sharedInstance.deviceId {
            findDevice()
        }
		
		//【*】每隔5秒进行一次轮循设备在线状态,支持sc码的才查询
		guard tick % 5 == 0, DHAddDeviceManager.sharedInstance.isSupportSC else {
			return
		}
		
		DHAddDeviceManager.sharedInstance.getDeviceStatus(success: { (bindInfo) in
			
			print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder)):: Time:\(cycleView.currentTime), deviceType:\(bindInfo.dh_accessType().rawValue), existed:\(bindInfo.dh_isExisted()), onlineStatus:\(bindInfo.dh_isOnline())")
			
			//【*】保证设备已注册成功
			guard bindInfo.dh_isExisted() else {
				return
			}
			
			//【*】防止页面已跳转，接口仍在处理
			guard self.isDeviceFound == false else {
				return
			}
			
			if bindInfo.dh_isOnline() {
				print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder)):: DMS is online, start to connect cloud...")
				self.findDevice()
			}
			
		}) { (error) in
			
		}
    }
    
    func cycleTimerViewTimeout(cycleView: DHCycleTimerView) {
        if failureVc == nil {
            failureVc = DHWifiConnectFailureViewController()
            failureVc?.delegate = self
        }
		
		//【*】默认使用旧的错误类型
		//【*】SoftAp流程，如果配置了，使用新的
		let parser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
		var type: DHNetConnectFailureType? = parser?.errorType
		if DHAddDeviceManager.sharedInstance.netConfigMode == .softAp, let softApErrorType = parser?.softApErrorType {
			type = softApErrorType
		}
		
		if type != nil, type != .ipcGeneral {
            failureVc?.failureType = type!
        } else {
            failureVc?.failureType = DHAddDeviceManager.sharedInstance.supportConfigModes.contains(.wired) ? .commonWithWired : .commonWithoutWired
        }
        
        //【！测试】
        if DHAddDeviceTest.openTest {
            failureVc?.failureType = testFailureType()
        }
        
        self.failureVc?.showOnParent(controller: self)
		
    }
}

// MARK: - DHWifiConnectFailureVCProtocol
extension DHWifiConnectViewController {
    func reconnectWifiAction(controller: DHWifiConnectFailureViewController) {
        self.startSmartConfig()
		smartConfig(openAudio: showPlayAudio)
		
    }
}


// MARK: - Test
extension DHWifiConnectViewController {
    
    private func testFailureType() -> DHNetConnectFailureType {
        var type: DHNetConnectFailureType = .commonWithoutWired
        let allTypes: [DHNetConnectFailureType] = [.tp1, .tp1s, .g1, .door, .overseasA, .overseasC,
                                                   .overseasDoorbell, .commonWithWired, .commonWithoutWired,
                                                   .accessory, .cloudTimeout]
        DHAddDeviceTest.failureIndex = (DHAddDeviceTest.failureIndex % (allTypes.count - 1)) + 1
        type = allTypes[DHAddDeviceTest.failureIndex ]
        
        return type
    }
}
