//
//  Copyright © 2018年 Imou. All rights reserved.
//	手动输入序列号

import UIKit

fileprivate let kMinScCodeLength = 6
fileprivate let kMaxScCodeLength = 8
fileprivate let kMinDeviceIdLength = 10
fileprivate let kMaxDeviceIdLength = 32

class LCInputSNViewController: LCAddBaseViewController, LCIdentifyContainerProtocol {
	
    
    public static func storyboardInstance() -> LCInputSNViewController {
        let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "LCInputSNViewControllerSID") as? LCInputSNViewController {
            return controller
        }
        return LCInputSNViewController()
    }
	
	@IBOutlet weak var snTipLabel: UILabel!
	@IBOutlet weak var qrCodeImageView: UIImageView!
	@IBOutlet weak var inputSnTextField: LCTextField!
	@IBOutlet weak var boxTipLabel: UILabel!
	@IBOutlet weak var nextStepButton: UIButton!
	@IBOutlet weak var autoKeyboardView: LCAutoKeyboardView!
	@IBOutlet weak var inputScTextField: LCTextField!
	@IBOutlet weak var scTipLabel: UILabel!
	@IBOutlet weak var qrImageHeightConstraint: NSLayoutConstraint!
	
    public var qrCodeScanFailedClosure: (() -> Void)? = nil
    
	// MARK: Life Cycles
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lccolor_c43()
		self.title = "add_device_title".lc_T()
		setupCustomContens()
//        self.btnNaviRight.isHidden = true
        // Do any additional setup after loading the view.
        
        //⚠️ 二维码扫描失败进入到手动输入SN界面会走这个closure
        self.qrCodeScanFailedClosure?()
        
		//按钮样式配置
		nextStepButton.layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
		nextStepButton.backgroundColor = LCModuleConfig.shareInstance().commonButtonColor()
		
        //颜色规范
        snTipLabel.textColor = UIColor.lccolor_c2()
        boxTipLabel.textColor = UIColor.lccolor_c5()
        scTipLabel.textColor = UIColor.lccolor_c5()
        nextStepButton.setTitleColor(UIColor.lccolor_c43(), for: .normal)
        
		setupTextFiledStyle(textField: inputSnTextField)
		setupTextFiledStyle(textField: inputScTextField)
		
		//海外输入限制处理，国内不需要进行限制
        if (!LCApplicationDataManager.isChinaMainland()) {
            inputSnTextField.lc_setInputRule(withRegEx: "^[A-Za-z0-9:-]$", andInputLength: UInt32(kMaxDeviceIdLength))
            inputScTextField.lc_setInputRule(withRegEx: "^[A-Za-z0-9:-]$", andInputLength: UInt32(kMaxScCodeLength))
        }
		
		nextStepButton.lc_enable = false
		inputSnTextField.textChanged = { [weak self] text in
            
            guard let `self` = self else {
                return
            }
            
			let snText = text ?? ""
			
			//【*】SMB不限制SC码位数
			self.nextStepButton.lc_enable = snText.count >= kMinDeviceIdLength
		}
		
		inputScTextField.textChanged = { [weak self] text in
            
            guard let `self` = self else {
                return
            }
            
			let snCount = self.inputSnTextField.text?.count ?? 0

			//【*】SMB不限制SC码位数
			self.nextStepButton.lc_enable = snCount >= kMinDeviceIdLength
		}
		
		autoKeyboardView.relatedView = nextStepButton
		
		//5s小屏手机兼容
		if lc_screenHeight < 667 {
			qrImageHeightConstraint.constant = 180
		}
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
	}
	
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		//每次都要重置
		LCAddDeviceManager.sharedInstance.reset()
    }
    
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
        
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	private func setupCustomContens() {
        
		snTipLabel.text = "add_device_input_sn_under_device".lc_T()
		inputSnTextField.placeholder = "add_device_input_sn".lc_T()
		nextStepButton.setTitle("common_next".lc_T(), for: .normal)
		inputScTextField.placeholder = "add_device_input_sccode".lc_T()
		
		//SMB特性：不显示乐盒
		boxTipLabel.text = ""
		scTipLabel.text = "add_device_without_input_sccode_tip".lc_T()
		
		qrCodeImageView.image = UIImage(lc_named: "adddevice_pic_serialnumber")
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
	
	//MAKR: Actions
	@IBAction func onNextAction(_ sender: Any) {
		//SMB逻辑与海外一致，8位或不输入
		let scCode = inputScTextField.text ?? ""
		
		//判断是否是8位的安全验证码
		if scCode.count == kMaxScCodeLength {
			LCAddDeviceManager.sharedInstance.initialPassword = scCode
			LCAddDeviceManager.sharedInstance.isSupportSC = true
            LCAddDeviceManager.sharedInstance.isManualInputSC = true
		}
		
		inputSnTextField.resignFirstResponder()
		inputScTextField.resignFirstResponder()
		
		//统一转换成大写
		let deviceId = inputSnTextField.text ?? ""
		let presenter = LCIdentifyPresenter()
		presenter.setup(container: self)
        // 添加productId
        presenter.getDeviceInfo(deviceId: deviceId.uppercased(), productId: nil, qrModel: nil, ncCode: nil, marketModel: nil, manualCheckCode: scCode)
        
        addDeviceStartLog(deviceId: deviceId, scCode: scCode)
	}
	
    private func addDeviceStartLog(deviceId: String, scCode: String) {
        let dictStr = "{SN: \(deviceId), SC: \(scCode), imeiCode: \("")}"
        let model = LCAddDeviceLogModel()
        model.bindDeviceType = StartAddType.SN
        model.inputData = dictStr
        LCAddDeviceLogManager.shareInstance.addDeviceStartLog(model: model)
    }
    
	// MARK: LCIdentifyContainerProtocol
	func navigationVC() -> UINavigationController? {
		return self.navigationController
	}
	
	func mainView() -> UIView {
		return self.view
	}
	
	func mainController() -> UIViewController {
		return self
	}
	
	func pauseIdentify() {
		
	}
	
	func resumeIdenfity() {
		
	}
    
	func retry() {
		
	}
	
	override func isRightActionHidden() -> Bool {
		return true
	}
    
    func smb_updateUI(deviceInfo: LCUserDeviceBindInfo) {
        
    }
}
