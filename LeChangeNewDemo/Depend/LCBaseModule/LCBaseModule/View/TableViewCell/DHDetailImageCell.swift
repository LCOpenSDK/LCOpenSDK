//
//  Copyright © 2018 dahua. All rights reserved.
//

import UIKit

@objc public class DHDetailImageCell: UITableViewCell, IDHTableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var rightArrow: UIImageView!
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLbl.textColor = UIColor.dhcolor_c2()
        titleLbl.font = UIFont.dhFont_t2()
        contentView.backgroundColor = UIColor.dhcolor_c43()
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: IDHTableViewCell
    func config(detailItem: IDHDeviceDetailItem) {

        titleLbl.text = detailItem.itemName
    
        if detailItem.imageItem.isUseFilePath {
            if let img = UIImage(contentsOfFile: detailItem.imageItem.filePath) {
                rightImageView.image = img
            } else {
                rightImageView.image = UIImage(named: "common_defaultcover_big")
            }
            
        } else {
            rightImageView.lc_setImage(withUrl: detailItem.imageItem.imageUrl, placeholderImage: "common_defaultcover_big", aesKey: detailItem.imageItem.encryPtKey, deviceID: detailItem.imageItem.deviceId, devicePwd: detailItem.imageItem.devicePwd, toDisk: true)
        }
        
        self.setArrowHidden(isHidden: !detailItem.isShowArrow)
        self.isUserInteractionEnabled = detailItem.isEnable

	
    }
    
    private func configCellState(cellState: DHDeviceCellState) {
        self.isUserInteractionEnabled = cellState != .noAuth
    }
    
    
    fileprivate func setArrowHidden(isHidden: Bool) {
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
