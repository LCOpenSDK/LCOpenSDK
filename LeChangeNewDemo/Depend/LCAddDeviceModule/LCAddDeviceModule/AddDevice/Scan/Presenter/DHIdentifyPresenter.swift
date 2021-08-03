//
//  Copyright © 2018年 dahua. All rights reserved.
//	序列号识别解释器

import UIKit
import LCBaseModule.DHModule
import AudioToolbox

/// 序列号识别容器(UIViewController)需要实现的协议
protocol DHIdentifyContainerProtocol: DHBindContainerProtocol {
    
    func pauseIdentify()
    
    func resumeIdenfity()
    
    func showAddBoxGuidView(needShoeBox:@escaping ((Bool) -> Void))
    
    // SMBDeviceInfoViewController 更新UI
    func smb_updateUI(deviceInfo: DHUserDeviceBindInfo)
}

class DHIdentifyPresenter: NSObject, LCSheetViewDelegate {
    
    private weak var container: DHIdentifyContainerProtocol?
    
    var isBusy: Bool = false
    
    var curQrModel: String = ""
    
    private lazy var bindPresenter: DHBindPresenter = {
        let presenter = DHBindPresenter()
        return presenter
    }()
    
    deinit {
        dh_printDeinit(self)
    }
    
    func setup(container: DHIdentifyContainerProtocol) {
        self.container = container
    }
    
