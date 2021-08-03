//
//  Copyright © 2019 dahua. All rights reserved.
//

import UIKit

class DHScanMenuCell: UIView {
    
    typealias CellClickedBlock = (_ tag: Int) -> ()
    
    var cellClick: CellClickedBlock?
    
    var cellImageView: UIImageView!
    
    var cellTitleLabel: UILabel!
    
    init(title: String, imageName: String, clickedHandle:@escaping CellClickedBlock) {
        super.init(frame: CGRect())
        self.isUserInteractionEnabled = true
        self.cellClick = clickedHandle
        loadSubview(title, imageName)
        addGesture()
    }
    
    private func loadSubview(_ title: String, _ imageName: String) {
        cellImageView = UIImageView()
        cellImageView.image = UIImage.init(named: imageName)
        cellImageView.contentMode = .scaleAspectFit
        self.addSubview(cellImageView)
        
        cellTitleLabel = UILabel()
        cellTitleLabel.text = title
        cellTitleLabel.textColor = UIColor.white
        cellTitleLabel.textAlignment = .center
        cellTitleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.addSubview(cellTitleLabel)
    }
    
    func addGesture() {
        // 点击手势
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureClick))
        self.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellImageView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            if let image = cellImageView.image {
                make.size.equalTo(CGSize.init(width: image.size.width, height: image.size.height))
            } else {
                make.size.equalTo(CGSize.init(width: 10.0, height: 30.0))
            }
            make.top.equalToSuperview().offset(15.0)
        }
        
        cellTitleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(cellImageView.snp.bottom).offset(10.0)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func tapGestureClick() {
        self.cellClick?(self.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
