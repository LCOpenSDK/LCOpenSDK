//
//  Copyright © 2019 dahua. All rights reserved.
//	IMEI码输入界面

import UIKit
import LCBaseModule

fileprivate let kMinIMEILength = 15
fileprivate let kMaxIMEILength = 17

class DHInputIMEIViewController: DHBaseViewController {

	public static func storyboardInstance() -> DHInputIMEIViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.dh_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "DHInputIMEIViewController") as? DHInputIMEIViewController {
            return controller
        }
		return DHInputIMEIViewController()
	}
	
	@IBOutlet weak var autoKeyboardView: DHAutoKeyboardView!
	@IBOutlet weak var imeiImageView: UIImageView!
	@IBOutlet weak var inputImeiTipLabel: UILabel!
	@IBOutlet weak var inputImeiTextField: LCTextField!
	@IBOutlet weak var imeiTipLabel: UILabel!
	@IBOutlet weak var nextButton: UIButton!
	
	// MARK: Life Cycles
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.dhcolor_c43()
		self.title = "add_device_title".lc_T
		setupCustomContens()
		
		// Do any additional setup after loading the view.
		// 进入NB配网，不需要进行局域网搜索
		DHNetSDKSearchManager.sharedInstance()?.stopSearch()
		
		//按钮样式配置
		nextButton.layer.cornerRadius = DHModuleConfig.shareInstance().commonButtonCornerRadius()
		nextButton.backgroundColor = DHModuleConfig.shareInstance().commonButtonColor()
		
		//颜色规范
		inputImeiTipLabel.textColor = UIColor.dhcolor_c2()
		imeiTipLabel.textColor = UIColor.dhcolor_c5()
		nextButton.setTitleColor(UIColor.dhcolor_c43(), for: .normal)
		nextButton.dh_enable = false
		
		setupTextFiledStyle(textField: inputImeiTextField)
		inputImeiTextField.lc_setInputRule(withRegEx: nil, andInputLength: UInt32(kMaxIMEILength))
		inputImeiTextField.textChanged = { [unowned self] text in
			let imei = text ?? ""
			self.nextButton.dh_enable = imei.count >= kMinIMEILength
		}

		autoKeyboardView.relatedView = nextButton
		
		inputImeiTipLabel.text = "add_device_input_imei_under_device".lc_T
		inputImeiTextField.placeholder = "add_device_input_imei".lc_T
		imeiTipLabel.text = "add_device_input_imei_by_user_tip".lc_T
		
		nextButton.setTitle("common_next".lc_T, for: .normal)
		imeiImageView.image = UIImage(named: "adddevice_pic_imei")
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	private func setupCustomContens() {
		
	}
	
	private func setupTextFiledStyle(textField: UITextField) {
		textField.backgroundColor = UIColor.clear
		textField.layer.borderWidth = 0.5
		textField.layer.borderColor = UIColor.dhcolor_c8().cgColor
		textField.autocapitalizationType = .allCharacters
		textField.keyboardType = .asciiCapable
		textField.leftViewMode = .always
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 45))
	}
	
	@IBAction func onNextAction(_ sender: Any) {
		inputImeiTextField.resignFirstResponder()
		
		//【*】保存IMEI
		DHAddDeviceManager.sharedInstance.imeiCode = inputImeiTextField.text ?? ""
		
        addDeviceStartLog()
        
		//【*】跳转NB检查界面
		let checkVc = DHNBCheckViewController()
		navigationController?.pushViewController(checkVc, animated: true)
	}
    
    private func addDeviceStartLog() {
        let manager = DHAddDeviceManager.sharedInstance
        let dictStr = "{SN: \(manager.deviceId), SC: \(manager.initialPassword), imeiCode: \(manager.imeiCode)}"
        let model = DHAddDeviceLogModel()
        model.bindDeviceType = StartAddType.SN
        model.inputData = dictStr
        DHAddDeviceLogManager.shareInstance.addDeviceStartLog(model: model)
    }
}
