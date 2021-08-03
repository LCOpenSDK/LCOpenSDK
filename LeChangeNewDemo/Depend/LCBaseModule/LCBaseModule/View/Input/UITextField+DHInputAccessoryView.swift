//
//  Copyright © 2020 jm. All rights reserved.
//

import UIKit

@objc public extension UITextField {
    @objc func dh_inputAccessoryView() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: dh_screenWidth, height: 30.0))
        toolBar.isTranslucent = true;
        toolBar.barStyle = .default;
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let button = UIButton(type: .custom)
        button.setTitle("完成", for: .normal)
        button.setTitleColor(UIColor.dhcolor_c0(), for: .normal)
        button.titleLabel?.font = UIFont.dhFont_f2()
        button.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        let doneItem = UIBarButtonItem(customView: button)
        toolBar.items = [spaceItem, doneItem]
        toolBar.barTintColor = UIColor.dhcolor_c3().withAlphaComponent(0.3)
        self.inputAccessoryView = toolBar
    }
    
    @objc fileprivate func doneAction() {
        self.resignFirstResponder()
    }
}
