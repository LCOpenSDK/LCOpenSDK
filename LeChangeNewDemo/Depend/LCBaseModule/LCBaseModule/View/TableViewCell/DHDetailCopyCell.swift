//
//  Copyright © 2018年 dahua. All rights reserved.
//

import UIKit

class DHDetailCopyCell: UITableViewCell, IDHTableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var rightLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLbl.textColor = UIColor.dhcolor_c2()
        titleLbl.font = UIFont.dhFont_t2()
        rightLbl.textColor = UIColor.dhcolor_c5()
        rightLbl.font = UIFont.dhFont_t5()
        contentView.backgroundColor = UIColor.dhcolor_c43()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(detailItem: IDHDeviceDetailItem) {
        titleLbl.text = detailItem.itemName
        rightLbl.text = detailItem.contentStr
    }
    
    @IBAction func copyBtnClick(_ sender: UIButton) {
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = rightLbl.text
        LCProgressHUD.showMsg("common_copy_success".lc_T)
    }
    
}
