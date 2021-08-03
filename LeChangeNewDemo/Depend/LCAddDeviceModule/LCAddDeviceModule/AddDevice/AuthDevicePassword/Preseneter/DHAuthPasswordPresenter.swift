//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//  密码检验界面解释器：普通设备

import UIKit

protocol DHAuthPasswordPresenterProtocol {
    var container: DHAuthPasswordViewController? {
        set get
    }
    
    init(container: DHAuthPasswordViewController)
    
	/// 下一步验证密码响应
	///
	/// - Parameters:
	///   - password: 密码
	///   - device: 局域网搜索到的设备
	///   - deviceId: 序列号
	func nextStepAction(password: String, device: ISearchDeviceNetInfo?, deviceId: String)
}

class DHAuthPasswordPresenter: NSObject, DHAuthPasswordPresenterProtocol {
    weak var container: DHAuthPasswordViewController?

	/// 是否已经进行过登录验证【暂缓实现】
	private var isLoginAuthed: Bool = false
	
	private lazy var bindPresenter: DHBindPresenter = {
		let presenter = DHBindPresenter()
		return presenter
	}()
    
    required init(container: DHAuthPasswordViewController) {
        self.container = container
    }
    
    func nextStepAction(password: String, device: ISearchDeviceNetInfo?, deviceId: String) {
		//【*】支持SC码的，直接进行绑定; 不支持的，进入旧的分支处理
		if DHAddDeviceManager.sharedInstance.isSupportSC {
			self.bind(password: password, isPasswordAuthed: false)
			return
		}
		
		//【*】国内、SMB：直接绑定
		self.bind(password: password, isPasswordAuthed: false)
    }
	
	func showDeviceLockVC() {
		let controller = DHDeviceLockViewController()
		self.container?.navigationController?.pushViewController(controller, animated: true)
	}
    
	func bind(password: String, isPasswordAuthed: Bool, showLoading: Bool = true) {
		bindPresenter.setup(container: self.container)
		bindPresenter.bindDevice(devicePassword: password, isPasswordAuthed: isPasswordAuthed, code: nil, deviceKey: nil, showLoading: showLoading, showErrorTip: true, complete: nil)
    }
}
