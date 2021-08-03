//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	通用错误界面：适用于按钮固定的场景

import UIKit

class DHErrorBaseViewController: DHAddBaseViewController, DHCommonErrorViewDelegate, DHErrorBaseVCProtocol {

	public var errorView: DHCommonErrorView = DHCommonErrorView.xibInstance()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupErrorView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setupErrorView() {
		errorView.delegate = self
		view.addSubview(errorView)
		
		errorView.snp.makeConstraints { make in
			make.edges.equalTo(self.view)
		}
		
		errorView.imageView.image = UIImage(named: errorImageName())
		errorView.contentLabel.dh_setAttributedText(text: errorContent(), font: UIFont.dhFont_t2())
		errorView.detailLabel.dh_setAttributedText(text: errorDescription(), font: UIFont.dhFont_t4())
        errorView.contentLabel.textColor = UIColor.dhcolor_c2()
        errorView.detailLabel.textColor = UIColor.dhcolor_c5()
		errorView.confrimButton.setTitle(confirmText(), for: .normal)
		errorView.confrimButton.isHidden = icConfirmHidden()
        errorView.confrimButton.setTitleColor(UIColor.dhcolor_c43(), for: .normal)
		errorView.quitButton.setTitle(quitText(), for: .normal)
        errorView.quitButton.setTitleColor(UIColor.dhcolor_c2(), for: .normal)
		errorView.quitButton.isHidden = isQuitHidden()
        
        if dh_screenHeight < 667 {
            errorView.contentLabel.dh_setAttributedText(text: errorContent(), font: UIFont.systemFont(ofSize: 13))
        } else {
            errorView.contentLabel.dh_setAttributedText(text: errorContent(), font: UIFont.dhFont_t2())
        }
	}
	
	public func dismiss() {
		self.view.removeFromSuperview()
		self.parent?.view.lc_transitionAnimation(type: .fade, direction: .fromBottom, duration: 0.3)
		self.removeFromParentViewController()
	}
	
	public func showOnParent(controller: UIViewController) {
		controller.addChildViewController(self)
		controller.view.addSubview(self.view)
		self.view.frame = controller.view.bounds
		
		controller.view.lc_transitionAnimation(type: .fade, direction: .fromBottom, duration: 0.3)
	}
	
	// MARK: DHAddBaseVCProtocol
	override func leftActionType() -> DHAddBaseLeftAction {
		return .quit
	}
	
	override func isLeftActionShowAlert() -> Bool {
		return true
	}
	
	override func rightActionType() -> [DHAddBaseRightAction] {
		return [.restart]
	}
	
	// MARK: DHErrorBaseVCProtocol
	func errorImageName() -> String {
		return "adddevice_fail_configurationfailure"
	}
	
	func errorContent() -> String {
		return "Please input content"
	}
	
	func errorDescription() -> String? {
		return nil
	}
	
	func icConfirmHidden() -> Bool {
		return false
	}
	
	func confirmText() -> String {
		return "add_device_confirm".lc_T
	}
	
	func quitText() -> String {
		return "add_device_quit".lc_T
	}
	
	func isQuitHidden() -> Bool {
		return true
	}
	
	func doConfirm() {
		baseBackToAddDeviceRoot()
	}
	
	func doQuit() {
		baseExitAddDevice()
	}
	
	func doFAQ() {
		basePushToFAQ()
	}
    
    func doBackRoot() {
        baseBackToAddDeviceRoot()
    }
}

extension DHErrorBaseViewController {
	// MARK: DHCommonErrorViewDelegate
	func errorViewOnConfirm(errorView: DHCommonErrorView) {
		doConfirm()
	}
	
	func errorViewOnFAQ(errorView: DHCommonErrorView) {
		doFAQ()
	}
	
	func errorViewOnQuit(errorView: DHCommonErrorView) {
		doQuit()
	}
    
    func errorViewOnBackRoot(errorView: DHCommonErrorView) {
        doBackRoot()
    }
}
