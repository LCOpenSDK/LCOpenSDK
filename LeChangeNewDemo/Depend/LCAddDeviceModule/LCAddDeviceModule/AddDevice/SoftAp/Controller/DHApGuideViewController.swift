//
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit
import CoreLocation

class DHApGuideViewController: DHAddBaseViewController {

	private var guideViews: [DHAddGuideView] = [DHAddGuideView]()
	
	private lazy var locationManager: CLLocationManager = {
		let location = CLLocationManager()
		return location
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        
		self.getGuideInfo()
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//配置引导信息
	private func getGuideInfo() {
		let manager = DHAddDeviceManager.sharedInstance
		let introduction = manager.getIntroductionParser()
		
		//【*】已有数据，直接进行加载
		//【*】没有数据，但在更新中，使用默认值，等待更新完成后刷新界面
		//【*】没有数据，且不在更新，使用默认值，并更新
		if let steps = introduction?.softApGuideInfo.guideSteps, steps.count > 0 {
			self.setup(guideSteps: steps)
			return
		} else {
            var step = DHOMSSoftApGuideStep()
            step.content = DHOMSSoftApGuideDefault.content
            self.setup(guideSteps: [step])
            
        }
		
		//【*】监听回调通知
		self.baseAddOMSIntroductionObserver()
	
		if manager.isIntroductionUpdating() {
//            LCProgressHUD.showHub(on: self.view, duration: 5.0)
//			LCProgressHUD.show(on: self.view)
            
		} else {
			if let model = manager.deviceMarketModel {
				DHOMSConfigManager.sharedManager.checkUpdateIntrodution(byMarketModel: model)
			}
		}
	}
	
	/// 设置引导信息
	private func setup(guideSteps: [DHOMSSoftApGuideStep]) {
		guard guideSteps.count > 0 else {
			return
		}
		
		guideViews.removeAll()
		
		for guideStep in guideSteps {
			let guideView = DHAddGuideView.xibInstance()
			guideView.delegate = self
			guideView.frame = self.view.bounds
			guideViews.append(guideView)
			guideView.topTipLabel.dh_setAttributedText(text: guideStep.content, font: UIFont.dhFont_t1())
			guideView.errorButton.titleLabel?.font = UIFont.dhFont_t1()
			guideView.topTipLabel.textAlignment = .center
			
			guideView.topImageView.lc_setImage(withUrl: guideStep.imageUrl, placeholderImage: DHOMSSoftApGuideDefault.imagename, toDisk: true )
			guideView.setCheckHidden(hidden: true)
			guideView.setDetailButtonHidden(hidden: true)
			
			adjustConstraint(guideView: guideView)
		}
		
        if let lastGuideView = guideViews.last {
			lastGuideView.setDetailButtonHidden(hidden: false)
			
			let introduction = DHAddDeviceManager.sharedInstance.getIntroductionParser()
			lastGuideView.setDetailButton(text: introduction?.lightResetInfo.resetGuide ?? DHSoftApResetDefault.guide)
            
            //DTS000797168 问题修复
            if guideSteps.count == 1,guideSteps[0].content == DHOMSSoftApGuideDefault.content
            {
                lastGuideView.setDetailButtonHidden(hidden: true)
            }
		}
        
        
	
		resetGuideViewsToFirstStep()
	}
	
	/// 调整GuideView的约束
	private func adjustConstraint(guideView: DHAddGuideView) {

		if dh_screenHeight < 667 {
			guideView.updateTopImageViewConstraint(top: 0, width: 240, maxHeight: 240)
			guideView.updateContentLabelConstraint(top: 5)
		} else {
			guideView.updateTopImageViewConstraint(top: 0, width: UIScreen.main.bounds.size.width, maxHeight: 320)
			guideView.updateContentLabelConstraint(top: 10)
		}
	}
	
	/// 重置引导图至第一页
	public func resetGuideViewsToFirstStep() {
		guideViews.forEach { (view) in
			view.removeFromSuperview()
		}
		
		if guideViews.count > 0 {
			self.view.addSubview(guideViews[0])
			guideViews[0].dh_x = 0
		}
	}
	
	// MARK: DHAddBaseVCProtocol(OMS Introduction)
	override func needUpdateCurrentOMSIntroduction() {
		LCProgressHUD.hideAllHuds(self.view)
		let parser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
		
		//【*】更新成功了使用实际的
		//【*】未更新成功，使用默认的
		if let steps = parser?.softApGuideInfo.guideSteps, steps.count > 0 {
			self.setup(guideSteps: steps)
		} else {
			var step = DHOMSSoftApGuideStep()
			step.content = DHOMSSoftApGuideDefault.content
			self.setup(guideSteps: [step])
		}
	}
}

extension DHApGuideViewController: DHAddGuideViewDelegate {
	
	func guideView(view: DHAddGuideView, action: DHAddGuideActionType) {
		if action == .detail {
			//进入重置
			pushToDeviceResetVC()
		} else if action == .next {
			let index = guideViews.index(of: view)!
			if index < guideViews.count - 1 {
				// 切换下一页
				let nextView = guideViews[index + 1]
				trans(view: view, toView: nextView)
			} else {
				//iOS13界面：
				if #available(iOS 13.0, *) {
					let status = CLLocationManager.authorizationStatus()
					if status == .notDetermined {
						//申请权限
						locationManager.requestWhenInUseAuthorization()
					} else if status == .denied {
						//被拒绝后，重新申请
						LCSetJurisdictionHelper.setJurisdictionAlertView("mobile_common_permission_apply".lc_T, message: "mobile_common_permission_explain_access_location_usage".lc_T)
					} else {
						//有位置访问权限，跳转下一步
						goLastStep()
					}
				} else {
					goLastStep()
				}
			}
        } else if action == .error {
            let vc = LCDeviceAddErrorController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
	}
	
	func goLastStep() {
		//最后一步，跳转到网络检查;并重置引导
		resetGuideViewsToFirstStep()
		let controller = DHApWifiCheckViewController()
		navigationController?.pushViewController(controller, animated: true)
	}
	
	private func trans(view: DHAddGuideView, toView: DHAddGuideView) {
		toView.frame = self.view.bounds
		self.view.addSubview(toView)
		toView.dh_x = dh_screenWidth
		
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
			view.dh_x = -dh_screenWidth
			toView.dh_x = 0
			view.nextButton.alpha = 0
			
		}) { _ in
			view.nextButton.alpha = 1
			view.removeFromSuperview()
		}
	}
	
	private func pushToDeviceResetVC() {
		let controller = DHResetDeviceViewController()
		let introductionParser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
		controller.placeholderImage = DHSoftApResetDefault.imagename
		controller.imageUrl = introductionParser?.lightResetInfo.resetImageUrl
		
		controller.resetContent = introductionParser?.lightResetInfo.resetOperation ?? DHSoftApResetDefault.operation
		self.navigationController?.pushViewController(controller, animated: true)
	}
}
