//
//  Copyright © 2019 Imou. All rights reserved.
//

import UIKit

public extension UIView {
    @objc func setCornerRadius(corners: UIRectCorner, radius: CGFloat ) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
	
	@objc func setCornerRadius(corners: UIRectCorner, bounds: CGRect, radius: CGFloat ) {
		let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
	}
}
