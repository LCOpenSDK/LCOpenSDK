//
//  Copyright © 2018年 Imou. All rights reserved.
//	序列号识别解释器

import UIKit
import LCBaseModule
import AudioToolbox

/// 序列号识别容器(UIViewController)需要实现的协议
protocol LCIdentifyContainerProtocol: LCBindContainerProtocol {
    
    func pauseIdentify()
    
    func resumeIdenfity()
    
    func smb_updateUI(deviceInfo: LCUserDeviceBindInfo)
}

class LCIdentifyPresenter: NSObject, LCSheetViewDelegate {
    
    private weak var container: LCIdentifyContainerProtocol?
    
    var isBusy: Bool = false
    
    var curQrModel: String = ""
    
    private lazy var bindPresenter: LCBindPresenter = {
        let presenter = LCBindPresenter()
        return presenter
    }()
    
    deinit {
        debugPrint("LCIdentifyPresenter", "Deinit Success:", self)
    }
    
    func setup(container: LCIdentifyContainerProtocol) {
        self.container = container
    }
    
    func checkQRCode(codeString: String) {
        if self.isBusy {
            return
        }
        
        
        let qrCode = LCQRCode()
        if codeString.lc_caseInsensitiveContain(string: "https") {
            // 网关
            let strings = codeString.components(separatedBy: " ")
            if strings.count >= 3 {
                qrCode.deviceSN = strings[2]
            }
            if strings.count >= 4 {
                qrCode.scCode = strings[3]
            }
        } else {
            //去除白空格
            let code = codeString.trimmingCharacters(in: CharacterSet.whitespaces)
            if LCModuleConfig.shareInstance().isChinaMainland {
                if self.isPureRDCode(code: code) {
                    return
                }
            } else {
                if self.isValidOverseasCode(code: code) == false {
                    return
                }
            }
            qrCode.pharseQRCode(code)
        }
        
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
        LCAddDeviceManager.sharedInstance.regCode = qrCode.identifyingCode
        
        //NC码
        LCAddDeviceManager.sharedInstance.ncCode = qrCode.ncCode
        
        //安全验证码:由于旧的局域网搜索方式需要兼容，暂时还不能停止搜索
        if qrCode.scCode != nil {
            print(" \(NSStringFromClass(self.classForCoder))::Support SC Mode: \(qrCode.scCode!)")
            LCAddDeviceManager.sharedInstance.isSupportSC = true
            LCAddDeviceManager.sharedInstance.initialPassword = qrCode.scCode
        } else {
            LCAddDeviceManager.sharedInstance.isSupportSC = false
            LCAddDeviceManager.sharedInstance.initialPassword = ""
        }
        
        getDeviceInfo(deviceId: qrCode.deviceSN, productId: qrCode.iotDeviceType, qrModel: qrCode.deviceType, ncCode: qrCode.ncCode, imeiCode: qrCode.imeiCode)
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
            LCAlertView.lc_ShowAlert(title: nil, detail: "Device_AddDevice_Scan_RDCode_Tip".lc_T(), confirmString: "common_confirm".lc_T(), cancelString: nil) { isConfirmSelected in
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
            LCAlertView.lc_ShowAlert(title: nil, detail: "add_devices_scan_code_failed".lc_T(), confirmString: "common_confirm".lc_T(), cancelString: nil) { isConfirmSelected in
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
    ///   - productId: iot设备产品ID
    ///   - qrModel: 二维码型号
    ///   - marketModel: 市场型号
    ///   - imeiCode: NB iot设备唯一标识码
    ///	  - manualCheckCode: 手动输入的安全码
    ///   - modeOptional  true 会弹出sheet让用户进行选择配网方式
    func getDeviceInfo(deviceId: String, productId: String?, qrModel: String?, ncCode: String?, marketModel: String? = nil, imeiCode: String? = nil, manualCheckCode: String? = nil, modeOptional: Bool = false ) {
        LCProgressHUD.show(onLowerView: self.container?.mainView())
        isBusy = true
        
        if marketModel != nil {
            LCAddDeviceManager.sharedInstance.deviceMarketModel = marketModel!
        }
        
        LCAddDeviceManager.sharedInstance.getUnBindDeviceInfo(deviceId: deviceId, productId: productId, qrModel: qrModel, ncCode: ncCode, marketModel: marketModel, imeiCode: imeiCode, success: { (deviceInfo, p2pStatus)  in
            LCProgressHUD.hideAllHuds(self.container?.mainView(), animated: false)
            self.isBusy = false
            
            self.curQrModel = modeOptional ? marketModel ?? "" : qrModel ?? ""
            
            //【*】返回后，不需要处理
            if self.container == nil {
                return
            }
            // 进入添加流程
            self.addDeviceStep(deviceInfo: deviceInfo, p2pStatus: p2pStatus, qrModel: qrModel, marketModel: marketModel, manualCheckCode: manualCheckCode, deviceId: deviceId)
            
        }) { error in
            LCProgressHUD.hideAllHuds(self.container?.mainView())
            self.isBusy = false
            
            //【*】返回后，不需要处理
            if self.container == nil {
                return
            }
            
            if (error.errorCode == "DV1001") {
                let bindVc = LCBindByOtherViewController.storyboardInstance()
                bindVc.bindAccount = error.errorMessage
                bindVc.leftAction = .quit
                self.container?.navigationVC()?.pushViewController(bindVc, animated: true)
                return
            }
            // 主账号已绑定，给子账号授权
            if error.errorCode == "DV1003" {
                LCAddDeviceManager.sharedInstance.addPlicy {
                    // 授权成功
                    let controller = LCBindSuccessViewController.storyboardInstance()
                    controller.deviceName = (((productId?.count ?? 0) > 0) || (qrModel?.count ?? 0 == 0)) ? deviceId : (qrModel ?? "") + deviceId.substring(fromIndex: (deviceId.count - 4))
                    self.container?.navigationVC()?.pushViewController(controller, animated: true)
                } failure: { error in
                    // 授权失败
                    error.showTips(error.errorMessage)
                }
                return
            }
            
            error.showTips(error.errorMessage)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.container?.resumeIdenfity()
            }
        }
    }
    
    func addDeviceStep(deviceInfo: LCUserDeviceBindInfo, p2pStatus: Bool, qrModel: String?, marketModel: String? = nil, manualCheckCode: String? = nil, deviceId: String, isCheckDeviceModelFirst: Bool? = false) {
        // 【*】判断设备是否支持绑定
        if self.checkDeviceIsSupported(deviceInfo: deviceInfo, qrModel: qrModel) == false {
            return
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
        
        //【5、】判断设备是否在线
        if self.checkDeviceIsOnline(deviceInfo: deviceInfo, configMode: LCAddDeviceManager.sharedInstance.netConfigMode, p2pStatus: p2pStatus) {
            return
        }
        //【*】检查引导信息
        if marketModel == nil, deviceInfo.modelName.count > 0 {
            LCAddDeviceManager.sharedInstance.deviceMarketModel = deviceInfo.modelName
        }
        
        LCAddDeviceManager.sharedInstance.softAPModeWifiVersion = deviceInfo.softAPModeWifiVersion ?? ""
        LCAddDeviceManager.sharedInstance.softAPModeWifiName = deviceInfo.softAPModeWifiName ?? ""
        
        //进入配网流程标识
        let pid = LCAddDeviceManager.sharedInstance.productId ?? ""
        if pid.count > 0 {
            if LCAddDeviceManager.sharedInstance.netConfigMode == .iotLan || LCAddDeviceManager.sharedInstance.netConfigMode == .iot4G {
                let guideVc = LCPowerGuideViewController.init()
                self.container?.navigationVC()?.pushViewController(guideVc, animated: true)
            } else {
                let wifiVc = LCIoTWifiConfigViewController.storyboardInstance()
                wifiVc.wifiConfigBlock = {[weak wifiVc] in // wifi 信息配置完成，跳转引导流程
                    if LCAddDeviceManager.sharedInstance.netConfigMode == .wifi {
                        let guideVc = LCApGuideViewController()
                        wifiVc?.navigationController?.pushViewController(guideVc, animated: true)
                    } else {
                        let guideVc = LCDeviceAddGuideViewController.init(productID: LCAddDeviceManager.sharedInstance.productId ?? "")
                        wifiVc?.navigationController?.pushViewController(guideVc, animated: true)
                    }
                }
                self.container?.navigationVC()?.pushViewController(wifiVc, animated: true)
            }
        } else {
            //【6、】判断设备类型是否确定
            if self.checkDeviceModelIsValidNotNC(deviceInfo: deviceInfo, qrModel: qrModel, deviceId: deviceId) == false {
                return
            }
            self.pushConfigNetPage()
        }
    }
    
    //【5、】跳转对应的配网类型
    private func pushConfigNetPage() {
        let manager = LCAddDeviceManager.sharedInstance
        if manager.netConfigMode == .softAp || manager.netConfigMode == .lan || manager.netConfigMode == .iotLan || manager.netConfigMode == .iot4G || manager.netConfigMode == .soundWave || manager.netConfigMode == .soundWaveV2 || manager.netConfigMode == .smartConfig {
            let controller = LCPowerGuideViewController()
            self.container?.navigationVC()?.pushViewController(controller, animated: true)
        } else {
            let controller = LCWifiPasswordViewController.storyboardInstance()
            let presenter = LCWifiPasswordPresenter(container: controller)
            controller.setup(presenter: presenter)
            self.container?.navigationVC()?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: Check Status
	private func checkDeviceIsSupported(deviceInfo: LCUserDeviceBindInfo, qrModel: String?) -> Bool {
		var isSupported = true
		// *根据平台字段返回
		isSupported = deviceInfo.support
		
		// *不支持的跳转不支持的页面
		if !isSupported {
			pushToUnsupportVC()
		}
		
		return isSupported
	}
    
    private func checkDeviceIsAccessory(deviceInfo: LCUserDeviceBindInfo, deviceId: String) -> Bool {
        let isPart = deviceInfo.lc_isAccesoryPart()
        if isPart {
            //【*】如果是配件，返回了配件类型，直接跳转选择网关
            //【*】如果没有配件类型，跳转类型选择界面
            self.pushToSelectModelVC(deviceId: deviceId)
            return true
        }
        
        return false
    }
    
    private func checkDeviceIsBinded(deviceInfo: LCUserDeviceBindInfo) -> Bool {
        let status = deviceInfo.lc_bindStatus()
        if status == .unbind {
            return false
        }
        
		//SMB::不需要分享
		if status == .bindBySelf {
            LCProgressHUD.showMsg("add_device_device_bind_by_yourself".lc_T())
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.container?.resumeIdenfity()
            }
        } else {
            self.pushToBindByOtherVC(account: deviceInfo.userAccount)
        }
        
        return true
    }
    
    private func checkScCodeLengthIsInvalid(deviceInfo: LCUserDeviceBindInfo, manualCheckCode: String? = nil) -> Bool {
        var isInvalid = false
        
        //支持SCCode的设备，如果输入了6位的，则进行提示
        if LCModuleConfig.shareInstance()?.isChinaMainland == true,
            manualCheckCode != nil,
            manualCheckCode?.count == 6,
            deviceInfo.ability.lc_caseInsensitiveContain(string: "SCCode") {
            isInvalid = true
            LCProgressHUD.showMsg("add_device_input_corrent_sc_tip".lc_T())
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.container?.resumeIdenfity()
            }
        }
        
        return isInvalid
    }
    
    private func checkDeviceIsOnline(deviceInfo: LCUserDeviceBindInfo, configMode: LCNetConfigMode, p2pStatus: Bool) -> Bool {
        
        //【*】海外：p2p设备在线/设备在线，进入密码检验；p2p设备不在线，进入配网
        //【*】国内：根据Auth及RD能力集，跳转设备密码检验/安全码检验界面
        
        var isOnline = deviceInfo.lc_isOnline()
        
        //【*】设备未注册，走离线配网流程
		if deviceInfo.lc_isExisted() == false {
            isOnline = false
        }
        
        if isOnline == false {
            return false
        }
        
        //【*】在线设备，支持SC码的，进入云配置流程
        //【*】在线设备，不支持码的，走旧的添加流程
        if LCAddDeviceManager.sharedInstance.isSupportSC {
            self.pushToConnectCloud()
        } else if LCModuleConfig.shareInstance().isChinaMainland == false {
            self.pushToAuthDevicePasswordVC()
        } else {
            if LCAddDeviceManager.sharedInstance.abilities.contains("Auth") {
                self.pushToAuthDevicePasswordVC()
            } else if LCAddDeviceManager.sharedInstance.abilities.contains("RegCode") {
                if let code = LCAddDeviceManager.sharedInstance.regCode, code.count != 0 {
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
    
    private func checkDeviceModelIsValidNotNC(deviceInfo: LCUserDeviceBindInfo, qrModel: String?, deviceId: String) -> Bool {
        // TODO: 切换配网方式需要修改
        if deviceInfo.deviceModel == nil || deviceInfo.deviceModel.count == 0 {
            // 【*】异常处理，兼容在选择设备型号界面出现异常
            if container is LCSelectModelViewController == false {
                pushToSelectModelVC(deviceId: deviceId)
            } else {
                LCAlertView.lc_ShowAlert(title: nil, detail: "add_device_no_device".lc_T(), confirmString: "common_confirm".lc_T(), cancelString: "common_cancel".lc_T(), handle: nil)
            }
            return false
        }
        return true
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
        let controller = LCSelectModelViewController.storyboardInstance()
        controller.deviceId = deviceId
        self.container?.navigationVC()?.pushViewController(controller, animated: true)
    }
    
    private func pushToBindByOtherVC(account: String) {
        let controller = LCBindByOtherViewController.storyboardInstance()
        controller.bindAccount = account
        controller.deviceId = LCAddDeviceManager.sharedInstance.deviceId
        controller.isIot = LCAddDeviceManager.sharedInstance.deviceId.length > 0
        container?.navigationVC()?.pushViewController(controller, animated: true)
    }
    
    private func pushToAuthDevicePasswordVC() {
        let controller = LCAuthPasswordViewController.storyboardInstance()
        controller.presenter = LCAuthPasswordPresenter(container: controller)
        self.container?.navigationVC()?.pushViewController(controller, animated: true)
    }
    
    private func pushToApGuideVC() {
        let controller = LCApGuideViewController()
        self.container?.navigationVC()?.pushViewController(controller, animated: true)
    }
    
    private func pushToAuthRegCodeVC() {
        let controller = LCAuthRegCodeViewController.storyboardInstance()
        self.container?.navigationVC()?.pushViewController(controller, animated: true)
    }
    
    private func pushToConnectCloud() {
        let controller = LCConnectCloudViewController.storyboardInstance()
        controller.deviceInitialPassword = LCAddDeviceManager.sharedInstance.initialPassword
        self.container?.navigationVC()?.pushViewController(controller, animated: true)
    }
    
    private func pushToInputSN() {
        let controller = LCInputSNViewController.storyboardInstance()
        controller.qrCodeScanFailedClosure = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                LCProgressHUD.showMsg("incomplete_QR_code_information".lc_T())
            })
        }
        self.container?.navigationVC()?.pushViewController(controller, animated: true)
    }
	
	private func pushToUnsupportVC() {
		let controller = LCDeviceUnsupportViewController()
		self.container?.navigationVC()?.pushViewController(controller, animated: true)
	}

    // MARK: LCSheetViewDelegate
    
    func sheetView(_ sheetView: LCSheetView!, clickedButtonAt buttonIndex: Int) {
        let btnTitle = sheetView.button(at: buttonIndex)?.titleLabel?.text
        let manager = LCAddDeviceManager.sharedInstance
        var controller: UIViewController?
        
        if let vc = controller {
            self.container?.navigationVC()?.pushViewController(vc, animated: true)
        }
    }
}
