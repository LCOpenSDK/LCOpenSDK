//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	连接乐橙云平台：检测到设备在经后
// 【1】国内如果没有RD、Auth能力集，直接绑定；如果有，需要跳转输入界面，优先Auth
// 【2】海外需要进入密码检验界面

import UIKit

class DHConnectCloudViewController: DHAddBaseViewController, DHCycleTimerViewDelegate {

	public static func storyboardInstance() -> DHConnectCloudViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.dh_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "DHConnectCloudViewController") as? DHConnectCloudViewController {
            return controller
        }
		return DHConnectCloudViewController()
	}
	
	/// 设备密码，上级初始化流程传入
	public var deviceInitialPassword: String?
	
	@IBOutlet weak var cycleTimerView: DHCycleTimerView!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var topAnimateView: UIImageView!
	@IBOutlet weak var cloudImageView: UIImageView!
	@IBOutlet weak var leftCloudAnimateView: UIImageView!
	@IBOutlet weak var rightCloudAnimateView: UIImageView!
	
	/// 超时的页面
	private lazy var timeoutVc: DHConnectCloudTimeoutViewController = {
		let controller = DHConnectCloudTimeoutViewController()
		controller.delegate = self
		return controller
	}()
	
	/// 绑定解释器
	private lazy var bindPresenter: DHBindPresenter = {
		let presenter = DHBindPresenter()
		presenter.setup(container: self)
		return presenter
	}()
	
	/// 查询到设备在线进行处理中
	private var isHandlingOnline: Bool = false
	
	/// 是否在绑定操作中
	private var isInBinding: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
        view.backgroundColor = UIColor.dhcolor_c43()
		// Do any additional setup after loading the view.
		configTopConnectView()
		configCustomContents()
		configCycleTimerView()

		//开始倒计时
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			self.startConnecting()
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		stopConnecting()
		
		//由于页面是在父视图显示的，需要单独区分超时与未超时的情况

	}
	
	private func configTopConnectView() {
		var images = [UIImage]()
        if let image1 = UIImage(named: "adddevice_netsetting_connectcloud_1") {
            images.append(image1)
        }
        if let image2 = UIImage(named: "adddevice_netsetting_connectcloud_2") {
            images.append(image2)
        }
        if let image3 = UIImage(named: "adddevice_netsetting_connectcloud_3") {
            images.append(image3)
        }
        
		topAnimateView.animationImages = images
		topAnimateView.animationDuration = 2
		cloudImageView.image = UIImage(named: "adddevice_netsetting_cloudserver")
	}
	
	private func configCustomContents() {
		contentLabel.text = "add_device_connect_cloud_please_wait".lc_T
        contentLabel.textColor = UIColor.dhcolor_c2()
	}
	
	private func configCycleTimerView() {
		switch DHAddDeviceManager.sharedInstance.netConfigMode {
		case .softAp:
			cycleTimerView.maxTime = DHAddConfigTimeout.softApCloudConnect
			
		case .nbIoT:
			cycleTimerView.maxTime = DHAddConfigTimeout.nbIoTCloudConnect
			
		default:
			cycleTimerView.maxTime = DHAddConfigTimeout.cloudConnect
		}
		
		cycleTimerView.delegate = self
	}
	
	// MARK: Timer
	private func startConnecting() {
		cycleTimerView.startTimer()
		startAnimation()
	}
	
	private func stopConnecting() {
		cycleTimerView.stopTimer()
		stopAnimation()
	}
	
	// MARK: Animations
	private func startAnimation() {
		topAnimateView.startAnimating()
		addCloudAnimation(onView: leftCloudAnimateView, toX: 25)
		addCloudAnimation(onView: rightCloudAnimateView, toX: 35)
	}
	
	private func stopAnimation() {
		topAnimateView.stopAnimating()
		leftCloudAnimateView.layer.removeAllAnimations()
		rightCloudAnimateView.layer.removeAllAnimations()
	}
	
	private func addCloudAnimation(onView view: UIView, toX: CGFloat) {
		let transAnimation = CABasicAnimation(keyPath: "transform.translation.x")
		transAnimation.fromValue = 0
		transAnimation.toValue = toX

		let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
		scaleAnimation.fromValue = 1
		scaleAnimation.toValue = 0.9
		
		let animationGroup = CAAnimationGroup()
		animationGroup.duration = 3
		animationGroup.repeatCount = MAXFLOAT
		animationGroup.autoreverses = true
		animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		animationGroup.animations = [transAnimation, scaleAnimation]
	
		view.layer.add(animationGroup, forKey: nil)
	}

	// MARK: DHAddBaseVCProtocol
	override func leftActionType() -> DHAddBaseLeftAction {
		return .quit
	}
	
	override func isLeftActionShowAlert() -> Bool {
		return true
	}
	
	override func rightActionType() -> [DHAddBaseRightAction] {
		return [.restart]
	}
}

