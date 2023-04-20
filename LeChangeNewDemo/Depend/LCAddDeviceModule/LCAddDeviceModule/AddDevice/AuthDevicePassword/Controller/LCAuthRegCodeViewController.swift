//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

import UIKit

class LCAuthRegCodeViewController: LCAddBaseViewController, UITextFieldDelegate, LCBindContainerProtocol {

	public static func storyboardInstance() -> LCAuthRegCodeViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "LCAuthRegCodeViewController") as? LCAuthRegCodeViewController {
            return controller
        }
		return LCAuthRegCodeViewController()
	}

	private lazy var bindPresenter: LCBindPresenter = {
		let presenter = LCBindPresenter()
		return presenter
	}()
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var tipLabel: UILabel!
	@IBOutlet weak var inputCodeTxf: LCTextField!
	@IBOutlet weak var nextButton: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupContents()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	private func setupContents() {
        view.backgroundColor = UIColor.lccolor_c43()
        
        tipLabel.textColor = UIColor.lccolor_c2()
        
		imageView.image = UIImage(lc_named: "adddevice_pic_safetycode")
		
		inputCodeTxf.backgroundColor = UIColor.lccolor_c43()
		inputCodeTxf.layer.borderColor = UIColor.lccolor_c8().cgColor
		inputCodeTxf.layer.borderWidth = 0.5
		inputCodeTxf.placeholder = "add_device_input_safe_code".lc_T()
		
		nextButton.layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
		nextButton.backgroundColor = LCModuleConfig.shareInstance().commonButtonColor()
        nextButton.setTitleColor(UIColor.lccolor_c43(), for: .normal)
		
		nextButton.lc_enable = false
		inputCodeTxf.lc_setInputRule(withRegEx: "^[A-Za-z0-9]$", andInputLength: 6)
		inputCodeTxf.delegate = self
		inputCodeTxf.keyboardType = .asciiCapable
		inputCodeTxf.returnKeyType = .done
		inputCodeTxf.leftViewMode = .always
		inputCodeTxf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 45))
		
		inputCodeTxf.textChanged = { [unowned self] text in
			let password = text ?? ""
			self.nextButton.lc_enable = password.count > 0
		}
	}

	@IBAction func onNextAction(_ sender: Any) {
		let regCode = inputCodeTxf.text ?? ""
		bindPresenter.setup(container: self)
        
		bindPresenter.bindDevice(devicePassword: LCAddDeviceManager.sharedInstance.initialPassword, code: regCode, deviceKey: regCode, showLoading: true, showErrorTip: true) { (_) in
			
		}
	}
}

extension LCAuthRegCodeViewController {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

extension LCAuthRegCodeViewController {
	
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
