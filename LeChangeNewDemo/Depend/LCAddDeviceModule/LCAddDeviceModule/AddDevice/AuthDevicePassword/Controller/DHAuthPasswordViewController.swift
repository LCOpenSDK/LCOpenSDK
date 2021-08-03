//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	密码检验
//	【*】国内：根据Auth能力集，点下一步时，绑定
//	【*】海外：登录设备检验密码，如果前面初始化流程传入了密码，则不需要进入，直接在连接云平台绑定设备；

import UIKit
import LCBaseModule

class DHAuthPasswordViewController: DHAddBaseViewController, UITextFieldDelegate, UITextViewDelegate, DHBindContainerProtocol {

	public static func storyboardInstance() -> DHAuthPasswordViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.dh_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "DHAuthPasswordViewController") as? DHAuthPasswordViewController {
            return controller
        }
		return DHAuthPasswordViewController()
	}
    
    public var presenter: DHAuthPasswordPresenterProtocol?
	
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
		view.backgroundColor = UIColor.dhcolor_c43()
        
		//SMB：色值修改
		tipLabel.text = "add_device_kindly_reminder".lc_T
		tipLabel.textColor = UIColor.dhcolor_c0() //UIColor.dhcolor_c2()
		nextButton.setTitle("common_next".lc_T, for: .normal)
		
		
		inputTipLabel.text = "add_device_input_device_password".lc_T
        inputTipLabel.textColor = UIColor.dhcolor_c2()
		passwordInputView.textField.placeholder = "add_device_input_device_password".lc_T
		passwordInputView.backgroundColor = UIColor.dhcolor_c43()
		
		nextButton.layer.cornerRadius = DHModuleConfig.shareInstance().commonButtonCornerRadius()
		nextButton.backgroundColor = DHModuleConfig.shareInstance().commonButtonColor()
        nextButton.dh_enable = false
        nextButton.setTitleColor(UIColor.dhcolor_c43(), for: .normal)
        
        topLine.backgroundColor = UIColor.dhcolor_c8()
        bottomLine.backgroundColor = UIColor.dhcolor_c8()
		
		//设置TextView，dataDetectorTypes为何无效？？
		detailTextView.delegate = self
		detailTextView.isUserInteractionEnabled = true
		detailTextView.isEditable = false
		detailTextView.isSelectable = true
		detailTextView.dataDetectorTypes = .link
        detailTextView.textColor = UIColor.dhcolor_c5()
		
		let style = NSMutableParagraphStyle()
		style.lineBreakMode = NSLineBreakMode.byWordWrapping
		style.lineSpacing = 5
		let attr1: [NSAttributedStringKey: Any] = [NSAttributedStringKey.paragraphStyle: style,
													NSAttributedStringKey.foregroundColor: UIColor.dhcolor_c5(),
													NSAttributedStringKey.font: UIFont.dhFont_t6()]
		
		let text = "add_device_password_initial_tip".lc_T
		let rang1 = NSMakeRange(0, text.count)
		let attrText = NSMutableAttributedString(string: text)
		attrText.addAttributes(attr1, range: rang1)
		
		if DHModuleConfig.shareInstance().isLeChange, DHModuleConfig.shareInstance().addDevice_showServiceCall() {
			let phoneNumber = DHModuleConfig.shareInstance().serviceCall() ?? ""
			let rang2 = NSMakeRange(0, phoneNumber.count)
			let attr2: [NSAttributedStringKey: Any] = [NSAttributedStringKey.paragraphStyle: style,
														NSAttributedStringKey.link: "serviceCall",
														NSAttributedStringKey.foregroundColor: UIColor.dhcolor_c32(),
														//NSAttributedStringKey.underlineStyle: 1,
														NSAttributedStringKey.font: UIFont.dhFont_t6()]
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
        //passwordInputView.textField.lc_setInputRule(withRegEx: "^[A-Za-z0-9]$", andInputLength: UInt32(DH_PASSWORD_MAX_LENGTH))
        passwordInputView.textField.delegate = self
        passwordInputView.textField.keyboardType = .asciiCapable
        passwordInputView.textField.returnKeyType = .done
        passwordInputView.textField.textChanged = { [unowned self] text in
            let password = text ?? ""
            self.nextButton.dh_enable = password.count > 0
        }
	}
    
	@IBAction func onNextAction(_ sender: Any) {
		let password = passwordInputView.textField.text ?? ""
		let device = DHAddDeviceManager.sharedInstance.getLocalDevice()
		
		passwordInputView?.textField.resignFirstResponder()
		
		//如果是AP是在线的，可能局域网搜索不到，无法用netsdk方式进行检验
		presenter?.nextStepAction(password: password, device: device, deviceId: DHAddDeviceManager.sharedInstance.deviceId)
		
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

extension DHAuthPasswordViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
	
	func textView(_ textView: UITextView, shouldInteractWith txtViewURL: URL, in characterRange: NSRange) -> Bool {
		if txtViewURL.absoluteString == "serviceCall" {
			let phone = "telprompt://" + DHModuleConfig.shareInstance().serviceCall()
			if let url = URL(string: phone) {
				UIApplication.shared.openURL(url)
			}
			
			return true
		}
		
		return false
	}
}

extension DHAuthPasswordViewController {
	
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
