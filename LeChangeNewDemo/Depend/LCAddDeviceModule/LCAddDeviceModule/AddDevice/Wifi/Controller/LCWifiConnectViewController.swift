//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//    WIFI配置：设备连接WIFI

import UIKit
import MediaPlayer
import LCOpenSDKDynamic

class LCWifiConnectViewController: LCAddBaseViewController, LCCycleTimerViewDelegate, LCWifiConnectFailureVCProtocol {
    
    public static func storyboardInstance() -> LCWifiConnectViewController {
        let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
        guard let controller = storyboard.instantiateViewController(withIdentifier: "LCWifiConnectViewController") as? LCWifiConnectViewController else {
            return LCWifiConnectViewController()
        }
        return controller
    }
    
    var showPlayAudio: Bool = true
    let config: LCOpenSDK_ConfigWIfi = LCOpenSDK_ConfigWIfi()
    var searchedDvice: LCOpenSDK_SearchDeviceInfo?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cycleTimerView: LCCycleTimerView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var tryAgainBtn: UIButton!
    @IBOutlet weak var startOverBtn: UIButton!
    
//    private var audioPlayer: AVAudioPlayer?
    private var isDeviceFound: Bool = false
    private var failureVc: LCWifiConnectFailureViewController?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startOverBtn.layer.borderWidth = 1.0
        startOverBtn.layer.borderColor = UIColor.init(red: 0xf1/255.0, green: 0xd0/255.0, blue: 0x00/255.0, alpha: 1.0).cgColor
        setupCustumContents()
        configCycleTimerView()
        registerNotification()
        startSmartConfig()
        self.contentLabel.text = "add_device_connect_router_please_wait".lc_T()
        self.detailLabel.text = "add_device_connect_router_please_alert".lc_T()
        self.tryAgainBtn.setTitle("add_device_try_again".lc_T(), for: .normal)
        self.startOverBtn.setTitle("add_device_re_add".lc_T(), for: .normal)
        
        if let image = self.imageView.image {
            let height = (self.imageView.frame.size.width / image.size.width) * image.size.height
            self.imageView.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(25)
                make.trailing.equalToSuperview().offset(-25)
                make.top.equalToSuperview()
                make.width.equalTo(self.imageView.frame.size.width)
                make.height.equalTo(height)
            }
        }
    }
    
    override func leftActionType() -> LCAddBaseLeftAction {
        return .quit
    }
    
    override func isLeftActionShowAlert() -> Bool {
        return true
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
//#if DEBUG
//        self.createDebugView()
//#endif
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
        }
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleInterruption(_:)), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
    }
    
    // MARK: - handleInterruption
    @objc func handleInterruption(_ notification: Notification) {
        guard let interruptionType = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt else {
            return
        }
//        if interruptionType == AVAudioSessionInterruptionType.began.rawValue {
            // started
//            self.audioPlayer?.pause()
//        } else if interruptionType == AVAudioSessionInterruptionType.ended.rawValue {
//            self.audioPlayer?.play()
//        }
    }
    
    // MARK: - SmartConfig
    private func startSmartConfig() {
        if cycleTimerView.currentTime > 0, cycleTimerView.currentTime < cycleTimerView.maxTime {
            cycleTimerView.resumeTimer()
        } else {
            cycleTimerView.startTimer()
        }
		smartConfig(openAudio: showPlayAudio)
    }
	
    private func stopSmartConfig() {
        self.config.configWifiStop()
        cycleTimerView.stopTimer()
    }
    
    // MARK: - Audio
	private func smartConfig(openAudio: Bool) {
		let manager = LCAddDeviceManager.sharedInstance
        let fskMode: LCFSKMode = manager.supportConfigModes.contains(.soundWaveV2) ? .new : .old
        let wavePath = self.config.configWifiStart(manager.deviceId, ssid: manager.wifiSSID ?? "", password: manager.wifiPassword, secure: "", voiceFreq: 11000, txMode: Int(fskMode.rawValue))
        LCOpenSDK_SearchDevices.share().start(withDeviceId: manager.deviceId, timeOut: 60*2) {[weak self] deviceInfo in
            self?.searchedDvice = deviceInfo
            LCOpenSDK_SearchDevices.share().stop()
        }
    }
    
    // MARK: - Find Device Process
	private func findDevice() {
        print(" \(NSStringFromClass(self.classForCoder))::Device found...")
		isDeviceFound = true
        stopSmartConfig()
		LCAddDeviceManager.sharedInstance.stopGetDeviceStatus()
		//【*】在线或者支持sc码的，配网后，直接跳转连接云平台即可
		//【*】其他需要跳转旧的初始化流程
		if LCAddDeviceManager.sharedInstance.isSupportSC {
			basePushToConnectCloudVC()
		} else {
			basePushToInitializeSearchVC()
		}
    }
    
    override func isRightActionHidden() -> Bool {
        return false
    }
    
    override func rightActionType() -> [LCAddBaseRightAction] {
        if failureVc != nil {
            var actions: [LCAddBaseRightAction] = [.restart]
            if LCAddDeviceManager.sharedInstance.supportWired() &&
                LCAddDeviceManager.sharedInstance.supportWifi() {
                if LCAddDeviceManager.sharedInstance.netConfigMode == .soundWave || LCAddDeviceManager.sharedInstance.netConfigMode == .soundWaveV2 || LCAddDeviceManager.sharedInstance.netConfigMode == .smartConfig {
                    actions.append(.switchToWired)
                } else if LCAddDeviceManager.sharedInstance.netConfigMode == .lan {
                    actions.append(.switchToWireless)
                }
            }
            return actions
        } else {
            return [.restart]
        }
    }
    
    @IBAction func tryAgain(_ sender: Any) {
        self.cycleTimerView.currentTime = 0
        self.contentLabel.text = "add_device_connect_router_please_wait".lc_T()
        self.detailLabel.text = "add_device_connect_router_please_alert".lc_T()
        self.tryAgainBtn.isHidden = true
        self.startOverBtn.isHidden = true
        self.cycleTimerView.isHidden = false
        self.imageView.image = UIImage(lc_named: "adddevice_netsetting_guide_luyou")
        cycleTimerView.stopTimer()
        cycleTimerView.startTimer()
        smartConfig(openAudio: showPlayAudio)
    }
    
    @IBAction func startOver(_ sender: Any) {
        self.baseBackToAddDeviceRoot()
    }
    
    private func wifiConnectFailure() {
        self.tryAgainBtn.isHidden = false
        self.startOverBtn.isHidden = false
        self.contentLabel.text = "add_device_connect_router_failed".lc_T()
        self.detailLabel.text = ""
        self.imageView.image = UIImage(lc_named: "adddevice_netsetting_guide_wifi_failure")
        self.cycleTimerView.isHidden = true
    }
}

