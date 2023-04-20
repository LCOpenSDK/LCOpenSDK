//
//  LCDeviceAddGuideCell.swift
//  LCAddDeviceModule
//
//  Created by 吕同生 on 2022/10/17.
//  Copyright © 2022 Imou. All rights reserved.
//

import Foundation
import SDWebImage

public class LCDeviceAddGuideCell: UICollectionViewCell {
    
    open lazy var imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    func setUpsubviews(introductionImage: String) {
        imageView.removeFromSuperview()
        
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView)
            make.leading.equalTo(self.contentView)
            make.trailing.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
//        if let urlStr = introductionImages?[index],urlStr.count > 0{
//            //静态图片
//            imageView.isHidden = false
            // iot添加引导页面 跟UI沟通结果：暂时移除默认图片，未加载完成时，默认展示空白，后续统一处理
//            imageView.sd_setImage(with: URL(string:introductionImage),placeholderImage:UIImage.lc_img(withName: "luyouqi_add_shangdian", bundle: "LCDeviceAddModule", targetClass: Self.self), completed: nil)
            imageView.sd_setImage(with: URL(string:introductionImage),placeholderImage:nil, completed: nil)
            imageView.contentMode = .scaleAspectFit
//        }
    }
}
