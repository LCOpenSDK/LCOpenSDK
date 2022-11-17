//
//  LCSetTimeHeadView.swift
//  LeChangeOverseas
//
//  Created by hyd on 2021/5/14.
//  Copyright © 2021 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

import UIKit
import LCBaseModule

class LCSetTimeHeadView: UIView {
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lccolor_c8()
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let colorView = UIView()
    let colorLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置UI: titleLabel detailLabel
    func setupUI() {
        self.backgroundColor = UIColor.clear
        
        self.addSubview(self.topView)
        self.addSubview(self.bottomView)
        let height = "device_manager_defence_tips".lc_T.lc_height(font: UIFont.systemFont(ofSize: 14), width: UIScreen.main.bounds.size.width - 30)
        self.topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98 + height - 14)
        }
        
        self.bottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.topView.snp.bottom)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.bold)
        titleLabel.text = "device_manager_defence_time".lc_T
        self.topView.addSubview(titleLabel)
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        detailLabel.font = UIFont.systemFont(ofSize: 14)
        detailLabel.textColor = UIColor.lccolor_c41()
        detailLabel.numberOfLines = 0
        detailLabel.text = "device_manager_defence_tips".lc_T
        self.topView.addSubview(detailLabel)
        detailLabel.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        self.colorView.backgroundColor = UIColor.lccolor_c10()
        self.colorView.layer.cornerRadius = 3
        self.bottomView.addSubview(self.colorView)
        self.colorView.snp.makeConstraints { (make) in
            make.width.equalTo(52)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(20)
        }
        
        colorLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        colorLabel.textColor = UIColor.lccolor_c41()
        colorLabel.textAlignment = NSTextAlignment.right
        colorLabel.text = "device_manager_defence_time1".lc_T
        self.bottomView.addSubview(colorLabel)
        colorLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalTo(self.colorView.snp.leading).offset(-10)
            make.height.equalTo(colorView)
        }
        
        let procellWidth = UIScreen.main.bounds.size.width - 40 - 65
        
        let timeScale = UILabel()
        timeScale.font = UIFont.systemFont(ofSize: 12)
        timeScale.textColor = UIColor.lccolor_c41()
        timeScale.text = "0"
        self.bottomView.addSubview(timeScale)
        timeScale.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(15)
            make.width.equalTo(30)
            make.leading.equalToSuperview().offset(70)
        }
        
        let timeScale12 = UILabel()
        timeScale12.font = UIFont.systemFont(ofSize: 12)
        timeScale12.textColor = UIColor.lccolor_c41()
        timeScale12.text = "12"
        timeScale12.textAlignment = NSTextAlignment.center
        self.bottomView.addSubview(timeScale12)
        timeScale12.snp.makeConstraints { (make) in
            make.top.equalTo(timeScale.snp.top)
            make.height.equalTo(15)
            make.width.equalTo(30)
            make.leading.equalTo(self.snp.leading).offset(procellWidth * 0.5 + 60)
        }
        
        let timeScale24 = UILabel()
        timeScale24.font = UIFont.systemFont(ofSize: 12)
        timeScale24.textColor = UIColor.lccolor_c41()
        timeScale24.text = "24"
        timeScale24.textAlignment = NSTextAlignment.right
        self.bottomView.addSubview(timeScale24)
        timeScale24.snp.makeConstraints { (make) in
            make.top.equalTo(timeScale.snp.top)
            make.height.equalTo(15)
            make.width.equalTo(30)
            make.leading.equalTo(self.snp.leading).offset(procellWidth + 60)
        }
    }
}
