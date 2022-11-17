//
//  LCTimePeriodView.swift
//  LoseAnson
//
//  Created by 安森 on 2018/9/12.
//  Copyright © 2018年 Imou. All rights reserved.
//

import UIKit

//时间进度条控件
class LCTimePeriodView: UIView {

    var selectedColor: UIColor = .lccolor_c30()
    var unselectedColor: UIColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1)
    var timeSlots: [LCTimeSlot] {
        get {
            return _timeSlots
        }
        set {
            _timeSlots = newValue
            self.setNeedsDisplay()
        }
    }
    
    fileprivate var _timeSlots: [LCTimeSlot] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        unselectedColor.set()
        context.fill(rect)
        
        selectedColor.set()
        let totoalValue: CGFloat = 60 * 24
        
        for timeSlot in timeSlots {
            let startValue: CGFloat = CGFloat(timeSlot.startHour * 60 + timeSlot.startMin)
            let endValue: CGFloat = CGFloat(timeSlot.endHour * 60 + timeSlot.endMin)
            let startX = startValue / totoalValue * rect.size.width
            let endX = endValue / totoalValue * rect.size.width
            let tempRect = CGRect(x: startX, y: 0, width: (endX - startX), height: rect.size.height)
//            context.fill(tempRect)
            //圆角
            addRoundRect(context: context, rect: tempRect, mode: .fill, radius: 3)
        }
    }
    // 绘制圆角 add by lmz
    func addRoundRect(context:CGContext, rect:CGRect,mode:CGPathDrawingMode,radius:CGFloat){
        let x1 = rect.origin.x;
        let y1 = rect.origin.y;
        let x2 = x1+rect.size.width;
        let y2 = y1;
        let x3 = x2;
        let y3 = y1+rect.size.height;
        let x4 = x1;
        let y4 = y3;
        
        context.move(to: CGPoint(x: x1, y: y1+radius))
        context.addArc(tangent1End: CGPoint(x: x1, y: y1), tangent2End: CGPoint(x: x1+radius, y: y1), radius: radius)
        context.addArc(tangent1End: CGPoint(x: x2, y: y2), tangent2End: CGPoint(x: x2, y: y2+radius), radius: radius)
        context.addArc(tangent1End: CGPoint(x: x3, y: y3), tangent2End: CGPoint(x: x3-radius, y: y3), radius: radius)
        context.addArc(tangent1End: CGPoint(x: x4, y: y4), tangent2End: CGPoint(x: x4, y: y4-radius), radius: radius)
        context.closePath()
        context.drawPath(using: mode)//根据坐标绘制路径
    }
}

