//
//  Copyright © 2018年 Imou. All rights reserved.
//

import UIKit
import DHScanner
import SnapKit
//二生成维码界面

private let kMaxBrightness: CGFloat = 0.8

class LCAddByQRCodeVC: LCAddBaseViewController, ILCAddByQRCodeView {
    var presenter: ILCAddByQRCodePresenter?

    var lastBrightness: CGFloat = 1.0
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.lcFont_t1()
        label.textColor = UIColor.lccolor_c2()
        label.text = "add_device_qrcode_title_tip".lc_T()
        return label
    }()
    
    lazy var tipLabelBottom: UILabel = {
        let label = UILabel()
        label.font = UIFont.lcFont_t5()
        label.textColor = UIColor.lccolor_c5()
        label.text = "add_device_qrcode_msg_tip".lc_T()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var nextBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("common_next".lc_T(), for: .normal)
        btn.lc_setRadius(5.0)
        btn.backgroundColor = UIColor.lccolor_c1()
        btn.setTitleColor(UIColor.lccolor_c43(), for: .normal)
        btn.addTarget(self, action: #selector(nextBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15.0)
            make.right.equalTo(-15.0)
            make.bottom.equalTo(-15.0)
            make.height.equalTo(45.0)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.equalTo(0.0)
            make.right.equalTo(0.0)
            make.bottom.equalTo(self.nextBtn.snp.top).offset(-15.0)
            make.top.equalTo(0.0)
        }
        
        let qrcodeImage = DHScannerUtils.createQRCodeWithoutMargin(string: (self.presenter?.qrCodeContent)!, size: CGSize(width: 500, height: 500))
        qrImageView.image = qrcodeImage
        scrollView.addSubview(qrImageView)
        qrImageView.snp.makeConstraints { (make) in
            make.left.equalTo(56.0)
            make.top.equalTo(35.0)
            make.right.equalTo(-56.0)
            make.width.equalTo(UIScreen.main.bounds.size.width - 56 * 2)
            make.height.equalTo(self.qrImageView.snp.width)
        }
        
        scrollView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.qrImageView.snp.bottom).offset(25.0)
            make.centerX.equalTo(self.scrollView)
        }
        
        let tipImageView = UIImageView(image: UIImage(lc_named: "adddevice_pic_scanqrcode"))
        scrollView.addSubview(tipImageView)
        tipImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.tipLabel.snp.bottom).offset(10.0)
        }

        scrollView.addSubview(tipLabelBottom)
        tipLabelBottom.snp.makeConstraints { (make) in
            make.top.equalTo(tipImageView.snp.bottom).offset(14.0)
            make.centerX.equalTo(self.scrollView)
            make.bottom.equalTo(self.scrollView)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lastBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = kMaxBrightness
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIScreen.main.brightness = lastBrightness
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - control event
    
    @objc private func nextBtnClicked() {
        presenter?.goNext()
    }
}

