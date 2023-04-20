//
//  Copyright © 2020 Imou. All rights reserved.
//

import UIKit

class LCApWifiHeaderView: UIView {
    @IBOutlet weak var imageView2G: UIImageView!
    @IBOutlet weak var label2G: UILabel!
    @IBOutlet weak var label5G: UILabel!
    @IBOutlet weak var imageView5G: UIImageView!
    @IBOutlet weak var wifiSupportLabel: UILabel!
    @IBOutlet weak var helpImageView: UIImageView!
    @IBOutlet weak var selectWifiHelp: UIImageView!
    @IBOutlet weak var selectwifiTip: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadSubviews()
        helpImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(helpClicked)))
        selectWifiHelp.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectHelpClicked)))
    }
    
    public static func xibInstance() -> LCApWifiHeaderView {
        if let view = Bundle.lc_addDeviceBundle()?.loadNibNamed("LCApWifiHeaderView", owner: nil, options: nil)!.first as? LCApWifiHeaderView {
            return view
        }
        return LCApWifiHeaderView()
    }

    private func loadSubviews() {
        helpImageView.isUserInteractionEnabled = true
        selectWifiHelp.isUserInteractionEnabled = true
        self.selectwifiTip.text = "add_device_softap_wifi_select".lc_T()
        self.wifiSupportLabel.text = "add_device_device_unsupport_5G".lc_T()
        
        if LCAddDeviceManager.sharedInstance.isSupport5GWifi {
            self.imageView2G.image = UIImage(lc_named: "adddevice_wifi_support")
            self.imageView5G.image = UIImage(lc_named: "adddevice_wifi_support")
            self.wifiSupportLabel.isHidden = true
            self.helpImageView.isHidden = true
        } else {
            self.imageView2G.image = UIImage(lc_named: "adddevice_wifi_support")
            self.imageView5G.image = UIImage(lc_named: "adddevice_wifi_unsupport")
            self.wifiSupportLabel.isHidden = false
            self.helpImageView.isHidden = false
        }
    }
    
    @objc func helpClicked() {
        let sheet = LCSheetGuideView(title: "add_device_connect_2_4g_wifi".lc_T(), message: "add_device_connect_2_4g_wifi_explain".lc_T(), image: nil, cancelButtonTitle: "Alert_Title_Button_Confirm1".lc_T())
             sheet.show()
    }
    
    @objc func selectHelpClicked() {
        let sheet = LCSheetGuideView(title: "Alert_Title_Notice2".lc_T(), message:"special_symbols_such_as_facial_expressions".lc_T(), image: nil, cancelButtonTitle: "Alert_Title_Button_Confirm1".lc_T())
        sheet.show()
    }
    
}
