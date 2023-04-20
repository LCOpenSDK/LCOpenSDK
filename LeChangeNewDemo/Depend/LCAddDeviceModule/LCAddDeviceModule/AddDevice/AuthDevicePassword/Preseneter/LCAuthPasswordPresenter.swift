//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//  密码检验界面解释器：普通设备

import UIKit

protocol LCAuthPasswordPresenterProtocol {
    var container: LCAuthPasswordViewController? {
        set get
    }
    
    init(container: LCAuthPasswordViewController)
    
	/// 下一步验证密码响应
	///
	/// - Parameters:
	///   - password: 密码
	///   - device: 局域网搜索到的设备
	///   - deviceId: 序列号
	func nextStepAction(password: String, deviceId: String)
}

class LCAuthPasswordPresenter: NSObject, LCAuthPasswordPresenterProtocol {
    weak var container: LCAuthPasswordViewController?

	private lazy var bindPresenter: LCBindPresenter = {
		let presenter = LCBindPresenter()
		return presenter
	}()
    
    required init(container: LCAuthPasswordViewController) {
        self.container = container
    }
    
    func nextStepAction(password: String, deviceId: String) {
        bindPresenter.setup(container: self.container)
        bindPresenter.bindDevice(devicePassword: password, isPasswordAuthed: false, code: nil, deviceKey: nil, showLoading: true, showErrorTip: true, complete: nil)
    }
	
	func showDeviceLockVC() {
		let controller = LCDeviceLockViewController()
		self.container?.navigationController?.pushViewController(controller, animated: true)
	}
}
