//
//  LCTimeperiodVC.swift
//  LoseAnson
//
//  Created by 安森 on 2018/9/12.
//  Copyright © 2018年 Imou. All rights reserved.
//

import UIKit
import SnapKit
import LCBaseModule
import LCNetworkModule

protocol LCTimeperiodVCDlegate: NSObjectProtocol {
    func saveTimeperiods(timePeriods: [LCAlarmPlanRule], finished:(() -> ())?)
}

class LCTimeperiodVC: LCBasicViewController {
    public weak var controller: LCDefenceTimeSetVC?
    weak var delegate: LCTimeperiodVCDlegate?
    var timePeriods: [LCAlarmPlanRule] = []
    var headerView: LCTimeSlotHeaderView!
    var currentDay: LCWeekDay = .sunday
    
    //数据源
    //自定义模式
    var customDaySrc:[(weekDay: LCWeekDay, items: [LCTimeSlot])] = [(weekDay:.monday, items:[]),
                                                                 (weekDay:.tuesday, items:[]),
                                                                 (weekDay:.wednesday, items:[]),
                                                                 (weekDay:.thursday, items:[]),
                                                                 (weekDay:.friday, items:[]),
                                                                 (weekDay:.saturday, items:[]),
                                                                 (weekDay:.sunday, items:[])]

