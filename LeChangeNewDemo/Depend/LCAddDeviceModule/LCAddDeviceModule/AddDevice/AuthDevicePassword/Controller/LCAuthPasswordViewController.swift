//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	密码检验
//	【*】国内：根据Auth能力集，点下一步时，绑定
//	【*】海外：登录设备检验密码，如果前面初始化流程传入了密码，则不需要进入，直接在连接云平台绑定设备；

import UIKit
import LCBaseModule

class LCAuthPasswordViewController: LCAddBaseViewController, UITextFieldDelegate, UITextViewDelegate, LCBindContainerProtocol {

	public static func storyboardInstance() -> LCAuthPasswordViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "LCAuthPasswordViewController") as? LCAuthPasswordViewController {
            return controller
        }
		return LCAuthPasswordViewController()
	}
    
    public var presenter: LCAuthPasswordPresenterProtocol?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordInputView: LCInputView!
	@IBOutlet weak var tipLabel: UILabel!
	@IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var tipImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
		setupContents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func setupContents() {
		view.backgroundColor = UIColor.lccolor_c43()
        
        titleLabel.text = "add_device_input_device_password".lc_T()
        passwordInputView.textField.placeholder = "add_device_input_device_password".lc_T()
		tipLabel.text = "add_device_kindly_reminder".lc_T()
		nextButton.setTitle("common_next".lc_T(), for: .normal)
        nextButton.lc_enable = false
        detailLabel.text = "add_device_auth_password_tip".lc_T()
        if LCAddDeviceManager.sharedInstance.isEntryFromWifiConfig {
            titleLabel.text = "add_device_input_device_sc".lc_T()
            passwordInputView.textField.placeholder = "add_device_input_device_sc_tip".lc_T()
            detailLabel.text = "add_device_input_device_sc_alert".lc_T()
        }
        self.tipImageView.image = UIImage(lc_named: "adddevice_failure_safety_code")
        if !NSString.lc_currentLanguageCode().contains("zh") {
            self.tipImageView.image = UIImage(lc_named: "adddevice_failure_safety_code_en")
        }
        passwordInputView.textField.delegate = self
        passwordInputView.textField.keyboardType = .asciiCapable
        passwordInputView.textField.returnKeyType = .done
        passwordInputView.textField.textChanged = { [unowned self] text in
            let password = text ?? ""
            self.nextButton.lc_enable = password.count > 0
        }
        
        if let image = self.tipImageView.image {
            let height = (self.tipImageView.frame.size.width / image.size.width) * image.size.height
            self.tipImageView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
        }
	}
    
	@IBAction func onNextAction(_ sender: Any) {
		let password = passwordInputView.textField.text ?? ""
		passwordInputView?.textField.resignFirstResponder()
		//如果是AP是在线的，可能局域网搜索不到，无法用netsdk方式进行检验
		presenter?.nextStepAction(password: password, deviceId: LCAddDeviceManager.sharedInstance.deviceId)
    }

	// MARK: LCAddBaseVCProtocol
	override func leftActionType() -> LCAddBaseLeftAction {
		return .quit
	}
	
	override func isLeftActionShowAlert() -> Bool {
		return true
	}
	
	override func rightActionType() -> [LCAddBaseRightAction] {
		return [.restart]
	}
}

extension LCAuthPasswordViewController {
	
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
