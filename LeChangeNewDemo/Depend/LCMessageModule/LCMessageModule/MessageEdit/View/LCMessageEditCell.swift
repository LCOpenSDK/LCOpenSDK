//
//  LCMessageEditCell.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/14.
//

import UIKit
import LCNetworkModule

class LCMessageEditCell: UITableViewCell {
    
    //MARK: - CellID
    class func cellID() -> String {
        return "LCMessageEditCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Private Func
    private func setupUI() {
        self.contentView.addSubview(selectImv)
        self.contentView.addSubview(messageImv)
        self.contentView.addSubview(titleLbl)
        self.contentView.addSubview(timeLabel)
        
        selectImv.snp.makeConstraints { make in
            make.leading.equalTo(15.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 20.0, height: 20.0))
        }
        messageImv.snp.makeConstraints { make in
            make.leading.equalTo(50.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 105.0, height: 75.0))
        }
        titleLbl.snp.makeConstraints { make in
            make.leading.equalTo(messageImv.snp.trailing).offset(16.0)
            make.top.equalToSuperview().offset(26.0)
            make.height.equalTo(21.0)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(messageImv.snp.trailing).offset(16.0)
            make.top.equalTo(titleLbl.snp.bottom).offset(5.0)
        }
        
    }
    
    //MARK: - Public Func
    public func updateData(_ messageItem:LCMessageItem) {
        let pskKey = LCApplicationDataManager.openId() + (messageItem.deviceId ?? "")
        var key: String = UserDefaults.standard.object(forKey: pskKey) as? String ?? ""
        if  (key.count < 0 || key == "") {
            key = messageItem.deviceId ?? ""
        }
        messageImv.lc_setMessageImage(withURL: messageItem.thumbUrl ?? "", placeholderImage: UIImage(named: "common_defaultcover_big") ?? UIImage(), deviceId: messageItem.deviceId ?? "", productId: messageItem.productId ?? "", playtoken: messageItem.playtoken ?? "", key: key)
        titleLbl.text = messageItem.title
        timeLabel.text = messageItem.timeStr
        selectImv.image = messageItem.isSelected ? UIImage(named: "icon_checkbox2") : UIImage(named: "icon_checkbox1")
    }
    
    //MARK: - Lazy Var
    lazy var selectImv:UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    
    lazy var messageImv:UIImageView = {
        let imv = UIImageView()
        imv.layer.cornerRadius = 8.0
        imv.clipsToBounds = true
        return imv
    }()
    
    lazy var titleLbl:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lc_color(withHexString: "#2c2c2c")
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textAlignment = .left
        return label
    }()
    
    lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lc_color(withHexString: "#8f8f8f")
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textAlignment = .left
        return label
    }()

}
