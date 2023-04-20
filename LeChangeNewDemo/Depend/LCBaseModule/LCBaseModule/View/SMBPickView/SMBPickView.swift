//
//  SMBPickView.swift
//  DHBaseModule
//
//  Created by imou on 2020/4/6.
//  Copyright © 2020 jm. All rights reserved.
//

import UIKit

public class SMBPickView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    typealias SMBPickViewResultBlock = (_ result: String) -> Void
    @IBOutlet public var confirmBtn: UIButton!
    @IBOutlet public var cancleBtn: UIButton!
    @IBOutlet public var titleLab: UILabel!
    @IBOutlet public var pickView: UIPickerView!
    var selectblock: SMBPickViewResultBlock!

    public override class func awakeFromNib() {
        super.awakeFromNib()
    }

    public static func pickOn(view: UIView, resultBlock: @escaping (_ result: String) -> Void) -> SMBPickView {
        var pick = UINib(nibName: "SMBPickView", bundle: Bundle.smb_BaseBundle()).instantiate(withOwner: nil, options: nil).first as! SMBPickView
        pick = SMBPickView(frame: CGRect(x: 0, y: dh_screenHeight, width: dh_screenWidth, height: 250))
        pick.selectblock = resultBlock
        pick.pickView.delegate = pick
        pick.pickView.dataSource = pick
        view.addSubview(pick)
        pick.showPick()
        return pick
    }

    func showPick() {
        let rect = CGRect(x: 0, y: dh_screenHeight - 250, width: dh_screenWidth, height: 250)
        UIView.animate(withDuration: 0.3) {
            self.frame = rect
        }
    }

    func hidePick() {
        let rect = CGRect(x: 0, y: dh_screenHeight, width: dh_screenWidth, height: 250)
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = rect
        }) { _ in
            self.removeFromSuperview()
        }
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
}
