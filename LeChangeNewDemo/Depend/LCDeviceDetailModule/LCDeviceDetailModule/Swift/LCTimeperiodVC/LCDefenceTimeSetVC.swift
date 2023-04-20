//
//
//  Created by lechech on 8/25/18.
//  Copyright © 2018 Imou. All rights reserved.
//

import SnapKit
import UIKit
import LCBaseModule

enum LCDefenceTimeSetVCType: CaseIterable {
    case crossLine // 越线
    case crossRegion // 动检区域
    case other
}

// 布防时间段设置
public class LCDefenceTimeSetVC: LCBasicViewController {
    @objc public var deviceId: String = "" // 设备唯一序列号
    @objc public var channelId: String = "" // 通道号
    @objc public var handleBlock: ((_ resultArr: NSArray) -> (Void))?

    var headView = LCSetTimeHeadView()

    var currentType: LCDefenceTimeSetVCType? = .other

    var planView = LCWeekDayProcessView()

    var tPresenter: LCTimeSetVCProtocol!

    public override func viewDidLoad() {
        super.viewDidLoad()
        // 基础UI
        setupUI()
        
        // 初始化 presnter
        tPresenter = LCTimeSetPresenter(controller: self)
        // 请求数据
        tPresenter.updateData()
        
        self.lcCreatNavigationBar(with: LCNAVIGATION_STYLE_DEFAULT, buttonClick: nil)
        // 导航栏右侧,根据
        initNavigatorRightItem()
    }

    // 通用布局
    func setupUI() {
        // 通用布局
        headView = LCSetTimeHeadView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 192))
        planView.tableHeaderView = headView
        planView.backgroundColor = .clear
        self.view.addSubview(planView)
        planView.processViewDelegate = self
        planView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
    }

    // 根据条件判断导航栏按键的状态
    func initNavigatorRightItem() {
        let setButton = UIButton(type: .custom)
        setButton.frame = CGRect(x: 0,y: 0,width: 30,height: 30)
        setButton.addTarget(self, action: #selector(configBtnClicked), for: .touchUpInside)
        setButton.setImage(UIImage.init(named: "icon_set_up"), for: .normal)
        //setButton.setImage(UIImage(named: "nav_icon_settings_disable"), for: .disabled)
        let backitem = UIBarButtonItem.init(customView: setButton)
        //setButton.isHidden = true
        self.navigationItem.setRightBarButton(backitem, animated: true)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // 导航栏点击事件
    @objc func configBtnClicked() {
        tPresenter.didSelectPlanTimeItem(day: .sunday)
    }
}

// 选择了某个时间段
extension LCDefenceTimeSetVC: LCWeekDayProcessViewDelegate {
    func didSelectitem(item: LCWeekDay) {
        tPresenter.didSelectPlanTimeItem(day: item)
    }
}
