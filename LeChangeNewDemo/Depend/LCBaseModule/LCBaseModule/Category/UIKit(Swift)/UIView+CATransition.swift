//
//  Copyright © 2017 Imou. All rights reserved.
//  
//  UIView的扩展，用于简化转场动画的实现

import UIKit

// 动画类型
public enum LCTransitionType {
    case fade           //淡入淡出
    case push           //推挤
    case reveal         //揭开
    case moveIn         //覆盖
    case cube           //立方体
    case suckEffect     //吮吸
    case oglFlip        //翻转
    case rippleEffect   //波纹
    case pageCurl       //翻页
    case pageUnCurl     //反翻页
    case cameraOpen     //开镜头
    case cameraClose    //关镜头
    case curlDown       //下翻页
    case curlUp         //上翻页
    case flipFromLeft   //左翻转
    case flipFromRight  //右翻转
    
    var description: String {
        
        switch self {
        case .fade:
            return kCATransitionFade
        case .push:
            return kCATransitionPush
        case .reveal:
            return kCATransitionReveal
        case .moveIn:
            return kCATransitionMoveIn
        case .cube:
            return "cube"
        case .suckEffect:
            return "suckEffect"
        case .oglFlip:
            return "oglFlip"
        case .rippleEffect:
            return "rippleEffect"
        case .pageCurl:
            return "pageCurl"
        case .pageUnCurl:
            return "pageUnCurl"
        case .cameraOpen:
            return "cameraIrisHollowOpen"
        case .cameraClose:
            return "cameraIrisHollowClose"
        default:
            return ""
        }
    }
    
    public var animationTransition: UIViewAnimationTransition {
        
        switch self {
        case .curlDown:
            return .curlDown
        case .curlUp:
            return .curlUp
        case .flipFromLeft:
            return .flipFromLeft
        case .flipFromRight:
            return .flipFromRight
        default:
            return .none
        }
    }
}

// 动画方向
public enum LCTransitionDirection {
    case fromLeft     // 向左
    case fromRight    // 向右
    case fromTop      // 向上
    case fromBottom   // 向下
    
    public var description: String {
        
        switch self {
        case .fromLeft:
            return kCATransitionFromLeft
        case .fromRight:
            return kCATransitionFromRight
        case .fromTop:
            return kCATransitionFromTop
        case .fromBottom:
            return kCATransitionFromBottom
        }
    }
}

extension UIView {
    
    
    /// 转场动画
    ///
    /// - Parameters:
    ///   - type: 动画类型
    ///   - direction: 动画方向
    ///   - duration: 时长
    ///   - animationCurve: 速度
    public func lc_transitionAnimation(type: LCTransitionType, direction: LCTransitionDirection, duration: CFTimeInterval = 0.3, animationCurve: UIViewAnimationCurve = .easeInOut) {
    
        switch type {
        case .curlUp, .curlDown, .flipFromLeft, .flipFromRight:
            lc_transitionAnimation(transition: type.animationTransition, duration: duration, animationCurve: animationCurve)
        default:
            lc_transitionAnimation(type: type, direction: direction, duration: duration, animationCurve: animationCurve, delegate: nil)
        }
    }
    
    /// 转场动画
    ///
    /// - Parameters:
    ///   - type: 动画类型
    ///   - subtype: 动画方向
    ///   - duration: 时长
    ///   - animationCurve: 动画速度
    public func lc_transitionAnimation(type: LCTransitionType, direction: LCTransitionDirection, duration: CFTimeInterval, animationCurve: UIViewAnimationCurve, delegate: CAAnimationDelegate?) {
        
        let animation = CATransition()
        animation.duration = duration
        animation.type = type.description
        animation.subtype = direction.description
        animation.delegate = delegate
        animation.timingFunction = lc_timingFunction(animationCurve: animationCurve)
        
        self.layer.add(animation, forKey: type.description)
    }
    
    /// UIView动画
    ///
    /// - Parameters:
    ///   - transition: 动画类型
    ///   - duration: 时长
    ///   - animationCurve: 速度
    ///   - completion: 完成回调
    public func lc_transitionAnimation(transition: UIViewAnimationTransition, duration: CFTimeInterval, animationCurve: UIViewAnimationCurve, completion: ((Bool) -> Swift.Void)? = nil) {
        
        UIView.animate(withDuration: duration, animations: {
            UIView.setAnimationCurve(animationCurve)
            UIView.setAnimationTransition(transition, for: self, cache: true)
        }, completion: completion)
    }
    
    
    /// animationCurve 转 CAMediaTimingFunction
    ///
    /// - Parameter animationCurve: curve
    /// - Returns: CAMediaTimingFunction
    public func lc_timingFunction(animationCurve: UIViewAnimationCurve) -> CAMediaTimingFunction? {
        
        switch animationCurve {
        case .easeIn:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        case .easeInOut:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        case .easeOut:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        case .linear:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        }
    }
}

