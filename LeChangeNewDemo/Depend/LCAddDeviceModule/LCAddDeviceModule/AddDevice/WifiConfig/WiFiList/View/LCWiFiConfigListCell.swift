//
//  Copyright © 2018 Imou. All rights reserved.
//

import UIKit

class LCWiFiConfigListCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var wifiImageView: UIImageView!
    @IBOutlet weak var selectImageView: UIImageView!
    
    public func configView(status: LCWifiInfo) {
        nameLabel.textColor = UIColor.lccolor_c2()
        setWifiName(status: status)
        setWifiImage(status: status)
        selectImageView.image = UIImage(named: "wifi_connect")
//        setSelectImage(status: status)
    }
    
    private func setWifiName(status: LCWifiInfo) {
        nameLabel.text = status.ssid == "" ? "unKnowWifi" : status.ssid
    }
    
    private func setWifiImage(status: LCWifiInfo) {
        
        var imageName = ""
		
		//不使用拼接方式处理图片，防止资源被清除
        switch status.intensity {
        case 0:
			imageName = status.auth == "OPEN" ? "wifi_bad_unlock" : "wifi_bad_lock"
        case 1, 2:
			imageName = status.auth == "OPEN" ? "wifi_weak_unlock" : "wifi_weak_lock"
        case 3:
			imageName = status.auth == "OPEN" ? "wifi_good_unlock" : "wifi_good_lock"
        default:
			imageName = status.auth == "OPEN" ? "wifi_nice_unlock" : "wifi_nice_lock"
        }
        
        wifiImageView.image = UIImage(named: imageName)
    }
    
    private func setSelectImage(status: LCWifiInfo) {
        //LinkStatus：0未连接，1连接中，2已连接。
        selectImageView.isHidden = Int(status.linkStatus.rawValue) != 2
    }

}
