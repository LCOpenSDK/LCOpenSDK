//
//  LCAddDeviceChooseView.swift
//  LeChangeDemo
//
//  Created by imou on 2026/1/22.
//  Copyright © 2026 imou. All rights reserved.
//

import Foundation
public enum DHAddDeviceChooseType {
    case scan
    case manual
}
public typealias DHAddDeviceChooseResultBlock = (_ type: DHAddDeviceChooseType) -> Void

public class LCAddDeviceChooseView: UIView {
    
    public var resultBlock: DHAddDeviceChooseResultBlock?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: lc_screenWidth, height: lc_screenHeight))
    }

    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func scanClick(btn: UIButton) {
        self.resultBlock?(.scan)
        self.hide()
    }
    
    @objc public func addClick(btn: UIButton) {
        self.resultBlock?(.manual)
        self.hide()
    }
    
    
    @objc func controlHiddenBar() {
        self.hide()
    }
    
    
    @objc func ignoreSuperClick() {
        
        
    }

    private func layoutViews(){
        
        self.addSubview(backgroundView)
        self.addSubview(contentView)
    
        contentView.addSubview(scanBtn)
        self.scanBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(60)
            make.top.equalTo(0)
        }
        
        contentView.addSubview(addBtn)
        
        self.addBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(scanBtn.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    private lazy  var backgroundView: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y:0 , width: lc_screenWidth, height:lc_screenHeight))
        view.clipsToBounds = true
        view.backgroundColor = UIColor.lc_color(withHexString: "#4D000000")
        
        let pan = UITapGestureRecognizer.init(target: self, action: #selector(controlHiddenBar))
        view.addGestureRecognizer(pan)
        return view
    }()

    
    private lazy var contentView: UIView = {
        var frame =  CGRect(x: 15, y:100 , width: 240, height: 0)
    
        let contentView = UIView.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor.lc_color(withHexString: "#FFFFFF")
        contentView.layer.cornerRadius = 10
        
        return contentView
    }()
    
    private lazy var scanBtn: UIButton = {
        let entranceView = UIButton(type: .custom)
        entranceView.addTarget(self, action: #selector(scanClick(btn:)), for: .touchUpInside)
        
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home_icon_scancode")
        

        entranceView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.leading.equalTo(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(28)
        }
        
        let label = UILabel()
        label.text = "home_add_scan".lc_T
        label.font =  UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.lc_color(withHexString: "#2C2C2C")
        label.numberOfLines = 0
        
        
        entranceView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
        
        
        let line = UIView()
        entranceView.addSubview(line)
        line.backgroundColor =  UIColor.lc_color(withHexString: "#ECECEC")
        line.snp.makeConstraints { (make) in
            make.leading.equalTo(46)
            make.trailing.equalTo(-8)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview().offset(0)
        }
        
        entranceView.clipsToBounds = true

        return entranceView
    }()
    
    
    private lazy var addBtn: UIButton = {
        let entranceView = UIButton(type: .custom)
        entranceView.addTarget(self, action: #selector(addClick(btn:)), for: .touchUpInside)
        
   
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home_icon_add_manually")

        entranceView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.leading.equalTo(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(28)
        }
        
        
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.lc_color(withHexString: "#2C2C2C")
        label.text = "home_add_manually".lc_T
        label.numberOfLines = 0
        
        entranceView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
        
        entranceView.clipsToBounds = true

        return entranceView
    }()
    


    public func show(offsetY:CGFloat) {
        
        self.layoutViews()
        
        let sheetHeight = 120.0

        UIApplication.shared.keyWindow?.addSubview(self)
        
        let sheetWidth = lc_screenWidth * 0.5
        var frame = CGRect(x: lc_screenWidth - sheetWidth - 10, y:offsetY , width: sheetWidth, height: sheetHeight)
        
        
        self.contentView.frame =  frame
       
        
    }
    
    @objc func hide() {
        self.removeFromSuperview()
    }
}

