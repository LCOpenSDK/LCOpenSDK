//
//  Copyright © 2018 dahua. All rights reserved.
//

import UIKit
import SnapKit

public protocol DHDetailSwitchCellDelegate: class {
    func cellChickSwitch(_ cell: DHDetailSwitchCell, isOn: Bool)
}

public class DHDetailSwitchCell: UITableViewCell, IDHTableViewCell {
    public weak var delegate: DHDetailSwitchCellDelegate?
    @IBOutlet public weak var titleLbl: UILabel!
    @IBOutlet public weak var rightSwitch: UIButton!
    @IBOutlet public weak var rightLbl: UILabel!
    @IBOutlet public weak var loadingView: DHActivityIndicatorView!
    @IBOutlet public weak var rightArrow: UIImageView!
    @IBOutlet public weak var descriptLbl: UILabel!
    @IBOutlet public weak var iconImageView: UIImageView!
    
    @objc func switchChange(_ sender: UIButton) {
        print(sender.isSelected ? "yes" : "no")
        delegate?.cellChickSwitch(self, isOn: !sender.isSelected)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        if let rightSwi = rightSwitch {
            rightSwi.setImage(UIImage(named: "common_btn_switchoff"), for: .normal)
            rightSwi.setImage(UIImage(named: "common_btn_switchon"), for: .selected)
            rightSwi.addTarget(self, action: #selector(switchChange(_:)), for: .touchUpInside)
        }
        if let desLabel = descriptLbl {
            desLabel.backgroundColor = UIColor.dhcolor_c7()
            desLabel.text = ""
            desLabel.textColor = UIColor.dhcolor_c2()
        }
        if let titleLabel = titleLbl {
            titleLabel.textColor = UIColor.dhcolor_c2()
            titleLabel.font = UIFont.dhFont_t2()
        }
        if let rightLabel = rightLbl {
            rightLabel.textColor = UIColor.dhcolor_c5()
            rightLabel.font = UIFont.dhFont_t5()
        }
        if let loadView = self.loadingView {
            loadView.rotationView.image = UIImage(named: "common_refresh")
        }
        contentView.backgroundColor = UIColor.dhcolor_c43()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    public func config(detailItem: IDHDeviceDetailItem) {
        titleLbl.text = detailItem.itemName
        rightLbl.text = detailItem.contentStr
        rightSwitch.isSelected = detailItem.isSwitchOn
        if detailItem.state == .loading {
            self.rightSwitch.isHidden = true
            self.loadingView.isHidden = false
            self.rightLbl.isHidden = true
        } else if detailItem.state == .normal {
            self.rightSwitch.isHidden = false
            self.loadingView.isHidden = true
            self.rightLbl.isHidden = true
        } else if detailItem.state == .loadFail {
            self.rightSwitch.isHidden = true
            self.loadingView.isHidden = true
            self.rightLbl.isHidden = false
        }
        
          //加载过程中 展示菊花
        self.rightLbl.textColor = detailItem.isContentDiable ? UIColor.dhcolor_c6() : UIColor.dhcolor_c5()
        self.loadingView.startAnimating()
        
        if detailItem.desString.count != 0 {
            let style: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            // 头部缩进
            style.headIndent = 15
            style.firstLineHeadIndent = 15
            // 尾部缩进
            style.tailIndent = -15
            
            let str = NSMutableAttributedString(string: "\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 6)])
            
            str.append(NSMutableAttributedString(string: detailItem.desString, attributes: [NSAttributedStringKey.paragraphStyle: style, NSAttributedStringKey.font: UIFont.dhFont_t6(), NSAttributedStringKey.foregroundColor: UIColor.dhcolor_c5()]))
            
            str.append(NSMutableAttributedString(string: "\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 2)]))
            descriptLbl.attributedText = str
            self.separatorInset = UIEdgeInsetsMake(0, UIScreen.main.bounds.size.width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
            
            self.backgroundColor = UIColor.dhcolor_c7()
        } else {
            descriptLbl.text = ""
            descriptLbl.attributedText = NSMutableAttributedString()
            self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0)
            self.backgroundColor = UIColor.dhcolor_c43()
        }
        
        //改样式的  没有箭头
        self.setArrowHidden(isHidden: true)
        self.isUserInteractionEnabled = detailItem.isEnable
        self.rightSwitch.isEnabled = detailItem.isEnable
    }

    public func setArrowHidden(isHidden: Bool) {
        if isHidden {
            self.rightArrow.snp.updateConstraints { (make) in
                make.width.equalTo(0)
            }
            self.layoutIfNeeded()
        } else {
            self.rightArrow.snp.updateConstraints { (make) in
                make.width.equalTo(20)
            }
        }
        self.layoutIfNeeded()
    }

}
