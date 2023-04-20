//
//  Copyright © 2018 Imou. All rights reserved.
//

import UIKit

class LCWiFiConfigListCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var wifiImageView: UIImageView!
    @IBOutlet weak var lockImageView: UIImageView!
    
    public func configView(status: LCWifiInfo) {
        nameLabel.textColor = UIColor.lccolor_c2()
        setWifiName(status: status)
        setWifiImage(status: status)
        lockImageView.image = UIImage(lc_named: "wifi_lock")
        if status.auth == "OPEN" {
            lockImageView.isHidden = true
        } else {
            lockImageView.isHidden = false
        }
    }
    
    private func setWifiName(status: LCWifiInfo) {
        nameLabel.text = status.ssid == "" ? "unKnowWifi" : status.ssid
    }
    
    private func setWifiImage(status: LCWifiInfo) {
        var imageName = ""
		//不使用拼接方式处理图片，防止资源被清除
        switch status.intensity {
        case 0:
			imageName = "wifi_bad_unlock"
        case 1, 2:
			imageName = "wifi_weak_unlock"
        case 3:
			imageName = "wifi_good_unlock"
        default:
			imageName = "wifi_nice_unlock"
        }
        wifiImageView.image = UIImage(lc_named: imageName)
    }

}
