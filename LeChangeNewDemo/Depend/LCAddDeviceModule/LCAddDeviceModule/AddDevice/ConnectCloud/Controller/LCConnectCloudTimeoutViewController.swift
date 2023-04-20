//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	连接云平台超时

import UIKit

protocol LCConnectCloudTimeoutVCDelegate: NSObjectProtocol {
	func cloudTimeOutReconnectAction()
    func cloudTimeOutQuitAction()
}

class LCConnectCloudTimeoutViewController: LCAddBaseViewController, LCCommonErrorViewDelegate {
    func errorViewOnTryAgain(errorView: LCCommonErrorView) {
        self.delegate?.cloudTimeOutReconnectAction()
    }
    
    func errorViewOnQuit(errorView: LCCommonErrorView) {
        self.delegate?.cloudTimeOutQuitAction()
    }

	/// 特殊需求，将详情重置为空
	public var detailText: String? = ""
	
	public weak var delegate: LCConnectCloudTimeoutVCDelegate?
	
    private lazy var failureView: LCCommonErrorView = {
        let view = LCCommonErrorView.init()
        view.imageView.image = UIImage(lc_named: "adddevice_failure")
        view.titleLabel.text = "add_device_failure".lc_T()
        view.descTextView.text = "add_device_failure_alert".lc_T()
        view.delegate = self
        return view
    }()
	
	override func viewDidLoad() {
		super.viewDidLoad()
        self.title = ""
        self.view.addSubview(self.failureView)
        self.failureView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
	}
	
	override func leftActionType() -> LCAddBaseLeftAction {
		return .quit
	}
	
	override func isLeftActionShowAlert() -> Bool {
		return true
	}
}
