//
//  LCTableFooterView.swift
//  LeChangeDemo
//
//  Created by yyg on 2022/9/27.
//  Copyright © 2022 Imou. All rights reserved.
//

import SnapKit
import LCBaseModule

public class LCTableFooterView: UIView {
    var deleteAction:(()->())?
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func getTableFooterView(width: CGFloat, deleteAction:(()->())?) -> LCTableFooterView? {
        let view = LCTableFooterView.init(frame: CGRect(x: 0, y: 0, width: width, height: 195))
        view.deleteAction = deleteAction
        return view
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        let label = UILabel()
        label.backgroundColor = UIColor.lccolor_c43()
        label.textColor = UIColor(red: 255.0/255.0, green: 79.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.text = "mobile_common_delete".lc_T
        label.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clickDelete)))
        self.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(80)
        }
    }
    
    @objc func clickDelete() {
        if let action = self.deleteAction {
            action()
        }
    }
    
}
