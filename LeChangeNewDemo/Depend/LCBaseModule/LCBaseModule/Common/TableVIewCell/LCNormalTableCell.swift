//
//  LCNormalTableCell.swift
//  DHBaseModule
//
//  Created by imou on 2020/4/1.
//  Copyright © 2020 jm. All rights reserved.
//

import UIKit

@objc public class LCNormalTableCell: UITableViewCell {

    @IBOutlet public weak var leftImageView: UIImageView!
    @IBOutlet public weak var contentLab: UILabel!
    @IBOutlet public weak var rightImageView: UIImageView!
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
