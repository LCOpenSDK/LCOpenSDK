//
//  Copyright © 2018 dahua. All rights reserved.
//

import UIKit

@objc public class DHDetailNormalCell: UITableViewCell, IDHTableViewCell {
    
    @IBOutlet public weak var titleLbl: UILabel!
    @IBOutlet public weak var rightLbl: UILabel!
    @IBOutlet public weak var rightArrow: UIImageView!
    @IBOutlet public weak var loadingView: DHActivityIndicatorView!
    @IBOutlet public weak var redDot: UIView!
    @IBOutlet public weak var descriptLbl: UILabel!
    @IBOutlet public weak var leftImageView: UIImageView!
    @IBOutlet public weak var lineView: UIView!
    @IBOutlet public var dotImgV: UIImageView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        if let loadView = loadingView {
            loadView.backgroundColor = UIColor.clear
        }
        if let desLabel = descriptLbl {
            desLabel.backgroundColor = UIColor.dhcolor_c7()
            desLabel.text = ""
            desLabel.textColor = UIColor.dhcolor_c5()
            desLabel.font = UIFont.dhFont_t6()
        }
        if let titleLabel = titleLbl {
            titleLabel.textColor = UIColor.dhcolor_c2()
        }
        if let rightLabel = rightLbl {
            rightLabel.textColor = UIColor.dhcolor_c5()
        }
        if let rDot = redDot {
            rDot.lc_setRound()
            rDot.backgroundColor = UIColor.dhcolor_c12()
        }
        if let leftImg = leftImageView {
            leftImg.dh_cornerRadius = 13
        }
        if let arrowImg = rightArrow {
            arrowImg.image = UIImage(named: "common_listicon_s_next")
        }
        if let line = lineView {
            line.backgroundColor = UIColor.dhcolor_c8()
        }
        if let dotImg = dotImgV {
            dotImg.image = UIImage.init(named: "device_icon_onlinepoint")
        }
        contentView.backgroundColor = UIColor.dhcolor_c10()
		backgroundColor = UIColor.dhcolor_c10()
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func config(detailItem: IDHDeviceDetailItem) {
        titleLbl.text = detailItem.itemName
        rightLbl.text = detailItem.contentStr
        
        redDot.isHidden = !detailItem.showRedDot
      
        self.loadingView.isHidden = detailItem.state != .loading  //加载过程中 展示菊花
        rightLbl.isHidden = !self.loadingView.isHidden
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
            
            str.append(NSMutableAttributedString(string: detailItem.desString, attributes: [NSAttributedStringKey.paragraphStyle: style, NSAttributedStringKey.font: UIFont.dhFont_t6()]))
            
            str.append(NSMutableAttributedString(string: "\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 2), NSAttributedStringKey.foregroundColor: UIColor.dhcolor_c5()]))
                descriptLbl.attributedText = str
            self.separatorInset = UIEdgeInsetsMake(0, UIScreen.main.bounds.size.width, 0, 0); //
        } else {
            descriptLbl.text = ""
            descriptLbl.attributedText = NSMutableAttributedString()
            self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0)
        }

        self.setArrowHidden(isHidden: !detailItem.isShowArrow)
        self.isUserInteractionEnabled = detailItem.isEnable
        
        if detailItem.cellType == .check {
            self.rightArrow.image = UIImage(named: "setting_icon_check")
        } else {
            self.rightArrow.image = UIImage(named: "common_listicon_s_next")
        }
    }
    
    func setArrowHidden(isHidden: Bool) {
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
