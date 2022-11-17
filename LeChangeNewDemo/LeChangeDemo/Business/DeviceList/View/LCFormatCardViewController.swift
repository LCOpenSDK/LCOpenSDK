//
//  FormatCardViewController.swift
//  LeChangeDemo
//
//  Created by WWB on 2022/9/30.
//  Copyright © 2022 dahua. All rights reserved.
//


import UIKit
import SnapKit


@objcMembers class LCFormatCardViewController :UIViewController{
    
    let formatCardController = LCFormatCardController()
    let formatCard = LCFormatCardModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backBtn = LCButton()
        backBtn.frame = CGRect(x: 0,y: 0,width: 30,height: 30)
        backBtn.setImage(UIImage.init(named: "common_icon_nav_back"), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(self.navigationBarClick), for: UIControlEvents.touchUpInside)
        let backitem = UIBarButtonItem.init(customView: backBtn)
        self.navigationItem.setLeftBarButton(backitem, animated: true)
        
        self.title = "SD_card".lc_T
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red: 44.0/255.0, green: 44.0/255.0, blue: 44.0/255.0, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.init(name:"PingFang SC",size: 16)! as Any]
        self.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        }
        formatCardController.loadData()
        self.view.addSubview(formatCardController.statusIV)
        formatCardController.statusIV.snp.makeConstraints{
            (make) in
            make.centerX.equalTo(self.view)
        }
        self.view.addSubview(formatCardController.statusIV.formatBtn)
        formatCardController.statusIV.formatBtn.snp.makeConstraints{
            (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-64)
            make.width.equalTo(300)
            make.centerX.equalTo(self.view)
            make.height.equalTo(45)
        }
    }
    func navigationBarClick() {
        self.navigationController?.popViewController(animated: true)
    }
    deinit {
        formatCard.timer.invalidate()
    }
}
