//
//  LCAPWifiPasswordViewController.swift
//  LCAddDeviceModule
//
//  Created by yyg on 2023/3/15.
//  Copyright © 2023 dahua. All rights reserved.
//
import UIKit
import LCBaseModule
import CoreLocation
import AFNetworking

class LCAPWifiPasswordViewController: LCAddBaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var wifiSupportIcon: UIImageView!
    @IBOutlet weak var wifiTypeLabel: UILabel!
    @IBOutlet weak var wifiNameLabel: UILabel!
    @IBOutlet weak var passwordInputView: LCInputView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var autoKeyboardView: UIView!

    private var isSelected: Bool = false
    private var presenter: LCAPWifiPasswordPresenterProtocol?
    
    public static func storyboardInstance() -> LCAPWifiPasswordViewController {
        let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
        let controller = storyboard.instantiateViewController(withIdentifier: "LCAPWifiPasswordViewController")
        return controller as! LCAPWifiPasswordViewController
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
    
    override func leftActionType() -> LCAddBaseLeftAction {
        return .quit
    }
    
    override func isLeftActionShowAlert() -> Bool {
        return true
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
    
    public func setup(presenter: LCAPWifiPasswordPresenterProtocol) {
        self.presenter = presenter
    }

    func setupCustomContents() {
        wifiNameLabel.text = nil
        checkButton.setTitle("add_device_remember_password".lc_T(), for: .normal)
        passwordInputView.textField.placeholder = "add_device_input_wifi_password".lc_T()
        nextButton.setTitle("common_next".lc_T(), for: .normal)
        
        //设置颜色规范
        passwordInputView.textField.textColor = UIColor.lccolor_c2()
        passwordInputView.textField.isSecureTextEntry = true
        wifiNameLabel.textColor = UIColor.lccolor_c2()
        checkButton.setTitleColor(UIColor.lccolor_c5(), for: .normal)
        checkButton.setImage(UIImage(lc_named: "adddevice_box_checkbox"), for: .normal)
        checkButton.setImage(UIImage(lc_named: "adddevice_box_checkbox_checked"), for: .selected)
        
        //按钮样式配置
        nextButton.layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
        nextButton.backgroundColor = LCModuleConfig.shareInstance().commonButtonColor()
        nextButton.setTitleColor(UIColor.lccolor_c43(), for: .normal)
        
        //支持多行显示
        checkButton.titleLabel?.numberOfLines = 2
        
        if LCAddDeviceManager.sharedInstance.isSupport5GWifi {
            self.wifiSupportIcon.image = UIImage(lc_named: "adddevice_wifi_support")
            self.wifiTypeLabel.text = "5G"
        } else {
            self.wifiSupportIcon.image = UIImage(lc_named: "adddevice_wifi_support")
            self.wifiTypeLabel.text = "2.4G"
        }
    }
    
    func setupInputView() {
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
        print("LCAPWifiPasswordViewController onWifiSwitchAction")
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
}

extension LCAPWifiPasswordViewController {
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
