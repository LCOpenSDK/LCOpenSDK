//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

import UIKit
import LCBaseModule.LCModule

class LCAddFAQViewController: LCAddBaseViewController {

	private var webVc: LCWebViewController?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		if LCModuleConfig.shareInstance().isChinaMainland {
            title = "Device_AddDevice_Add_Help".lc_T
        } else {
            title = "me_settings_faq".lc_T
        }
		
		setupWebVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	public func setupWebVC() {
        //需要补齐路径
        let strUrl = "https://www.xxx.com"
        
		if webVc == nil {
            webVc = LCWebViewController()
		}
		
		webVc!.playUrl = strUrl
		
		addChildViewController(webVc!)
		view.addSubview(webVc!.view)
		webVc!.view.snp.makeConstraints { make in
			make.edges.equalTo(self.view)
		}
	}
	
	// MARK: - LCAddBaseVCProtocol
	override func isRightActionHidden() -> Bool {
		return true
	}
}
