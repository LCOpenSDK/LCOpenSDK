//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	5G路由器的详细说明

import UIKit

class LC5GWifiDetailView: UIView {

    @IBOutlet weak var textLabel: UILabel!
    
    public static func xibInstance() -> LC5GWifiDetailView {
        guard let view = Bundle.lc_addDeviceBundle()?.loadNibNamed("LC5GWifiDetailView", owner: nil, options: nil)?.first as? LC5GWifiDetailView else {
            return LC5GWifiDetailView()
        }

        view.backgroundColor = UIColor.lccolor_c43()
        view.textLabel.textColor = UIColor.lccolor_c2()
		return view
	}
}
