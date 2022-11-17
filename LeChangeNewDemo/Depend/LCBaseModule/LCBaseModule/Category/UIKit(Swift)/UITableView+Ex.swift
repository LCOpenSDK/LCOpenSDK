//
//  Copyright © 2017 Imou. All rights reserved.
//

import UIKit


fileprivate let SECTION_FONT_SIZE: CGFloat = 13
fileprivate let SECTION_MARGIN_SIZE: CGFloat = 15
fileprivate let SECTION_MIN_HEIGHT: CGFloat = 35

// MARK: - Section

public extension UITableView {

    // Section view
    static func lc_sectionView(title: String) -> UIView {
    
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: lc_screenWidth, height: lc_sectionHeight(title: title))
        
        let label = UILabel()
        label.frame = CGRect(x: SECTION_MARGIN_SIZE, y: 0, width: view.lc_width - SECTION_MARGIN_SIZE * 2, height: view.lc_height)
        label.font = UIFont.systemFont(ofSize: SECTION_FONT_SIZE)
        label.textColor = UIColor(white: 0.5, alpha: 1.0)
        label.text = title
        label.numberOfLines = 0
        label.textAlignment = .justified
        
        view.addSubview(label)
        
        return view
    }
    
    // Section height
    static func lc_sectionHeight(title: String?) -> CGFloat {
        
        if title == nil || title?.lc_length == 0 {
            return 0.0
        }
        
        return lc_sectionHeight(title: title!, font: UIFont.systemFont(ofSize: SECTION_FONT_SIZE), margin: SECTION_MARGIN_SIZE, minHeight: SECTION_MIN_HEIGHT)
    }
    
    // Section height
    static func lc_sectionHeight(title: String, font: UIFont, margin: CGFloat, minHeight: CGFloat) -> CGFloat {
        
        var height = title.lc_height(font: font, width: lc_screenWidth - 2 * margin) + SECTION_MARGIN_SIZE
        
        height = height < minHeight ? minHeight : height
        
        return height
    }
}
