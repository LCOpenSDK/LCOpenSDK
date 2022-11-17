//
//  Copyright © 2019 Imou. All rights reserved.
//

import UIKit

extension UITextView {
    
    /// 设置TextView的富文本
    ///
    /// - Parameters:
    ///   - text: 需要设置的文字
    ///   - font: 字体大小
    ///   - lineSpace: 行距
    ///   - alignment: 对齐方式
    @objc func lc_setAttributedText(text: String?, font: UIFont, lineSpace: CGFloat = 5, alignment: NSTextAlignment = .center) {
        guard let string = text else {
            self.attributedText = nil
            return
        }
        
        let style = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        style?.lineBreakMode = NSLineBreakMode.byWordWrapping
        style?.lineSpacing = lineSpace
        style?.alignment = alignment
        
        let attributes = [ NSAttributedStringKey.paragraphStyle: style ?? NSMutableParagraphStyle.default,
                           NSAttributedStringKey.font: font ]
        
        let attrText = NSMutableAttributedString(string: string, attributes: attributes)
        self.attributedText = attrText
    }

}


