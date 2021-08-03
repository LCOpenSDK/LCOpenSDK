//
//  Copyright © 2017 dahua. All rights reserved.
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
        view.frame = CGRect(x: 0, y: 0, width: dh_screenWidth, height: lc_sectionHeight(title: title))
        
        let label = UILabel()
        label.frame = CGRect(x: SECTION_MARGIN_SIZE, y: 0, width: view.dh_width - SECTION_MARGIN_SIZE * 2, height: view.dh_height)
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
        
        if title == nil || title?.dh_length == 0 {
            return 0.0
        }
        
        return lc_sectionHeight(title: title!, font: UIFont.systemFont(ofSize: SECTION_FONT_SIZE), margin: SECTION_MARGIN_SIZE, minHeight: SECTION_MIN_HEIGHT)
    }
    
    // Section height
    static func lc_sectionHeight(title: String, font: UIFont, margin: CGFloat, minHeight: CGFloat) -> CGFloat {
        
        var height = title.dh_height(font: font, width: dh_screenWidth - 2 * margin) + SECTION_MARGIN_SIZE
        
        height = height < minHeight ? minHeight : height
        
        return height
    }
    
    private func dh_registerCell<T: UITableViewCell>(cellClass: T.Type)where T: IDHTableViewCell {
        let nibName = String(describing: cellClass.self)
        print(nibName)
        let nib = UINib(nibName: nibName, bundle: Bundle.demo_BaseBundle())
        if nib.instantiate(withOwner: nil, options: nil).count != 0 {
            self.register(nib, forCellReuseIdentifier: cellClass.dh_cellID())
        } else {
            self.register(cellClass, forCellReuseIdentifier: cellClass.dh_cellID())
        }
    }
    
    func dh_dequeueReusableCell<T: UITableViewCell>
        () -> T where T: IDHTableViewCell {
        var cell: UITableViewCell? = self.dequeueReusableCell(withIdentifier: T.dh_cellID())
        if cell == nil {
            self.dh_registerCell(cellClass: T.self)
            cell = self.dequeueReusableCell(withIdentifier: T.dh_cellID())
        }
        return cell! as! T
    }
}
