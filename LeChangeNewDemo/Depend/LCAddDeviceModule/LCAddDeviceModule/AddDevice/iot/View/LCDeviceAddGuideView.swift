//
//  LCDeviceAddGuideView.swift
//  LCAddDeviceModule
//
//  Created by 吕同生 on 2022/10/17.
//  Copyright © 2022 Imou. All rights reserved.
//

import UIKit
import SnapKit

/// 引导页头部示例图片
public class LCDeviceAddGuideImageView: UIView, UIScrollViewDelegate {

    // 引导图数组
    var introductionImages: [String]?
    var placeHoldImage: String?

    lazy var introductionImgListView: TYCyclePagerView = {
        let introductionImgListView = TYCyclePagerView.init()
        introductionImgListView.autoScrollInterval = 2
        introductionImgListView.collectionView?.isScrollEnabled = true
        introductionImgListView.register(LCDeviceAddGuideCell.self, forCellWithReuseIdentifier: "IoTGuideImageCell")
        introductionImgListView.delegate = self
        introductionImgListView.dataSource = self
        introductionImgListView.backgroundColor = .clear
        introductionImgListView.autoScrollInterval = 4
        return introductionImgListView
    }()

    init(imageUrls: [String], placeHoldImage: String) {
        super.init(frame: CGRect.zero)
        self.introductionImages = imageUrls
        self.placeHoldImage = placeHoldImage
        
        self.addSubview(introductionImgListView)
        introductionImgListView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalTo(self)
        }
    }
    
    // 页面更新
    func update(imageUrls: [String], imageStrs: [String]) {
        self.introductionImages = imageUrls
        self.introductionImgListView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LCDeviceAddGuideImageView: TYCyclePagerViewDelegate, TYCyclePagerViewDataSource {
    // -----------dataSource-------------
    public func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        if let count = introductionImages?.count, count > 1 {
            introductionImgListView.autoScrollInterval = 2
            introductionImgListView.collectionView?.isScrollEnabled = true
        } else {
            introductionImgListView.autoScrollInterval = 0
            introductionImgListView.collectionView?.isScrollEnabled = false
        }
        
        return introductionImages?.count ?? 0
    }

    public func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell: LCDeviceAddGuideCell = pagerView.dequeueReusableCell(withReuseIdentifier: "IoTGuideImageCell", for: index) as! LCDeviceAddGuideCell
        cell.setUpsubviews(introductionImage: introductionImages?[index] ?? "")
        return cell
    }

    public func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout: TYCyclePagerViewLayout = TYCyclePagerViewLayout()
        if let count = introductionImages?.count, count > 1 {
            layout.itemSize = CGSize(width: lc_screenWidth - 35 * 2, height: 200)
            layout.itemSpacing =  5
        } else {
            layout.itemSize = CGSize(width: lc_screenWidth - 25 * 2, height: 200)
            layout.itemSpacing =  10
        }
        return layout
    }

    // -----------delegate-------------
    func pagerView(_ pageView: TYCyclePagerView, didScrollFrom fromIndex: Int, to toIndex: Int) {
//        self.pageControlImageViews = self.pageControlImageViews.sorted { (img1, img2) -> Bool in
//            return img1.frame.origin.x < img2.frame.origin.y
//        }
//        for index in 0..<self.pageControlImageViews.count  {
//            if index <= toIndex {
//                pageControlImageViews[index].backgroundColor = UIColor.lccolor_c10()
//            } else {
//                pageControlImageViews[index].backgroundColor = UIColor.lc_color(withHexString: "#c9c9c9")
//            }
//        }
    }
}

/// 引导页点击事件
public protocol LCDeviceAddGuideViewDelegate : NSObjectProtocol {
    // 下一步 操作
    func addGuideViewConnectNext(_ addGuideView: LCDeviceAddGuideView)
    
    // 其他按钮操作
    func addGuideViewOther(_ addGuideView: LCDeviceAddGuideView)
    
    // 提示
    func addGuideViewConnectHelp(_ addGuideView: LCDeviceAddGuideView)
}

/// 设备添加引导页
public class LCDeviceAddGuideView: UIView {
    
    open var helpModel = LCDeviceAddHelpModel()
    
    weak open var delegate: LCDeviceAddGuideViewDelegate?
    lazy var guideImageView: LCDeviceAddGuideImageView = {
        let guideImageView = LCDeviceAddGuideImageView.init(imageUrls: [], placeHoldImage: "luyouqi_add_shangdian")
        return guideImageView
    }()
    
