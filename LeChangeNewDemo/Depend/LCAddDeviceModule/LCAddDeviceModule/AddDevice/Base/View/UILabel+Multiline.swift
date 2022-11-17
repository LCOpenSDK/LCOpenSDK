//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

import UIKit

extension UILabel {
	
	/// 设置Label的富文本
	///
	/// - Parameters:
	///   - text: 需要设置的文字
	///   - font: 字体大小
	///   - lineSpace: 行距
	///   - alignment: 对齐方式
	@objc func lc_setAttributedText(text: String?, font: UIFont, lineSpace: CGFloat = 5, alignment: NSTextAlignment = .center) {
		guard text != nil else {
			self.attributedText = nil
			return
		}
		
		let style = NSMutableParagraphStyle()
		style.lineBreakMode = NSLineBreakMode.byWordWrapping
		style.lineSpacing = lineSpace
		style.alignment = alignment
		
		let attributes = [NSAttributedStringKey.paragraphStyle: style,
						  NSAttributedStringKey.font: font]

		let attrText = NSMutableAttributedString(string: text!)
		attrText.addAttributes(attributes, range: NSMakeRange(0, text!.count))
		self.attributedText = attrText
	}
    
    /// 设置Label的富文本
    ///
    /// - Parameters:
    ///   - text: 需要设置的文字
    ///   - font: 字体大小
    ///   - lineSpace: 行距
    ///   - alignment: 对齐方式
    @objc public func lc_setAttributedText(text: String?, font: UIFont, color: UIColor, lineSpace: CGFloat = 5, alignment: NSTextAlignment = .center) {
        guard text != nil else {
            self.attributedText = nil
            return
        }
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = NSLineBreakMode.byWordWrapping
        style.lineSpacing = lineSpace
        style.alignment = alignment
        
        let attributes = [NSAttributedString.Key.paragraphStyle: style,
                          NSAttributedString.Key.font: font,
                          NSAttributedString.Key.foregroundColor: color]

        let attrText = NSMutableAttributedString(string: text!)
        attrText.addAttributes(attributes, range: NSMakeRange(0, text!.count))
        self.attributedText = attrText
    }
    
    
    /// 设置Label的富文本
    ///
    /// - Parameters:
    ///   - text: 需要设置的文字
    ///   - font: 字体大小
    ///   - lineSpace: 行距
    ///   - color: 字体颜色
    func lc_setAttributedText_Normal(text: String?, font: UIFont, color: UIColor, lineSpace: CGFloat = 5) {
        guard text != nil else {
            self.attributedText = nil
            return
        }
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = NSLineBreakMode.byWordWrapping
        style.lineSpacing = lineSpace
        
        let attributes = [NSAttributedStringKey.paragraphStyle: style,
                          NSAttributedStringKey.font: font,
                          NSAttributedStringKey.foregroundColor: color]
        
        let attrText = NSMutableAttributedString(string: text!)
        attrText.addAttributes(attributes, range: NSMakeRange(0, text!.count))
        self.attributedText = attrText
    }
    
    
    /// 设置Label的富文本-颜色
    ///
    /// - Parameters:
    ///   - text: 需要设置的文字
    ///   - length: 改变颜色字体节点
    ///   - color1: 前段字体颜色
    ///   - color2: 后段字体颜色
    func lc_setAttributedTextColor(text: String, length: Int, color1: UIColor, color2: UIColor) {
        if text.count >= length {
            let attrStr: NSMutableAttributedString = NSMutableAttributedString.init(string: text)
            attrStr.addAttributes([NSAttributedStringKey.foregroundColor: color1], range: NSMakeRange(0, length))
            attrStr.addAttributes([NSAttributedStringKey.foregroundColor: color2], range: NSMakeRange(length, text.count - length))
            self.attributedText = attrStr
        }
    }
}
