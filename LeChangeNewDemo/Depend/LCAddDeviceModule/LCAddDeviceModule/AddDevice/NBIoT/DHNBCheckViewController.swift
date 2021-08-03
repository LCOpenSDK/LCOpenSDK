//
//  Copyright © 2019 dahua. All rights reserved.
//	NB 自检/消音界面

import UIKit

class DHNBCheckViewController: DHGuideBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		// 进入NB配网，不需要进行局域网搜索
		DHNetSDKSearchManager.sharedInstance()?.stopSearch()
    }
	
	override func tipImageName() -> String? {
		return "adddevice_default"
	}
	
	override func tipImageUrl() -> String? {
		let introductionParser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
		return introductionParser?.nbGuideInfo.imageUrl
	}
	
	override func tipText() -> String? {
		let introductionParser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
		return introductionParser?.nbGuideInfo.content ?? DHOMSSNBGuideDefault.content
	}
	
	override func descriptionText() -> String? {
		return "add_device_nb_tip2".lc_T
	}
	
	override func isCheckHidden() -> Bool {
		return true
	}
	
	override func doNext() {
		//跳转连接乐橙云
		basePushToConnectCloudVC()
	}
}
