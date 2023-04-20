//
//  LCMessagePictureShowView.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/13.
//

import UIKit

class LCMessagePictureShowView: UIView {
    //MARK: - Init
    private init() {
        super.init(frame: .zero)
        setupUI()
        addGesture()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Func
    public class func show(_ picUrl:String, productId:String?, deviceId:String, secretKey:String, playtoken:String?, containView:UIView) {
        for subView in containView.subviews {
            if subView.isKind(of: LCMessagePictureShowView.classForCoder()) {
                subView.removeFromSuperview()
            }
        }
        let picShowView = LCMessagePictureShowView()
        containView.addSubview(picShowView)
        picShowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        picShowView.showMessagePicture(picUrl, productId: productId, deviceId: deviceId, secretKey: secretKey, playtoken: playtoken)
        
    }
    
    //MARK: - @objc func
    @objc func tapClick() {
        self.removeFromSuperview()
    }
    
    //MARK: - Private Func
    private func setupUI() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        self.addSubview(messageImv)
    }
    
    private func addGesture() {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    private func showMessagePicture(_ picUrl:String, productId:String?, deviceId:String, secretKey:String, playtoken:String?) {
        messageImv.lc_setMessageImage(withURL: picUrl, placeholderImage: UIImage(named: "common_defaultcover_big") ?? UIImage(), deviceId: deviceId, productId: productId ?? "", playtoken: playtoken ?? "", key: secretKey)
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        messageImv.frame = CGRect(x: screenW / 2.0, y: screenH / 2.0, width: 0.0, height: 0.0)

        UIView.animate(withDuration: 0.4) {
            self.messageImv.frame = CGRect(x: 15.0, y: screenH / 2.0 - 245.0 / 2.0, width: screenW - 30.0, height: 245.0)
        }
    }
    
    lazy var messageImv:UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFit
        imv.isUserInteractionEnabled = false
        return imv
    }()
}

extension LCMessagePictureShowView:UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        let touchPoint = gestureRecognizer.location(in: self)
        if touchPoint.x < 15.0 || touchPoint.x > screenW - 15.0 || touchPoint.y < screenH / 2.0 - 245.0 / 2.0 || touchPoint.y > screenH / 2.0 + 245.0 / 2.0 {
            return true
        }
        
        return false
    }
}
