//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	通用错误界面：适用于按钮固定的场景

import UIKit

class LCErrorBaseViewController: LCAddBaseViewController, LCCommonErrorViewDelegate, LCErrorBaseVCProtocol {

	public var errorView: LCCommonErrorView = LCCommonErrorView.xibInstance()
	
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
		errorView.contentLabel.lc_setAttributedText(text: errorContent(), font: UIFont.lcFont_t2())
		errorView.detailLabel.lc_setAttributedText(text: errorDescription(), font: UIFont.lcFont_t4())
        errorView.contentLabel.textColor = UIColor.lccolor_c2()
        errorView.detailLabel.textColor = UIColor.lccolor_c5()
		errorView.confrimButton.setTitle(confirmText(), for: .normal)
		errorView.confrimButton.isHidden = icConfirmHidden()
        errorView.confrimButton.setTitleColor(UIColor.lccolor_c43(), for: .normal)
		errorView.quitButton.setTitle(quitText(), for: .normal)
        errorView.quitButton.setTitleColor(UIColor.lccolor_c2(), for: .normal)
		errorView.quitButton.isHidden = isQuitHidden()
        
        if lc_screenHeight < 667 {
            errorView.contentLabel.lc_setAttributedText(text: errorContent(), font: UIFont.systemFont(ofSize: 13))
        } else {
            errorView.contentLabel.lc_setAttributedText(text: errorContent(), font: UIFont.lcFont_t2())
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
	
	// MARK: LCAddBaseVCProtocol
	override func leftActionType() -> LCAddBaseLeftAction {
		return .quit
	}
	
	override func isLeftActionShowAlert() -> Bool {
		return true
	}
	
	override func rightActionType() -> [LCAddBaseRightAction] {
		return [.restart]
	}
	
	// MARK: LCErrorBaseVCProtocol
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

extension LCErrorBaseViewController {
	// MARK: LCCommonErrorViewDelegate
	func errorViewOnConfirm(errorView: LCCommonErrorView) {
		doConfirm()
	}
	
	func errorViewOnFAQ(errorView: LCCommonErrorView) {
		doFAQ()
	}
	
	func errorViewOnQuit(errorView: LCCommonErrorView) {
		doQuit()
	}
    
    func errorViewOnBackRoot(errorView: LCCommonErrorView) {
        doBackRoot()
    }
}
