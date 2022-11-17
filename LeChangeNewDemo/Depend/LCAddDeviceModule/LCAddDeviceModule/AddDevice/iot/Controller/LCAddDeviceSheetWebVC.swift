//
//  LCAddDeviceSheetWebVC.swift
//  LCAddDeviceModule
//
//  Created by 吕同生 on 2022/10/19.
//  Copyright © 2022 Imou. All rights reserved.
//

import UIKit
import SnapKit
import LCBaseModule

public class LCAddDeviceSheetWebVC: UIViewController {
    
    open var playUrl: String = ""
    
    let bgViewHeight: CGFloat = lc_screenHeight - LC_statusBarHeight - lc_navBarHeight - 26 - LC_bottomSafeMargin
         
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 15
        bgView.backgroundColor = UIColor.white
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.height.equalTo(bgViewHeight)
            make.leading.equalTo(self.view).offset(20);
            make.trailing.equalTo(self.view).offset(-20);
            make.bottom.equalTo(self.view.snp.bottom).offset(lc_screenHeight);
        }
        return bgView
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton()
        sureBtn.setTitle("Alert_Title_Button_Confirm1".lc_T, for: .normal)
        sureBtn.setTitleColor(UIColor.lccolor_c43(), for: .normal)
        sureBtn.backgroundColor = UIColor.lccolor_c10()
        sureBtn.lc_setRadius(lc_scaleSize(22.5))
        sureBtn.addTarget(self, action: #selector(sureBtnClick), for: .touchUpInside)
        bgView.addSubview(sureBtn)
        return sureBtn
    }()
    
    lazy var webView:WKWebView = {
        
        let config: WKWebViewConfiguration = WKWebViewConfiguration.init()
        if #available(iOS 10.0, *) {
            config.mediaTypesRequiringUserActionForPlayback = .all
        } else {
            // Fallback on earlier versions
        }
        config.allowsInlineMediaPlayback = true
        
        let webView = WKWebView.init(frame: CGRect.zero, configuration: config)
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        bgView.addSubview(webView)
        return webView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.lc_color(withHexString: "0x0", alpha: 0.3)
        
        configureView()
        
        playUrl = playUrl.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//        WebViewJavascriptBridge.enableLogging()
        
        var url = URL.init(string: playUrl)
        if (url == nil) {
            playUrl = playUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            url = URL.init(string: playUrl)
        }
        
        webView.load(URLRequest.init(url: url!))
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.bgView.snp.updateConstraints { make in
                make.height.equalTo(self.bgViewHeight)
                make.leading.equalTo(self.view).offset(20);
                make.trailing.equalTo(self.view).offset(-20);
                make.bottom.equalTo(self.view.snp.bottom).offset(-26);
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func configureView() {
        webView.snp.makeConstraints { make in
            make.top.equalTo(bgView)
            make.leading.equalTo(bgView)
            make.trailing.equalTo(bgView)
            make.bottom.equalTo(sureBtn.snp.top).offset(20)
        }
        
        let gradientView = UIView()
        
        let gradient: CAGradientLayer = CAGradientLayer.init()
        gradient.frame = CGRect.init(x: 0, y: 0, width: lc_screenWidth - 40, height: lc_scaleSize(45 + 38))
        gradient.startPoint = CGPoint.init(x: 0, y: 1)
        gradient.endPoint = CGPoint.init(x: 0, y: 0)
        gradient.colors = [
            UIColor.lc_color(withHexString: "#FFFFFF", alpha: 1).cgColor,
            UIColor.lc_color(withHexString: "#FFFFFF", alpha: 0).cgColor,
        ]
        gradientView.layer.addSublayer(gradient)
        webView.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.leading.equalTo(webView)
            make.trailing.equalTo(webView)
            make.bottom.equalTo(webView).offset(0)
            make.height.equalTo(lc_scaleSize(45 + 38))
        }
        
        sureBtn.snp.makeConstraints { make in
            make.leading.equalTo(bgView).offset(25)
            make.trailing.equalTo(bgView).offset(-25)
            make.height.equalTo(lc_scaleSize(45))
            make.bottom.equalTo(bgView).offset(-38)
        }
    }
    
    @objc func sureBtnClick() {
        UIView.animate(withDuration: 0.3) {
            self.bgView.snp.updateConstraints { make in
                make.height.equalTo(self.bgViewHeight)
                make.leading.equalTo(self.view).offset(20);
                make.trailing.equalTo(self.view).offset(-20);
                make.bottom.equalTo(self.view.snp.bottom).offset(lc_screenHeight);
            }
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