    // 临时代码-LTS  平台未返回配置步骤
    lazy var tempImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "adddevice_iot_softap_net")
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var operateLab: UILabel = {
        let operateLab = UILabel()
        operateLab.numberOfLines = 0
        return operateLab
    }()
    
    lazy var desLab: UILabel = {
        let desLab = UILabel()
        desLab.numberOfLines = 0
        return desLab
    }()
    
    lazy var helpUrlTitleBtn: UIButton = {
        let helpUrlTitleBtn = UIButton()
        helpUrlTitleBtn.titleLabel?.numberOfLines = 0
        helpUrlTitleBtn.titleLabel?.font = UIFont.lcFont_t3()
        helpUrlTitleBtn.setTitleColor(UIColor.lccolor_c10(), for: .normal)
        helpUrlTitleBtn.addTarget(self, action: #selector(wifiButtonClicked), for: .touchUpInside)
        return helpUrlTitleBtn
    }()
    
    lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.titleLabel?.font = UIFont.lcFont_t3()
        nextButton.layer.cornerRadius = 22.5
        nextButton.layer.masksToBounds = true
        nextButton.backgroundColor = LCModuleConfig.shareInstance().commonButtonColor()
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonClikced), for: .touchUpInside)
        return nextButton
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        loadSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSubviews() {
        self.addSubview(tempImageView)
        self.addSubview(guideImageView)
        guideImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(25)
            make.trailing.equalTo(self).offset(-25)
            make.height.equalTo(200)
        }
        tempImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(guideImageView)
        }
        
        self.addSubview(operateLab)
        operateLab.sizeToFit()
        operateLab.snp.makeConstraints { (make) in
            make.top.equalTo(guideImageView.snp.bottom).offset(30)
            make.leading.equalTo(self).offset(25)
            make.trailing.equalTo(self).offset(-25)
        }
        
        self.addSubview(desLab)
        desLab.sizeToFit()
        desLab.snp.makeConstraints { (make) in
            make.top.equalTo(operateLab.snp.bottom).offset(15)
            make.leading.equalTo(self).offset(25)
            make.trailing.equalTo(self).offset(-25)
        }
        
        self.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-30 - LC_bottomSafeMargin)
            make.leading.equalTo(self).offset(37.5)
            make.trailing.equalTo(self).offset(-37.5)
            make.height.equalTo(45)
        }
        
        self.addSubview(helpUrlTitleBtn)
        helpUrlTitleBtn.titleLabel?.sizeToFit()
        helpUrlTitleBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.nextButton.snp_top).offset(-20)
            make.leading.equalTo(self).offset(15)
            make.trailing.equalTo(self).offset(-15)
//            make.height.equalTo(14)
        }
    }
}

extension LCDeviceAddGuideView {
    
    public func updateGuideView(stepModel: LCDeviceAddStepModel) {
        guideImageView.update(imageUrls: stepModel.stepIcon ?? [], imageStrs: ["luyouqi_add_shangdian", "luyouqi_add_lianjiewifi"])
        operateLab.lc_setAttributedText_Normal(text: stepModel.stepTitle ?? "", font: UIFont.lcFont_t1Bold(), color: UIColor.lccolor_c40(), lineSpace: 10)
        desLab.lc_setAttributedText_Normal(text: stepModel.stepOperate ?? "", font: UIFont.lcFont_t4(), color: UIColor.lccolor_c40(), lineSpace: 10)
        
        helpModel = stepModel.help ?? LCDeviceAddHelpModel()
        if let count = helpModel.helpUrlTitle?.count, count > 0 { // 包含helpmodel
            helpUrlTitleBtn.setTitle(helpModel.helpUrlTitle ?? "", for: .normal)
            nextButton.setTitle(stepModel.stepButton?[0] ?? "", for: .normal)
        } else {
            if let count = stepModel.stepButton?.count, count > 1 { // 不包含helpModle，但是配置了两个按钮
                helpUrlTitleBtn.setTitle(stepModel.stepButton?[0] ?? "", for: .normal)
                nextButton.setTitle(stepModel.stepButton?[1] ?? "", for: .normal)
            } else if let count = stepModel.stepButton?.count, count > 0 {
                helpUrlTitleBtn.isHidden = true
                nextButton.setTitle(stepModel.stepButton?[0] ?? "", for: .normal)
            }
        }
//        setupButtons(stepModel: stepModel)
    }
    
    func setupButtons(stepModel: LCDeviceAddStepModel) {
        if let count = stepModel.stepButton?.count {
            for i in 0..<count {
                let nextButton = UIButton()
                nextButton.titleLabel?.font = UIFont.lcFont_t3()
                nextButton.layer.cornerRadius = 22.5
                nextButton.layer.masksToBounds = true
                nextButton.backgroundColor = LCModuleConfig.shareInstance().commonButtonColor()
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.addTarget(self, action: #selector(nextButtonClikced), for: .touchUpInside)
                nextButton.setTitle(stepModel.stepButton?[i] ?? "", for: .normal)
                nextButton.tag = count - 1 - i
                self.addSubview(nextButton)
                nextButton.snp.makeConstraints { (make) in
                    if i == 0 {
                        make.bottom.equalTo(self).offset(-30 - LC_bottomSafeMargin)
                    } else {
                        make.bottom.equalTo(self.nextButton.snp_top).offset(-20)
                    }
                    make.leading.equalTo(self).offset(37.5)
                    make.trailing.equalTo(self).offset(-37.5)
                    make.height.equalTo(45)
                }
                self.nextButton = nextButton
            
                helpUrlTitleBtn.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(self.nextButton.snp_top).offset(-20)
                    make.leading.equalTo(self).offset(15)
                    make.trailing.equalTo(self).offset(-15)
                    make.height.equalTo(14)
                }
            }
            
            helpModel = stepModel.help ?? LCDeviceAddHelpModel()
            if let count = helpModel.helpUrlTitle?.count, count > 0 { // 包含helpmodel
                helpUrlTitleBtn.setTitle(helpModel.helpUrlTitle ?? "", for: .normal)
            } else {
                helpUrlTitleBtn.isHidden = true
            }
        }
    }
   
    @objc func wifiButtonClicked() {
        self.delegate?.addGuideViewConnectHelp(self)
    }
    
    @objc func nextButtonClikced(button: UIButton) {
        print("点击了下一步")
        if button.tag == 0 {
            self.delegate?.addGuideViewConnectNext(self)
        } else {
            self.delegate?.addGuideViewOther(self)
        }
    }
}
