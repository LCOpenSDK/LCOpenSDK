//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	连接乐橙云平台：检测到设备在经后
// 【1】国内如果没有RD、Auth能力集，直接绑定；如果有，需要跳转输入界面，优先Auth
// 【2】海外需要进入密码检验界面

import UIKit

class LCConnectCloudViewController: LCAddBaseViewController, LCCycleTimerViewDelegate {

	public static func storyboardInstance() -> LCConnectCloudViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "LCConnectCloudViewController") as? LCConnectCloudViewController {
            return controller
        }
		return LCConnectCloudViewController()
	}
	
	/// 设备密码，上级初始化流程传入
	public var deviceInitialPassword: String?
	
	@IBOutlet weak var cycleTimerView: LCCycleTimerView!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var cloudImageView: UIImageView!

    /// 超时的页面
	private lazy var timeoutVc: LCConnectCloudTimeoutViewController = {
		let controller = LCConnectCloudTimeoutViewController()
		controller.delegate = self
		return controller
	}()
	
	/// 绑定解释器
	private lazy var bindPresenter: LCBindPresenter = {
		let presenter = LCBindPresenter()
		presenter.setup(container: self)
		return presenter
	}()
	
	/// 查询到设备在线进行处理中
	private var isHandlingOnline: Bool = false
	
	/// 是否在绑定操作中
	private var isInBinding: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
        view.backgroundColor = UIColor.lccolor_c43()
        self.title = ""
        self.contentLabel.text = "add_device_connect_cloud_please_wait".lc_T()
		configCycleTimerView()

		//开始倒计时
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			self.startConnecting()
		}
        
        if let image = self.cloudImageView.image {
            let height = (self.cloudImageView.frame.size.width / image.size.width) * image.size.height
            self.cloudImageView.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(25)
                make.trailing.equalToSuperview().offset(-25)
                make.top.equalToSuperview()
                make.width.equalTo(self.cloudImageView.frame.size.width)
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
		stopConnecting()
	}
	
	private func configCycleTimerView() {
        cycleTimerView.maxTime = 120
		cycleTimerView.delegate = self
	}
	
	// MARK: Timer
	private func startConnecting() {
		cycleTimerView.startTimer()
	}
	
	private func stopConnecting() {
		cycleTimerView.stopTimer()
	}
}

// MARK: CycleTimerViewDelegate
extension LCConnectCloudViewController {
	func cycleTimerViewTimeout(cycleView: LCCycleTimerView) {

        handleTimeout()
	}
	
	func cycleTimerView(cycleView: LCCycleTimerView, tick: Int) {
		// 【*】每隔3秒进行一次轮循
		guard tick % 3 == 0 else {
			return
		}
		
		print(" \(NSStringFromClass(self.classForCoder))::Tick...\(tick / 3 )")
		
		//【*】在线绑定、或者查询在线状态
		guard self.isHandlingOnline == false else {
			return
		}
		
        if LCAddDeviceManager.sharedInstance.isEntryFromWifiConfig {
            let info = LCDeviceInfo()
            info.deviceId = LCAddDeviceManager.sharedInstance.deviceId
            info.productId = LCAddDeviceManager.sharedInstance.productId ?? ""
            let deviceArr = NSArray.init(array: [info])
            LCDeviceManagerInterface.listDeviceDetailBatch(deviceArr as! [LCDeviceInfo], success: {[weak self] (deviceInfoArr) in
                let deviceInfo = deviceInfoArr[0] as? LCDeviceInfo
                if deviceInfo?.status == "online" {
                    self?.handleOnline()
                }
            }, failure: { (error) in
            })
        } else {
            LCAddDeviceManager.sharedInstance.getDeviceStatus(success: { [weak self] (bindInfo) in
                guard cycleView.currentTime < cycleView.maxTime else {
                    return
                }
                //【*】保证设备已注册成功
                guard bindInfo.lc_isExisted() else {
                    NSLog("数据库不存在此设备，联系后台检查")
                    return
                }
                // 【*】SMB: 设备不支持，跳转不支持的界面
                if bindInfo.support == false {
                    self?.stopConnecting()
                    LCAddDeviceManager.sharedInstance.stopGetDeviceStatus()
                    self?.isHandlingOnline = false
                    let controller = LCDeviceUnsupportViewController()
                    controller.backToSacn = true
                    self?.navigationController?.pushViewController(controller, animated: true)
                    return
                }
                
                // 【*】SMB: 设备在线，直接进行绑定
                if bindInfo.lc_isOnline() {
                    print("DMS is online, start to bind...")
                    self?.handleOnline()
                }
                
            }) { [weak self] (error) in
                print("\(error.description)")
                if cycleView.currentTime < cycleView.maxTime, self?.bindPresenter.bindUnsuccessfullyProcessed(error: error, type: self?.getFailureType() ?? .accessory ) == true {
                    self?.stopConnecting()
                }
            }
        }
	}
	
	// MARK: Handle online/timeout
	func handleOnline() {
		if self.isHandlingOnline {
			return
		}
		
		LCAddDeviceManager.sharedInstance.stopGetDeviceStatus()
		self.isHandlingOnline = true
		
		if LCAddDeviceManager.sharedInstance.isEntryFromWifiConfig {
			handleOfflineWifiConfig()
        } else {
            handleOnlineLechange()
        }
	}
	
