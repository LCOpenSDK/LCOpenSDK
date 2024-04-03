//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	通用错误界面：适用于按钮固定的场景

import UIKit

@objcMembers class LCErrorBaseViewController: LCAddBaseViewController, LCCommonErrorViewDelegate, LCErrorBaseVCProtocol {

    public var errorView: LCCommonErrorView = LCCommonErrorView.init()
	
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
		
		errorView.imageView.image = UIImage(lc_named: errorImageName())
		errorView.titleLabel.lc_setAttributedText(text: errorContent(), font: UIFont.lcFont_t2())
        errorView.titleLabel.textColor = UIColor.lccolor_c2()
		errorView.tryAgainButton.setTitle(confirmText(), for: .normal)
		errorView.tryAgainButton.isHidden = icConfirmHidden()
        errorView.tryAgainButton.setTitleColor(UIColor.lccolor_c43(), for: .normal)
		errorView.quitButton.setTitle(quitText(), for: .normal)
        errorView.quitButton.setTitleColor(UIColor.lccolor_c2(), for: .normal)
		errorView.quitButton.isHidden = isQuitHidden()
        
        if errorView.quitButton.isHidden == true, errorView.tryAgainButton.isHidden == true {
            errorView.descTextView.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(25)
                make.trailing.equalToSuperview().offset(-25)
                make.top.equalTo(errorView.titleLabel.snp.bottom).offset(30)
                make.bottom.equalToSuperview().offset(-30)
            }
        }
        
        if lc_screenHeight < 667 {
            errorView.titleLabel.lc_setAttributedText(text: errorContent(), font: UIFont.systemFont(ofSize: 13))
        } else {
            errorView.titleLabel.lc_setAttributedText(text: errorContent(), font: UIFont.lcFont_t2())
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
		return "common_confirm".lc_T()
	}
	
	func quitText() -> String {
		return "add_device_quit".lc_T()
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
	func errorViewOnTryAgain(errorView: LCCommonErrorView) {
		doConfirm()
	}
	
	func errorViewOnQuit(errorView: LCCommonErrorView) {
		doQuit()
	}
    
//    func errorViewOnBackRoot(errorView: LCCommonErrorView) {
//        doBackRoot()
//    }
}
