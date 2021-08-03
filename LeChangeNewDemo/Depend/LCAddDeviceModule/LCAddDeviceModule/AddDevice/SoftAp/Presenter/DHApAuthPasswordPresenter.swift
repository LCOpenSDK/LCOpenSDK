//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//  密码检验界面解释器：软Ap

import UIKit

class DHApAuthPasswordPresenter: NSObject, DHAuthPasswordPresenterProtocol {

    weak var container: DHAuthPasswordViewController?
    var scDeviceIsInited: Bool = false
    
    required init(container: DHAuthPasswordViewController) {
        self.container = container
    }
    
    func nextStepAction(password: String, device: ISearchDeviceNetInfo?, deviceId: String) {
		if device == nil {
			LCProgressHUD.showMsg("add_device_connect_failed_and_retry".lc_T)
			return
		}
		
        LCProgressHUD.show(on: self.container?.view)
        let helper = DHAuthPassworHelper()
		
		helper.authByNetSDK(password: password, device: device!, success: { loginHandle in
            DHAddDeviceManager.sharedInstance.initialPassword = password
            //【*】获取WIFI列表后，跳转软AP选择WIFI界面
			DHNetSDKHelper.loadWifiList(byLoginHandle: loginHandle, complete: { (wifiList, error) in
                LCProgressHUD.hideAllHuds(self.container?.view)
                let controller = DHApWifiSelectViewController.storyboardInstance()
                controller.loginHandle = loginHandle
                controller.devicePassword = password
                if wifiList != nil {
                    controller.wifiList.append(contentsOf: wifiList!)
                }
                controller.scDeviceIsInited = self.scDeviceIsInited
                
                self.container?.navigationController?.pushViewController(controller, animated: true)
            })
            
        }) { (description) in
            LCProgressHUD.hideAllHuds(self.container?.view)
			
			//返回后不再进行提示等操作
			if self.container == nil {
				return
			}
			
			//用户被锁定、密码输入错误
			if description == "login_user_locked" {
				self.showDeviceLockVC()
			} else if description == "login_user_or_pwd_error" {
				LCProgressHUD.showMsg("add_device_password_error_and_will_lock".lc_T)
			} else {
				LCProgressHUD.showMsg(description.lc_T)
			}
        }
    }
	
	func showDeviceLockVC() {
		let controller = DHDeviceLockViewController()
		self.container?.navigationController?.pushViewController(controller, animated: true)
	}
}
