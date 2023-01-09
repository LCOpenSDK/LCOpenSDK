//
//  LCTableViewSectionHeaderView.swift
//  LeChangeDemo
//
//  Created by yyg on 2022/9/22.
//  Copyright © 2022 Imou. All rights reserved.
//

import SnapKit

public class LCTableViewSectionHeaderView: UITableViewHeaderFooterView {
    lazy var title: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor(red: 143.0/255.0, green: 143.0/255.0, blue: 143.0/255.0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var model: LCTableViewSectionModel? {
        didSet {
            self.title.text = self.model?.title
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(self.title)
        
        self.title.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-5)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
