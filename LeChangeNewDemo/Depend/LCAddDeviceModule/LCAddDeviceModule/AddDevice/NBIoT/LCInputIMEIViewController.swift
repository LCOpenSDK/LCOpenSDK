//
//  Copyright © 2019 Imou. All rights reserved.
//	IMEI码输入界面

import UIKit
import LCBaseModule

fileprivate let kMinIMEILength = 15
fileprivate let kMaxIMEILength = 17

class LCInputIMEIViewController: LCAddBaseViewController {

	public static func storyboardInstance() -> LCInputIMEIViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "LCInputIMEIViewController") as? LCInputIMEIViewController {
            return controller
        }
		return LCInputIMEIViewController()
	}
	
	@IBOutlet weak var autoKeyboardView: LCAutoKeyboardView!
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
		view.backgroundColor = UIColor.lccolor_c43()
		self.title = "add_device_title".lc_T
		setupCustomContens()
		
		// Do any additional setup after loading the view.
		// 进入NB配网，不需要进行局域网搜索
		LCNetSDKSearchManager.sharedInstance()?.stopSearch()
		
		//按钮样式配置
		nextButton.layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
		nextButton.backgroundColor = LCModuleConfig.shareInstance().commonButtonColor()
		
		//颜色规范
		inputImeiTipLabel.textColor = UIColor.lccolor_c2()
		imeiTipLabel.textColor = UIColor.lccolor_c5()
		nextButton.setTitleColor(UIColor.lccolor_c43(), for: .normal)
		nextButton.lc_enable = false
		
		setupTextFiledStyle(textField: inputImeiTextField)
		inputImeiTextField.lc_setInputRule(withRegEx: nil, andInputLength: UInt32(kMaxIMEILength))
		inputImeiTextField.textChanged = { [unowned self] text in
			let imei = text ?? ""
			self.nextButton.lc_enable = imei.count >= kMinIMEILength
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
		textField.layer.borderColor = UIColor.lccolor_c8().cgColor
		textField.autocapitalizationType = .allCharacters
		textField.keyboardType = .asciiCapable
		textField.leftViewMode = .always
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 45))
	}
	
	@IBAction func onNextAction(_ sender: Any) {
		inputImeiTextField.resignFirstResponder()
		
		//【*】保存IMEI
		LCAddDeviceManager.sharedInstance.imeiCode = inputImeiTextField.text ?? ""
		
        addDeviceStartLog()
        
		//【*】跳转NB检查界面
		let checkVc = LCNBCheckViewController()
		navigationController?.pushViewController(checkVc, animated: true)
	}
    
    private func addDeviceStartLog() {
        let manager = LCAddDeviceManager.sharedInstance
        let dictStr = "{SN: \(manager.deviceId), SC: \(manager.initialPassword), imeiCode: \(manager.imeiCode)}"
        let model = LCAddDeviceLogModel()
        model.bindDeviceType = StartAddType.SN
        model.inputData = dictStr
        LCAddDeviceLogManager.shareInstance.addDeviceStartLog(model: model)
    }
}
