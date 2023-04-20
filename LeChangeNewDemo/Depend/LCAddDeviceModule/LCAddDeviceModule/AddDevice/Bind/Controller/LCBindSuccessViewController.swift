//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

import UIKit

class LCBindSuccessViewController: LCAddBaseViewController, UITextFieldDelegate, UITextViewDelegate {
	
	/// 设备绑定成功后返回的名称 
	public var deviceName: String = ""
    
    /// 设备绑定成功后返回的名称
    public var successInfo: LCBindDeviceSuccess?

	public static func storyboardInstance() -> LCBindSuccessViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "LCBindSuccessViewController") as? LCBindSuccessViewController {
            return controller
        }
		return LCBindSuccessViewController()
	}
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	@IBOutlet weak var nameInputView: LCInputView!
	@IBOutlet weak var confirmButton: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""

		configSubViews()
		setupCustomContents()
        addDeviceEndSuccessLog()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func setupCustomContents() {
        nameInputView.textField.placeholder = self.deviceName
		contentLabel.text = "add_device_add_successfully".lc_T()
		detailLabel.text = "add_device_name_for_device".lc_T()
		confirmButton.setTitle("add_device_done".lc_T(), for: .normal)
	}
	
	private func configSubViews() {
		confirmButton.layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
		confirmButton.backgroundColor = LCModuleConfig.shareInstance().commonButtonColor()
		imageView.image = UIImage(lc_named: "adddevice_sucess")
        nameInputView.textField.lc_setInputRule(withRegEx: "^[A-Za-z0-9\u{4e00}-\u{9fa5}\\-@_ ]+$", andInputLength: UInt32(20))
        nameInputView.textField.delegate = self
        nameInputView.textField.returnKeyType = .done
        nameInputView.textField.text = deviceName
        nameInputView.textField.isSecureTextEntry = false
		confirmButton.lc_enable = deviceName.count > 0
        nameInputView.textField.textChanged = { [unowned self] text in
			let name = text ?? ""
			self.confirmButton.lc_enable = name.count > 0
		}
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	@IBAction func onConfirmAction(_ sender: Any) {
        nameInputView.textField.resignFirstResponder()
		doConfirmBusiness()
	}
	
	private func doConfirmBusiness() {
		//【*】检查夏令时是否合理
		//【*】设备名称修改需要进行提示
		//【*】时区信息修改后台默默处理
		modifyDeviceName()
	}
    
    private func doPushToFreeCloudStorageViewController() {
		self.handleExitAddDevice()
    }
	
	private func modifyDeviceName() {
		let manager = LCAddDeviceManager.sharedInstance
		let deviceId = manager.deviceId
		
		//【*】去除白空格
        let text = nameInputView.textField.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
		let name = text.count > 0 ? text : deviceId
		
		//如果没有修改过名称，则不下发接口，直接走成功处理
		if deviceName == name {
			doPushToFreeCloudStorageViewController()
			return
		}
		
		LCProgressHUD.show(on: self.view)
		
		var channelId: String = ""
		
		// 国内：单通道设备，同步修改通道名称
		if LCModuleConfig.shareInstance().isChinaMainland, manager.channelNum == "1" {
			channelId = "0"
		}
        LCDeviceManagerInterface.modifyDevice(forDevice: deviceId, productId: manager.productId, channel: channelId, newName: name, success: {
            LCProgressHUD.hideAllHuds(self.view)
            self.updateDeviceLocalName(name: name, deviceId: deviceId)
            self.doPushToFreeCloudStorageViewController()
        }) { (error) in
            LCProgressHUD.hideAllHuds(self.view)
            error.showTips("device_settings_wifi_config_save_failed".lc_T())
        }
		
	}
	
	/// 退出流程处理，海外：成功或者返回，退出到主页
	private func handleExitAddDevice() {
		self.baseExitAddDevice(showAlert: false)
	}
	
    private func addDeviceEndSuccessLog() {
        let model = LCAddDeviceLogModel()
        model.res = ResType.Success.rawValue
        model.errCode = CodeType.Success.rawValue
        model.dese = DescType.Success.rawValue
        LCAddDeviceLogManager.shareInstance.addDeviceEndLog(model: model)
    }
    
	// MARK: Actions
    @objc func onShareAction() {
		
    }
	
	@IBAction func onModifyPasswordAction(_ sender: Any) {
		
	}
	
	// MARK: LCAddBaseVCProtocol
	override func leftActionType() -> LCAddBaseLeftAction {
		return .quit
	}
	
	override func isRightActionHidden() -> Bool {
		return false
	}
    
	// MARK: 重写返回事件处理，比较特殊，
	override func onLeftNaviItemClick(_ button: UIButton) {
		if self.isLeftActionShowAlert() {
			self.showQuitAlert { [unowned self] in
				self.handleExitAddDevice()
			}
		} else {
			self.handleExitAddDevice()
		}
	}
}

extension LCBindSuccessViewController {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string != "" && !string.isVaildDeviceName() {
            return false;
        }
        
		//不允许输入以空格开头的
		if textField.text == nil || textField.text!.count == 0 {
			return string != " "
		}
		
        
		return true
	}
}

extension LCBindSuccessViewController {
	
	func updateDeviceLocalName(name: String, deviceId: String) {
		//通过LCMoudle发送事件
		var userInfo = [String: Any]()
		userInfo["deviceId"] = deviceId
		userInfo["name"] = name
	}
}
