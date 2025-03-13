//
//  LCVisualIntercomPlayContainer.swift
//  LCNewLivePreviewModule
//
//  Created by dahua on 2024/3/20.
//

import UIKit

public enum LCVisualIntercomDefaultPosition: Int {
    case topLeft = 0        // 左上角
    case topRight = 1       // 右上角
    case bottomLeft = 2     // 左下角
    case bottomRight = 3    // 右下角
}

public class LCVisualIntercomPlayContainer: UIView {
    
    //MARK: - var
    /// 固定标准视图
    public var standardTargetView: UIView?
    /// 移动目标视图
    public var moveTargetView: UIView?
    /// 默认位置
    public var defaultPosition: LCVisualIntercomDefaultPosition = .topRight
    /// 移动视图大小
    public var moveViewSize: CGSize = .zero
    /// 容器视图大小
    public var containerSize: CGSize = .zero
    
    //MARK: - private var
    /// 可移动标记
    private var touchInTargetView: Bool = false
    /// 内部缩进
    private let borderInset: CGFloat = 8.0
    
    //MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 绑定移动目标
    /// - Parameters:
    ///   - targetView: 目标控件
    ///   - viewSize: 目标控件大小
    ///   - defaultPosition: 默认位置
    public func  combindMoveTargetView(standardView: UIView, moveTargetView: UIView, targetViewSize: CGSize, containerSize: CGSize) {
        
        self.standardTargetView = standardView
        self.moveTargetView = moveTargetView
        self.moveViewSize = targetViewSize
        self.containerSize = containerSize
        // 配置目标视图
        self.setupTargetView()
    }
    
    public func setupTargetView() {
        
        guard let targetView = self.moveTargetView, let standardView = self.standardTargetView else {
            return
        }
//        let center = self.defaultTargetViewCenterPoint()
//        targetView.frame = CGRect(x: center.x - moveViewSize.width/2.0, y: center.y - moveViewSize.height/2.0, width: moveViewSize.width, height: moveViewSize.height)
        
        // 滑动小窗口在主窗口下方，滑动窗口最低端不超出父容器，固定窗口的顶端位置在父容器 1：6.5处
        var standardViewTop = containerSize.height / 6.5    //固定视图顶部
        let standardViewWidth = containerSize.width     // 固定视图宽度
        let standardViewHeight = standardViewWidth * 9.0 / 16.0     //固定视图高度
        var moveViewTop = standardViewTop + standardViewHeight  //滑动视图顶部
        let moveViewX = containerSize.width / 2.0 - moveViewSize.width / 2.0    // 滑动视图横轴X
        let bottomMargin = (moveViewTop + moveViewSize.height) - containerSize.height
        if bottomMargin > 0 {
            // 移动视图的高度超出容器高度，固定视图往上移
            standardViewTop -= bottomMargin
            moveViewTop -= bottomMargin
        }
        standardView.snp.updateConstraints { make in
            make.top.equalTo(standardViewTop)
        }
        targetView.frame = CGRect(x: moveViewX, y: moveViewTop, width: moveViewSize.width, height: moveViewSize.height)
    }
    
    //MARK: - touch move
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        guard let touch  = touches.first, let targetView = moveTargetView else {
            return
        }
        let touchPoint = touch.location(in: self)
        // 点击是否在目标视图内
        touchInTargetView = targetView.frame.contains(touchPoint)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesMoved(touches, with: event)
        
        guard touchInTargetView, let touch  = touches.first, let targetView = moveTargetView else {
            return
        }
        let currentPoint = touch.location(in: self)
        let previousePoint = touch.previousLocation(in: self)
        // 计算差值
        var offsetX = currentPoint.x - previousePoint.x
        var offsetY = currentPoint.y - previousePoint.y
        // 边界计算
        // offsetX < 0 往左移动, offsetX > 0 往右移动
        if (offsetX < 0 && targetView.frame.minX + offsetX <= 0) || (offsetX > 0 && targetView.frame.maxX + offsetX >= self.frame.width) {
            //横向方位到达边缘
            offsetX = 0
        }
        // offsetY < 0 往上移动, offsetY > 0 往下移动
        if (offsetY < 0 && targetView.frame.minY + offsetY <= 0) || (offsetY > 0 && targetView.frame.maxY + offsetY >= self.frame.height) {
            //纵向方位到达边缘
            offsetY = 0
        }
        let destinationCenter = CGPoint(x: targetView.lc_centerX + offsetX, y: targetView.lc_centerY + offsetY)
//        LCPrintLog("\(#fileID) touchesMoved destinationCenter: x=\(destinationCenter.x) y=\(destinationCenter.y)")
        // 移动视图
        targetView.center = destinationCenter
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
//        guard touchInTargetView, let targetView = moveTargetView else {
//            return
//        }
        // 计算最终移动位移
//        let finalCenter = getFinalCenterPoint(for: targetView.center)
//        LCPrintLog("\(#fileID) touchesEnded finalCenter: x=\(finalCenter.x) y=\(finalCenter.y)")
//        UIView.animate(withDuration: 0.15) {
//            targetView.center = finalCenter
//        }
        // 标记结束
//        self.touchInTargetView = false
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        // 标记结束
        self.touchInTargetView = false
    }

    //MARK: - utils
    
    /// 获取默认的视图中点
    /// - Returns: 中点
    private func defaultTargetViewCenterPoint() -> CGPoint {
        
        var center: CGPoint = .zero
        switch self.defaultPosition {
        case .topRight:
            center = CGPoint(x: containerSize.width - (borderInset + moveViewSize.width/2.0), y: moveViewSize.height/2.0)
            break
        case .topLeft:
            center = CGPoint(x: borderInset + moveViewSize.width/2.0, y: moveViewSize.height/2.0)
            break
        case .bottomLeft:
            center = CGPoint(x: borderInset + moveViewSize.width/2.0, y: containerSize.height - moveViewSize.height/2.0)
            break
        case .bottomRight:
            center = CGPoint(x: containerSize.width - (borderInset + moveViewSize.width/2.0), y: containerSize.height - moveViewSize.height/2.0)
            break
        }
        return center
    }
    
    /// 获取目标视图最终的中点
    /// - Parameter curCenter: 当前中点
    /// - Returns: 目标中点
    private func getFinalCenterPoint(for curCenter: CGPoint) -> CGPoint {
        
        var finalCenter: CGPoint = curCenter
        // 判断当前目标视图所处方位
        if curCenter.x < self.lc_centerX {
            // 在左边
            finalCenter.x = borderInset + moveViewSize.width/2.0
        }else {
            // 在右边
            finalCenter.x = containerSize.width - (borderInset + moveViewSize.width/2.0)
        }
        return finalCenter
    }
    
}
