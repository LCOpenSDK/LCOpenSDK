//
//  FormatCardViewController.swift
//  LeChangeDemo
//
//  Created by WWB on 2022/9/30.
//  Copyright © 2022 Imou. All rights reserved.
//


import UIKit
import SnapKit
import LCBaseModule

public class LCFormatCardViewController : LCBasicViewController {
    var formatCardController: LCFormatCardController?
    lazy var contentView: LCMemoryManagementView = {
        let view = LCMemoryManagementView()
        view.formatAction = {[weak self] in
            self?.formatCardController?.formatSDCard()
        }
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @objc public convenience init(deviceId: String, sdUsed: Int64, sdTotal: Int64, status: String) {
        self.init(nibName: nil, bundle: nil)
        
        self.formatCardController = LCFormatCardController(used: sdUsed, total: sdTotal, deviceId: deviceId, cardStatus: status, statusIV: self.contentView)
        self.formatCardController?.used = sdUsed
        self.formatCardController?.total = sdTotal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let backBtn = LCButton()
        backBtn.frame = CGRect(x: 0,y: 0,width: 30,height: 30)
        backBtn.setImage(UIImage.init(named: "common_icon_nav_back"), for: .normal)
        backBtn.addTarget(self, action: #selector(self.navigationBarClick), for: .touchUpInside)
        let backitem = UIBarButtonItem.init(customView: backBtn)
        self.navigationItem.setLeftBarButton(backitem, animated: true)
        
        self.title = "SD_card".lc_T
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red: 44.0/255.0, green: 44.0/255.0, blue: 44.0/255.0, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.init(name:"PingFang SC",size: 16)! as Any]
        self.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        }
        formatCardController?.loadData()
        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints{
            (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    @objc func navigationBarClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        
    }
}
