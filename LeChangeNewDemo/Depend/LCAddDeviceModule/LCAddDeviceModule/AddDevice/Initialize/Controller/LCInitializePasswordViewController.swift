//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	设备初始化：设置设备密码界面

import UIKit

fileprivate let kLegalDevicePassword: String = "^[A-Za-z0-9!#%,<=>@_~`\\-\\.\\/\\(\\)\\*\\+\\?\\$\\[\\]\\\\\\^\\{\\}\\|]$"

class LCInitializePasswordViewController: LCAddBaseViewController, UITextFieldDelegate, LCBindContainerProtocol, LCCommonErrorViewDelegate {
	
	public static func storyboardInstance() -> LCInitializePasswordViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
        guard let controller = storyboard.instantiateViewController(withIdentifier: "LCInitializePasswordViewController") as? LCInitializePasswordViewController else {
            return LCInitializePasswordViewController()
        }
		return controller
	}
	
	
	@IBOutlet weak var safeImageView: UIImageView!
	@IBOutlet weak var safeLabel: UILabel!
	@IBOutlet weak var pwdInputView: LCInputView!
	@IBOutlet weak var pwdTipLabel: UILabel!
	@IBOutlet weak var warmPromptLabel: UILabel!
	@IBOutlet weak var warmPromptTextView: UITextView!
	@IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var topLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLine: UIView!
	
	private lazy var bindPresenter: LCBindPresenter = {
		let presenter = LCBindPresenter()
		return presenter
	}()
	
	private lazy var errorView: LCCommonErrorView = {
		let view = LCCommonErrorView.xibInstance()
		view.contentMode = .scaleAspectFit
		view.imageView.image = UIImage(named: "adddevice_fail_undetectable")
		view.frame = self.view.bounds
		view.contentLabel.lc_setAttributedText(text: "add_device_initialize_failed".lc_T, font: UIFont.lcFont_t1())
        view.contentLabel.textColor = UIColor.lccolor_c2()
		view.delegate = self
		return view
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.lccolor_c43()
		// Do any additional setup after loading the view.
		
		configSubViews()
        configCustomContents()
		warmPromptTextView.scrollRangeToVisible(NSMakeRange(0, 0))
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.view.endEditing(true)
	}
	
	private func configCustomContents() {
		if lc_screenHeight < 667 {
			safeLabel.font = UIFont.lcFont_t4()
			pwdInputView.textField.font = UIFont.lcFont_t4()
            self.topLabelBottomConstraint.constant = 10
            self.topLabelTopConstraint.constant = 5
		}
		
		safeLabel.text = "add_device_set_device_password_for_safety".lc_T
        safeLabel.textColor = UIColor.lccolor_c2()
        
		pwdInputView.textField.placeholder = "add_device_input_device_password".lc_T
		confirmButton.setTitle("common_button_next_step".lc_T, for: .normal)
        confirmButton.setTitleColor(UIColor.lccolor_c43(), for: .normal)
		warmPromptLabel.text = "add_device_kindly_reminder".lc_T
		warmPromptTextView.text = "add_device_define_device_password_tip".lc_T
        warmPromptTextView.textColor = UIColor.lccolor_c5()
		pwdTipLabel.text = "mobile_common_device_password_rule_tip".lc_T
        pwdTipLabel.textColor = UIColor.lccolor_c5()
		warmPromptLabel.textColor = UIColor.lccolor_c0() //UIColor.lccolor_c2()
        bottomLine.backgroundColor = UIColor.lccolor_c8()
	}
	
	private func configSubViews() {
		
		confirmButton.lc_enable = false
		
		//由于确定按钮在底部，需要进行键盘确定操作
		pwdInputView.textField.lc_setInputRule(withRegEx: kLegalDevicePassword, andInputLength: UInt32(LC_PASSWORD_MAX_LENGTH))
		pwdInputView.textField.delegate = self
		pwdInputView.textField.keyboardType = .asciiCapable
		pwdInputView.textField.returnKeyType = .done
		pwdInputView.textField.textChanged = { [unowned self] text in
			let password = text ?? ""
			self.confirmButton.lc_enable = password.count > LC_PASSWORD_MIN_LENGTH - 1
		}
		
		//密码国内默认为明文，可点击隐藏，海外默认为暗文
		pwdInputView.openBtnState = LCModuleConfig.shareInstance().isChinaMainland
		
		//按钮样式配置
		confirmButton.layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
		confirmButton.backgroundColor = LCModuleConfig.shareInstance().commonButtonColor()
		
		//图片设置
		safeImageView.image = UIImage(named: "adddevice_icon_devicepassword")
	}
	
	@IBAction func onConfirmAction(_ sender: UIButton) {
	
		guard pwdInputView.textField.text != nil else {
			return
		}
        
    
        guard NSString.lc_pwdVerifiers(pwdInputView.textField.text) == true else {
            return
        }
        
		self.setDevicePassword(password: pwdInputView.textField.text!)
	}
	
	private func setDevicePassword(password: String) {
		
		LCProgressHUD.show(on: lc_keyWindow)
		
		let deviceId = LCAddDeviceManager.sharedInstance.deviceId
		let device = LCNetSDKSearchManager.sharedInstance().getNetInfo(byID: deviceId)
		
		guard device != nil else {
			LCProgressHUD.hideAllHuds(lc_keyWindow)
			print(" \(NSStringFromClass(self.classForCoder)):: Initialized failed, device is nil with id:\(deviceId)")
			self.initializeFailure()
			return
		}
		
		let beginTime = Date().timeIntervalSince1970
		print(" \(NSStringFromClass(self.classForCoder)):: Initialized started:\(beginTime)")
		let isApDevice = LCAddDeviceManager.sharedInstance.netConfigMode == .softAp
		LCNetSDKInitialManager.sharedInstance().initialDevice(withPassWord: password, isSoftAp: isApDevice, withInitialType: device!.deviceInitType, withSuccessBlock: {
			LCAddDeviceManager.sharedInstance.initialPassword = password
			
			print(" \(NSStringFromClass(self.classForCoder)):: Initialized succeed...")
			LCProgressHUD.hideAllHuds(lc_keyWindow)
			self.initialSuccess(devicePassword: password)
		}) {
			print(" \(NSStringFromClass(self.classForCoder)):: Initialized failed...")
			LCProgressHUD.hideAllHuds(lc_keyWindow)
			self.initializeFailure()
		}
	}
	
	private func initializeFailure() {
		errorView.showOnView(superView: self.view, animated: true)
		
	}
	
	private func initialSuccess(devicePassword: String) {
		//【*】软AP初始化成功后，进入WIFI列表选择界面
		//【*】普通设备（新方案不区分p2p/非paas），进入连接乐橙云界面
		let manager = LCAddDeviceManager.sharedInstance
		if manager.netConfigMode == .softAp {
            if true == LCAddDeviceManager.sharedInstance.isSupportSC {
                let controller = LCConnectCloudViewController.storyboardInstance()
                controller.deviceInitialPassword = LCAddDeviceManager.sharedInstance.initialPassword
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                let controller = LCApWifiSelectViewController.storyboardInstance()
                controller.devicePassword = devicePassword
                self.navigationController?.pushViewController(controller, animated: true)
            }
		} else {
			let controller = LCConnectCloudViewController.storyboardInstance()
			controller.deviceInitialPassword = devicePassword
			self.navigationController?.pushViewController(controller, animated: true)
		}
		
		// 待完善：如果是离线配网，需要修改设备密码
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
		return [.restart]
	}
}

extension LCInitializePasswordViewController {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

extension LCInitializePasswordViewController {
	
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
		
	}
}

extension LCInitializePasswordViewController {
	
	// MARK: - LCCommonErrorViewDelegate
	func errorViewOnConfirm(errorView: LCCommonErrorView) {
		errorView.dismiss(animated: true)
		
		//退出到初始化搜索界面
		if let searchVc = baseBackToViewController(cls: LCInitializeSearchViewController.self) as? LCInitializeSearchViewController {
			searchVc.startSearchDevices()
		}
	}
	
	func errorViewOnFAQ(errorView: LCCommonErrorView) {
		basePushToFAQ()
	}
	
	func errorViewOnQuit(errorView: LCCommonErrorView) {
		baseExitAddDevice()
	}
    
    func errorViewOnBackRoot(errorView: LCCommonErrorView) {
        baseBackToAddDeviceRoot()
    }
}
