//
//  Copyright © 2017 Imou. All rights reserved.
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
    func lc_width(font: UIFont) -> CGFloat {
		
		let newFont = font.lc_aviailableFont
		
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
    func lc_height(font: UIFont, width: CGFloat) -> CGFloat {
		
		let newFont = font.lc_aviailableFont
		
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
    var lc_length: Int {
        return self.count
    }
    
    func lc_preFixStr(_ to: Int) -> String {
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

public extension String {
    
    private static let formatter = NumberFormatter()
    
    func clippingCharacters(in characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }
    
    func convertedDigitsToLocale(_ locale: Locale = .current) -> String {
        let digits = Set(clippingCharacters(in: CharacterSet.decimalDigits.inverted))
        guard !digits.isEmpty else { return self }
        Self.formatter.locale = locale
        let maps: [(original: String, converted: String)] = digits.map {
            let original = String($0)
            let digit = Self.formatter.number(from: original)!
            let localized = Self.formatter.string(from: digit)!
            return (original, localized)
        }
        return maps.reduce(self) { converted, map in
            converted.replacingOccurrences(of: map.original, with: map.converted)
        }
    }

    func base64encode() -> String? {
        
        let utf8str:Data? = self.data(using: String.Encoding.utf8)
        guard let utf8Data = utf8str else{
            return nil
        }
        
        let base64Encoded:String = utf8Data.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        return base64Encoded
    }
}

