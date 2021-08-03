//
//  Copyright © 2017 dahua. All rights reserved.
//

import UIKit

public extension String {
    
    
    /// 判断字符串是否不为空（不算空格）
    ///
    /// - Returns: true / false
    func isNotBlank() -> Bool {
        var isNotBlank = false
        let trimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if trimmed.count > 0 {
            isNotBlank = true
        }
        
        return isNotBlank
    }

    // 计算单行字符串宽度
    func dh_width(font: UIFont) -> CGFloat {
		
		let newFont = font.dh_aviailableFont
		
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = NSLineBreakMode.byCharWrapping
        
        let attributes = [NSAttributedStringKey.font: newFont, NSAttributedStringKey.paragraphStyle: style.copy()]
        
        // 强转成NSString
        let text = self as NSString
        let rect = text.boundingRect(with: size,
                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                     attributes: attributes,
                                     context: nil)
        
        return rect.size.width
    }
    
    // 计算固定宽度字符串高度
    func dh_height(font: UIFont, width: CGFloat) -> CGFloat {
		
		let newFont = font.dh_aviailableFont
		
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = NSLineBreakMode.byCharWrapping
        
        let attributes = [NSAttributedStringKey.font: newFont, NSAttributedStringKey.paragraphStyle: style.copy()]
        
        // 强转成NSString
        let text = self as NSString
        let rect = text.boundingRect(with: size,
                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                     attributes: attributes,
                                     context: nil)
        
        return rect.size.height
    }
    
    // 字符串长度
    var dh_length: Int {
        return self.count
    }
    
    func dh_preFixStr(_ to: Int) -> String {
        if self.count <= to {
            return self
        }
        
        let endIndex = self.index(self.startIndex, offsetBy: to)
        
        let range = Range<String.Index>(uncheckedBounds: (lower: self.startIndex, upper: endIndex))
        
        let str = String(self[range])
        return str
    }
    
    func intValue() -> Int {
        return Int(self) ?? 0
    }
}
