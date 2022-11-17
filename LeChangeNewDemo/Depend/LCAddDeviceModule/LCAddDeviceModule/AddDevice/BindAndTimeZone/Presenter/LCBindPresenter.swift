//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	说明：不要在局部函数中创建LCBindPresenter对象，会导致内部的delegate为nil

import UIKit

/// 绑定容器(UIViewController)需要实现的协议
protocol LCBindContainerProtocol: LCAddBaseVCProtocol {
	
	func navigationVC() -> UINavigationController?
	
	func mainController() -> UIViewController
	
	func mainView() -> UIView
	
	func retry()
}

class LCBindPresenter: NSObject, LCConnectCloudTimeoutVCDelegate {

	private weak var container: LCBindContainerProtocol?
	
	private var isInBinding: Bool = false
	
	/// 绑定失败的界面，UE没有考虑，暂时这样处理
	private lazy var failureView: LCConnectCloudTimeoutViewController = {
		let vc = LCConnectCloudTimeoutViewController()
		vc.delegate = self
		vc.failureType = .cloudTimeout
		vc.detailText = nil
		return vc
	}()
	
	/// 已经验证过的密码，再试重试绑定时，就不需要登录设备【海外用】
	private var authedPassword: String = ""
	
	deinit {
        debugPrint("🍻🍻🍻", "Deinit Success:", self)
	}
	
	func setup(container: LCBindContainerProtocol?) {
		self.container = container
	}
	
	public func bindDevice(devicePassword: String,
						   isPasswordAuthed: Bool = false,
						   code: String? = nil,
						   deviceKey: String? = nil,
						   showLoading: Bool = true,
						   showErrorTip: Bool = true,
						   complete: ((_ isSucceed: Bool) -> ())?) {
		if self.isInBinding {
			return
		}
		 
		if showLoading {
			DispatchQueue.main.async {
				LCProgressHUD.show(on: self.container?.mainView())
			}
		}
		
		if isPasswordAuthed {
			self.authedPassword = devicePassword
		}

		self.isInBinding = true
        
		LCAddDeviceManager.sharedInstance.bindDevice(devicePassword: devicePassword, code: code, deviceKey: "", success: {
            LCAddDeviceManager.sharedInstance.addPlicy {
                LCAddDeviceManager.sharedInstance.getDeviceInfoAfterBind(success: { (successInfo) in
                    LCProgressHUD.hideAllHuds(self.container?.mainView())
                    self.isInBinding = false
                    self.deviceBindedProcessed(successInfo: successInfo)
                    complete?(true)
                }) { (error) in
                    
                }
            } failure: { (error) in
            }
		}) { (error) in
			LCProgressHUD.hideAllHuds(self.container?.mainView())

			//【*】处理特定的绑定错误码：海外由于是绑定前进行检验，不需要处理
			var errorProcessed = false
			if LCModuleConfig.shareInstance()?.isChinaMainland == true {
				errorProcessed = self.bindUnsuccessfullyProcessed(error: error, type: .cloudTimeout)
			}
			
			if showErrorTip, errorProcessed == false {
                if error.errorMessage.count > 0 {
                    error.showTips(error.errorMessage)
                } else {
                    error.showTips("device_common_operate_fail_try_again".lc_T)
                }
			}
			
			self.isInBinding = false
			complete?(false)
		}
	}
	
