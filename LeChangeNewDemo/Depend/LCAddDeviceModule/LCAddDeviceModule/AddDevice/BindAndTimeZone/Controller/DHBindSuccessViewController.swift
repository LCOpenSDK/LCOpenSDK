//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

import UIKit

class DHBindSuccessViewController: DHAddBaseViewController, UITextFieldDelegate, UITextViewDelegate {
	
	/// 设备绑定成功后返回的名称 
	public var deviceName: String = ""
    
    /// 设备绑定成功后返回的名称
    public var successInfo: DHBindDeviceSuccess?
	
	/// 是否配置时区
	private var showTimezoneSetting: Bool = false
	
	public static func storyboardInstance() -> DHBindSuccessViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.dh_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "DHBindSuccessViewController") as? DHBindSuccessViewController {
            return controller
        }
		return DHBindSuccessViewController()
	}
	
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var autoKeyboardView: DHAutoKeyboardView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	@IBOutlet weak var textField: LCTextField!
	@IBOutlet weak var confirmButton: UIButton!
	@IBOutlet weak var bindSuccessImageView: UIImageView!
	
    lazy var alramEnableBtn: UIButton = {
        let alramEnableBtn = UIButton(type: .custom)
        alramEnableBtn.setImage(UIImage(named: "adddevice_box_checkbox"), for: .normal)
        alramEnableBtn.setImage(UIImage(named: "adddevice_box_checkbox_checked"), for: .selected)
        alramEnableBtn.setTitle("add_device_enable_motion_detect".lc_T, for: .normal)
        alramEnableBtn.setTitle("add_device_enable_motion_detect".lc_T, for: .selected)
        alramEnableBtn.setTitleColor(UIColor.dhcolor_c5(), for: .normal)
        alramEnableBtn.setTitleColor(UIColor.dhcolor_c5(), for: .selected)
        alramEnableBtn.isSelected = true
        alramEnableBtn.addTarget(self, action: #selector(self.alramEnableBtnClicked(_:)), for: .touchUpInside)
        alramEnableBtn.titleLabel?.textAlignment = .left
        return alramEnableBtn
    }()
	
	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dhcolor_c43()
		//根据设备类型设置夏令时显示/隐藏
		//【*】配件、p2p设备不展示
		//【*】国内不展示
		let manager = DHAddDeviceManager.sharedInstance
        if manager.isAccessory
            || manager.accessType == .p2p
            || DHModuleConfig.shareInstance().isLeChange
            || manager.deviceModel.contains("DS11") {
			showTimezoneSetting = false
		}

		//进入添加成功界面，停止搜索
		DHNetSDKSearchManager.sharedInstance().stopSearch()

        // Do any additional setup after loading the view.
        setupNaviRightItem()
		configSubViews()
		configTimezoneView()
		updateSuccessImage()
		baseAddOMSIntroductionObserver()
        completeDeviceAddObserver()
		setupCustomContents()
		
		// 大华通用设备，3.9.5去掉配件
		if DHModuleConfig.shareInstance().isLeChange, manager.brand.lowercased() == "general", manager.isAccessory == false {
			view.addSubview(alramEnableBtn)
			alramEnableBtn.snp.makeConstraints { (make) in
				make.left.equalTo(15.0)
				make.top.equalTo(self.textField.snp.bottom).offset(25.0)
			}
		}

        addDeviceEndSuccessLog()
		
		//页面访问次数 ad-connect-platform1、ad-connect-platform2，只有包含配网流程才处理
		guard DHAddDeviceManager.sharedInstance.isContainNetConfig else {
			return
		}
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func updateSuccessImage() {
		let imageUrl = DHAddDeviceManager.sharedInstance.getIntroductionParser()?.doneInfo.imageUrl
		let placeholder = DHAddDeviceManager.sharedInstance.isAccessory ? DHAccessoryDoneDefault.imagename : DHIPCDoneDefault.imagename
		imageView.lc_setImage(withUrl: imageUrl, placeholderImage: placeholder, toDisk: true)
	}
	
	private func setupCustomContents() {
        lineView.backgroundColor = UIColor.dhcolor_c8()
		textField.placeholder = "add_device_please_input_device_name".lc_T
		contentLabel.text = "add_device_add_successfully".lc_T
        contentLabel.textColor = UIColor.dhcolor_c2()
		detailLabel.text = "add_device_name_for_device".lc_T
        detailLabel.textColor = UIColor.dhcolor_c5()
		confirmButton.setTitle("add_device_done".lc_T, for: .normal)
        confirmButton.setTitleColor(UIColor.dhcolor_c43(), for: .normal)
	}
	
	private func configSubViews() {
		confirmButton.layer.cornerRadius = DHModuleConfig.shareInstance().commonButtonCornerRadius()
		confirmButton.backgroundColor = DHModuleConfig.shareInstance().commonButtonColor()
		
		imageView.backgroundColor = UIColor.clear
		imageView.image = UIImage(named: "adddevice_device_default")
		bindSuccessImageView.image = UIImage(named: "adddevice_icon_success")
		textField.lc_setInputRule(withRegEx: "^[A-Za-z0-9\u{4e00}-\u{9fa5}\\-@_ ]+$", andInputLength: UInt32(20))
		textField.delegate = self
		textField.returnKeyType = .done
		textField.text = deviceName
		confirmButton.dh_enable = deviceName.count > 0
		textField.textChanged = { [unowned self] text in
			let name = text ?? ""
			self.confirmButton.dh_enable = name.count > 0
		}
		
		autoKeyboardView.relatedView = textField
	}
	
	private func configTimezoneView() {
		
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
    
    @objc func alramEnableBtnClicked(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
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
		let manager = DHAddDeviceManager.sharedInstance
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
		if DHModuleConfig.shareInstance().isLeChange, manager.channelNum == "1" {
			channelId = "0"
		}
        LCDeviceManagerInterface.modifyDevice(forDevice: deviceId, channel: channelId, newName: name, success: {
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
        let model = DHAddDeviceLogModel()
        model.res = ResType.Success.rawValue
        model.errCode = CodeType.Success.rawValue
        model.dese = DescType.Success.rawValue
        DHAddDeviceLogManager.shareInstance.addDeviceEndLog(model: model)
    }
    
	// MARK: Actions
    @objc func onShareAction() {
		
    }
	
	@IBAction func onModifyPasswordAction(_ sender: Any) {
		
	}
	
	// MARK: DHAddBaseVCProtocol
	override func leftActionType() -> DHAddBaseLeftAction {
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
		//【*】海外设备共享
		if DHModuleConfig.shareInstance()?.isLeChange == false {
            let manager = DHAddDeviceManager.sharedInstance
            if manager.isAccessory
                || DHModuleConfig.shareInstance().isLeChange
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
	
	// MARK: DHAddBaseVCProtocol(OMS Introduction)
	override func needUpdateCurrentOMSIntroduction() {
		LCProgressHUD.hideAllHuds(self.view)
		let parser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
		if parser != nil {
			self.updateSuccessImage()
		}
	}
    
    override func completeDeviceAddObserverHandle(notifaction: NSNotification) {
        self.handleExitAddDevice()
    }
}

extension DHBindSuccessViewController {
	
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

extension DHBindSuccessViewController {
	
	func updateDeviceLocalName(name: String, deviceId: String) {
		//通过DHMoudle发送事件
		var userInfo = [String: Any]()
		userInfo["deviceId"] = deviceId
		userInfo["name"] = name
		
		//修改名称成功后，再次刷新列表【后期优化，可以考虑用更新单个设备信息接口】
		DHAddDeviceManager.sharedInstance.postUpdateDeviceNotification()
	}
}
