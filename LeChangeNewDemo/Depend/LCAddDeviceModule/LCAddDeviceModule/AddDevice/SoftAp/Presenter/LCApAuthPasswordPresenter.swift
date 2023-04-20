//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//  密码检验界面解释器：软Ap

import UIKit
import LCOpenSDKDynamic

class LCApAuthPasswordPresenter: NSObject, LCAuthPasswordPresenterProtocol {

    weak var container: LCAuthPasswordViewController?
    var scDeviceIsInited: Bool = false
    var searchedDevice: LCOpenSDK_SearchDeviceInfo?
    
    required init(container: LCAuthPasswordViewController) {
        self.container = container
    }
    
    func nextStepAction(password: String, deviceId: String) {
        // 离线配网，无SC时，手动输入SC
        if LCAddDeviceManager.sharedInstance.isEntryFromWifiConfig {
            LCAddDeviceManager.sharedInstance.initialPassword = password
            let controller = LCApWifiCheckViewController()
            self.container?.navigationController?.pushViewController(controller, animated: true)
            return
        }
        
        if self.searchedDevice == nil {
			LCProgressHUD.showMsg("add_device_connect_failed_and_retry".lc_T())
			return
		}
		
        LCProgressHUD.show(on: self.container?.view)
        LCNetSDKHelper.getSoftApWifiList(self.searchedDevice?.ip ?? "", port: Int(self.searchedDevice?.port ?? 37777), devicePassword: password, isSC: false) { wifiList in
            LCProgressHUD.hideAllHuds(self.container?.view)
            let controller = LCApWifiSelectViewController()
            controller.devicePassword = password
            if wifiList != nil {
                controller.wifiList.append(contentsOf: wifiList!)
            }
            controller.searchedDevice = self.searchedDevice
            controller.scDeviceIsInited = self.scDeviceIsInited
            self.container?.navigationController?.pushViewController(controller, animated: true)
        } failure: { errorCode, description in
            let errorDesc = LCNetSDKInterface.getErrorDescription(UInt32(bitPattern: Int32(errorCode)))
            LCProgressHUD.hideAllHuds(self.container?.view)
            //返回后不再进行提示等操作
            if self.container == nil {
                return
            }
            //用户被锁定、密码输入错误
            if errorDesc == "login_user_locked" {
                self.showDeviceLockVC()
            } else if errorDesc == "login_user_or_pwd_error" {
                LCProgressHUD.showMsg("add_device_password_error_and_will_lock".lc_T())
            } else {
                LCProgressHUD.showMsg(description?.lc_T())
            }
        }
    }
	
	func showDeviceLockVC() {
		let controller = LCDeviceLockViewController()
		self.container?.navigationController?.pushViewController(controller, animated: true)
	}
}
