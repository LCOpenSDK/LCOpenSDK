//
//  LCWeekDayProcessView.swift
//  LoseAnson
//
//  Created by 安森 on 2018/9/13.
//  Copyright © 2018年 Imou. All rights reserved.
//

import UIKit
import LCBaseModule
import LCNetworkModule

protocol LCWeekDayProcessViewDelegate: class {
    func didSelectitem(item: LCWeekDay)
}


class LCWeekDayProcessView: UITableView, UITableViewDelegate, UITableViewDataSource {
    weak var processViewDelegate: LCWeekDayProcessViewDelegate?
    
    var titleWidth: CGFloat = 0
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    init() {
        super.init(frame: CGRect(), style: .plain)
        delegate = self
        dataSource = self
        self.separatorColor = UIColor.lccolor_c53()
        self.separatorStyle = .none
        self.rowHeight = 52.0
        self.register(LCTimeProgressCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.titleWidth = getTitlesMaxWidth()
        self.reloadData()
        self.tableFooterView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var customDaySrc:[(weekDay: LCWeekDay, items: [LCTimeSlot])] = {
//        if LCModuleConfig.shareInstance().isChinaMainland {
//            return [
//                (weekDay:.monday, items:[]),
//                (weekDay:.tuesday, items:[]),
//                (weekDay:.wednesday, items:[]),
//                (weekDay:.thursday, items:[]),
//                (weekDay:.friday, items:[]),
//                (weekDay:.saturday, items:[]),
//                (weekDay:.sunday, items:[])
//            ]
//        } else {
        return [
            (weekDay:.sunday, items:[]),
            (weekDay:.monday, items:[]),
            (weekDay:.tuesday, items:[]),
            (weekDay:.wednesday, items:[]),
            (weekDay:.thursday, items:[]),
            (weekDay:.friday, items:[]),
            (weekDay:.saturday, items:[])
        ]
//      }
    }()
    
    
    
    fileprivate let weekDayDesDic: [LCWeekDay: String] = LCWeekDay.weekDayDesDic()
    
    func setTimePeriods(timePeriods: [LCAlarmPlanRule]) {
        func filterTimePeriods(oldTimePeriods: [LCAlarmPlanRule]) -> [LCAlarmPlanRule] {
            //注: 此方法用于兼容协议返回了everyday格式数据的情况
            if oldTimePeriods.count == 1 {
                let everytimePeriod = oldTimePeriods[0]
                if everytimePeriod.period.caseInsensitiveCompare("everyday") == .orderedSame {
                    let dayArray = ["Sunday","Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
                    var newtimePeriods = [LCAlarmPlanRule]()
                    for i in 0...6 {
                        let timePeriod = LCAlarmPlanRule()
                        timePeriod.beginTime = everytimePeriod.beginTime
                        timePeriod.endTime = everytimePeriod.endTime
                        timePeriod.period = dayArray[i]
                        newtimePeriods.append(timePeriod)
                    }
                    return newtimePeriods
                }
            }
            return oldTimePeriods
        }

        //数据兼容
        let newTimePeriods = filterTimePeriods(oldTimePeriods: timePeriods)
        LCWeekDay.allCases.forEach { (weekDay) in
            let data = newTimePeriods.filter({$0.period == weekDay.rawValue}).map { (timePord) -> LCTimeSlot in
                return timePord.timeSlot()
            }
            
            if let index = self.customDaySrc.index(where: {$0.weekDay == weekDay}) {
                self.customDaySrc[index] = (weekDay:weekDay, items:data)
            }
        }
        
        self.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LCWeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LCTimeProgressCell
        let weekday = customDaySrc[indexPath.row].weekDay
        cell.setCellFrame(width: titleWidth)
        cell.titleLabel.text = weekDayDesDic[weekday]
        cell.timePeriodView.timeSlots = customDaySrc[indexPath.row].items
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weekday = customDaySrc[indexPath.row].weekDay
        self.processViewDelegate?.didSelectitem(item: weekday)
    }

    // MARK: - 计算titleLabel的宽度
    func getTitlesMaxWidth() -> CGFloat {
        let titles = ["device_manager_mon".lc_T, "device_manager_tue".lc_T, "device_manager_wed".lc_T, "device_manager_thu".lc_T, "device_manager_fri".lc_T, "device_manager_sat".lc_T, "device_manager_sun".lc_T]
        var width: CGFloat = 35.0
        for item in titles {
            let temp = item.lc_width(font: UIFont.lcFont_t3())
            if width < temp {
                width = temp
            }
        }
        return width + 10
    }
    
}

class LCTimeProgressCell: UITableViewCell {
    
    let timePeriodView = LCTimePeriodView()
    let titleLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.lccolor_c43()
        titleLabel.font = UIFont.lcFont_t3()
        titleLabel.textColor = UIColor.lccolor_c40()
        self.contentView.addSubview(titleLabel)
        self.selectionStyle = .none
        
        timePeriodView.selectedColor = UIColor.lccolor_c10() //选中时间段
        self.contentView.addSubview(timePeriodView)
    }
    func setCellFrame(width: CGFloat) {
        titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(width)
            make.height.equalTo(52)
            make.top.equalToSuperview()
        }
        timePeriodView.snp.remakeConstraints { (make) in
            make.leading.equalTo(25 + width)
            make.top.equalToSuperview().offset(6)
            make.width.equalTo(lc_screenWidth - 40 - width)
            make.height.equalTo(40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
