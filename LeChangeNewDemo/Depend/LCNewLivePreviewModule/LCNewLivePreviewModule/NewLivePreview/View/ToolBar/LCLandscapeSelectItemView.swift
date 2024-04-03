//
//  LCLandscapeSelectItemView.swift
//  LCNewLivePreviewModule
//
//  Created by dahua on 2024/3/21.
//

import UIKit

@objc public class LCLandscapeSelectItem: NSObject {
    @objc public var normalImage:UIImage?
    @objc public var normalTitle:String?
    @objc public var selectedImage:UIImage?
    @objc public var selectedTitle:String?
    @objc public var titleFont:UIFont?
}

@objc public class LCLandscapeVideoSelectView: UIView {
    
    public var lock:NSLock?
    
    //MARK: - Init/Deinit
    public init() {
        super.init(frame: .zero)
        self.lock = NSLock.init()
        initialView()
        addGesture()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialView()
        addGesture()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Func
    @objc public func configSelectItems(_ selectedItems:[LCLandscapeSelectItem], selectHandle:((Int) -> ())?) {
        guard selectedItems.count > 0 else {
            return
        }
        //先移除之前的Cell
        self.subviews.forEach { subView in
            if subView.isKind(of: LCLandscapeSelectItemView.self) {
                subView.removeFromSuperview()
            }
        }
        let countFloat = CGFloat(selectedItems.count)
        let itemHeight:CGFloat = 80.0
        let firstOffsetX:CGFloat = (lc_screenWidth - countFloat * itemHeight - (countFloat - 1.0) * 25.0) / 2.0
        
        for (index, selectedItem) in selectedItems.enumerated() {
            let itemView = LCLandscapeSelectItemView()
            itemView.configSelectItem(selectedItem, index)
            itemView.selectedHandle = { [weak self](index) in
                selectHandle?(index)
                self?.dismiss()
            }
            bgView.addSubview(itemView)
            itemView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(firstOffsetX + CGFloat(index) * (itemHeight + 25.0))
                make.leading.equalToSuperview().offset(20.0)
                make.trailing.equalToSuperview().offset(-20.0)
                make.height.equalTo(itemHeight)
            }
        }
    }
    
    @objc public func showAlert() {
        guard let superView = LCProgressHUD.keyWindow() else {
            return
        }
        superView.subviews.forEach { subView in
            if subView.isKind(of: LCLandscapeVideoSelectView.self) {
                subView.removeFromSuperview()
            }
        }
        superView.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        superView.layoutIfNeeded()
        self.bgView.isHidden = false
        bgView.snp.updateConstraints { make in
            make.leading.equalTo(self.snp.trailing).offset(-315.0/812.0 * lc_screenHeight)
        }
        UIView.animate(withDuration: lc_animDuratuion) {
            self.layoutIfNeeded()
        }
    }
    
    public func dismiss() {
//        self.lock?.lock()
        guard self.bgView.superview != nil else {
//            self.lock?.unlock()
            return
        }
        self.bgView.snp.updateConstraints { make in
            make.leading.equalTo(self.snp.trailing).offset(0.0)
        }
        UIView.animate(withDuration: lc_animDuratuion) {
            self.layoutIfNeeded()
        } completion: { success in
            self.bgView.isHidden = true
            self.removeFromSuperview()
//            self.lock?.unlock()
        }

    }
    
    //MARK: - Private Func
    private func initialView() {
        self.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.trailing).offset(0.0)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(315.0/812.0 * lc_screenHeight)
        }
    }
    
    private func addGesture() {
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick(_:)))
        self.addGestureRecognizer(tap)
    }
    
    //MARK: - @Objc Func
    @objc func tapClick(_ gesture:UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: self)
        if touchPoint.x < lc_screenHeight - 315.0/812.0 * lc_screenHeight {
            self.dismiss()
        }
    }
    
    //MARK: - Lazy Var
    lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lc_color(withHexString: "#000000", alpha: 0.9)
        view.isHidden = true
        return view
    }()

}

class LCLandscapeSelectItemView:UIView {
    
    var item:LCLandscapeSelectItem?
    
    var index:Int = 0
    
    var selectedHandle:((Int) -> ())?
    
    //MARK: - Init/Deinit
    init() {
        super.init(frame: .zero)
        initialView()
        addGesture()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialView()
        addGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Func
    public func configSelectItem(_ selectItem:LCLandscapeSelectItem, _ index:Int) {
        self.item = selectItem
        self.index = index
        self.tipImv.image = selectItem.normalImage
        if let imageSize = selectItem.normalImage?.size {
            self.tipImv.lc_size = imageSize
        }
        self.tipLabel.text = selectItem.normalTitle
        if let titleFont = selectItem.titleFont {
            self.tipLabel.font = titleFont
        }
    }
    
    //MARK: - Private Func
    private func initialView() {
        self.layer.cornerRadius = 15.0
        self.backgroundColor = UIColor.lc_color(withHexString: "#242424")
        
        self.addSubview(tipImv)
        self.addSubview(tipLabel)
        self.addSubview(arrowImv)
        
        tipImv.snp.makeConstraints { make in
            make.leading.equalTo(15.0)
            make.centerY.equalToSuperview()
        }
        tipLabel.snp.makeConstraints { make in
            make.leading.equalTo(tipImv.snp.trailing).offset(10.0)
            make.trailing.equalTo(arrowImv.snp.leading).offset(-12.0)
            make.centerY.equalToSuperview()
        }
        arrowImv.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 20.0, height: 20.0))
        }
    }
    
    private func addGesture() {
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick(_:)))
        self.addGestureRecognizer(tap)
    }
    
    //MARK: - @objc func
    @objc func tapClick(_ gesture:UITapGestureRecognizer) {
        self.selectedHandle?(index)
    }
    
    //MARK: - Lazy Var
    lazy var tipImv:UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    
    lazy var tipLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lccolor_c43()
        label.font = UIFont.lcFont_t5()
        label.numberOfLines = 2
        return label
    }()
    
    lazy var arrowImv:UIImageView = {
        let imv = UIImageView()
        return imv
    }()
}
