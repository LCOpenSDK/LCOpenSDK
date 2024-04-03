//
//  LCAlertView.swift
//  LCBaseModule
//
//  Created by yyg on 2022/10/8.
//  Copyright © 2022 jm. All rights reserved.
//

import SnapKit

public class LCAlertView: UIView {
    /// 回调代码块
    var block: ((_ isConfirmSelected: Bool) -> ())?
    /// title
    var title: String?
    /// detail
    var detail: String?
    /// showAgain
    var showAgain: Bool = false
    /// confirm
    var confirmTitle: String?
    /// cancle
    var cancleTitle: String?
    
    let horizontalMargin = 25
    
    @objc public class func lc_ShowAlert(title: String?, detail: String?, showAgain: Bool = false, confirmString: String?, cancelString: String?, handle:((_ isConfirmSelected: Bool) -> ())?) {
        LCAlertView().showAlert(title: title, detail: detail, showAgain: showAgain, confirmTitle: confirmString, cancelTitle: cancelString, complete: handle)
    }
    
    @objc public class func lc_ShowAlert(title: String?, detail: String?, confirmString: String?, cancelString: String?, handle:((_ isConfirmSelected: Bool) -> ())?) {
        LCAlertView().showAlert(title: title, detail: detail, showAgain: false, confirmTitle: confirmString, cancelTitle: cancelString, complete: handle)
    }
    
    @objc private func showAlert(title: String?, detail: String?, showAgain: Bool = false, confirmTitle: String?, cancelTitle: String?, complete: ((_ isConfirmSelected: Bool) -> ())?) {
        self.block = complete
        self.title = title
        self.detail = detail
        self.confirmTitle = confirmTitle
        self.cancleTitle = cancelTitle
        self.showAgain = showAgain
        self.setupView()
    }
    
    @objc public class func lc_showTextFieldAlert(title: String?, detail: String?, placeholder: String?, confirmString: String?, cancleString: String?, handle:((_ isConfirmSelected: Bool, _ inputContent: String?) -> ())?) {
        let alertController = UIAlertController(title: title, message: detail, preferredStyle: .alert)
        let  confirmAction = UIAlertAction(title: confirmString, style: .default) { action in
            if let callback = handle {
                callback(true, alertController.textFields?.first?.text)
            }
        }
        let cancleAction = UIAlertAction(title: cancleString, style: .cancel) { action in
            if let callback = handle {
                callback(false, nil)
            }
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancleAction)
        alertController.addTextField { textfield in
            textfield.placeholder = placeholder
        }
        self.topPresentOrRootController()?.present(alertController, animated: true)
    }
    
    private func setupView() {
        let backgroundView = UIView.init(frame: UIApplication.shared.keyWindow?.frame ?? CGRect.zero)
        backgroundView.backgroundColor = UIColor.lccolor_c51()
        UIApplication.shared.keyWindow?.addSubview(backgroundView)
        self.backgroundColor = UIColor.lccolor_c43()
        backgroundView.addSubview(self)
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(35)
            make.trailing.equalToSuperview().offset(-35)
            make.centerY.equalTo(backgroundView)
            make.centerX.equalTo(backgroundView)
        }
        
