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
	
    @IBOutlet weak var inputTipLabel: UILabel!
    @IBOutlet weak var passwordInputView: LCInputView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var warmTipView: UIView!
	@IBOutlet weak var tipLabel: UILabel!
	@IBOutlet weak var detailTextView: UITextView!
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupContents()
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func setupContents() {
		view.backgroundColor = UIColor.lccolor_c43()
        
		//SMB：色值修改
		tipLabel.text = "add_device_kindly_reminder".lc_T
		tipLabel.textColor = UIColor.lccolor_c0() //UIColor.lccolor_c2()
		nextButton.setTitle("common_next".lc_T, for: .normal)
		
		
		inputTipLabel.text = "add_device_input_device_password".lc_T
        inputTipLabel.textColor = UIColor.lccolor_c2()
		passwordInputView.textField.placeholder = "add_device_input_device_password".lc_T
		passwordInputView.backgroundColor = UIColor.lccolor_c43()
		
		nextButton.layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
		nextButton.backgroundColor = LCModuleConfig.shareInstance().commonButtonColor()
        nextButton.lc_enable = false
        nextButton.setTitleColor(UIColor.lccolor_c43(), for: .normal)
        
        topLine.backgroundColor = UIColor.lccolor_c8()
        bottomLine.backgroundColor = UIColor.lccolor_c8()
		
		//设置TextView，dataDetectorTypes为何无效？？
		detailTextView.delegate = self
		detailTextView.isUserInteractionEnabled = true
		detailTextView.isEditable = false
		detailTextView.isSelectable = true
		detailTextView.dataDetectorTypes = .link
        detailTextView.textColor = UIColor.lccolor_c5()
		
		let style = NSMutableParagraphStyle()
		style.lineBreakMode = NSLineBreakMode.byWordWrapping
		style.lineSpacing = 5
		let attr1: [NSAttributedStringKey: Any] = [NSAttributedStringKey.paragraphStyle: style,
													NSAttributedStringKey.foregroundColor: UIColor.lccolor_c5(),
													NSAttributedStringKey.font: UIFont.lcFont_t6()]
		
		let text = "add_device_password_initial_tip".lc_T
		let rang1 = NSMakeRange(0, text.count)
		let attrText = NSMutableAttributedString(string: text)
		attrText.addAttributes(attr1, range: rang1)
		
		if LCModuleConfig.shareInstance().isChinaMainland, LCModuleConfig.shareInstance().addDevice_showServiceCall() {
			let phoneNumber = LCModuleConfig.shareInstance().serviceCall() ?? ""
			let rang2 = NSMakeRange(0, phoneNumber.count)
			let attr2: [NSAttributedStringKey: Any] = [NSAttributedStringKey.paragraphStyle: style,
														NSAttributedStringKey.link: "serviceCall",
														NSAttributedStringKey.foregroundColor: UIColor.lccolor_c32(),
														//NSAttributedStringKey.underlineStyle: 1,
														NSAttributedStringKey.font: UIFont.lcFont_t6()]
			let attrPhone = NSMutableAttributedString(string: phoneNumber)
			attrPhone.addAttributes(attr2, range: rang2)
			attrText.append(attrPhone)
		}
		
		detailTextView.attributedText = attrText
		detailTextView.scrollRangeToVisible(NSMakeRange(0, 0))
		let rect = attrText.string.boundingRect(with: CGSize(width: view.bounds.width - 30, height: view.bounds.height),
												options: NSStringDrawingOptions.usesLineFragmentOrigin,
												attributes: attr1,
												context: nil)
		textViewHeightConstraint.constant = rect.height + 30
		
		//验证密码不需要限制
        passwordInputView.textField.delegate = self
        passwordInputView.textField.keyboardType = .asciiCapable
        passwordInputView.textField.returnKeyType = .done
        passwordInputView.textField.textChanged = { [unowned self] text in
            let password = text ?? ""
            self.nextButton.lc_enable = password.count > 0
        }
        passwordInputView.tfUnSecureImg = UIImage(named: "common_icon_close_small")
        passwordInputView.tfSecureImg = UIImage(named: "adddevice_common_icon_open_small")
        passwordInputView.openBtnState = false
	}
    
	@IBAction func onNextAction(_ sender: Any) {
		let password = passwordInputView.textField.text ?? ""
		let device = LCAddDeviceManager.sharedInstance.getLocalDevice()
		
		passwordInputView?.textField.resignFirstResponder()
		
		//如果是AP是在线的，可能局域网搜索不到，无法用netsdk方式进行检验
		presenter?.nextStepAction(password: password, device: device, deviceId: LCAddDeviceManager.sharedInstance.deviceId)
		
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
	
	func textView(_ textView: UITextView, shouldInteractWith txtViewURL: URL, in characterRange: NSRange) -> Bool {
		if txtViewURL.absoluteString == "serviceCall" {
			let phone = "telprompt://" + LCModuleConfig.shareInstance().serviceCall()
			if let url = URL(string: phone) {
				UIApplication.shared.openURL(url)
			}
			
			return true
		}
		
		return false
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
