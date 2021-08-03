//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

import UIKit

class DHApWifiHeaderView: UIView {

	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var indicatorView: UIActivityIndicatorView!
	
	public static func xibInstance() -> DHApWifiHeaderView {
        if let view = Bundle.dh_addDeviceBundle()?.loadNibNamed("DHApWifiHeaderView", owner: nil, options: nil)!.first as? DHApWifiHeaderView {
            return view
        }
        
		return DHApWifiHeaderView()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		backgroundColor = UIColor.dhcolor_c7()
		indicatorView.hidesWhenStopped = true
		label.textColor = UIColor.dhcolor_c2()
		label.text = "add_device_choose_wifi".lc_T
	}
}
