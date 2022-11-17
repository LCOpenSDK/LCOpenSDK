//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

import UIKit

class DHApWifiHeaderView: UIView {

	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var indicatorView: UIActivityIndicatorView!
	
	public static func xibInstance() -> DHApWifiHeaderView {
        if let view = Bundle.lc_addDeviceBundle()?.loadNibNamed("DHApWifiHeaderView", owner: nil, options: nil)!.first as? DHApWifiHeaderView {
            return view
        }
        
		return DHApWifiHeaderView()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		backgroundColor = UIColor.lccolor_c7()
		indicatorView.hidesWhenStopped = true
		label.textColor = UIColor.lccolor_c2()
		label.text = "add_device_choose_wifi".lc_T
	}
}
