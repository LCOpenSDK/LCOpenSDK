//
//  LCTimeSetPickerView.swift
//  LCIphoneAdhocIP
//
//  Created by lechech on 9/13/18.
//  Copyright © 2018 Imou. All rights reserved.
//

import Foundation
import LCBaseModule

//按钮点击回调block
typealias CompleteHandler = ((_ timeSlot: LCTimeSlot) -> ())


class LCTimeSetPickerView: LCDeviceBasePickerView {
    
    var complete: CompleteHandler?
    
    deinit {
        print(self)
    }
    
    private var hourDataSource: [Int] {
        var result = [Int]()
        for i in 00...23 {
            result.append(i)
        }
        return result
    }
    
    private var minDataSource: [Int] {
        var result = [Int]()
        for i in 00...59 {
            result.append(i)
        }
        return result
    }
    
    var timeSlot: LCTimeSlot? {
        didSet {
            pickerView.selectRow((timeSlot?.startHour)!, inComponent: 0, animated: false)
            pickerView.selectRow((timeSlot?.startMin)!, inComponent: 2, animated: false)
            pickerView.selectRow((timeSlot?.endHour)!, inComponent: 4, animated: false)
            pickerView.selectRow((timeSlot?.endMin)!, inComponent: 6, animated: false)
        }
    }
    
    override func setUp() {
        super.setUp()
        pickerView.delegate = self
        confirmButton.setTitleColor(UIColor.lccolor_confirm(), for: .normal)
        titleLabel.font = UIFont.lcFont_t2()
        confirmButton.titleLabel?.font = UIFont.lcFont_t4()
        cancelButton.titleLabel?.font = UIFont.lcFont_t4()
    }
    
    override func clickConfirm() {
        timeSlot?.startHour = pickerView.selectedRow(inComponent: 0)
        timeSlot?.startMin = pickerView.selectedRow(inComponent: 2)
        timeSlot?.endHour = pickerView.selectedRow(inComponent: 4)
        timeSlot?.endMin = pickerView.selectedRow(inComponent: 6)
        
        //判断是否符合要求
        if (timeSlot?.isFitTenMinRule() ?? 0) > 10 {
            //返回结果
            super.clickConfirm()
            if let complete = self.complete, let timeSlot = self.timeSlot {
                complete(timeSlot)
                print("DeploymentSetting:",Date.init(),"\(#function)::更改布防时间段",timeSlot.isFitTenMinRule(),"分钟")
            }
        } else {
            if (timeSlot?.isFitTenMinRule() ?? 0) > 0 {
                LCProgressHUD.showMsg("device_manager_time_set_tenmin_error".lc_T)
            } else {
                LCProgressHUD.showMsg("device_manager_end_time_less_than_start".lc_T)
            }
        }
    }
    
}

extension LCTimeSetPickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 70
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 || component == 4 {
            //小时
            return hourDataSource.count
        } else if component == 2 || component == 6 {
            //分钟
            return minDataSource.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let timeCompoentWidth = 40.0
        switch component {
        case 0:
            return timeCompoentWidth
        case 1:
            return 19
        case 2:
            return timeCompoentWidth
        case 3:
            return 93.0
        case 4:
            return timeCompoentWidth
        case 5:
            return 19
        case 6:
            return timeCompoentWidth
        default:
            return 0
        }
    }
}

extension LCTimeSetPickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String.init(format: "%02d", hourDataSource[row])
        case 1:
            return ":"
        case 2:
            return String.init(format: "%02d", minDataSource[row])
        case 3:
            return "—"
        case 4:
            return String.init(format: "%02d", hourDataSource[row])
        case 5:
            return ":"
        case 6:
            return String.init(format: "%02d", minDataSource[row])
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        if label == nil {
            label = UILabel()
            label!.textAlignment = NSTextAlignment.center
            label!.backgroundColor = UIColor.clear
            label?.font = UIFont.systemFont(ofSize: 17)
            label!.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        }
        label!.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return label!
    }
    
}