	func handleOfflineWifiConfig() {
		stopConnecting()
		LCProgressHUD.showMsg("add_device_config_done".lc_T())
		LCAddDeviceManager.sharedInstance.isEntryFromWifiConfig = false
		self.baseExitAddDevice(showAlert: false)
	}

	func handleOnlineLechange() {
		//【*】有Auth能力集：没有缓存密码，进入密码验证；有缓存密码，直接绑定
		//【*】有Reg能力集的，没有缓存安全码，进入安全码验证
		//【*】其他，直接绑定
		let manager = LCAddDeviceManager.sharedInstance
		if manager.abilities.contains("Auth") {
			print(" \(Date()) \(NSStringFromClass(self.classForCoder))::handleOnlineLechange with Auth, password:\(String(describing: deviceInitialPassword))")
			if let password = deviceInitialPassword, password.count > 0 {
				self.bindDevice(password: password)
			} else {
				let controller = LCAuthPasswordViewController.storyboardInstance()
				controller.presenter = LCAuthPasswordPresenter(container: controller)
				self.navigationController?.pushViewController(controller, animated: true)
			}
        } else if manager.abilities.contains("RegCode") {
			//Code存在时，直接进行绑定，不存在时弹出验证框
            if let code = LCAddDeviceManager.sharedInstance.regCode, code.count != 0 {
                //调用添加接口
                self.bindDevice(password: deviceInitialPassword ?? "")
            } else {
                let controller = LCAuthRegCodeViewController.storyboardInstance()
                self.navigationController?.pushViewController(controller, animated: true)
            }

        } else {
			print(" \(Date()) \(NSStringFromClass(self.classForCoder))::handleOnlineLechange with no auth, password:\(String(describing: deviceInitialPassword))")
            self.bindDevice(password: deviceInitialPassword ?? "")
		}
	}
	
	func bindDevice(password: String) {
		self.contentLabel.text = "add_device_binding_to_account".lc_T()
		
		//【*】正在进行绑定操作，不需要处理
		if self.isInBinding {
			return
		}
		
		self.isInBinding = true
		let code = LCAddDeviceManager.sharedInstance.regCode ?? ""
		LCAddDeviceManager.sharedInstance.bindDevice(devicePassword: password, code: code, deviceKey: "", success: {
            LCAddDeviceManager.sharedInstance.addPlicy { [weak self] in
                LCAddDeviceManager.sharedInstance.getDeviceInfoAfterBind(success: { (successInfo) in
                    if self?.cycleTimerView.currentTime ?? 0 < self?.cycleTimerView.maxTime ?? 0 {
                        self?.bindPresenter.deviceBindedProcessed(successInfo: successInfo)
                        self?.stopConnecting()
                    }
                    self?.isInBinding = false
                    self?.isHandlingOnline = false
                }) { (error) in
                    
                }
            } failure: { (error) in
            }
		}) { [weak self] (error) in
			if self?.cycleTimerView.currentTime ?? 0 < self?.cycleTimerView.maxTime ?? 0 {
                if self?.bindPresenter.bindUnsuccessfullyProcessed(error: error, type: self?.getFailureType() ?? .accessory) == true {
					self?.stopConnecting()
				}
			}
			self?.isHandlingOnline = false
			self?.isInBinding = false
		}
	}
	
	func handleTimeout() {
		stopConnecting()
		LCAddDeviceManager.sharedInstance.stopGetDeviceStatus()
		self.isHandlingOnline = false
		
        addDeviceEndLog()
        
		//离线配网超时，进入入口页
		if LCAddDeviceManager.sharedInstance.isEntryFromWifiConfig {
			LCProgressHUD.showMsg("add_device_config_failed_please_retry".lc_T())
			baseExitToOfflineWifiConfigRoot()
			return
		}
        
        self.navigationController?.pushViewController(self.timeoutVc, animated: true)
	}

	
	///【*】软AP设备：根据类型显示
	// 【*】配件：走'LCAccessoryConnectFailureViewController'流程
	// 【*】其他设备：显示通用连接乐橙云平台超时
	///
	/// - Returns: 错误类型
	private func getFailureType() -> LCNetConnectFailureType {
		var failureType: LCNetConnectFailureType
		let manager = LCAddDeviceManager.sharedInstance
		if manager.netConfigMode == .softAp {
			failureType = LCModuleConfig.shareInstance().isChinaMainland ? .door : .overseasDoorbell
		} else {
			failureType = .cloudTimeout
		}
		
		return failureType
	}
    
    private func addDeviceEndLog() {
        let model = LCAddDeviceLogModel()
        model.res = ResType.Fail.rawValue
        model.errCode = CodeType.ConnectCloudTimeOut.rawValue
        model.dese = DescType.ConnectCloudTimeOut.rawValue
        LCAddDeviceLogManager.shareInstance.addDeviceEndLog(model: model)
    }
}

// MARK: LCBindContainerProtocol
extension LCConnectCloudViewController: LCBindContainerProtocol {
	func navigationVC() -> UINavigationController? {
		return self.navigationController
	}
	
	func mainView() -> UIView {
		return self.view
	}
	
	func mainController() -> UIViewController {
		return self
	}
}

// MARK: LCConnectCloudTimeoutVCDelegate
extension LCConnectCloudViewController: LCConnectCloudTimeoutVCDelegate {
	func cloudTimeOutReconnectAction() {
        self.navigationController?.popViewController(animated: true)
		self.startConnecting()
	}
    
    func cloudTimeOutQuitAction() {
        self.baseExitAddDevice()
    }
}