    lazy var mainTableView: UITableView = {
        let mainTableView = UITableView(frame: .zero, style: .grouped)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = 80.0
        mainTableView.backgroundColor = .white
        mainTableView.separatorStyle = .singleLine
        mainTableView.separatorColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1)
        mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        return mainTableView
    }()
    
    lazy var saveBtn: UIButton = {
        let saveBtn = UIButton(type: .custom)
        saveBtn.setTitle("common_save".lc_T, for: .normal)
        saveBtn.setTitleColor(UIColor.lccolor_c43(), for: .normal)
        saveBtn.titleLabel?.textAlignment = .center
        saveBtn.titleLabel?.font = UIFont.lcFont_t4()
        saveBtn.backgroundColor = UIColor.lccolor_c10()
        saveBtn.addTarget(self, action: #selector(saveBtnClicked(btn:)), for: .touchUpInside)
        return saveBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "device_manager_period_setting".lc_T
        self.lcCreatNavigationBar(with: LCNAVIGATION_STYLE_DEFAULT, buttonClick: nil)
        headerView = LCTimeSlotHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 105))
        headerView.backgroundColor = .lccolor_c8()
        headerView.headerDelegate = self
        self.mainTableView.tableHeaderView = headerView

        view.addSubview(saveBtn)		
        saveBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(38)
            make.trailing.equalTo(-38)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-28)
        }
        saveBtn.layer.cornerRadius = 22.5
        saveBtn.layer.masksToBounds = true
        
        view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(self.saveBtn.snp.top).offset(-28)
        }
        
        //兼容协议返回的特殊情况(出现everyday格式的时间段)
        filtterTimePeriods()

        //设置数据源
        setDataSource()
        
        mainTableView.reloadData()
        
        self.lcCreatNavigationBar(with: LCNAVIGATION_STYLE_DEFAULT) {[weak self] index in
            func isDataSourceEdited() -> Bool {
                //判断数据源是否编辑过
                if let newTimeperiods  = self?.getConfigTimePeriods(){
                    guard newTimeperiods.count == self?.timePeriods.count else {
                        return true
                    }
                    
                    for timeperiod in newTimeperiods {
                        let newPlan = self?.getPlanTime(dataSource: newTimeperiods, weekDay: LCWeekDay(rawValue: timeperiod.period)!)
                        let oldPlan = self?.getPlanTime(dataSource: self?.timePeriods ?? [], weekDay: LCWeekDay(rawValue: timeperiod.period)!)
                        if self?.comparePlanTime(plan1: newPlan ?? [], plan2: oldPlan ?? []) == false {
                            return true
                        }
                    }
                }
                return false
            }
            
            if isDataSourceEdited() {
                // LCAlertView.lc_ShowAlert(title: "Alert_Title_Notice2".lc_T, detail: "setting_device_alarm_alert_close".lc_T, confirmString: "Alert_Title_Button_Confirm".lc_T, cancelString: "Alert_Title_Button_Cancle".lc_T) {
                LCAlertView.lc_ShowAlert(title: "Alert_Title_Notice2".lc_T, detail: "device_settings_cross_line_set_no_save_tip".lc_T, confirmString: "device_manager_exit".lc_T, cancelString: "common_cancel".lc_T) { isConfirmSelected in
                    if isConfirmSelected == true {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: custom method
    func filtterTimePeriods() {
        //数据源兼容
        if self.timePeriods.count == 1 {
            let everytimePeriod = self.timePeriods[0]
            if everytimePeriod.period.caseInsensitiveCompare("everyday") == .orderedSame {
                let dayArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
                var newtimePeriods = [LCAlarmPlanRule]()
                for i in 0...6 {
                    let timePeriod = LCAlarmPlanRule()
                    timePeriod.beginTime = everytimePeriod.beginTime
                    timePeriod.endTime = everytimePeriod.endTime
                    timePeriod.period = dayArray[i]
                    newtimePeriods.append(timePeriod)
                }
                self.timePeriods = newtimePeriods
            }
        }
    }

    func setDataSource() {
        LCWeekDay.allCases.forEach { (weekDay) in
            let data = timePeriods.filter({$0.period == weekDay.rawValue}).map { (timePord) -> LCTimeSlot in
                return timePord.timeSlot()
            }
            
            if let index = self.customDaySrc.firstIndex(where: {$0.weekDay == weekDay}) {
                self.customDaySrc[index] = (weekDay:weekDay, items:data)
            }
        }
        //更新已设置过的天数
        updateSelectedWeekDays()
        //选中当前设置过的第一个按钮
        self.headerView.currentDay = currentDay
    }
    
    func updateSelectedWeekDays() {
        let weekDays = customDaySrc.filter({$0.items.count != 0}).map({$0.weekDay})
        var weekDaySet: Set<LCWeekDay> = []
        weekDays.forEach { (weekday) in
            weekDaySet.insert(weekday)
        }
    
        self.headerView.selectedWeekDay = weekDaySet
    }
    
    // MARK: ui action
    @objc func addBtnClicked(btn: UIButton) {
        func isOverLimit() -> Bool {
            for tuple in self.customDaySrc {
                if tuple.weekDay == self.headerView.currentDay {
                    return tuple.items.count >= 6 ? true : false
                }
            }
            return false
        }
        
        if isOverLimit() {
            LCProgressHUD.showMsg("device_manager_no_more_than_six_periods".lc_T)
            return
        }
     
        //添加数据
        //todo 调用控件获取
        let timeSlot = LCTimeSlot()
   
        let pickerView = LCTimeSetPickerView()
        pickerView.timeSlot = timeSlot
        pickerView.complete = { timeSlot in
            if let index = self.customDaySrc.firstIndex(where: {$0.weekDay == self.headerView.currentDay}) {
                self.customDaySrc[index].items.append(timeSlot)
                self.updateSelectedWeekDays()
            }
            self.mainTableView.reloadData()
            
            //这里一定要加延时  不然无效
            if btn.tag == 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if self.mainTableView.contentSize.height > self.mainTableView.frame.size.height {
                        let offset = CGPoint(x: 0, y: self.mainTableView.contentSize.height - self.mainTableView.frame.size.height)
                        self.mainTableView.setContentOffset(offset, animated: true)
                    }
                }
            }
        }
        pickerView.show(in: self.navigationController?.view)
    }
    
    @objc func saveBtnClicked(btn: UIButton) {
        LCProgressHUD.show(on: self.view)
        delegate?.saveTimeperiods(timePeriods: getConfigTimePeriods(),finished: { [weak self] in
            guard let strongSelf = self else { return }
            LCProgressHUD.hideAllHuds(strongSelf.view)
            LCProgressHUD.hideAllHuds(nil)
            sleep(1)
        })
    }
    
    // MARK: common method
    //获取当前所有时间项
    private func getConfigTimePeriods() -> [LCAlarmPlanRule] {
        var timePeriods: [LCAlarmPlanRule] = []
        for weekDay in LCWeekDay.allCases {
            if let index = self.customDaySrc.firstIndex(where: {$0.weekDay == weekDay}) {
                let items = self.customDaySrc[index].items.map({ (timeSlot) -> LCAlarmPlanRule in
                    return timeSlot.timePeriod(weekDay: weekDay)
                })
                timePeriods.append(contentsOf: items)
            }
        }
        return timePeriods
    }
    
    //获取某天的所有时间段
    func getPlanTime(dataSource: [LCAlarmPlanRule], weekDay: LCWeekDay) -> [(beginTime: String, endTime: String)] {
        return dataSource.filter({$0.period == weekDay.rawValue}).map { (timePeriod) -> (beginTime: String, endTime: String) in
            return (beginTime:timePeriod.beginTime, endTime:timePeriod.endTime)
            }.sorted(by: {$0.beginTime < $1.beginTime})
    }
    
    //比较两天的时间短是否相等
    func comparePlanTime(plan1:[(beginTime: String, endTime: String)], plan2:[(beginTime: String, endTime: String)]) -> Bool {
        if plan1.count != plan2.count {
            return false
        }
        
        for i in 0..<plan1.count {
            if !(plan1[i].beginTime == plan2[i].beginTime && plan1[i].endTime == plan2[i].endTime) {
                return false
            }
            
        }
        return true
    }
    
}

extension LCTimeperiodVC: LCTimeSlotHeaderViewDelegate {
    func selectedWeekDay(weekDay: LCWeekDay) {
        mainTableView.reloadData()
    }
}

extension LCTimeperiodVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item: LCTimeSlot?
        var tempList: [LCTimeSlot]? = self.customDaySrc.first(where: {$0.weekDay == self.headerView.currentDay})?.items
        item = tempList?[indexPath.row]
        let pickerView = LCTimeSetPickerView()
        pickerView.timeSlot = item
        pickerView.complete = { timeSlot in
            tempList![indexPath.row] = timeSlot
            self.mainTableView.reloadData()
        }
        pickerView.show(in: self.navigationController?.view)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customDaySrc.first(where: {$0.weekDay == self.headerView.currentDay})?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont.lcFont_t3()
        cell.textLabel?.textColor = UIColor.lccolor_c40()
        cell.selectionStyle = .none
        
        let item: LCTimeSlot? = self.customDaySrc.first(where: {$0.weekDay == self.headerView.currentDay})?.items[indexPath.row]
        func desStr(_ value: Int) -> String {
            return value >= 10 ? "\(value)" : "0\(value)"
        }
        
        if let item = item {
            cell.textLabel?.text = desStr(item.startHour) + ":" + desStr(item.startMin) + "-" + desStr(item.endHour) + ":" + desStr(item.endMin)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        let addBtn = UIButton(type: .custom)
        addBtn.setTitle("device_manager_add_period".lc_T, for: .normal)
        addBtn.titleLabel?.lineBreakMode = .byTruncatingTail
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addBtn.setImage(UIImage.init(named: "devicemanage_icon_adddevice"), for: .normal)
        addBtn.tag = section
        addBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        addBtn.addTarget(self, action: #selector(addBtnClicked(btn:)), for: .touchUpInside)
        header.addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
        addBtn.setTitleColor(UIColor.lccolor_c10(), for: .normal)
        addBtn.backgroundColor = UIColor.lccolor_c43()
        addBtn.titleLabel?.font = UIFont.lcFont_t5()
        return header
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "mobile_common_delete".lc_T
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {
            [weak self](action, view, handler) in
            if let index = self?.customDaySrc.firstIndex(where: {$0.weekDay == self?.headerView.currentDay}) {
                self?.customDaySrc[index].items.remove(at: indexPath.row)
                self?.updateSelectedWeekDays()
            }
            self?.mainTableView.reloadData()
            print("DeploymentSetting:",Date.init(),"\(#function)::删除布防时间段成功",indexPath ,tableView)
        }
        deleteAction.backgroundColor = UIColor.lc_color(withHexString: "ff4f4f")
        deleteAction.image = UIImage.init(named: "common_nav_delete_w_d")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let index = self.customDaySrc.firstIndex(where: {$0.weekDay == self.headerView.currentDay}) {
            self.customDaySrc[index].items.remove(at: indexPath.row)
            updateSelectedWeekDays()
        }
        self.mainTableView.reloadData()
    }
}

extension LCTimeSlot {
    func timePeriod(weekDay: LCWeekDay) -> LCAlarmPlanRule {
        func desStr(_ value: Int) -> String {
            return value >= 10 ? "\(value)" : "0\(value)"
        }
        //THHMMSS
        let timePeriod = LCAlarmPlanRule()
        timePeriod.period = weekDay.rawValue
        timePeriod.beginTime = "\(desStr(self.startHour)):\(desStr(self.startMin)):\(desStr(self.startSecond))"
        timePeriod.endTime = "\(desStr(self.endHour)):\(desStr(self.endMin)):\(desStr(self.endSecond))"
        return timePeriod
    }
}

extension LCAlarmPlanRule {
    func timeSlot() -> LCTimeSlot {
        func getHourAndMin(tTime: String) -> (hour: Int, min: Int, second: Int) {
            let time = tTime
            let hour = time[time.startIndex..<time.index(time.startIndex, offsetBy: 2)]
            let min = time[time.index(time.startIndex, offsetBy: 3)..<time.index(time.startIndex, offsetBy: 5)]
            let second = time[time.index(time.startIndex, offsetBy: 6)..<time.endIndex]
            
            return (hour:Int(hour) ?? 0, min:Int(min) ?? 0, second:Int(second) ?? 0)
        }
        
        let timeSlot = LCTimeSlot()
        let start = getHourAndMin(tTime: self.beginTime)
        timeSlot.startHour = start.hour
        timeSlot.startMin = start.min
        timeSlot.startSecond = start.second
        let end = getHourAndMin(tTime: self.endTime)
        timeSlot.endHour = end.hour
        timeSlot.endMin = end.min
        timeSlot.endSecond = end.second
        return timeSlot
    }
}
