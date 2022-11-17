//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//  密码检验界面解释器：软Ap

import UIKit

class LCApAuthPasswordPresenter: NSObject, LCAuthPasswordPresenterProtocol {

    weak var container: LCAuthPasswordViewController?
    var scDeviceIsInited: Bool = false
    
    required init(container: LCAuthPasswordViewController) {
        self.container = container
    }
    
    func nextStepAction(password: String, device: ISearchDeviceNetInfo?, deviceId: String) {
		if device == nil {
			LCProgressHUD.showMsg("add_device_connect_failed_and_retry".lc_T)
			return
		}
		
        LCProgressHUD.show(on: self.container?.view)
        LCNetSDKHelper.getSoftApWifiList(device?.deviceIP ?? "", port: Int(device?.port ?? 37777), devicePassword: password, isSC: false) { wifiList in
            LCProgressHUD.hideAllHuds(self.container?.view)
            let controller = LCApWifiSelectViewController.storyboardInstance()
            controller.devicePassword = password
            if wifiList != nil {
                controller.wifiList.append(contentsOf: wifiList!)
            }
            controller.scDeviceIsInited = self.scDeviceIsInited
            
            self.container?.navigationController?.pushViewController(controller, animated: true)
        } failure: { errorCode, description in
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
                LCProgressHUD.showMsg(description?.lc_T)
            }
        }
    }
	
	func showDeviceLockVC() {
		let controller = LCDeviceLockViewController()
		self.container?.navigationController?.pushViewController(controller, animated: true)
	}
}