    func checkQRCode(codeString: String) {
        if self.isBusy {
            return
        }
        
        //去除白空格
        
        let code = codeString.trimmingCharacters(in: CharacterSet.whitespaces)
        if DHModuleConfig.shareInstance().isLeChange {
            if self.isPureRDCode(code: code) {
                return
            }
        } else {
            if self.isValidOverseasCode(code: code) == false {
                return
            }
        }
        
        let qrCode = LCQRCode()
        qrCode.pharseQRCode(code)
        
        //V3.15.0 序列号二维码规则字母 + 数字，长度 10 - 32位 否则进入手动输入页面
        //如果http或者https开头的
        
        
        let regex = "[0-9a-zA-Z]{10,32}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isPure = predicate.evaluate(with: qrCode.deviceSN)
        //如果SN为空，直接返回
        if !isPure {
            self.pushToInputSN()
            return
        }
        
        
        //震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        //查询信息过程中，暂停扫描
        self.container?.pauseIdentify()
        
        //保存安全码
        DHAddDeviceManager.sharedInstance.regCode = qrCode.identifyingCode
        
        //NC码
        DHAddDeviceManager.sharedInstance.ncCode = qrCode.ncCode
        
        //安全验证码:由于旧的局域网搜索方式需要兼容，暂时还不能停止搜索
        if qrCode.scCode != nil {
            print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder))::Support SC Mode: \(qrCode.scCode!)")
            DHAddDeviceManager.sharedInstance.isSupportSC = true
            DHAddDeviceManager.sharedInstance.initialPassword = qrCode.scCode
        } else {
            DHAddDeviceManager.sharedInstance.isSupportSC = false
            DHAddDeviceManager.sharedInstance.initialPassword = ""
        }
        
        //NC码
        if qrCode.ncCode != nil {
            print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder))::Support NC Mode: \(qrCode.ncCode!)")
            DHAddDeviceManager.sharedInstance.ncType = DHNetConnectType.convert(byNcCode: qrCode.ncCode!)
            
            let supportConfigModes = DHNetConnectType.getWifiConfigModes(byNcCode: qrCode.ncCode!)
            
            //使用NC的进行初始化    后面接口里面的数据如果不为空  会覆盖这个值
            
            if supportConfigModes.count == 0 {
                DHAddDeviceManager.sharedInstance.supportConfigModes = [.wired, .wifi, .softAp]
            } else {
                DHAddDeviceManager.sharedInstance.supportConfigModes = supportConfigModes
                DHAddDeviceManager.sharedInstance.netConfigStrategy = .fromNC
            }
            
            
        } else {
            DHAddDeviceManager.sharedInstance.ncType = .none
        }
        
        getDeviceInfo(deviceId: qrCode.deviceSN, qrModel: qrCode.deviceType, ncCode: qrCode.ncCode, imeiCode: qrCode.imeiCode)
    }
    
    func stopSearchDevices() {
        DHNetSDKSearchManager.sharedInstance().stopSearch()
    }
    
    func startSearchDevices() {
        DHNetSDKSearchManager.sharedInstance().startSearch()
    }
    
    
    /// 判断是否为纯的6位安全码
    ///
    /// - Parameter code: 二维码字符串
    private func isPureRDCode(code: String) -> Bool {
        let regex = "[0-9a-zA-Z]{1,6}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isPure = predicate.evaluate(with: code)
        
        if isPure {
            self.container?.pauseIdentify()
            DHAlertController.show(withTitle: "", message: "Device_AddDevice_Scan_RDCode_Tip".lc_T, cancelButtonTitle: nil, otherButtonTitle: "common_confirm".lc_T) { (_) in
                self.container?.resumeIdenfity()
            }
        }
        
        return isPure
    }
    
    /// 判断是否是海外合法的序列号
    ///
    /// - Parameter code: 二维码
    /// - Returns: 合法返回YES，非法返回NO
    private func isValidOverseasCode(code: String) -> Bool {
        if code.count == 0 || code.count > 64 {
            self.container?.pauseIdentify()
            DHAlertController.show(withTitle: "", message: "add_devices_scan_code_failed".lc_T, cancelButtonTitle: nil, otherButtonTitle: "common_confirm".lc_T) { (_) in
                self.container?.resumeIdenfity()
            }
            return false
        }
        
        return true
    }

    
    /// 获取设备信息
    ///
    /// - Parameters:
    ///   - deviceId: 序列号
    ///   - qrModel: 二维码型号
    ///   - marketModel: 市场型号
    ///   - imeiCode: NB iot设备唯一标识码
    ///	  - manualCheckCode: 手动输入的安全码
    ///   - modeOptional  true 会弹出sheet让用户进行选择配网方式
    func getDeviceInfo(deviceId: String, qrModel: String?, ncCode: String?, marketModel: String? = nil, imeiCode: String? = nil, manualCheckCode: String? = nil, modeOptional: Bool = false ) {
        LCProgressHUD.show(onLowerView: self.container?.mainView(), tip: nil)
        isBusy = true
        
        //预先加载引导信息
        if marketModel != nil {
            DHAddDeviceManager.sharedInstance.deviceMarketModel = marketModel!
            DHOMSConfigManager.sharedManager.checkUpdateIntrodution(byMarketModel: marketModel!)
        }
        
        DHAddDeviceManager.sharedInstance.getDeviceInfo(deviceId: deviceId, qrModel: qrModel, ncCode: ncCode, marketModel: marketModel, imeiCode: imeiCode, success: { (deviceInfo, p2pStatus)  in
            LCProgressHUD.hideAllHuds(self.container?.mainView(), animated: false)
            self.isBusy = false
            
            self.curQrModel = modeOptional ? marketModel ?? "" : qrModel ?? ""
            
            //【*】返回后，不需要处理
            if self.container == nil {
                return
            }
            
            //【*】保存deviceId，并全部转换成大写
            let manager = DHAddDeviceManager.sharedInstance
            manager.deviceId = deviceId.uppercased()
            
            // 进入添加流程
            self.addDeviceStep(deviceInfo: deviceInfo, p2pStatus: p2pStatus, qrModel: qrModel, marketModel: marketModel, manualCheckCode: manualCheckCode, deviceId: deviceId)
            
        }) { error in
            LCProgressHUD.hideAllHuds(self.container?.mainView())
            self.isBusy = false
            
            //【*】返回后，不需要处理
            if self.container == nil {
                return
            }
            
            if(error.errorCode == "DV1003") {
                DHAddDeviceManager.sharedInstance.addPlicy {
                    DispatchQueue.main.async {
                        let controller = DHBindSuccessViewController.storyboardInstance()
                        self.container?.navigationVC()?.pushViewController(controller, animated: true)
                    }

                } failure: { (error) in
                    error.showTips(error.errorMessage)
                };
                return;
            }
            
            error.showTips(error.errorMessage)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.container?.resumeIdenfity()
            }
            
            /**
             当满足以下两种情况时会返回设备离线状态
             1.设备已经配网且未绑定且离线
             2.设备从未注册到平台
            */
//            if (error.errorCode == "DV1007") {
//                //设备离线时跳转选择设备页
//                NSLog("ADD-DEVICE:获取未绑定设备信息为设备离线,下一步:跳转选择设备页")
//                self.pushToSelectModelVC(deviceId: deviceId)
//            } else if (error.errorCode == "DV1003") {
//                LCProgressHUD.showMsg("add_device_device_bind_by_yourself".lc_T)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    self.container?.resumeIdenfity()
//                }
//            } else if (error.errorCode == "DV1001") {
//                self.pushToBindByOtherVC(account: error.errorMessage)
//            } else {
//                error.showTips("mobile_common_bec_common_tip".lc_T)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    self.container?.resumeIdenfity()
//                }
//            }
        }
    }
    
    func addDeviceStep(deviceInfo: DHUserDeviceBindInfo, p2pStatus: Bool, qrModel: String?, marketModel: String? = nil, manualCheckCode: String? = nil, deviceId: String, isCheckDeviceModelFirst: Bool? = false) {
        // 【*】判断设备是否支持绑定
        if self.checkDeviceIsSupported(deviceInfo: deviceInfo, qrModel: qrModel) == false {
            return
        }
        
        //【*】检查引导信息
        if marketModel == nil, deviceInfo.modelName.count > 0 {
            DHAddDeviceManager.sharedInstance.deviceMarketModel = deviceInfo.modelName
            DHOMSConfigManager.sharedManager.checkUpdateIntrodution(byMarketModel: deviceInfo.modelName)
        }
        
        //【1、】判断是否是配件，配件判断Catalog是否存在，配件不需要判断绑定状态
        if self.checkDeviceIsAccessory(deviceInfo: deviceInfo, deviceId: deviceId) {
            return
        }
        
        //【2、】判断设备是否绑定
        if self.checkDeviceIsBinded(deviceInfo: deviceInfo) {
            return
        }
        
        //【3、】sc码手动输入流程：判断安全码位数是否符合要求
        if self.checkScCodeLengthIsInvalid(deviceInfo: deviceInfo, manualCheckCode: manualCheckCode) {
            return
        }
        
        // [4、]  NB的话直接进填写imei页面
        if self.checkDeviceIsNB() {
            self.pushConfigNetPage()
            return
        }
        
        //【5、】判断设备是否在线
        if self.checkDeviceIsOnline(deviceInfo: deviceInfo, configMode: DHAddDeviceManager.sharedInstance.netConfigMode, p2pStatus: p2pStatus) {
            return
        }
        
        //进入配网流程标识
        DHAddDeviceManager.sharedInstance.isContainNetConfig = true
        
        //【6、】判断设备类型是否确定 且无NC码  如果有NC码 就不用纠结设备类型
        if self.checkDeviceModelIsValidNotNC(deviceInfo: deviceInfo, qrModel: qrModel, deviceId: deviceId) == false {
            return
        }
        
        if deviceInfo.wifiConfigModeOptional {
            self.showModeOptional()
        } else {
            self.pushConfigNetPage()
        }
    }
    
    //【5、】跳转对应的配网类型
    private func pushConfigNetPage() {
        let controller = self.getNetConfigModeVc()
        self.container?.navigationVC()?.pushViewController(controller, animated: true)
    }
    
    // MARK: Check Status
	private func checkDeviceIsSupported(deviceInfo: DHUserDeviceBindInfo, qrModel: String?) -> Bool {
		var isSupported = true
		
		// *乐盒判断
		if qrModel?.uppercased() == "G10" {
			isSupported = false
		}
		
		// *根据平台字段返回
		isSupported = deviceInfo.surpport
		
		// *不支持的跳转不支持的页面
		if !isSupported {
			pushToUnsurpportVC()
		}
		
		return isSupported
	}
    
    private func checkDeviceIsAccessory(deviceInfo: DHUserDeviceBindInfo, deviceId: String) -> Bool {
        let isPart = deviceInfo.dh_isAccesoryPart()
        if isPart {
            //【*】如果是配件，返回了配件类型，直接跳转选择网关
            //【*】如果没有配件类型，跳转类型选择界面
            self.pushToSelectModelVC(deviceId: deviceId)
//            if deviceInfo.catalog != nil {
//                self.pushToSelectGatewayVC(type: deviceInfo.catalog, model: deviceInfo.deviceModel)
//            } else {
//                self.pushToSelectModelVC(deviceId: deviceId)
//            }
            
            return true
        }
        
        return false
    }
    
    private func checkDeviceIsBinded(deviceInfo: DHUserDeviceBindInfo) -> Bool {
        let status = deviceInfo.dh_bindStatus()
        if status == .unbind {
            return false
        }
        
		//SMB::不需要分享
		if status == .bindBySelf {
            LCProgressHUD.showMsg("add_device_device_bind_by_yourself".lc_T)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.container?.resumeIdenfity()
            }
        } else {
            self.pushToBindByOtherVC(account: deviceInfo.userAccount)
        }
        
        return true
    }
    
    private func checkScCodeLengthIsInvalid(deviceInfo: DHUserDeviceBindInfo, manualCheckCode: String? = nil) -> Bool {
        var isInvalid = false
        
        //支持SCCode的设备，如果输入了6位的，则进行提示
        if DHModuleConfig.shareInstance()?.isLeChange == true,
            manualCheckCode != nil,
            manualCheckCode?.count == 6,
            deviceInfo.ability.dh_caseInsensitiveContain(string: "SCCode") {
            isInvalid = true
            LCProgressHUD.showMsg("add_device_input_corrent_sc_tip".lc_T)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.container?.resumeIdenfity()
            }
        }
        
        return isInvalid
    }
    
    // 判断是否是NB
    private func checkDeviceIsNB() -> Bool {
        
        return DHAddDeviceManager.sharedInstance.supportConfigModes.contains(.nbIoT)
    }
    
    private func checkDeviceIsOnline(deviceInfo: DHUserDeviceBindInfo, configMode: DHNetConfigMode, p2pStatus: Bool) -> Bool {
        
        //【*】海外：p2p设备在线/设备在线，进入密码检验；p2p设备不在线，进入配网
        //【*】国内：根据Auth及RD能力集，跳转设备密码检验/安全码检验界面
        
        var isOnline = deviceInfo.dh_isOnline()
        
        //如果是p2p设备  查看p2p状态   不是的话  就看设备状态
        if deviceInfo.dh_accessType() == .p2p {
            isOnline = p2pStatus
        }
        
        //【*】设备未注册，走离线配网流程
		if deviceInfo.dh_isExisted() == false {
            isOnline = false
        }
        
        if isOnline == false {
            return false
        }
        
        //【*】记录不走配网流程
        DHAddDeviceManager.sharedInstance.isContainNetConfig = false
        
        //【*】在线设备，支持SC码的，进入云配置流程
        //【*】在线设备，不支持码的，走旧的添加流程
        if DHAddDeviceManager.sharedInstance.isSupportSC {
            self.pushToConnectCloud()
        } else if DHModuleConfig.shareInstance().isLeChange == false {
            self.pushToAuthDevicePasswordVC()
        } else {
            if DHAddDeviceManager.sharedInstance.abilities.contains("Auth") {
                self.pushToAuthDevicePasswordVC()
            } else if DHAddDeviceManager.sharedInstance.abilities.contains("RegCode") {
                if let code = DHAddDeviceManager.sharedInstance.regCode, code.count != 0 {
                    //调用添加接口
                    self.addOnlineDevice(devicePassword: "", code: code)
                } else {
                    self.pushToAuthRegCodeVC()
                }
            } else {
                self.addOnlineDevice(devicePassword: "")
            }
        }
        
        return isOnline
    }
    
    private func checkDeviceModelIsValidNotNC(deviceInfo: DHUserDeviceBindInfo, qrModel: String?, deviceId: String) -> Bool {
        
        //NC设备走下去
        if DHAddDeviceManager.sharedInstance.netConfigStrategy == .fromNC {
            return true
        }
        
        if deviceInfo.deviceModel == nil || deviceInfo.deviceModel.count == 0 {
            
            // 【*】异常处理，兼容在选择设备型号界面出现异常
            if container is DHSelectModelViewController == false {
                pushToSelectModelVC(deviceId: deviceId)
            } else {
                DHAlertController.show(withTitle: "", message: "无该型号设备,请根据页面提示确定型号", cancelButtonTitle: "common_cancel".lc_T, otherButtonTitle: "common_confirm".lc_T, handler: nil)
            }
            
            
            return false
        }
        return true
    }
    
    private func getNetConfigModeVc() -> UIViewController {
        // 判断设备配网模式
        var controller: UIViewController!
        let manager = DHAddDeviceManager.sharedInstance
        if manager.netConfigStrategy == .defalult {
            controller = DHPowerGuideViewController()
            manager.netConfigMode = .wired
            return controller
        }
        
        //NB设备
        if manager.supportConfigModes.contains(.nbIoT) {
            manager.netConfigMode = .nbIoT
            if manager.imeiCode.count == 0 {
                controller = DHInputIMEIViewController.storyboardInstance()
            } else if manager.isOnline {
                let vc = DHConnectCloudViewController.storyboardInstance()
                vc.deviceInitialPassword = manager.initialPassword
                controller = vc
            } else {
                controller = DHNBCheckViewController()
            }
        } else if manager.supportConfigModes.contains(.local) { //猫眼
            manager.netConfigMode = .local
            controller = DHLocalNetGuideViewController()
        } else if manager.supportConfigModes.contains(.simCard) {//SIM卡
            
            manager.netConfigMode = .simCard
            controller = DHSIMCardGuideViewController()
        } else if manager.supportConfigModes.contains(.softAp) { //软AP
            //局域网搜索到了设备
            //【*】前置条件：非Ap类设备，设备不在线（在线的设备，在之前已经处理过）
            //【2】不需要初始化（包括无初始化能力集、已初始化、或是SC设备），进入连接云平台
            //【3】需要初始化，进入初始化流程【与Android保持统一】
            if let device = DHAddDeviceManager.sharedInstance.getLocalDevice() {
                manager.netConfigMode = .wired
				if device.deviceInitStatus == .init || device.deviceInitStatus == .noAbility || manager.isSupportSC {
                    let vc = DHConnectCloudViewController.storyboardInstance()
                    controller = vc
                } else {
                    let vc = DHInitializeSearchViewController.storyboardInstance()
                    controller = vc
                }
            } else {
                manager.netConfigMode = .softAp
                let vc = DHApGuideViewController()
                controller = vc
            }
        } else if manager.supportConfigModes.contains(.wifi) {
            manager.netConfigMode = .wifi
            controller = DHPowerGuideViewController()
        } else if manager.supportConfigModes.contains(.ble) {
            
        } else {
            controller = DHPowerGuideViewController()
            manager.netConfigMode = .wired
        }
        
        return controller
    }
    
    // MARK: Add online device
    func addOnlineDevice(devicePassword: String, code: String? = nil) {
        
        self.isBusy = true
        bindPresenter.setup(container: self.container)
        bindPresenter.bindDevice(devicePassword: devicePassword, code: code, deviceKey: "", showLoading: true, showErrorTip: true) { (isSucceed) in
            self.isBusy = false
            if isSucceed == false {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.container?.resumeIdenfity()
                })
            }
        }
    }
    
    // MARK: Controller Navigation
    private func pushToSelectModelVC(deviceId: String) {
        let controller = DHSelectModelViewController.storyboardInstance()
        controller.deviceId = deviceId
        self.container?.navigationVC()?.pushViewController(controller, animated: true)
    }
    
    private func pushToBindByOtherVC(account: String) {
        let controller = DHBindByOtherViewController.storyboardInstance()
        controller.bindAccount = account
        self.container?.navigationVC()?.pushViewController(controller, animated: true)
    }
    
    private func pushToAuthDevicePasswordVC() {
        let controller = DHAuthPasswordViewController.storyboardInstance()
        controller.presenter = DHAuthPasswordPresenter(container: controller)
        self.container?.navigationVC()?.pushViewController(controller, animated: true)
    }
    
    private func pushToApGuideVC() {
        let controller = DHApGuideViewController()
        self.container?.navigationVC()?.pushViewController(controller, animated: true)
    }
    
    private func pushToAuthRegCodeVC() {
        let controller = DHAuthRegCodeViewController.storyboardInstance()
        self.container?.navigationVC()?.pushViewController(controller, animated: true)
    }
    
    private func pushToConnectCloud() {
        let controller = DHConnectCloudViewController.storyboardInstance()
        controller.deviceInitialPassword = DHAddDeviceManager.sharedInstance.initialPassword
        self.container?.navigationVC()?.pushViewController(controller, animated: true)
    }
    
    private func pushToInputSN() {
        let controller = DHInputSNViewController.storyboardInstance()
        controller.qrCodeScanFailedClosure = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                LCProgressHUD.showMsg("二维码信息不完整，请尝试手动添加设备".lc_T)
            })
        }
        self.container?.navigationVC()?.pushViewController(controller, animated: true)
    }
	
	private func pushToUnsurpportVC() {
		let controller = DHDeviceUnsupportViewController()
		self.container?.navigationVC()?.pushViewController(controller, animated: true)
	}
    
    private func showModeOptional() {
        //获取所有支持的配网类型
        let supportModes = DHAddDeviceManager.sharedInstance.supportConfigModes.sorted { (mode1, mode2) -> Bool in
            return mode1.rawValue < mode2.rawValue
        }
        
        let otherTitles = supportModes.map { (mode) -> String in
            return mode.name()
        }
        
        let sheet = LCSheetView(title: "", message: "", delegate: self, cancelButton: "common_cancel".lc_T, otherButtons: otherTitles)
        
        let cancleBtn = sheet?.button(at: 0)
        cancleBtn?.setTitleColor(UIColor.dhcolor_c12(), for: .normal)
        sheet?.show()
        
        let btn = UIButton();
        btn.setTitle("请选择添加方式", for: .normal)
        btn.backgroundColor = UIColor.dhcolor_c1()
        btn.lc_setRadius(25)
        sheet?.clipsToBounds = false
        if let `sheet` = sheet {
            sheet.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.centerX.equalTo(sheet)
                make.bottom.equalTo(-(otherTitles.count * 50) - 80 - (UIDevice.lc_isIphoneX() ? 34 : 0))
                make.height.equalTo(50)
                make.width.equalTo(200)
            }
        }
        /*
         case wifi
         case wired
         case softAp
         case simCard
         case qrCode
         case local /**< 猫眼类只支持本地配网 */
         case nbIoT /**< NB */
         */
    }
    
    // MARK: LCSheetViewDelegate
    
    func sheetView(_ sheetView: LCSheetView!, clickedButtonAt buttonIndex: Int) {
        let btnTitle = sheetView.button(at: buttonIndex)?.titleLabel?.text
        let manager = DHAddDeviceManager.sharedInstance
        var controller: UIViewController?
        
        switch btnTitle {
        case DHNetConfigMode.wifi.name():
            manager.netConfigMode = .wifi
            controller = DHPowerGuideViewController()
            
        case DHNetConfigMode.wired.name():
            controller = DHPowerGuideViewController()
            manager.netConfigMode = .wired
            
        case DHNetConfigMode.softAp.name():
            //局域网搜索到了设备
            //【*】前置条件：非Ap类设备，设备不在线（在线的设备，在之前已经处理过）
            //【2】不需要初始化，进入连接云平台
            //【3】需要初始化，进入初始化流程【与Android保持统一】
            if let device = DHAddDeviceManager.sharedInstance.getLocalDevice() {
                manager.netConfigMode = .wired
                if device.deviceInitStatus == .init || device.deviceInitStatus == .noAbility {
                    let vc = DHConnectCloudViewController.storyboardInstance()
                    controller = vc
                } else {
                    let vc = DHInitializeSearchViewController.storyboardInstance()
                    controller = vc
                }
            } else {
                manager.netConfigMode = .softAp
                let vc = DHApGuideViewController()
                controller = vc
            }
            
            break
        case DHNetConfigMode.simCard.name():
            manager.netConfigMode = .simCard
            controller = DHSIMCardGuideViewController()
            break
        case DHNetConfigMode.qrCode.name():
            break
        case DHNetConfigMode.local.name():
            manager.netConfigMode = .local
            controller = DHLocalNetGuideViewController()
            break
        case DHNetConfigMode.ble.name():
            manager.netConfigMode = .ble
            break
        case DHNetConfigMode.nbIoT.name():
            //NB设备
            if manager.supportConfigModes.contains(.nbIoT) {
                manager.netConfigMode = .nbIoT
                if manager.imeiCode.count == 0 {
                    controller = DHInputIMEIViewController.storyboardInstance()
                } else if manager.isOnline {
                    let vc = DHConnectCloudViewController.storyboardInstance()
                    vc.deviceInitialPassword = manager.initialPassword
                    controller = vc
                } else {
                    controller = DHNBCheckViewController()
                }
            }
            
        default:
            break
        }
        
        if let vc = controller {
            self.container?.navigationVC()?.pushViewController(vc, animated: true)
        }
    }
}
