//
//  SMBLocalPickView.swift
//  DHBaseModule
//
//  Created by imou on 2020/4/6.
//  Copyright © 2020 jm. All rights reserved.
//

import Categories
import UIKit

class SMBLocalPickView: SMBPickView, UIPickerViewDataSource, UIPickerViewDelegate {
    var localArray: Array<Dictionary<String, Any>>!
    typealias SMBLocalPickViewResultBlock = (_ province: String, _ city: String, _ area: String) -> Void
    var result: SMBLocalPickViewResultBlock!
    var province: String!
    var city: String!
    var area: String!

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            // 省
            return allProvince().count
        }
        if component == 1 {
            // 市
        }
        if component == 2 {
            // 区
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            // 省
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        }
        if component == 1 {
            // 市
            pickerView.reloadComponent(2)
        }
        if component == 2 {
            // 区
        }
    }

//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if component == 0 {
//            // 省
//            return allProvince()[row]
//        }
//        if component == 1 {
//            // 市
//            pickerView.reloadComponent(2)
//        }
//        if component == 2 {
//            // 区
//        }
//    }

    func getPick(result: @escaping SMBLocalPickViewResultBlock) {
        self.result = result
        pickView.delegate = self
        pickView.dataSource = self
    }

    func allProvince() -> Array<String> {
        let provinces = NSMutableArray()
        for item in localArray {
            let name = item["name"] as! String
            provinces.add(name)
        }
        return provinces as! Array<String>
    }

//    func cityForProvince(province: String) -> Array<String> {
//        var city = NSMutableArray()
//        for item in localArray {
//            let name = item["name"] as! String
//            if name==province {
//                for cityTemp in item["name"] {
//                    let name = item["name"] as! String
//                    provinces.add(name)
//                }
//            }
//        }
//        return city as! Array<String>
//    }

    func getLocalJsonObject() {
        let path = Bundle.main.path(forResource: "local", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        // 带throws的方法需要抛异常
        do {
            /*
             * try 和 try! 的区别
             * try 发生异常会跳到catch代码中
             * try! 发生异常程序会直接crash
             */
            let data = try Data(contentsOf: url)
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            localArray = jsonData as? Array<Dictionary<String, Any>>

        } catch _ as Error? {
        }
    }
}
