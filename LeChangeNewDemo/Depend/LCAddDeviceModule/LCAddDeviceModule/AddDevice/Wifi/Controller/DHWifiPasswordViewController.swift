//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	无线配置、软AP配置：WIFI密码输入

import UIKit
import LCBaseModule
import CoreLocation

class DHWifiPasswordViewController: DHAddBaseViewController, UITextFieldDelegate {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var inputPwdLabel: UILabel!
	@IBOutlet weak var wifiLabel: UILabel!
	@IBOutlet weak var wifiNameLabel: UILabel!
	@IBOutlet weak var passwordInputView: LCInputView!
	@IBOutlet weak var checkButton: UIButton!
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var supportView: UIView!
	@IBOutlet weak var supportTipButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
	@IBOutlet weak var autoKeyboardView: DHAutoKeyboardView!
    @IBOutlet weak var switchWifiBtn: UIButton!
    @IBOutlet weak var wifiNameTrailToSuperView: NSLayoutConstraint!
	@IBOutlet weak var wifiDetectButton: UIButton!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    private var isSelected: Bool = false
    private var presenter: DHWifiPasswordPresenterProtocol?
	@IBOutlet weak var checkWidthConstraint: NSLayoutConstraint!
	
	public static func storyboardInstance() -> DHWifiPasswordViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.dh_addDeviceBundle())
		let controller = storyboard.instantiateViewController(withIdentifier: "DHWifiPasswordViewController")
		return controller as! DHWifiPasswordViewController
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.setupCustomContents()
		self.setupInputView()
        
        //通过Presenter设置
        self.presenter?.setupSupportView()
		
		
		autoKeyboardView.relatedView = nextButton

		if DHAddDeviceManager.sharedInstance.netConfigMode == .softAp {
			switchWifiBtn.isHidden = true
			wifiNameTrailToSuperView.constant = 15
            
		}
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
		for vc in controllers {
			if let container = vc as? DHContainerVC, container.contentViewController is DHWifiCheckViewController {
				checkWifiVc = vc
				break
			}
		}
		
		if checkWifiVc != nil {
			let index = controllers.index(of: checkWifiVc!)
			controllers.remove(at: index!)
			navigationController?.setViewControllers(controllers, animated: false)
		}
		
		navigationController?.popViewController(animated: true)
	}
	
	func baseStackContainControllers() -> [UIViewController] {
		var controllers: [UIViewController] = [UIViewController]()
		if let naviVc = self.navigationController as? DHNavigationController, let stackControllers = naviVc.dh_viewContainers() {
			controllers.append(contentsOf: stackControllers)
		}
		return controllers
	}
    
    public func setup(presenter: DHWifiPasswordPresenterProtocol) {
        self.presenter = presenter
    }

	func setupCustomContents() {
		wifiNameLabel.text = nil
		inputPwdLabel.text = "add_device_input_wifi_password".lc_T
		wifiLabel.text = "add_device_wifi_ssid".lc_T
		checkButton.setTitle("add_device_remember_password".lc_T, for: .normal)
		supportTipButton.setTitle("add_device_device_not_support_5g".lc_T, for: .normal)
		passwordInputView.textField.placeholder = "add_device_input_wifi_password".lc_T
		nextButton.setTitle("common_next".lc_T, for: .normal)
		
        //设置颜色规范
		passwordInputView.textField.textColor = UIColor.dhcolor_c2()
		wifiNameLabel.textColor = UIColor.dhcolor_c2()
        wifiLabel.textColor = UIColor.dhcolor_c5()
        inputPwdLabel.textColor = UIColor.dhcolor_c2()
        supportTipButton.setTitleColor(UIColor.dhcolor_c2(), for: .normal)
        checkButton.setTitleColor(UIColor.dhcolor_c5(), for: .normal)
        topLine.backgroundColor = UIColor.dhcolor_c8()
        bottomLine.backgroundColor = UIColor.dhcolor_c8()
        
		switchWifiBtn.setImage(UIImage(named: "adddevice_icon_switchwifi"), for: .normal)
		checkButton.setImage(UIImage(named: "adddevice_box_checkbox"), for: .normal)
		checkButton.setImage(UIImage(named: "adddevice_box_checkbox_checked"), for: .selected)
		imageView.image = UIImage(named: "adddevice_icon_wifipassword")
		
		//按钮样式配置
		nextButton.layer.cornerRadius = DHModuleConfig.shareInstance().commonButtonCornerRadius()
		nextButton.backgroundColor = DHModuleConfig.shareInstance().commonButtonColor()
        nextButton.setTitleColor(UIColor.dhcolor_c43(), for: .normal)
		
		//支持多行显示
		checkButton.titleLabel?.numberOfLines = 2
		supportTipButton.titleLabel?.numberOfLines = 2
		supportView.backgroundColor = UIColor.clear
		
        wifiDetectButton.isHidden = true

	}
	
	func setupInputView() {
        helpButton.setImage(UIImage.init(named: "adddevice_icon_help"), for: UIControlState.normal)
		passwordInputView.backgroundColor = UIColor.clear
		passwordInputView.textField.returnKeyType = .done
		passwordInputView.textField.delegate = self
		
		//密码国内默认为明文，可点击隐藏，海外默认为暗文
		passwordInputView.openBtnState = DHModuleConfig.shareInstance().isLeChange
	}
	
	// MARK: Actions
	@IBAction func onCheckAction(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
		
		//【*】清除当前对应的WIFI密码
		if checkButton.isSelected == false, let ssid = wifiNameLabel.text {
			DHUserManager.shareInstance().removeSSID(ssid)
		}
        
        isSelected = sender.isSelected
	}
	
    @IBAction func onWifiSwitchAction(_ sender: Any) {
        print("DHWifiPasswordViewController onWifiSwitchAction")
        let url = URL.init(string: UIApplicationOpenSettingsURLString)!
        if #available(iOS 10.0, *) {
            //先判断是否有iOS10SDK的方法，如果有，则实现iOS10的跳转
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            // Fallback on earlier versions
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func onSupportTipAction(_ sender: Any) {
		let supportVc = DHWiFiUnsupportVC()
		self.navigationController?.pushViewController(supportVc, animated: true)
	}
	
	@IBAction func onNextAction(_ sender: Any) {
        
        if #available(iOS 13.0, *) {
            let status = CLLocationManager.authorizationStatus()
            if status == .denied {
                //弹框提示
                LCProgressHUD.showMsg("请开启手机定位信息权限".lc_T)
                return
            }
        }
        
		if DHNetWorkHelper.sharedInstance().emNetworkStatus != .reachableViaWiFi {
			LCProgressHUD.showMsg("add_devices_smartconfig_msg_no_wifi".lc_T)
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

		if let vc: UIViewController = DHRouter.object(forURL: "/lechange/wifidetection/page", withUserInfo: infoDic) as? UIViewController {
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	func checkSavePassword() {
		let wifiSSID = wifiNameLabel.text
		let wifiPassword = passwordInputView.textField.text
		DHAddDeviceManager.sharedInstance.wifiSSID = wifiSSID
		DHAddDeviceManager.sharedInstance.wifiPassword = wifiPassword
		
		//统一下一步记住密码
		if checkButton.isSelected, wifiSSID != nil, wifiPassword != nil {
			DHUserManager.shareInstance().addSSID(wifiSSID, ssidPwd: wifiPassword)
		}
		
		isSelected = checkButton.isSelected
	}
	
	// MARK: DHAddBaseVCProtocol
//    override func rightActionType() -> [DHAddBaseRightAction] {
//        var actions: [DHAddBaseRightAction] = [.restart]
//        
//        //软AP等复用情况下，不切换到有线
//        let manager = DHAddDeviceManager.sharedInstance
//        if manager.netConfigMode == .wifi, manager.supportConfigModes.contains(.wired) {
//            actions.append(.switchToWired)
//        }
//        
//        return actions
//    }
}

extension DHWifiPasswordViewController {
	
	// MARK: UITextFieldDelegate
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
