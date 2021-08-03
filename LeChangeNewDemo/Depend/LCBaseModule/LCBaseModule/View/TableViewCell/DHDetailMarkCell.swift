//
//  Copyright © 2019年 dahua. All rights reserved.
//

import UIKit

class DHDetailMarkCell: UITableViewCell, IDHTableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var markImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLbl.textColor = UIColor.dhcolor_c2()
        titleLbl.font = UIFont.dhFont_t2()
        contentView.backgroundColor = UIColor.dhcolor_c43()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(detailItem: IDHDeviceDetailItem) {
        titleLbl.text = detailItem.itemName
        markImage.image = UIImage.init(named: detailItem.imageName)
    }
}
