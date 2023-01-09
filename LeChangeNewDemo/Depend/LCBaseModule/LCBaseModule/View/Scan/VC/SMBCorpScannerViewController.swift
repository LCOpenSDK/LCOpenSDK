//
//  SMBCorpScannerViewController.swift
//  LCIphoneAdhocIP
//
//  Created by imou on 2020/4/8.
//  Copyright © 2020 dahua. All rights reserved.
//

import DHScanner
import UIKit

public class SMBCorpScannerViewController: DHScannerViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let heightRadio = (dh_screenHeight / 812)
    let pickerVC = UIImagePickerController()

    override public func viewDidLoad() {
        configSubview()
        super.viewDidLoad()
        configBtn()
        configNav()
    }

    func configSubview() {
        let style = DHScannerViewStyle()
        style.showRectangleBorder = false
        style.animationViewType = .line
        style.scanningImage = UIImage(named: "common_scan_line")
        style.rectangleTop = dh_screenHeight / 3.0 * heightRadio
        style.rectangleLeft = 38
        style.cornerLineWith = 0
        style.rectangeRatio = 1
        style.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        viewStyle = style
    }

    func configNav() {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "common_icon_backarrow"), for: .normal)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { snp in
            snp.left.equalTo(self.view).offset(15)
            snp.top.equalTo(self.view).offset(55)
        }
        backBtn.addTarget(self, action: #selector(backClick(btn:)), for: .touchUpInside)
    }

    func configBtn() {
        let albumbBtn = UIButton(type: .custom)
        albumbBtn.setImage(UIImage(named: "common_scan_icon_image"), for: .normal)
        view.addSubview(albumbBtn)
        albumbBtn.snp.makeConstraints { snp in
            snp.bottom.equalTo(self.view).offset(-60 * heightRadio)
            snp.right.equalTo(self.view.snp_right).offset(-74)
//            snp.top.equalTo(self.scanningArea.maxY).offset(20)
        }
        albumbBtn.addTarget(self, action: #selector(albumBtnClick), for: .touchUpInside)

        let lightBtn = UIButton(type: .custom)
        lightBtn.setImage(UIImage(named: "common_scan_icon_light"), for: .normal)
        lightBtn.setUIButtonImageUpWithTitleDownUI()
        lightBtn.addTarget(self, action: #selector(lightBtnClick(btn:)), for: .touchUpInside)
        view.addSubview(lightBtn)
        lightBtn.snp.makeConstraints { snp in
            snp.bottom.equalTo(self.view).offset(-60 * heightRadio)
            snp.left.equalTo(self.view.snp_left).offset(74)
//            snp.top.equalTo(self.scanningArea.maxY).offset(20)
        }
    }

    @objc func albumBtnClick(btn: UIButton) {
        LCPermissionHelper.requestAlbumPermission { granted in
            if granted {
                self.pickerVC.sourceType = .photoLibrary
                self.pickerVC.allowsEditing = true
                self.pickerVC.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
                self.present(self.pickerVC, animated: true, completion: nil)
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true) {
        }
        let mediaType = info[UIImagePickerControllerMediaType] as! String?
        if mediaType == "public.image" {
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                // 处理图片
                LCProgressHUD.show(on: view)
                if let resultStr = DHScannerUtils.decodeImage(image: image), resultStr.count > 0 {
                    print("110801====DHScannerUtils:\(resultStr)")
                    LCProgressHUD.hideAllHuds(view)
                    self.scanResult(text: resultStr, image: image)
                } else {
                    let ciImage : CIImage = CIImage(image: image)!
                    let context = CIContext(options: nil)
                    let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
                    let features = detector?.features(in: ciImage)
                    if let feature = features?.first as? CIQRCodeFeature, let resultStr = feature.messageString, resultStr.count > 0 {
                        print("110801======CIQRCodeFeature:\(resultStr)")
                        LCProgressHUD.hideAllHuds(view)
                        self.scanResult(text: resultStr, image: image)
                    }else {
                        LCProgressHUD.hideAllHuds(view)
                        LCProgressHUD.showMsg("add_device_scanning_error_tip".lc_T)
                    }
                }
            }
        }
    }

    @objc func backClick(btn: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc func lightBtnClick(btn: UIButton) {
        torchOn = !torchOn
    }

    override public func scanResult(text: String, image: UIImage?) {
        if text.isSafetyWeb() {
            let web = LCAdvertisementDetailViewController()
            web.playUrl = text
            self.present(web, animated: true, completion: nil)
        }
    }
}
