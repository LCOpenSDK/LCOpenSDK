//
//  LCTimeSlot.swift
//  LoseAnson
//
//  Created by 安森 on 2018/9/12.
//  Copyright © 2018年 Imou. All rights reserved.
//

import Foundation


enum LCWeekDay: String, CaseIterable {
    case sunday = "Sunday"
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    
    static func weekDayDesDic() -> [LCWeekDay: String] {
       return [
             .sunday: "device_manager_sun".lc_T,
             .monday: "device_manager_mon".lc_T,
             .tuesday: "device_manager_tue".lc_T,
             .wednesday: "device_manager_wed".lc_T,
             .thursday: "device_manager_thu".lc_T,
             .friday: "device_manager_fri".lc_T,
             .saturday: "device_manager_sat".lc_T]
    }
    
    static func weekDayTitle(type: LCWeekDay) -> String {
        var title = "device_manager_monday".lc_T
        self.weekDayDesDic().forEach { (key, value) in
            if type == key {
                title = value
            }
        }
        return title
    }
}

//时间段设置
class LCTimeSlot {
    var startHour: Int = 0
    var startMin: Int = 0
    var startSecond: Int = 0
    
    var endHour: Int = 0
    var endMin: Int = 0
    var endSecond: Int = 59   //默认59秒
    
    public func isFitTenMinRule() -> Int {
        //结束时间是否大于开始时间十分钟
        let differ = (endHour * 60 + endMin) - (startHour * 60 + startMin)
        return differ
    }
}

