//
//  LCFormatCardController.swift
//  LeChangeDemo
//
//  Created by WWB on 2022/9/29.
//  Copyright © 2022 Imou. All rights reserved.
//
import UIKit
import SnapKit
import LCBaseModule

@objcMembers class LCFormatCardController {
    
    var used: Int64 = 0
    
    var total: Int64 = 0
    
    var cardStatus: String = ""
    
    private var formatCard: LCFormatCardModel?
    
    private weak var statusIV: LCMemoryManagementView?

    init(used: Int64, total: Int64, deviceId: String, cardStatus: String, statusIV: LCMemoryManagementView?) {
        self.used = used
        self.total = total
        self.cardStatus = cardStatus
        
        self.formatCard = LCFormatCardModel(deviceId: deviceId)
        self.statusIV = statusIV
    }
    
    func loadData() {
        LCProgressHUD.show(onLowerView: self.statusIV)
        self.formatCard?.stateCard() { result in
            if result == "abnormal" {
                self.statusIV?.setupView(result: result, dic: [:])
                LCProgressHUD.hideAllHuds(self.statusIV)
            } else {
                self.formatCard?.deviceStorage() { dic in
                    self.statusIV?.setupView(result: result, dic: dic)
                    
                    var userinfo = dic
                    userinfo["status"] = result
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: SMBNotificationDeviceSDCardUpdate), object: nil, userInfo: userinfo)
                    LCProgressHUD.hideAllHuds(self.statusIV)
                } failure: { error in
                    LCProgressHUD.hideAllHuds(self.statusIV)
                    error.showTips()
                }
            }
        } failure: { error in
            LCProgressHUD.hideAllHuds(nil)
            error.showTips()
        }
    }

    func formatSDCard() {
        LCAlertView.lc_ShowAlert(title: "Alert_Title_Notice1".lc_T, detail: "formatting_reminder".lc_T, confirmString: "Alert_Title_Button_Formatting".lc_T, cancelString: "Alert_Title_Button_Cancle".lc_T) { [self] objc in
            if objc == true {
                self.statusIV?.inFormatting()
                LCProgressHUD.show(onLowerView: nil)
                formatCard?.recoverSDCard() { [self] result in
                    if result == "sdcard-error" {
                        LCProgressHUD.hideAllHuds(nil)
                        LCProgressHUD.showMsg("formatting_failed".lc_T)
                        self.statusIV?.statusImageView.image = UIImage.init(named:"image")
                        self.statusIV?.formatBtn.isHidden = false
                        self.statusIV?.progressView.isHidden = true
                        self.statusIV?.statusLabel.text = "storage_exception".lc_T
                    } else if result == "start-recover" || result == "in-recover" {
                        self.queryFormatResult()
                    } else {
                        self.statusIV?.secondaryFormatting(result: result)
                    }
                } failure: { error in
                    print("失败" + error.errorMessage)
                    LCProgressHUD.hideAllHuds(nil)
                    LCProgressHUD.showMsg("formatting_failed".lc_T)
                }
            }
        }
    }
    
    func queryFormatResult() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.formatCard?.deviceSDCardStatus() {[weak self] status in
                if status == "normal" {
                    self?.statusIV?.secondaryFormatting(result: status)
                    LCProgressHUD.hideAllHuds(nil)
                    print("LocalStorage:",Date.init(),"\(#function)::格式化成功" + status)
                    let dic = ["status":"normal", "totalBytes":self?.total ?? 0, "usedBytes":0] as [String : Any]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: SMBNotificationDeviceSDCardUpdate), object: nil, userInfo: dic)
                }
                
                if status == "abnormal" || status == "empty" {
                    self?.statusIV?.secondaryFormatting(result: "abnormal")
                }

                if status == "recovering" {
                    self?.queryFormatResult()
                }
            } failure: { error in
                print("失败" + error.errorMessage)
                LCProgressHUD.hideAllHuds(nil)
            }
        }

    }
}