extension LCWifiConnectViewController {
    
    // MARK: - LCCycleTimerViewDelegate
    func cycleTimerView(cycleView: LCCycleTimerView, tick: Int) {
		guard isDeviceFound == false else {
			return
		}
		
		//【*】判断局域网是否搜索到
        if self.searchedDvice != nil {
            findDevice()
        }
		
		//【*】每隔5秒进行一次轮循设备在线状态,支持sc码的才查询
		guard tick % 5 == 0, LCAddDeviceManager.sharedInstance.isSupportSC else {
			return
		}
		
		LCAddDeviceManager.sharedInstance.getDeviceStatus(success: { (bindInfo) in
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
        self.wifiConnectFailure()
    }
}

// MARK: - LCWifiConnectFailureVCProtocol
extension LCWifiConnectViewController {
    func reconnectWifiAction(controller: LCWifiConnectFailureViewController) {
        self.startSmartConfig()
		smartConfig(openAudio: showPlayAudio)
    }
}

// MARK: - Debug
//extension LCWifiConnectViewController {
//    private func createDebugView() {
//        let debug_Success: UIButton = {
//            let btn: UIButton = UIButton(frame: CGRect(x: 0, y: 20, width: 50, height: 40))
//            btn.backgroundColor = UIColor.white
//            btn.titleLabel?.font = UIFont.lcFont_t3()
//            btn.setTitle("路由器成功".lc_T(), for: .normal)
//            btn.setTitleColor(UIColor.lccolor_c0(), for: .normal)
//            btn.addTarget(self, action: #selector(debugSuccess), for: .touchUpInside)
//            return btn
//        }()
//
//        let debug_Failure: UIButton = {
//            let btn: UIButton = UIButton(frame: CGRect(x: 0, y: 20, width: 50, height: 40))
//            btn.backgroundColor = UIColor.white
//            btn.titleLabel?.font = UIFont.lcFont_t3()
//            btn.setTitle("路由器失败".lc_T(), for: .normal)
//            btn.setTitleColor(UIColor.lccolor_c0(), for: .normal)
//            btn.addTarget(self, action: #selector(debugFailure), for: .touchUpInside)
//            return btn
//        }()
//
//        let debug_initialize: UIButton = {
//            let btn: UIButton = UIButton(frame: CGRect(x: 0, y: 20, width: 50, height: 40))
//            btn.backgroundColor = UIColor.white
//            btn.titleLabel?.font = UIFont.lcFont_t3()
//            btn.setTitle("初始化".lc_T(), for: .normal)
//            btn.setTitleColor(UIColor.lccolor_c0(), for: .normal)
//            btn.addTarget(self, action: #selector(debugInitialize), for: .touchUpInside)
//            return btn
//        }()
//
//
//        self.view.addSubview(debug_Success)
//        self.view.addSubview(debug_Failure)
//        self.view.addSubview(debug_initialize)
//
//        debug_Failure.snp.makeConstraints({ (make) in
//            make.centerX.equalTo(self.view)
//            make.bottom.equalTo(self.view).offset(-LC_bottomSafeMargin)
//        })
//
//        debug_Success.snp.makeConstraints({ (make) in
//            make.centerX.equalTo(self.view)
//            make.bottom.equalTo(debug_Failure.snp.top).offset(-10)
//        })
//
//        debug_initialize.snp.makeConstraints({ (make) in
//            make.centerX.equalTo(self.view)
//            make.bottom.equalTo(debug_Success.snp.top).offset(-10)
//        })
//    }
//
//    @objc private func debugSuccess() {
//        basePushToConnectCloudVC()
//    }
//
//    @objc private func debugFailure() {
//        self.wifiConnectFailure()
//    }
//
//    @objc private func debugInitialize() {
//        basePushToInitializeSearchVC()
//    }
//}
