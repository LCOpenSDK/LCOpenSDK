//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	无线配置、软AP配置：WIFI密码输入

import UIKit
import LCBaseModule
import CoreLocation
import AFNetworking

class LCWifiPasswordViewController: LCAddBaseViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wifiNameLabel: UILabel!
	@IBOutlet weak var passwordInputView: LCInputView!
	@IBOutlet weak var checkButton: UIButton!
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var supportTipButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
	@IBOutlet weak var autoKeyboardView: UIView!
    @IBOutlet weak var switchWifiBtn: UIButton!
    
    private var isSelected: Bool = false
    private var presenter: LCWifiPasswordPresenterProtocol?
	
	public static func storyboardInstance() -> LCWifiPasswordViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
		let controller = storyboard.instantiateViewController(withIdentifier: "LCWifiPasswordViewController")
		return controller as! LCWifiPasswordViewController
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.setupCustomContents()
		self.setupInputView()
        
        //通过Presenter设置
        self.presenter?.setupSupportView()
        
        self.title = ""
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter?.updateContainerViewByNetwork()
        if isSelected == true {
            checkButton.isSelected = true
        }
    }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.view.endEditing(true)
		
		//统一在页面消失时处理记住密码
		checkSavePassword()
	}
	
	override func onLeftNaviItemClick(_ button: UIButton) {
		//重写左键返回，上一步如果是检查WIFI入口进来的，需要返回到更上一级【由于有自动检查的步骤】
		var checkWifiVc: UIViewController?
		var controllers = baseStackContainControllers()

		if checkWifiVc != nil {
			let index = controllers.index(of: checkWifiVc!)
			controllers.remove(at: index!)
			navigationController?.setViewControllers(controllers, animated: false)
		}
		
		navigationController?.popViewController(animated: true)
	}
	
	func baseStackContainControllers() -> [UIViewController] {
		var controllers: [UIViewController] = [UIViewController]()
		if let naviVc = self.navigationController as? LCNavigationController {
			controllers.append(contentsOf: naviVc.viewControllers)
		}
		return controllers
	}
    
    public func setup(presenter: LCWifiPasswordPresenterProtocol) {
        self.presenter = presenter
    }

	func setupCustomContents() {
        if LCAddDeviceManager.sharedInstance.isSupport5GWifi {
            supportTipButton.isHidden = true
            helpButton.isHidden = true
        }
		wifiNameLabel.text = nil
		checkButton.setTitle("add_device_remember_password".lc_T(), for: .normal)
		supportTipButton.setTitle("add_device_iot_wifi_2_4g_only".lc_T(), for: .normal)
		passwordInputView.textField.placeholder = "add_device_input_wifi_password".lc_T()
		nextButton.setTitle("common_next".lc_T(), for: .normal)
        passwordInputView.tfUnSecureImg = UIImage(lc_named: "login_icon_openeye_click")
        passwordInputView.tfSecureImg = UIImage(lc_named: "login_icon_closeeye_click")
        titleLabel.text = "add_device_connect_wifi".lc_T()
        
        //设置颜色规范
		passwordInputView.textField.textColor = UIColor.lccolor_c2()
        passwordInputView.switchEnable = true;
		wifiNameLabel.textColor = UIColor.lccolor_c2()
        supportTipButton.setTitleColor(UIColor.lccolor_c2(), for: .normal)
        checkButton.setTitleColor(UIColor.lccolor_c5(), for: .normal)
        
		switchWifiBtn.setImage(UIImage(lc_named: "adddevice_wifi_refresh"), for: .normal)
		checkButton.setImage(UIImage(lc_named: "adddevice_box_checkbox"), for: .normal)
		checkButton.setImage(UIImage(lc_named: "adddevice_box_checkbox_checked"), for: .selected)
		
		//按钮样式配置
		nextButton.layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
		nextButton.backgroundColor = LCModuleConfig.shareInstance().commonButtonColor()
        nextButton.setTitleColor(UIColor.lccolor_c43(), for: .normal)
		
		//支持多行显示
		checkButton.titleLabel?.numberOfLines = 2
		supportTipButton.titleLabel?.numberOfLines = 2

	}
	
	func setupInputView() {
        helpButton.setImage(UIImage(lc_named: "adddevice_icon_help"), for: UIControlState.normal)
		passwordInputView.textField.returnKeyType = .done
		passwordInputView.textField.delegate = self
	}
	
	// MARK: Actions
	@IBAction func onCheckAction(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
		
		//【*】清除当前对应的WIFI密码
		if checkButton.isSelected == false, let ssid = wifiNameLabel.text {
			LCUserManager.shareInstance().removeSSID(ssid)
		}
        
        isSelected = sender.isSelected
	}
	
    @IBAction func onWifiSwitchAction(_ sender: Any) {
        print("LCWifiPasswordViewController onWifiSwitchAction")
        if UIApplication.shared.canOpenURL(URL(string: "prefs:root=WIFI")!) {
            UIApplication.shared.open(URL(string: "prefs:root=WIFI")!)
        } else {
            UIApplication.shared.open(URL(string: "App-Prefs:root=WIFI")!)
        }
    }
    
    @IBAction func onSupportTipAction(_ sender: Any) {
        let sheet = LCSheetGuideView(title: "add_device_connect_2_4g_wifi".lc_T(), message: "add_device_connect_2_4g_wifi_explain".lc_T(), image: nil, cancelButtonTitle: "Alert_Title_Button_Confirm1".lc_T())
        sheet.show()
//		let supportVc = LCWiFiUnsupportVC()
//		self.navigationController?.pushViewController(supportVc, animated: true)
	}
	
	@IBAction func onNextAction(_ sender: Any) {
        
        if #available(iOS 13.0, *) {
            let status = CLLocationManager.authorizationStatus()
            if status == .denied {
                //弹框提示
                LCProgressHUD.showMsg("turn_on_mobile_phone_positioning".lc_T())
                return
            }
        }
        
		if LCNetWorkHelper.sharedInstance().emNetworkStatus != AFNetworkReachabilityStatus.reachableViaWiFi.rawValue {
			LCProgressHUD.showMsg("add_devices_smartconfig_msg_no_wifi".lc_T())
		} else {
			
			self.view.endEditing(true)
			
			//解释器处理下一步
			self.presenter?.nextStepAction(wifiSSID: wifiNameLabel.text ?? "", wifiPassword: passwordInputView.textField.text ?? "")
		}
	}
	
	@IBAction func onWifiDetectAction(_ sender: Any) {
		self.view.endEditing(true)
		
		var infoDic = [String: Any]()
		infoDic["currentVC"] = self

		if let vc: UIViewController = LCRouter.object(forURL: "/lechange/wifidetection/page", withUserInfo: infoDic) as? UIViewController {
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	func checkSavePassword() {
		let wifiSSID = wifiNameLabel.text
		let wifiPassword = passwordInputView.textField.text
		LCAddDeviceManager.sharedInstance.wifiSSID = wifiSSID
		LCAddDeviceManager.sharedInstance.wifiPassword = wifiPassword
		
		//统一下一步记住密码
		if checkButton.isSelected, wifiSSID != nil, wifiPassword != nil {
			LCUserManager.shareInstance().addSSID(wifiSSID, ssidPwd: wifiPassword)
		}
		
		isSelected = checkButton.isSelected
	}
	
	// MARK: LCAddBaseVCProtocol
//    override func rightActionType() -> [LCAddBaseRightAction] {
//        var actions: [LCAddBaseRightAction] = [.restart]
//        
//        //软AP等复用情况下，不切换到有线
//        let manager = LCAddDeviceManager.sharedInstance
//        if manager.netConfigMode == .wifi, manager.supportConfigModes.contains(.wired) {
//            actions.append(.switchToWired)
//        }
//        
//        return actions
//    }
}

extension LCWifiPasswordViewController {
	
	// MARK: UITextFieldDelegate
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