        let titleLabel = UILabel()
        self.addSubview(titleLabel)
        titleLabel.text = self.title
        titleLabel.textColor = UIColor.lccolor_c40()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        let detailLab = UILabel()
        self.addSubview(detailLab)
//        detailLab.text = self.detail
        detailLab.textColor = UIColor.lccolor_c40()
        detailLab.numberOfLines = 0
        detailLab.font = UIFont.systemFont(ofSize: 16)
        let width = self.detail?.lc_width(font: UIFont.boldSystemFont(ofSize: 16)) ?? 0.0
        if width > (backgroundView.frame.size.width - 50 - 70) {
            detailLab.textAlignment = .left
        } else {
            detailLab.textAlignment = .center
        }
        let  paraph =  NSMutableParagraphStyle ()
        paraph.lineSpacing = 10
        let  attributes = [ NSAttributedStringKey.font : UIFont .systemFont(ofSize: 16),
                            NSAttributedStringKey.paragraphStyle : paraph]
        detailLab.attributedText =  NSAttributedString (string: self.detail ?? "", attributes: attributes)
        detailLab.lineBreakMode = .byWordWrapping
        detailLab.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(horizontalMargin)
            make.leading.equalToSuperview().offset(horizontalMargin)
            make.trailing.equalToSuperview().offset(-horizontalMargin)
        }
        
        let cancleBtn = LCButton.createButton(with: LCButtonTypeCustom)
        cancleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancleBtn.setTitle(cancleTitle, for: .normal)
        cancleBtn.setTitleColor(UIColor.lccolor_c40(), for: .normal)
        cancleBtn.layer.cornerRadius = 22.5
        cancleBtn.layer.masksToBounds = true
        cancleBtn.layer.borderWidth = 0.5
        cancleBtn.layer.borderColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0).cgColor
        self.addSubview(cancleBtn)
        cancleBtn.touchUpInsideblock = { [weak self]
            btn in
            backgroundView.removeFromSuperview()
            if let callBack = self?.block {
                callBack(false)
            }
        }
        
        let confirmBtn = LCButton.createButton(with: LCButtonTypeCustom)
        confirmBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        confirmBtn.setTitle(confirmTitle, for: .normal)
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.backgroundColor = UIColor.lccolor_c0()
        confirmBtn.layer.cornerRadius = 22.5
        confirmBtn.layer.masksToBounds = true
        if (confirmTitle == "mobile_common_delete".lc_T) {
            confirmBtn.backgroundColor = UIColor.lc_color(withHexString: "#FF4F4F")
        }
        self.addSubview(confirmBtn)
        confirmBtn.touchUpInsideblock = { [weak self]
            btn in
            backgroundView.removeFromSuperview()
            if let callBack = self?.block {
                callBack(true)
            }
        }
        var showHeight = 0
        if self.showAgain == true {
            showHeight = 40
            let againView = UIView()
            self.addSubview(againView)
            againView.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.top.equalTo(detailLab.snp.bottom);
                make.leading.equalTo(detailLab.snp.leading);
                make.trailing.equalTo(detailLab.snp.trailing);
            }
            let checkbox = LCButton.createButton(with: LCButtonTypeCustom)
            checkbox.setImage(UIImage(named: "icon_checkbox_no"), for: .normal)
            checkbox.setImage(UIImage(named: "icon_checkbox_selected"), for: .selected)
            againView.addSubview(checkbox)
            checkbox.touchUpInsideblock = {btn in
                btn.isSelected = !btn.isSelected;
                UserDefaults.standard.set(btn.isSelected, forKey: self.detail ?? "")
            }
            checkbox.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.height.width.equalTo(20)
                make.leading.equalToSuperview()
            }
            
            let againLabel = UILabel()
            againLabel.font = UIFont.systemFont(ofSize: 14)
            againLabel.textColor = UIColor(red: 143.0/255.0, green: 143.0/255.0, blue: 143.0/255.0, alpha: 1.0)
            againLabel.text = "dont_prompt_again".lc_T
            againView.addSubview(againLabel)
            againLabel.snp.makeConstraints { make in
                make.leading.equalTo(checkbox.snp.trailing).offset(10);
                make.top.height.equalTo(checkbox);
            }
        }
        if (self.cancleTitle != nil && self.cancleTitle != "") && (self.confirmTitle != nil && self.confirmTitle != "") {
            cancleBtn.snp.makeConstraints { make in
                make.top.equalTo(detailLab.snp.bottom).offset(20 + showHeight);
                make.bottom.equalToSuperview().offset(-25)
                make.leading.equalToSuperview().offset(25)
                make.height.equalTo(45)
                make.width.equalToSuperview().multipliedBy(0.37)
            }
            
            confirmBtn.snp.makeConstraints { make in
                make.top.bottom.width.equalTo(cancleBtn)
                make.trailing.equalToSuperview().offset(-25)
                make.height.equalTo(45)
            }
            
            confirmBtn.isHidden = false
            cancleBtn.isHidden = false
        }
        
        if (self.confirmTitle != nil && self.confirmTitle != "") && (self.cancleTitle == nil || self.cancleTitle == "") {
            confirmBtn.snp.makeConstraints { make in
                make.leading.equalTo(detailLab).offset(25);
                make.trailing.equalTo(detailLab).offset(-25);
                make.height.equalTo(45);
                make.top.equalTo(detailLab.snp.bottom).offset(20 + showHeight);
                make.bottom.equalToSuperview().offset(-25);
            }
            confirmBtn.isHidden = false
            cancleBtn.isHidden = true
        }
        if (self.cancleTitle != nil && self.cancleTitle != "") && (self.confirmTitle == nil || self.confirmTitle == "") {
            cancleBtn.snp.makeConstraints { make in
                make.leading.equalTo(detailLab).offset(25);
                make.trailing.equalTo(detailLab).offset(-25);
                make.height.equalTo(45);
                make.top.equalTo(detailLab.snp.bottom).offset(20 + showHeight);
                make.bottom.equalToSuperview().offset(-25);
            }
            confirmBtn.isHidden = true
            cancleBtn.isHidden = false
        }
    }
    
    class private func topPresentOrRootController() -> UIViewController? {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            var resultVC = self._topPresentOrRootController(vc: rootViewController)
            while resultVC?.presentedViewController != nil {
                resultVC = self._topPresentOrRootController(vc: (resultVC?.presentedViewController)!)
            }
            return resultVC
        }
        return nil
    }
    
    class private func _topPresentOrRootController(vc: UIViewController) -> UIViewController? {
        if vc.isKind(of: UINavigationController.self) {
            return self._topPresentOrRootController(vc: (vc as! UINavigationController).topViewController ?? UIViewController())
        } else if vc.isKind(of: UITabBarController.self) {
            return self._topPresentOrRootController(vc: (vc as! UITabBarController).selectedViewController ?? UIViewController())
        } else {
            return vc
        }
    }
}
