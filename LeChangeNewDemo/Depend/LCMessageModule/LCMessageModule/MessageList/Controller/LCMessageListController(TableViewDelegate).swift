//
//  LCMessageListController(TableViewDelegate).swift
//  LCMessageModule
//
//  Created by lei on 2022/10/12.
//

import Foundation
import LCNetworkModule

extension LCMessageListController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.showMessageInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LCMessageListCell.cellID(), for: indexPath) as! LCMessageListCell
        if indexPath.row < self.presenter.showMessageInfos.count {
            let messageInfo = self.presenter.showMessageInfos[indexPath.row]
            let messageItem = LCMessageItem(messageInfo, deviceId: presenter.deviceInfo.deviceId, productId: presenter.deviceInfo.productId, playtoken: presenter.deviceInfo.playToken)
            cell.updateData(messageItem)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < presenter.showMessageInfos.count else {
            return
        }
        let messageInfo = presenter.showMessageInfos[indexPath.row]
        guard let picUrl = messageInfo.picurlArray.first else {
            return
        }
        let pskKey = LCApplicationDataManager.openId() + (presenter.deviceInfo.deviceId )
        var key: String = UserDefaults.standard.object(forKey: pskKey) as? String ?? ""
        if  (key.count < 0 || key == "") {
            key = presenter.deviceInfo.deviceId
        }
        LCMessagePictureShowView.show(picUrl, productId: presenter.deviceInfo.productId, deviceId: presenter.deviceInfo.deviceId, secretKey: key, playtoken:presenter.deviceInfo.playToken, containView: self.view)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            for subView in tableView.subviews {
                if let swipeContainerView = NSClassFromString("_UITableViewCellSwipeContainerView"), subView.isKind(of: swipeContainerView) && subView.subviews.count > 0 {
                    guard let swipeView = subView.subviews.first else {
                        return
                    }
                    swipeView.backgroundColor = .clear
                    if swipeView.subviews.count >= 0, let deleteBtn = swipeView.subviews[0] as? UIButton {
                        deleteBtn.setTitle("", for: .normal)
                        deleteBtn.setImage(UIImage(named: "icon_shanchu"), for: .normal)
                    }
                }
            }
        }else if #available(iOS 11.0, *) {
            for subView in tableView.subviews {
                if let swipeContainerView = NSClassFromString("UISwipeActionPullView"), subView.isKind(of: swipeContainerView) {
                    subView.backgroundColor = .clear
                    if subView.subviews.count > 0, let deleteBtn = subView.subviews[0] as? UIButton {
                        deleteBtn.setTitle("", for: .normal)
                        deleteBtn.setImage(UIImage(named: "icon_shanchu"), for: .normal)
                    }
                }
            }
        }else {
            guard let tableCell = tableView.cellForRow(at: indexPath) else {
                return
            }
            for subView in tableCell.subviews {
                if let deleteView = NSClassFromString("UITableViewCellDeleteConfirmationView"), subView.isKind(of: deleteView) && subView.subviews.count > 0, let deleteBtn = subView.subviews[0] as? UIButton {
                    deleteBtn.setTitle("", for: .normal)
                    deleteBtn.setImage(UIImage(named: "icon_shanchu"), for: .normal)
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete, indexPath.row < presenter.showMessageInfos.count else {
            return
        }
        let alarmStr:String? = presenter.showMessageInfos[indexPath.row].alarmId
        guard let alarmId = alarmStr else {
            return
        }
        self.presenter.deleteMessageAlarm(by: alarmId)
    }
    
}
