//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//    WIFI配置：设备连接WIFI

import UIKit
import MediaPlayer

class LCWifiConnectViewController: LCAddBaseViewController, LCCycleTimerViewDelegate, LCWifiConnectFailureVCProtocol {
    
    public static func storyboardInstance() -> LCWifiConnectViewController {
        let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
        guard let controller = storyboard.instantiateViewController(withIdentifier: "LCWifiConnectViewController") as? LCWifiConnectViewController else {
            return LCWifiConnectViewController()
        }
        return controller
    }
    
    var showPlayAudio: Bool = true
    var descriptionContent: String = "add_device_adjust_phone_volume_to_hear_bugu".lc_T
    let tipContent: String = "add_device_listen_wifi_pwd_error_tip".lc_T
    
    lazy var wifiPassWordBtn: UIButton = {
        let btn: UIButton = UIButton(frame: CGRect(x: 0, y: 20, width: 50, height: 22))
        btn.backgroundColor = UIColor.clear
        btn.titleLabel?.font = UIFont.lcFont_t3()
        if lc_screenHeight < 667 {
            btn.titleLabel?.font = UIFont.lcFont_t5()
        }
        
        btn.setTitle(tipContent, for: .normal)
        btn.setTitleColor(UIColor.lccolor_c0(), for: .normal)
        btn.addTarget(self, action: #selector(jumpWifiPassword), for: .touchUpInside)
        return btn
    }()
    
    @IBOutlet weak var wifiStrengthView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cycleTimerView: LCCycleTimerView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    private var audioPlayer: AVAudioPlayer?
    private var isDeviceFound: Bool = false
    private var failureVc: LCWifiConnectFailureViewController?
    
    /// 开启音频前手机的音量
    private var defaultVolume: Float = 0.5
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lccolor_c43()
        
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
        contentLabel.textColor = UIColor.lccolor_c2()
        detailLabel.textColor = UIColor.lccolor_c5()
        let content = "add_device_connect_router_please_wait".lc_T
        contentLabel.lc_setAttributedText(text: content, font: UIFont.lcFont_t1())
        
        let detail = descriptionContent
        detailLabel.lc_setAttributedText(text: detail, font: UIFont.lcFont_t3())
        
        if lc_screenHeight < 667 {
            contentLabel.lc_setAttributedText(text: content, font: UIFont.lcFont_t2())
            detailLabel.lc_setAttributedText(text: detail, font: UIFont.lcFont_t5())
        }
        
        ///国内乐橙配对路由器等待页面下方增加提示语，并能跳转到输入WIFI密码页面
        if LCModuleConfig.shareInstance().isChinaMainland {
            self.view.addSubview(wifiPassWordBtn)
            wifiPassWordBtn.snp.makeConstraints({ (make) in
                make.centerX.equalTo(self.view)
                make.bottom.equalTo(self.view).offset(-LC_bottomSafeMargin)
            })
        }
    }
    
