//
//  LCBluetoothDeviceCell.swift
//  LCAddDeviceModule
//
//  Created on 2026/1/22.
//  Copyright © 2026 Imou. All rights reserved.
//

import UIKit
import LCBaseModule

class LCBluetoothDeviceCell: UITableViewCell {
    
    private lazy var radioButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lccolor_c2()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lc_color(withHexString: "#ECECEC")
        return line
    }()
    
    var deviceModel: LCBluetoothDeviceModel? {
        didSet {
            updateUI()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        
        self.contentView.addSubview(radioButton)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(lineView)
        
        radioButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(radioButton.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }
    
    func updateUI() {
        guard let model = deviceModel else {
            // 如果没有model，清空显示
            nameLabel.text = ""
            radioButton.setImage(nil, for: .normal)
            return
        }
        
        nameLabel.text = model.displayName
        
        // 根据选中状态更新checkbox图标
        if model.isSelected {
            // 选中状态：橙色背景白色对勾
            // 使用bluetooth_checkbox_selected资源名称（对应Contents.json中的"Checkbox 选择框(1).png"）
            let image = UIImage(named: "bluetooth_checkbox_selected")
            radioButton.setImage(image, for: .normal)
        } else {
            // 未选中状态：灰色空心圆圈
            // 使用bluetooth_checkbox_unselected资源名称（对应Contents.json中的"Checkbox 选择框.png"）
            let image = UIImage(named: "bluetooth_checkbox_unselected")
            radioButton.setImage(image, for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // 注意：这里不应该直接修改deviceModel的isSelected
        // 因为选中状态应该由ViewController统一管理
    }
}
