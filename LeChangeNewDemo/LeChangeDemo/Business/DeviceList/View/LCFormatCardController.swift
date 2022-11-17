//
//  LCFormatCardController.swift
//  LeChangeDemo
//
//  Created by WWB on 2022/9/29.
//  Copyright © 2022 dahua. All rights reserved.
//
import UIKit
import SnapKit
import LCBaseModule

//import LCBaseModuleBundle

@objcMembers class LCFormatCardController {
    let used:Float = 0.0
    let total:Float = 0.0
    var cardStatus:String = ""
    let formatCard = LCFormatCardModel()
    let statusIV = LCMemoryManagementView()

    func loadData() {
        LCProgressHUD.show(onLowerView: nil)
        formatCard.stateCard(deviceId: "7J0191AFACC608E") { result in
            self.formatCard.deviceStorage(deviceId: "7J0191AFACC608E") { dic in
                self.statusIV.setupView(result: result, dic: dic)
                LCProgressHUD.hideAllHuds(nil)//应该添加到数据返回后，当数据展示完成后，结束弹窗
            } failure: { error in
                print("失败" + error.errorMessage)
                LCProgressHUD.hideAllHuds(nil)
            }
        } failure: { error in
            print("失败" + error.errorMessage)
            LCProgressHUD.hideAllHuds(nil)
        }

        statusIV.formatBtn.addTarget(self, action: #selector(self.buttontop), for: UIControlEvents.touchUpInside)
    }
    
    func buttontop() {
        LCAlertView.lc_ShowAlert(title: "Alert_Title_Notice".lc_T, detail: "formatting_reminder".lc_T, confirmString: "Alert_Title_Button_Formatting".lc_T, cancelString: "Alert_Title_Button_Cancle".lc_T) { [self] objc in
            if objc == true {
                self.statusIV.inFormatting()
                formatCard.recoverSDCard(deviceId: "7J0191AFACC608E") { [self] result in
                    if result == "sdcard-error"{   
                        LCProgressHUD.hideAllHuds(nil)
                        LCProgressHUD.showMsg("formatting_failed".lc_T)
                        self.statusIV.statusImageView.image = UIImage.init(named:"image")
                        self.statusIV.formatBtn.isHidden = false
                        self.statusIV.progressView.isHidden = true
                        self.statusIV.statusLabel.text = "storage_exception".lc_T
                    } else {
                        self.formatCard.deviceSDCardStatus(deviceId: "7J0191AFACC608E") { status in
                            self.statusIV.secondaryFormatting(result: status)
                        } failure: { error in
                            print("失败" + error.errorMessage)
                            LCProgressHUD.hideAllHuds(nil)
                        }
                    }
                } failure: { error in
                    print("失败" + error.errorMessage)
                    LCProgressHUD.hideAllHuds(nil)
                }
            }
        }
    }
}

