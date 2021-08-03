//
//  Copyright © 2018年 dahua. All rights reserved.
//

import UIKit
import SnapKit

class LCAddDeviceHelpView: UIView {

    var helpBtnClick:(() -> ())?
    
    lazy var serverLbl: UILabel = {
        let desLbl: UILabel = UILabel(frame: CGRect.zero)
        return desLbl
//        let desLbl: TTTAttributedLabel = TTTAttributedLabel(frame: CGRect.zero)
//        desLbl.font = UIFont.dhFont_t5()
//        desLbl.textAlignment = .left
//
//		//SMB Todo::
//        var text: NSString = "客服热线：".lc_T + "1234567890" as NSString
//        var atributeStr: NSMutableAttributedString = NSMutableAttributedString(string: text as String, attributes: [NSAttributedStringKey.foregroundColor: UIColor.dhcolor_c5(), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13.0)])
//        desLbl.attributedText = atributeStr
//        desLbl.linkAttributes       = [NSAttributedStringKey.foregroundColor: UIColor.dhcolor_c32(),
//                                       NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13.0),
//                                       NSAttributedStringKey.underlineColor: UIColor.dhcolor_c32(),
//                                       NSAttributedStringKey.underlineStyle: 1 as NSNumber
//        ]
//
//        desLbl.delegate = self
//        var range: NSRange = text.range(of: "1234567890")
//        desLbl.addLink(to: URL(string: "ssssss"), with: range)
//        return desLbl
    }()
    
    lazy var helpBtn: UIButton = {
        let btn = UIButton(type: .custom)
        let image = UIImage(named: "adddevice_icon_help")
        btn.setImage(image, for: .normal)
        btn.setTitle("common_help".lc_T, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        btn.setTitleColor(UIColor.dhcolor_c5(), for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: (image?.size.width)!, bottom: 0, right: (image?.size.width)!)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: -35)
        btn.addTarget(self, action: #selector(helpBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
		/* SMB不需要客服
        self.addSubview(serverLbl)
	
        serverLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(50.0)
            make.height.equalTo(self)
        }
        
        self.addSubview(helpBtn)
        helpBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-50.0)
            make.width.equalTo(120)
            make.height.equalTo(self)
        } */
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func helpBtnPressed() {
        self.helpBtnClick?()
    }
    
//    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
//        UIApplication.shared.openURL(URL(string: "tel:4006728169")!)
//    }
}
