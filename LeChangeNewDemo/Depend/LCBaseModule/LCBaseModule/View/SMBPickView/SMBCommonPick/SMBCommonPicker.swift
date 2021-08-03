//
//  SMBCommonPicker.swift
//  DHBaseModule
//
//  Created by imou on 2020/4/7.
//  Copyright © 2020 jm. All rights reserved.
//

import UIKit

public enum SMBPickViewType: String {
    case scale
    case postion
    case category
}

public class SMBCommonPicker: SMBPickView {
    var _type: SMBPickViewType?
   public var type: SMBPickViewType {
        get {
            return _type ?? .scale
        }
        set {
            _type = newValue
            pickView.reloadAllComponents()
        }
    }

    lazy var scales: Array<String> = {
        let scales = ["0-9", "10-49", "50-99", "100-499", "500-1999", "2000及以上"]
        return scales
    }()

    lazy var positions: Array<String> = {
        let positions = ["负责人", "管理层", "人事", "行政", "IT", "财务", "员工", "其他"]
        return positions
    }()
    
    lazy var categorys: Array<Dictionary<String,Any>> = {
        let categorys = allCategory()
        return categorys as! [Dictionary<String, Any>]
    }()
    
    var selectCategory:String!
    
    override public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if type == .category {
            return 2
        }
        return 1
    }

    override public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type {
        case .scale:
            return scales.count
        case .postion:
            return positions.count
        case .category:
            if component == 0 {
                return categorys.count
            }else{
                if component == 0 {
                    return categorys.count
                }else{
                    return findSubFor(name: selectCategory).count
                }
                
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch type {
        case .scale:
            return scales[row]
        case .postion:
            return positions[row]
        case .category:
            if component == 0 {
                return categorys[row]["name"] as? String
            }else{
                return findSubFor(name: selectCategory)[row]["name"] as? String
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch type {
        case .scale:
            if (selectblock != nil) {
                selectblock(scales[row])
            }
        case .postion:
            if (selectblock != nil) {
                selectblock(positions[row])
            }
        case .category: break
//            if component == 0 {
//                sel
//            }else{
//                return findSubFor(name: selectCategory)[row]["name"] as? String
//            }
        }
    }

    func allCategory() -> Array<Any> {
        let path = Bundle.main.path(forResource: "job", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        // 带throws的方法需要抛异常
        do {
            let data = try Data(contentsOf: url)
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr = jsonData as! NSArray
            return jsonArr as! Array<Any>
        } catch let error as Error? {
            print("读取本地数据出现错误!", error ?? nil!)
            return []
        }
    }

    func findSubFor(name:String) -> Array<Dictionary<String,Any>> {
        for item in categorys {
            if (item["name"] as! String) == name {
                return (item["children"] as! Array)
            }
        }
        return []
    }
}
