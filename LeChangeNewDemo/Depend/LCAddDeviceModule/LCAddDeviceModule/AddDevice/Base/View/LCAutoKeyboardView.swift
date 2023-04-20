//
//  Copyright © 2018年 Imou. All rights reserved.
//	定义一个参考的view、能根据keyboard能够，自动调整frame的视图

import UIKit

@objc public class LCAutoKeyboardView: UIView {
	
	/// 是否全屏界面，影响参考视图与键盘距离的计算
	public var isFullScreen: Bool = false
	
	/// 键盘关联的视图
	public weak var relatedView: UIView?
	
	/// 内部记录上次键盘的高度
	private var lastKeyboardHeight: CGFloat = 0
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.addObserver()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.addObserver()
		self.addTapGesture()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	func addObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	func addTapGesture() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
		self.addGestureRecognizer(tapGesture)
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
	}
	
	@objc func keyboardWillShow(notification: Notification) {
		
		guard relatedView != nil else {
			return
		}
		
		if let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
			let keyboardFrame = value.cgRectValue
			lastKeyboardHeight = keyboardFrame.height
			
			keyboardShow(height: keyboardFrame.height)
		}
	}
	
	func keyboardShow(height: CGFloat, offset: CGFloat = 0) {
		//【*】参考视图与屏幕底部、键盘的距离计算
		var distanceToBottom = UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.height - self.relatedView!.frame.maxY
		
		if !isFullScreen {
			distanceToBottom -= 44
		}
		
		var transform: CGAffineTransform
		if distanceToBottom < height {
			transform = CGAffineTransform(translationX: 0, y: distanceToBottom - height - offset)
		} else {
			transform = CGAffineTransform.identity
		}
		
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
			self.transform = transform
		}, completion: nil)
	}
	
	// MARK: - Auto Adjust
	
	/// 自动调整布局
	///
	/// - Parameter offset: 向上偏移尺寸，默认为0
	@objc func autoAdjust(offset: CGFloat = 0) {
	
		guard lastKeyboardHeight > 0 else {
			return
		}
		
		keyboardShow(height: lastKeyboardHeight, offset: offset)
	}
	
	//MAKR: - Notification
	@objc func keyboardWillHide(notification: Notification) {
		lastKeyboardHeight = 0
		
		guard relatedView != nil else {
			return
		}
		
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
			self.transform = CGAffineTransform.identity
		}, completion: nil)
	}
	
	@objc func tap() {
		self.endEditing(true)
	}
}
