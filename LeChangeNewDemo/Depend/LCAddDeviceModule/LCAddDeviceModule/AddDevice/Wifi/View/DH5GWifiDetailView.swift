//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	5G路由器的详细说明

import UIKit

class DH5GWifiDetailView: UIView {

    @IBOutlet weak var textLabel: UILabel!
    
    public static func xibInstance() -> DH5GWifiDetailView {
        guard let view = Bundle.dh_addDeviceBundle()?.loadNibNamed("DH5GWifiDetailView", owner: nil, options: nil)?.first as? DH5GWifiDetailView else {
            return DH5GWifiDetailView()
        }

        view.backgroundColor = UIColor.dhcolor_c43()
        view.textLabel.textColor = UIColor.dhcolor_c2()
		return view
	}
}
