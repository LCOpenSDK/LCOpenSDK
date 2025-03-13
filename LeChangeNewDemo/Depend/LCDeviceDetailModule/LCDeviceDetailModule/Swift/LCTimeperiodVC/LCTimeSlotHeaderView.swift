//
//  LCTimeSlotHeaderView.swift
//  LoseAnson
//
//  Created by 安森 on 2018/9/12.
//  Copyright © 2018年 Imou. All rights reserved.
//

import UIKit
import SnapKit

enum LCTimeSlotType {
    case weekend
    case everyday
    case custom
}

protocol LCTimeSlotHeaderViewDelegate: NSObjectProtocol {
    func selectedWeekDay(weekDay: LCWeekDay)
}

class LCTimeSlotHeaderView: UIView {
    weak var headerDelegate: LCTimeSlotHeaderViewDelegate?
    var selectedColor: UIColor = UIColor.lccolor_c10()
    var unselectedColor: UIColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1)
    var selectedWeekDay: Set<LCWeekDay> {
        get {
            return _selectedWeekDay
        }
        set {
            _selectedWeekDay = newValue
            updateWeekDayBtns()
        }
    }
    
    var currentDay: LCWeekDay {
        
        get {
            return _currentDay
        }
        set {
            _currentDay = newValue
            if let currentBtnIndex = LCWeekDay.allCases.index(where: {$0 == _currentDay}) {
                //遍历weekBtns数组
                self.weekBtns.forEach { (item) in
                    if item.tag == currentBtnIndex {
                        weekBtnClicked(btn: item)
                    }

                }
            }
            
            self.weekAlert.text = LCWeekDay.weekDayTitle(type: _currentDay)
        }
    }
    
    // MARK: private
    fileprivate var _type: LCTimeSlotType = .custom
    fileprivate var _selectedWeekDay: Set<LCWeekDay> = []
    fileprivate var _currentDay: LCWeekDay = .monday //默认选中周四
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(weekBtnsContainer)
        weekBtnsContainer.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15.0)
            make.left.equalTo(0.0)
            make.width.equalTo(self)
            make.height.equalTo(43)
        }
        
        addSubview(weekAlert)
        weekAlert.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-5)
            make.leading.equalToSuperview().offset(10)
        }
        
        //默认选中周一
        self.currentDay = .monday
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var weekAlert: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 143.0/255.0, green: 143.0/255.0, blue: 143.0/255.0, alpha: 1.0)
        return label
    }()
    
    fileprivate lazy var weekBtnsContainer: UIView = {
        let weekBtnsContainer = UIView()
        var last = weekBtnsContainer.snp.left
        let btnWidth: CGFloat = 43.0
        let titalBtnWidth: CGFloat = btnWidth * 7.0
        let btnSpace = (UIScreen.main.bounds.size.width - titalBtnWidth) / 8.0
        var idx = 0
        for btn in self.weekBtns {
            weekBtnsContainer.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.top.equalTo(0)
                make.left.equalTo(last).offset(btnSpace)
                make.width.equalTo(btnWidth)
                make.height.equalTo(btnWidth)
            }
            last = btn.snp.right
            btn.lc_setRadius(btnWidth / 2.0) //圆角
            idx = idx + 1
        }
        weekBtnsContainer.backgroundColor = .clear
        return weekBtnsContainer
    }()
    
    fileprivate lazy var weekBtns: [UIButton] = {
        var btns: [UIButton] = []
        var titles: [String] = ["device_manager_sun_s".lc_T, "device_manager_mon_s".lc_T, "device_manager_tue_s".lc_T, "device_manager_wed_s".lc_T, "device_manager_thu_s".lc_T, "device_manager_fri_s".lc_T, "device_manager_sat_s".lc_T]
        for i in 0..<titles.count {
            let btn = UIButton()
            btn.tag = i
            btn.setTitle(titles[i], for: .normal)
            btn.titleLabel?.textAlignment = .center
            btn.titleLabel?.lineBreakMode = .byTruncatingTail
            btn.setTitleColor(UIColor.lccolor_c40(), for: .normal)  // 黑色
            btn.setTitleColor(UIColor.lccolor_c40(), for: .selected)  // 橙色
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.setBackgroundImage(UIImage.imageWithColor(self.unselectedColor), for: .normal)
            btn.addTarget(self, action: #selector(weekBtnClicked(btn:)), for: .touchUpInside)
            btns.append(btn)
        }
        return btns
    }()
    
    @objc func weekBtnClicked(btn: UIButton) {
        self.weekBtns.forEach { (item) in
            // 对所有日期样式做一个复位
            item.setTitleColor(UIColor.lccolor_c40(), for: .normal)    // 无数据黑色字体
            item.setTitleColor(UIColor.lccolor_c40(), for: .selected)  // 有数据橙色字体
            item.setBackgroundImage(UIImage.imageWithColor(self.unselectedColor), for: .normal)//灰色背景
        }

        self.weekBtns.forEach { (item) in
            if item.tag == btn.tag {
                // 获取当前点击的button对应的日期,更新为当前日期
                _currentDay = LCWeekDay.allCases[btn.tag]
                self.weekAlert.text = LCWeekDay.weekDayTitle(type: _currentDay)
            }
        }
       
        updateWeekDayBtns()
        // 选中的日期 无论有无数据,一律橙色底,白色字体
        btn.setBackgroundImage(UIImage.imageWithColor(self.selectedColor), for: .normal)
        btn.setTitleColor(UIColor.lccolor_c54(), for: .normal)
        btn.setTitleColor(UIColor.lccolor_c54(), for: .selected)
        //回调处罚外部视图做相应刷新
        self.headerDelegate?.selectedWeekDay(weekDay: self.currentDay)
        
    }

    //更新button样式
    fileprivate func updateWeekDayBtns() {
        //1.复位button状态
        self.weekBtns.forEach { (btn) in
            btn.isSelected = false
        }
        
        let allCase = LCWeekDay.allCases
        /*
         3.加载数据,区分一个概念,原先的逻辑是认为有数据即selected, 当前选中为currentDay
         按照设计的需求,
         无数据的日期灰底黑字,无橙色圆点,
         有数据的日期灰底橙字,带橙色圆点,
         当前选中日期橙底白字,无橙色圆点.
         */
        for weekDay in self.selectedWeekDay {
            // LCWeekDay 从.monday开始枚举 ,此处需求以sunday为起始点
            if let index = allCase.index(where: {$0 == weekDay}) {
                // 枚举值比较
                if _currentDay == weekDay {
                    //当前选中 橙底白字,无橙色下标点
                    self.weekBtns.forEach { (item) in
                        if item.tag == index {
                            item.backgroundColor = UIColor.lccolor_c10()
                            item.isSelected = true
                        }
                    }
                } else {
                    //其他有数据的日期  灰底橙字,橙色下标点
                    self.weekBtns.forEach { (item) in
                        if item.tag == index {
                            item.backgroundColor = UIColor.lccolor_c10()
                            item.isSelected = true
                        }
                    }
                }
            }
        }
    }
    //haveData
    func updataButtonState(btn:UIButton) {
        
    }
}

extension UIImage {
    class func imageWithColor(_ color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0;
        format.opaque = false;
        let renderer = UIGraphicsImageRenderer.init(size: rect.size, format: format)
        let image = renderer.image { rendererContext in
            let context = rendererContext.cgContext
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }
        
        return image
    }
}
// 圆点
class LCDotView: UIView {
    
    override func draw(_ rect: CGRect) {
        
        //获取画笔上下文
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        UIColor.lccolor_c10().setFill()
        self.addRoundRect(context: context, rect: CGRect(x: rect.width * 0.5 - rect.height * 0.5, y: 0, width: rect.height, height: rect.height), mode: CGPathDrawingMode.fill, radius: rect.size.height * 0.5)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 画圆函数
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

