//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	设备初始化：设置设备密码界面

import UIKit
import LCOpenSDKDynamic

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
	
    
    var searchedDevice: LCOpenSDK_SearchDeviceInfo? = nil
    
	private lazy var bindPresenter: LCBindPresenter = {
		let presenter = LCBindPresenter()
		return presenter
	}()
	
	private lazy var errorView: LCCommonErrorView = {
		let view = LCCommonErrorView.init()
		view.imageView.image = UIImage(lc_named: "adddevice_netsetting_guide_safe")
		view.frame = self.view.bounds
		view.delegate = self
		return view
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        self.title = ""
        
		configSubViews()
		warmPromptTextView.scrollRangeToVisible(NSMakeRange(0, 0))
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.view.endEditing(true)
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
        pwdInputView.textField.placeholder = "add_device_input_device_password".lc_T()
		
		//密码国内默认为明文，可点击隐藏，海外默认为暗文
		pwdInputView.openBtnState = LCModuleConfig.shareInstance().isChinaMainland
		
		//按钮样式配置
		confirmButton.layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
		confirmButton.backgroundColor = LCModuleConfig.shareInstance().commonButtonColor()
        
        self.safeLabel.text = "add_device_set_device_password_for_safety".lc_T()
        self.pwdTipLabel.text = "mobile_common_device_password_rule_tip".lc_T()
        self.warmPromptLabel.text = "add_device_kindly_reminder".lc_T()
        self.warmPromptTextView.text = "add_device_device_password_alert".lc_T()
        self.confirmButton.setTitle("Button_Confirm".lc_T(), for: .normal)
        
//#if DEBUG
//        self.createDebugView()
//#endif
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
        if self.searchedDevice == nil {
            print(" \(NSStringFromClass(self.classForCoder)):: Initialized failed, device is nil")
            self.initializeFailure()
            return
        }
        
        LCProgressHUD.show(on: self.view)
		let beginTime = Date().timeIntervalSince1970
		print(" \(NSStringFromClass(self.classForCoder)):: Initialized started:\(beginTime)")
		let isApDevice = LCAddDeviceManager.sharedInstance.netConfigMode == .softAp
        LCNetSDKInitialManager.sharedInstance().initialDevice(withPassWord: password, isSoftAp: isApDevice, deviceNetInfo:self.searchedDevice, withSuccessBlock: { [weak self] in
			LCAddDeviceManager.sharedInstance.initialPassword = password
			
			print("LCInitializePasswordViewController:: Initialized succeed...")
			LCProgressHUD.hideAllHuds(self?.view)
			self?.initialSuccess(devicePassword: password)
		}) { [weak self] in
			print("LCInitializePasswordViewController:: Initialized failed...")
			LCProgressHUD.hideAllHuds(self?.view)
			self?.initializeFailure()
		}
	}
	
	private func initializeFailure() {
		errorView.showOnView(superView: self.view, animated: false)
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
                let controller = LCApWifiSelectViewController()
                controller.devicePassword = devicePassword
                controller.searchedDevice = self.searchedDevice
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
	func errorViewOnTryAgain(errorView: LCCommonErrorView) {
		errorView.dismiss(animated: true)
		//退出到初始化搜索界面
		if let searchVc = baseBackToViewController(cls: LCInitializeSearchViewController.self) as? LCInitializeSearchViewController {
			searchVc.startSearchDevices()
		}
	}
	
	func errorViewOnQuit(errorView: LCCommonErrorView) {
		baseExitAddDevice()
	}
    
//    func errorViewOnBackRoot(errorView: LCCommonErrorView) {
//        baseBackToAddDeviceRoot()
//    }
}


// MARK: - Debug
//extension LCInitializePasswordViewController {
//    private func createDebugView() {
//        let debug_Failure: UIButton = {
//            let btn: UIButton = UIButton(frame: CGRect(x: 0, y: 20, width: 50, height: 40))
//            btn.backgroundColor = UIColor.white
//            btn.titleLabel?.font = UIFont.lcFont_t3()
//            btn.setTitle("设置失败".lc_T(), for: .normal)
//            btn.setTitleColor(UIColor.lccolor_c0(), for: .normal)
//            btn.addTarget(self, action: #selector(debugFailure), for: .touchUpInside)
//            return btn
//        }()
//        
//        self.view.addSubview(debug_Failure)
//        
//        debug_Failure.snp.makeConstraints({ (make) in
//            make.centerX.equalTo(self.view)
//            make.bottom.equalTo(self.view).offset(-LC_bottomSafeMargin)
//        })
//    }
//    
//    @objc private func debugFailure() {
//        self.initializeFailure()
//    }
//}
