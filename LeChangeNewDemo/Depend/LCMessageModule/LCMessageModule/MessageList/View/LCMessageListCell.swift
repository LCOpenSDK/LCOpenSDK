//
//  LCMessageListCell.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/12.
//

import UIKit
import LCNetworkModule

class LCMessageListCell: UITableViewCell {
    
    //MARK: - CellID
    class func cellID() -> String {
        return "LCMessageListCell"
    }
    
    //MARK: - Init
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
        self.contentView.addSubview(messageImv)
        self.contentView.addSubview(titleLbl)
        self.contentView.addSubview(timeLabel)
        
        messageImv.snp.makeConstraints { make in
            make.leading.equalTo(15.0)
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
        if let title = messageItem.title, title.count > 0 {
            titleLbl.text = messageItem.title
        }else {
            titleLbl.text = "message_module_other".lc_T
        }
        timeLabel.text = messageItem.timeStr
    }
    
    //MARK: - Lazy Var
    
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
