//
//  Copyright © 2019 Imou. All rights reserved.
//

import UIKit

protocol LCQRScanMenuViewDelegate: class {
    func qrScanMenu(_ menuView: LCQRScanMenuView, didSelectedMenuAt type: QRScanMenuType)
}

class LCQRScanMenuView: UIView {
    
    weak var delegate: LCQRScanMenuViewDelegate?
    
    var menuModels: Array<QRScanMenuModel> = []
    
    var menuCells: Array<LCScanMenuCell> = []
    
    public init(frame: CGRect, qrScanMenuModels models: Array<QRScanMenuModel>) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
        self.menuModels = models
        loadSubviews()
    }
    
    init(qrScanMenuModels models: Array<QRScanMenuModel>) {
        super.init(frame: CGRect())
        self.menuModels = models
        loadSubviews()
    }
    
    func loadSubviews() {
        weak var weakSelf = self
        for (index, model) in self.menuModels.enumerated() {
            let menuCell = LCScanMenuCell.init(title: model.title, imageName: model.imageName) { (cellTag) in
                let menuType = weakSelf?.transferMenuType(index: cellTag - 10)
                weakSelf?.delegate?.qrScanMenu(weakSelf!, didSelectedMenuAt: menuType!)
            }
            menuCell.tag = 10 + index
            menuCells.append(menuCell)
            self.addSubview(menuCell)
        }
    }
    
    func transferMenuType(index: Int) -> QRScanMenuType {
        if index == 0 {
            return .serialNumber
        } else if index == 1 {
            return .photoAlbum
        }
        
        return .unKnown
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard self.menuCells.count > 0 else {
            return
        }
        let cellHeight = self.bounds.size.height
        let cellWidth: CGFloat = 65.0
        let areaWidth = self.bounds.size.width / CGFloat(self.menuCells.count)
        for (index, cell) in self.menuCells.enumerated() {
            cell.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: cellWidth, height: cellHeight))
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(areaWidth * CGFloat(index) + (areaWidth - cellWidth) / 2.0)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct QRScanMenuModel {
    var title: String = ""
    var imageName: String = ""
    var menuType: QRScanMenuType = .unKnown
}

enum QRScanMenuType {
    case serialNumber
    case photoAlbum
    case unKnown
}
