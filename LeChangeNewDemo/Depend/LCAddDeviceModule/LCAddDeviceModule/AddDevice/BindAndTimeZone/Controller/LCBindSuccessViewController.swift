//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

import UIKit

class LCBindSuccessViewController: LCAddBaseViewController, UITextFieldDelegate, UITextViewDelegate {
	
	/// 设备绑定成功后返回的名称 
	public var deviceName: String = ""
    
    /// 设备绑定成功后返回的名称
    public var successInfo: LCBindDeviceSuccess?
	
	/// 是否配置时区
	private var showTimezoneSetting: Bool = false
	
	public static func storyboardInstance() -> LCBindSuccessViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "LCBindSuccessViewController") as? LCBindSuccessViewController {
            return controller
        }
		return LCBindSuccessViewController()
	}
	
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var autoKeyboardView: LCAutoKeyboardView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	@IBOutlet weak var textField: LCTextField!
	@IBOutlet weak var confirmButton: UIButton!
	@IBOutlet weak var bindSuccessImageView: UIImageView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lccolor_c43()
		//根据设备类型设置夏令时显示/隐藏
		//【*】配件、p2p设备不展示
		//【*】国内不展示
		let manager = LCAddDeviceManager.sharedInstance
        if manager.isAccessory
            || manager.accessType == .p2p
            || LCModuleConfig.shareInstance().isChinaMainland
            || manager.deviceModel.contains("DS11") {
			showTimezoneSetting = false
		}

		//进入添加成功界面，停止搜索
		LCNetSDKSearchManager.sharedInstance().stopSearch()

        // Do any additional setup after loading the view.
        setupNaviRightItem()
		configSubViews()
		configTimezoneView()
		updateSuccessImage()
		baseAddOMSIntroductionObserver()
        completeDeviceAddObserver()
		setupCustomContents()
		
        addDeviceEndSuccessLog()
		
		//页面访问次数 ad-connect-platform1、ad-connect-platform2，只有包含配网流程才处理
		guard LCAddDeviceManager.sharedInstance.isContainNetConfig else {
			return
		}
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func updateSuccessImage() {
		let imageUrl = LCAddDeviceManager.sharedInstance.getIntroductionParser()?.doneInfo.imageUrl
		let placeholder = LCAddDeviceManager.sharedInstance.isAccessory ? LCAccessoryDoneDefault.imagename : LCIPCDoneDefault.imagename
		imageView.lc_setImage(withUrl: imageUrl, placeholderImage: placeholder, toDisk: true)
	}
	
	private func setupCustomContents() {
        lineView.backgroundColor = UIColor.lccolor_c8()
		textField.placeholder = "add_device_please_input_device_name".lc_T
		contentLabel.text = "add_device_add_successfully".lc_T
        contentLabel.textColor = UIColor.lccolor_c2()
		detailLabel.text = "add_device_name_for_device".lc_T
        detailLabel.textColor = UIColor.lccolor_c5()
		confirmButton.setTitle("add_device_done".lc_T, for: .normal)
        confirmButton.setTitleColor(UIColor.lccolor_c43(), for: .normal)
	}
	
	private func configSubViews() {
		confirmButton.layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
		confirmButton.backgroundColor = LCModuleConfig.shareInstance().commonButtonColor()
		
		imageView.backgroundColor = UIColor.clear
		imageView.image = UIImage(named: "adddevice_device_default")
		bindSuccessImageView.image = UIImage(named: "adddevice_icon_success")
		textField.lc_setInputRule(withRegEx: "^[A-Za-z0-9\u{4e00}-\u{9fa5}\\-@_ ]+$", andInputLength: UInt32(20))
		textField.delegate = self
		textField.returnKeyType = .done
		textField.text = deviceName
		confirmButton.lc_enable = deviceName.count > 0
		textField.textChanged = { [unowned self] text in
			let name = text ?? ""
			self.confirmButton.lc_enable = name.count > 0
		}
		
		autoKeyboardView.relatedView = textField
	}
	
	private func configTimezoneView() {
		
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	@IBAction func onConfirmAction(_ sender: Any) {
		textField.resignFirstResponder()
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
		let text = textField.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
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
            error.showTips("device_settings_wifi_config_save_failed".lc_T)
        }
		
	}
	
	/// 退出流程处理，海外：成功或者返回，退出到主页
	private func handleExitAddDevice() {
		self.baseExitAddDevice(showAlert: false, backToMain: true)
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
	
	override func isLeftActionShowAlert() -> Bool {
		return showTimezoneSetting
	}
	
	override func leftActionAlertText() -> String? {
		return "add_devices_time_zone_quit_hint".lc_T
	}
	
	override func isRightActionHidden() -> Bool {
		return false
	}
	
    override func setupNaviRightItem() {
//        btnNaviRight.isHidden = true
		//【*】海外设备共享
		if LCModuleConfig.shareInstance()?.isChinaMainland == false {
            let manager = LCAddDeviceManager.sharedInstance
            if manager.isAccessory
                || LCModuleConfig.shareInstance().isChinaMainland
                || manager.deviceModel.contains("DS11")
                || (manager.deviceMarketModel ?? "").contains("H1G") {
                return
            }
            
            btnNaviRight = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
            btnNaviRight.setImage(UIImage.init(named: "common_image_nav_share"), for: .normal)
            btnNaviRight.setImage(UIImage.init(named: "common_image_nav_share"), for: .highlighted)
            btnNaviRight.addTarget(self, action: #selector(onShareAction), for: .touchUpInside)
            let item = UIBarButtonItem(customView: btnNaviRight)
            self.navigationItem.lc_rightBarButtonItems = [item]

            
            btnNaviRight.isHidden = self.isRightActionHidden()
		}
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
	
	// MARK: LCAddBaseVCProtocol(OMS Introduction)
	override func needUpdateCurrentOMSIntroduction() {
		LCProgressHUD.hideAllHuds(self.view)
		let parser = LCAddDeviceManager.sharedInstance.getIntroductionParser()
		if parser != nil {
			self.updateSuccessImage()
		}
	}
    
    override func completeDeviceAddObserverHandle(notifaction: NSNotification) {
        self.handleExitAddDevice()
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
		
		//修改名称成功后，再次刷新列表【后期优化，可以考虑用更新单个设备信息接口】
		LCAddDeviceManager.sharedInstance.postUpdateDeviceNotification()
	}
}