	// MARK: 绑定错误处理
	public func deviceBindedProcessed(successInfo: LCBindDeviceSuccess) {
		//【*】bindStatus为空，跳转正常的绑定成功页面
		//【*】bindStatus为bindByMe，返回到首页，给出提示
		//【*】bindStatus为bindByOther，跳转到被别人绑定的界面
		if successInfo.bindStatus == nil || successInfo.bindStatus.count == 0 {
			let successVc = LCBindSuccessViewController.storyboardInstance()
			successVc.deviceName = successInfo.deviceName ?? ""
            successVc.successInfo = successInfo
			self.container?.navigationVC()?.pushViewController(successVc, animated: true)
		} else if successInfo.bindStatus.lc_caseInsensitiveSame(string: "bindByMe") {
			LCProgressHUD.showMsg("add_device_device_bind_by_yourself".lc_T)
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				self.container?.baseExitAddDevice(showAlert: false, backToMain: true)
			}
		} else {
			let bindVc = LCBindByOtherViewController.storyboardInstance()
			bindVc.bindAccount = successInfo.userAccount ?? ""
			bindVc.leftAction = .quit
			self.container?.navigationVC()?.pushViewController(bindVc, animated: true)
		}
	}
	
	/// 绑定失败处理：序列号串号、绑定次数过多、局域网限制等特定错误
	///
	/// - Parameters:
	///   - error: 错误
	///   - type: 失败类型
	/// - Returns: 成功处理，返回true; 未处理失败，返回false
	public func bindUnsuccessfullyProcessed(error: LCError, type: LCNetConnectFailureType) -> Bool {
		let errorCode = error.errorCode //EC_DEVICE_BINDING_LAN_LIMIT.rawValue //
		
		var processed = false
		if errorCode == "DV1014" || errorCode == "DV1015" || errorCode == "DV1040" {
			//【*】绑定限制：时间和次数
			let desc = error.errorMessage as? String
			_ = self.showBindFailureView(imagename: "adddevice_fail_rest", content: desc)
			processed = true
		} else if errorCode == "DV1013" || errorCode == "DV1044" || errorCode == "DV1018" {
			//【*】绑定限制：局域网
			let desc = error.errorMessage as? String
			//let testText = "您的设备注册到平台已超过3天\n要求设备与客户端在同一局域网才能绑定\n请断电重启"
			let vc = self.showBindFailureView(imagename: "adddevice_netsetting_power", content: desc)
			if let image = UIImage(named: "adddevice_netsetting_power") {
				vc.errorView.updateTopImageViewConstraint(top: 0, width: image.width, height: image.height)
			}
			
			processed = true
		}
        else if errorCode == "DV1042" {
			//【*】密码错误：设备密码错误达限制次数
			let vc = self.showBindFailureView(imagename: "adddevice_netsetting_power", content: "add_device_device_locked_please_reboot".lc_T)
			if let image = UIImage(named: "adddevice_netsetting_power") {
				vc.errorView.updateTopImageViewConstraint(top: 0, width: image.width, height: image.height)
			}

			processed = true
		}
        else if errorCode == "DV1005" || errorCode == "DV1027" || errorCode == "DV1025" || errorCode == "DV1016" {
			//【*】绑定时错误: 旧的密码错误（13005）、通过sc初始化失败（当超时处理）
			//【*】绑定时密码错误：增加SC方式，修改设备密码后，会出现这种情况，以默认的sc码，进行绑定，密码错误
			//【*】如果已在当前界面，则不需要处理
			if container?.mainController().isKind(of: LCAuthPasswordViewController.self) == false {
				let controller = LCAuthPasswordViewController.storyboardInstance()
				controller.presenter = LCAuthPasswordPresenter(container: controller)
				container?.navigationVC()?.pushViewController(controller, animated: true)
				
				processed = true
			}
		} 
		
		return processed
	}
	
	private func showBindFailureView(imagename: String, content: String?) -> LCBindFailureViewController {

		let errorVc = LCBindFailureViewController()
		errorVc.imagename = imagename
		errorVc.content = content
		
		if let controller = self.container?.mainController() {
			errorVc.showOnParent(controller: controller)
		}
		
		return errorVc
	}
}


// MARK: LCConnectCloudTimeoutVCDelegate
extension LCBindPresenter {
	
	func cloudTimeOutReconnectAction(controller: LCConnectCloudTimeoutViewController) {
		if self.authedPassword.count > 0 {
			self.bindDevice(devicePassword: self.authedPassword, isPasswordAuthed: true, code: nil, deviceKey: nil, showLoading: true, showErrorTip: true, complete: nil)
		} else {
			//国内无法验证密码，需要再次进输入密码界面绑定
			self.failureView.dismiss()
		}
	}
}