    @objc private func jumpWifiPassword() {
        for controller in baseStackControllers() {
            LCUserManager.shareInstance().removeSSID(LCAddDeviceManager.sharedInstance.wifiSSID)
            if controller is LCWifiPasswordViewController {
                self.navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    private func configCycleTimerView() {
        cycleTimerView.maxTime = LCAddConfigTimeout.wifiConnect
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
            self.audioPlayer?.pause()
        } else if interruptionType == AVAudioSessionInterruptionType.ended.rawValue {
            self.audioPlayer?.play()
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
		let manager = LCAddDeviceManager.sharedInstance
		let fskMode: LCFSKMode = manager.ncType == .soundWaveV2 ? .new : .old
        let wavePath = LCSmartConfig.shareInstance().start(withDevice: manager.deviceId,
                                                ssid: manager.wifiSSID,
                                            password: manager.wifiPassword,
                                            security: "",
                                            fskMode: fskMode)
		//不需要开启音频，直接return
		if openAudio == false {
			return
		}

        if self.audioPlayer == nil {
            if let path = wavePath, path.count > 0 {
                let fileUrl = URL(fileURLWithPath: path)
                self.audioPlayer = try? AVAudioPlayer(contentsOf: fileUrl)
                self.audioPlayer?.numberOfLoops = -1
                self.audioPlayer?.prepareToPlay()
            }
        }

        self.audioPlayer?.play()
    }
    
    private func stopAudio() {
        self.audioPlayer?.stop()
        self.audioPlayer = nil
    }
    
    
    // MARK: - Find Device Process
	private func findDevice() {
        print(" \(NSStringFromClass(self.classForCoder))::Device found...")
		isDeviceFound = true
        stopSmartConfig()
        stopAudio()
        uploadWifiPairInfo()
		LCAddDeviceManager.sharedInstance.stopGetDeviceStatus()
		
		//【*】在线或者支持sc码的，配网后，直接跳转连接云平台即可
		//【*】其他需要跳转旧的初始化流程
		if LCAddDeviceManager.sharedInstance.isSupportSC {
			basePushToConnectCloudVC()
		} else {
			basePushToInitializeSearchVC()
		}
    }
    
    //上报WIFI配对信息
    private func uploadWifiPairInfo() {
		
		/* SMB 不上报 */
    }
    
    // MARK: - LCAddBaseVCProtocol
    override func leftActionType() -> LCAddBaseLeftAction {
        return .quit
    }
    
    override func isLeftActionShowAlert() -> Bool {
        return true
    }
    
    override func isRightActionHidden() -> Bool {
        return false
    }
    
    override func rightActionType() -> [LCAddBaseRightAction] {
        if failureVc != nil {
            var actions: [LCAddBaseRightAction] = [.restart]
            if LCAddDeviceManager.sharedInstance.supportConfigModes.contains(.wired) &&
                LCAddDeviceManager.sharedInstance.supportConfigModes.contains(.wifi) {
                if LCAddDeviceManager.sharedInstance.netConfigMode == .wifi {
                    actions.append(.switchToWired)
                } else if LCAddDeviceManager.sharedInstance.netConfigMode == .wired {
                    actions.append(.switchToWireless)
                }
            }
            
            return actions
        } else {
            return [.restart]
        }
    }
}

extension LCWifiConnectViewController {
    
    // MARK: - LCCycleTimerViewDelegate
    func cycleTimerView(cycleView: LCCycleTimerView, tick: Int) {
        let deviceId = LCAddDeviceManager.sharedInstance.deviceId
        let device = LCNetSDKSearchManager.sharedInstance().getNetInfo(byID: deviceId)
		guard isDeviceFound == false else {
			return
		}
		
		//【*】判断局域网是否搜索到
        if device != nil, deviceId == LCAddDeviceManager.sharedInstance.deviceId {
            findDevice()
        }
		
		//【*】每隔5秒进行一次轮循设备在线状态,支持sc码的才查询
		guard tick % 5 == 0, LCAddDeviceManager.sharedInstance.isSupportSC else {
			return
		}
		
		LCAddDeviceManager.sharedInstance.getDeviceStatus(success: { (bindInfo) in
			
			print(" \(NSStringFromClass(self.classForCoder)):: Time:\(cycleView.currentTime), deviceType:\(bindInfo.lc_accessType().rawValue), existed:\(bindInfo.lc_isExisted()), onlineStatus:\(bindInfo.lc_isOnline())")
			
			//【*】保证设备已注册成功
			guard bindInfo.lc_isExisted() else {
				return
			}
			
			//【*】防止页面已跳转，接口仍在处理
			guard self.isDeviceFound == false else {
				return
			}
			
			if bindInfo.lc_isOnline() {
				print(" \(NSStringFromClass(self.classForCoder)):: DMS is online, start to connect cloud...")
				self.findDevice()
			}
			
		}) { (error) in
			
		}
    }
    
    func cycleTimerViewTimeout(cycleView: LCCycleTimerView) {
        if failureVc == nil {
            failureVc = LCWifiConnectFailureViewController()
            failureVc?.delegate = self
        }
		
		//【*】默认使用旧的错误类型
		//【*】SoftAp流程，如果配置了，使用新的
		let parser = LCAddDeviceManager.sharedInstance.getIntroductionParser()
		var type: LCNetConnectFailureType? = parser?.errorType
		if LCAddDeviceManager.sharedInstance.netConfigMode == .softAp, let softApErrorType = parser?.softApErrorType {
			type = softApErrorType
		}
		
		if type != nil, type != .ipcGeneral {
            failureVc?.failureType = type!
        } else {
            failureVc?.failureType = LCAddDeviceManager.sharedInstance.supportConfigModes.contains(.wired) ? .commonWithWired : .commonWithoutWired
        }
        
        //【！测试】
        if LCAddDeviceTest.openTest {
            failureVc?.failureType = testFailureType()
        }
        
        self.failureVc?.showOnParent(controller: self)
		
    }
}

// MARK: - LCWifiConnectFailureVCProtocol
extension LCWifiConnectViewController {
    func reconnectWifiAction(controller: LCWifiConnectFailureViewController) {
        self.startSmartConfig()
		smartConfig(openAudio: showPlayAudio)
		
    }
}


// MARK: - Test
extension LCWifiConnectViewController {
    
    private func testFailureType() -> LCNetConnectFailureType {
        var type: LCNetConnectFailureType = .commonWithoutWired
        let allTypes: [LCNetConnectFailureType] = [.tp1, .tp1s, .g1, .door, .overseasA, .overseasC,
                                                   .overseasDoorbell, .commonWithWired, .commonWithoutWired,
                                                   .accessory, .cloudTimeout]
        LCAddDeviceTest.failureIndex = (LCAddDeviceTest.failureIndex % (allTypes.count - 1)) + 1
        type = allTypes[LCAddDeviceTest.failureIndex ]
        
        return type
    }
}
