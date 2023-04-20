//
//  Copyright © 2019年 Imou. All rights reserved.
//

import UIKit

class LCHotSpotViewController: LCAddBaseViewController {

    let imageView = UIImageView()
    let mainTipLabel = UILabel()
    let littleTipLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "add_device_title".lc_T()
        
        configureSubviews()
        configureConstraints()
        
    }
    
    private func configureConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(self.view.snp.width).multipliedBy(0.66)
        }
        
        mainTipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp_bottomMargin).offset(30)
            make.left.equalTo(imageView).offset(10)
            make.right.equalTo(imageView).offset(-10)
            make.height.greaterThanOrEqualTo(100)
        }
        
        littleTipLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-30)
            make.left.equalTo(imageView).offset(50)
            make.right.equalTo(imageView).offset(-50)
            make.height.greaterThanOrEqualTo(50)
        }
    }
    
    private func configureSubviews() {
        self.view.addSubview(imageView)
        self.view.addSubview(mainTipLabel)
        self.view.addSubview(littleTipLabel)
        
        imageView.image = UIImage(lc_named: "adddevice_pic_serialnumber")
        
        mainTipLabel.numberOfLines = 5
        mainTipLabel.textAlignment = .center
        mainTipLabel.textColor = UIColor.lccolor_c2()
        mainTipLabel.font = UIFont.lcFont_t1()
        mainTipLabel.text = "add_devices_tip_about_wifi_pwd".lc_T()
        
        littleTipLabel.numberOfLines = 2
        littleTipLabel.font = UIFont.lcFont_t5()
        littleTipLabel.textAlignment = .center
		littleTipLabel.text = nil
        
    }

}
