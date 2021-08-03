//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

import UIKit

class DHAuthRegCodeViewController: DHAddBaseViewController, UITextFieldDelegate, DHBindContainerProtocol {

	public static func storyboardInstance() -> DHAuthRegCodeViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.dh_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "DHAuthRegCodeViewController") as? DHAuthRegCodeViewController {
            return controller
        }
		return DHAuthRegCodeViewController()
	}

	private lazy var bindPresenter: DHBindPresenter = {
		let presenter = DHBindPresenter()
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
        view.backgroundColor = UIColor.dhcolor_c43()
        
        tipLabel.textColor = UIColor.dhcolor_c2()
        
		imageView.image = UIImage(named: "adddevice_pic_safetycode")
		
		inputCodeTxf.backgroundColor = UIColor.dhcolor_c43()
		inputCodeTxf.layer.borderColor = UIColor.dhcolor_c8().cgColor
		inputCodeTxf.layer.borderWidth = 0.5
		inputCodeTxf.placeholder = "add_device_input_safe_code".lc_T
		
		nextButton.layer.cornerRadius = DHModuleConfig.shareInstance().commonButtonCornerRadius()
		nextButton.backgroundColor = DHModuleConfig.shareInstance().commonButtonColor()
        nextButton.setTitleColor(UIColor.dhcolor_c43(), for: .normal)
		
		nextButton.dh_enable = false
		inputCodeTxf.lc_setInputRule(withRegEx: "^[A-Za-z0-9]$", andInputLength: 6)
		inputCodeTxf.delegate = self
		inputCodeTxf.keyboardType = .asciiCapable
		inputCodeTxf.returnKeyType = .done
		inputCodeTxf.leftViewMode = .always
		inputCodeTxf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 45))
		
		inputCodeTxf.textChanged = { [unowned self] text in
			let password = text ?? ""
			self.nextButton.dh_enable = password.count > 0
		}
	}

	@IBAction func onNextAction(_ sender: Any) {
		let regCode = inputCodeTxf.text ?? ""
		bindPresenter.setup(container: self)
        
		bindPresenter.bindDevice(devicePassword: DHAddDeviceManager.sharedInstance.initialPassword, code: regCode, deviceKey: regCode, showLoading: true, showErrorTip: true) { (_) in
			
		}
	}
}

extension DHAuthRegCodeViewController {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

extension DHAuthRegCodeViewController {
	
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