// MARK: CycleTimerViewDelegate
extension DHConnectCloudViewController {
	func cycleTimerViewTimeout(cycleView: DHCycleTimerView) {
		handleTimeout()
	}
	
	func cycleTimerView(cycleView: DHCycleTimerView, tick: Int) {
		// 【*】每隔3秒进行一次轮循
		guard tick % 3 == 0 else {
			return
		}
		
		print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder))::Tick...\(tick / 3 )")
		
		//【*】在线绑定、或者查询在线状态
		guard self.isHandlingOnline == false else {
			return
		}
		
		DHAddDeviceManager.sharedInstance.getDeviceStatus(success: { (bindInfo) in
			
			print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder)):: Time:\(cycleView.currentTime), deviceType:\(bindInfo.dh_accessType().rawValue), existed:\(bindInfo.dh_isExisted()), onlineStatus:\(bindInfo.dh_isOnline())")
			
			guard cycleView.currentTime < cycleView.maxTime else {
				return
			}
			
			//【*】保证设备已注册成功
			guard bindInfo.dh_isExisted() else {
                NSLog("数据库不存在此设备，联系后台检查")
				return
			}
			
			// 【*】SMB: 设备不支持，跳转不支持的界面
			if bindInfo.surpport == false {
				self.stopConnecting()
				DHAddDeviceManager.sharedInstance.stopGetDeviceStatus()
				self.isHandlingOnline = false
				let controller = DHDeviceUnsupportViewController()
				controller.backToSacn = true
				self.navigationController?.pushViewController(controller, animated: true)
				return
			}
			
			// 【*】SMB: 设备在线，直接进行绑定
			if bindInfo.dh_isOnline() {
				print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder)):: DMS is online, start to bind...")
				self.handleOnline()
			}
			
		}) { (error) in
			print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder))::\(error.description)")
			
			//解释器处理了错误【内部跳转页面等】，停止计时
			if cycleView.currentTime < cycleView.maxTime, self.bindPresenter.bindUnsuccessfullyProcessed(error: error, type: self.getFailureType()) {
				self.stopConnecting()
			}
		}
	}
	
	// MARK: Handle online/timeout
	func handleOnline() {
		if self.isHandlingOnline {
			return
		}
		
		DHAddDeviceManager.sharedInstance.stopGetDeviceStatus()
		self.isHandlingOnline = true
		
		if DHAddDeviceManager.sharedInstance.isEntryFromWifiConfig {
			handleOfflineWifiConfig()
			return
		}
	
		
		// 【*】国内如果没有RD、Auth能力集，直接绑定
		handleOnlineLechange()
	}
	
	func handleOfflineWifiConfig() {
		stopConnecting()
		LCProgressHUD.showMsg("add_device_config_done".lc_T)
		DHAddDeviceManager.sharedInstance.isEntryFromWifiConfig = false
		DHAddDeviceManager.sharedInstance.postUpdateDeviceNotification(isWifiConfig: true)
		
		self.baseExitAddDevice(showAlert: false, backToMain: true)
	}
	
	func handleOnlineOverseas() {
		// 【*】有初始化流程缓存的密码，直接进行绑定【软AP走之前的步骤，肯定会有密码，如果未设置则APP异常】
		// 【*】没有初始化流程缓存的密码，进入密码输入界面
		if let password = deviceInitialPassword, password.count > 0 {
			self.bindDevice(password: password)
		} else {
			self.stopConnecting()
			let controller = DHAuthPasswordViewController.storyboardInstance()
            controller.presenter = DHAuthPasswordPresenter(container: controller)
			self.navigationController?.pushViewController(controller, animated: true)
		}
	}
	
	func handleOnlineLechange() {
		//【*】有Auth能力集：没有缓存密码，进入密码验证；有缓存密码，直接绑定
		//【*】有Reg能力集的，没有缓存安全码，进入安全码验证
		//【*】其他，直接绑定
		let manager = DHAddDeviceManager.sharedInstance
		if manager.abilities.contains("Auth") {
			print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder))::handleOnlineLechange with Auth, password:\(String(describing: deviceInitialPassword))")
			if let password = deviceInitialPassword, password.count > 0 {
				self.bindDevice(password: password)
			} else {
				let controller = DHAuthPasswordViewController.storyboardInstance()
				controller.presenter = DHAuthPasswordPresenter(container: controller)
				self.navigationController?.pushViewController(controller, animated: true)
			}
        } else if manager.abilities.contains("RegCode") {
			
			//Code存在时，直接进行绑定，不存在时弹出验证框
            if let code = DHAddDeviceManager.sharedInstance.regCode, code.count != 0 {
                //调用添加接口
                self.bindDevice(password: deviceInitialPassword ?? "")
            } else {
                let controller = DHAuthRegCodeViewController.storyboardInstance()
                self.navigationController?.pushViewController(controller, animated: true)
            }

        } else {
			print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder))::handleOnlineLechange with no auth, password:\(String(describing: deviceInitialPassword))")
            self.bindDevice(password: deviceInitialPassword ?? "")
		}
	}
	
	func bindDevice(password: String) {
		self.contentLabel.text = "add_device_binding_to_account".lc_T
		
		//【*】正在进行绑定操作，不需要处理
		if self.isInBinding {
			return
		}
		
		self.isInBinding = true
		//【*】成功计时范围内才处理
		//【*】失败，在计时范围内，处理特定的错误码
		let code = DHAddDeviceManager.sharedInstance.regCode

		DHAddDeviceManager.sharedInstance.bindDevice(devicePassword: password, code: code, deviceKey: "", success: {
            DHAddDeviceManager.sharedInstance.addPlicy {
                DHAddDeviceManager.sharedInstance.getDeviceInfoAfterBind(success: { (successInfo) in
                    if self.cycleTimerView.currentTime < self.cycleTimerView.maxTime {
                        self.bindPresenter.deviceBindedProcessed(successInfo: successInfo)
                        self.stopConnecting()
                    }
                    self.isInBinding = false
                    self.isHandlingOnline = false
                }) { (error) in
                    
                }
            } failure: { (error) in
                
            }
		}) { (error) in
			if self.cycleTimerView.currentTime < self.cycleTimerView.maxTime {
				//解释器处理了错误【内部跳转页面等】，停止计时
				if self.bindPresenter.bindUnsuccessfullyProcessed(error: error, type: self.getFailureType()) {
					self.stopConnecting()
				}
			}

			self.isHandlingOnline = false
			self.isInBinding = false
		}
	}
	
	func handleTimeout() {
		stopConnecting()
		DHAddDeviceManager.sharedInstance.stopGetDeviceStatus()
		self.isHandlingOnline = false
		
        addDeviceEndLog()
        
		//离线配网超时，进入入口页
		if DHAddDeviceManager.sharedInstance.isEntryFromWifiConfig {
			LCProgressHUD.showMsg("add_device_config_failed_please_retry".lc_T)
			baseExitToOfflineWifiConfigRoot()
			return
		}
		
		timeoutVc.failureType = getFailureType()
		timeoutVc.showOnParent(controller: self)
		
	}

	
	///【*】软AP设备：根据类型显示
	// 【*】配件：走'DHAccessoryConnectFailureViewController'流程
	// 【*】其他设备：显示通用连接乐橙云平台超时
	///
	/// - Returns: 错误类型
	private func getFailureType() -> DHNetConnectFailureType {
		var failureType: DHNetConnectFailureType
		let manager = DHAddDeviceManager.sharedInstance
		if manager.netConfigMode == .softAp {
			failureType = DHModuleConfig.shareInstance().isLeChange ? .door : .overseasDoorbell
			
			//【*】OMS配置了类型
			if let omsType = manager.getIntroductionParser()?.softApErrorType {
				failureType = omsType
			}
			
			//【测试】
			if DHAddDeviceTest.openTest {
				failureType = DHAddDeviceTest.apConnectTimeoutType
			}
		} else {
			failureType = .cloudTimeout
		}
		
		return failureType
	}
    
    private func addDeviceEndLog() {
        let model = DHAddDeviceLogModel()
        model.res = ResType.Fail.rawValue
        model.errCode = CodeType.ConnectCloudTimeOut.rawValue
        model.dese = DescType.ConnectCloudTimeOut.rawValue
        DHAddDeviceLogManager.shareInstance.addDeviceEndLog(model: model)
    }
}

// MARK: DHBindContainerProtocol
extension DHConnectCloudViewController: DHBindContainerProtocol {
	
	func navigationVC() -> UINavigationController? {
		return self.navigationController
	}
	
	func mainView() -> UIView {
		return self.view
	}
	
	func mainController() -> UIViewController {
		return self
	}
	
	func retry() {
		self.startConnecting()
		
	}
}

// MARK: DHConnectCloudTimeoutVCDelegate
extension DHConnectCloudViewController: DHConnectCloudTimeoutVCDelegate {
	
	func cloudTimeOutReconnectAction(controller: DHConnectCloudTimeoutViewController) {
		self.timeoutVc.dismiss()
		self.startConnecting()
		
	}
}
