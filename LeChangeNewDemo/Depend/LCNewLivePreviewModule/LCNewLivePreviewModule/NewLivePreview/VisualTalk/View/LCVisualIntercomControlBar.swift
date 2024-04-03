//
//  LCVisualIntercomControlBar.swift
//  LCNewLivePreviewModule
//
//  Created by dahua on 2024/3/20.
//

import UIKit


/// 按钮配置信息
public typealias LCIntercomControlItemConfig = (title: String, normalImg: UIImage?, selectedTitle: String, selectedImg: UIImage?, disableImg: UIImage?)

/// 双向对讲控制按钮
@objc public enum LCIntercomControlItem: Int {
    case answer = 30001      //接听
    case hangup = 30002      //挂断
    case filp = 30003        //摄像头翻转
    case camera = 30004      //摄像头开关
    case microphone = 30005  //麦克风开关
    
    
    public func configuration() -> LCIntercomControlItemConfig {
        
        var config: LCIntercomControlItemConfig
        switch self {
        case .answer:
            config = (title: "接听".lc_T, normalImg: UIImage(named: "call_btn_answer_n"), selectedTitle: "接听".lc_T, selectedImg: UIImage(named: "call_btn_answer_n"), disableImg: UIImage(named: "call_btn_answer_d"))
        case .hangup:
            config = (title: "挂断".lc_T, normalImg: UIImage(named: "call_btn_refuse_n"), selectedTitle: "挂断".lc_T, selectedImg: UIImage(named: "call_btn_refuse_n"), disableImg: UIImage(named: "call_btn_refuse_d"))
        case .filp:
            config = (title: "镜头翻转".lc_T, normalImg: UIImage(named: "call_btn_flip_n"), selectedTitle: "镜头翻转".lc_T, selectedImg: UIImage(named: "call_btn_flip_n"), disableImg: UIImage(named: "call_btn_flip_d"))
        case .camera:
            config = (title: "镜头关闭".lc_T, normalImg: UIImage(named: "call_btn_video_off"), selectedTitle: "镜头开启".lc_T, selectedImg: UIImage(named: "call_btn_video_on"), disableImg: nil)
        case .microphone:
            config = (title: "麦克风关".lc_T, normalImg: UIImage(named: "call_btn_mic_off"), selectedTitle: "麦克风开".lc_T, selectedImg: UIImage(named: "call_btn_mic_on"), disableImg: UIImage(named: "call_btn_mic_off_d"))
        }
        return config
    }
}

@objc public protocol ILCVisualIntercomControlBar: NSObjectProtocol {
    
    
    /// 点击挂断
    /// - Parameters:
    ///   - controlBar: 控制功能栏
    ///   - hangup: 是否挂断
    func controlBar(doHangup controlBar: LCVisualIntercomControlBar)
    
    /// 点击接听
    /// - Parameters:
    ///   - controlBar: 控制功能栏
    ///   - isAnswer: 是否接听
    func controlBar(doAnswer controlBar: LCVisualIntercomControlBar)
    
    /// 翻转摄像头
    /// - Parameters:
    ///   - controlBar: 控制功能栏
    ///   - isFrontCamera: true: 前置，false：后置
    func controlBar(_ controlBar: LCVisualIntercomControlBar, doFilp isFrontCamera: Bool)
    
    /// 开关摄像头
    /// - Parameters:
    ///   - controlBar: 控制功能栏
    ///   - isCameraOn: on/off
    func controlBar(_ controlBar: LCVisualIntercomControlBar, switchCamera isCameraOn: Bool)
    
    /// 开关麦克风
    /// - Parameters:
    ///   - controlBar: 控制功能栏
    ///   - isMicrophoneOn: on/off
    func controlBar(_ controlBar: LCVisualIntercomControlBar, switchMicrophone isMicrophoneOn: Bool)
}

public class LCVisualIntercomControlBar: UIView {
    
    
    //MARK: - public var
    
    public var barWidth: CGFloat = lc_screenWidth
    /// 代理
    @objc weak public var controlBarDelegate: ILCVisualIntercomControlBar?
    
    //MARK: - private var
    
    /// 按钮配置
    private var allItemButtons: [LCIntercomControlItem: LCButton] = [:]
    /// 展示的按钮
    private var allItems: [LCIntercomControlItem] = []
    
    //MARK: - lift cycle
    
    @objc public init(barWidth: CGFloat) {
        super.init(frame: .zero)
        self.barWidth = barWidth
        setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        self.backgroundColor = .clear
    }
    
    
    //MARK: - public func
    
    public func configItems(_ items: [LCIntercomControlItem]) {
        
        guard items.count > 0 else {
            return
        }
        // 清空缓存的信息
        allItems = []
        allItemButtons.values.forEach({ $0.removeFromSuperview() })
        allItemButtons = [:]
        
        allItems = items
        
        let widthHeight: CGFloat = 90.0
        let inset: CGFloat = 28.0
        let countF: CGFloat = CGFloat(items.count)
        var margin: CGFloat = 28.0
        if items.count > 1 {
            margin = (lc_screenWidth - inset * 2.0 - widthHeight * countF) / (countF - 1.0)
        }else {
            margin = lc_screenWidth - inset * 2.0 - widthHeight * countF
        }
        for (index, item) in items.enumerated() {
            let itemConfig = item.configuration()
            let button = LCButton.createButton(with: LCButtonTypeVertical)
            button.setTitle(itemConfig.title, for: .normal)
            button.setTitle(itemConfig.selectedTitle, for: .selected)
            button.setImage(itemConfig.normalImg, for: .normal)
            button.setImage(itemConfig.selectedImg, for: .selected)
            button.setImage(itemConfig.disableImg, for: .disabled)
            button.titleLabel?.font = UIFont.lcFont_t8()
            button.setTitleColor(UIColor.lccolor_c43(), for: .normal)
            button.tag = item.rawValue
            
            button.addTarget(self, action: #selector(itemBtnAction(sender:)), for: .touchUpInside)
            allItemButtons[item] = button
            addSubview(button)
            button.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(inset + (widthHeight + margin)*CGFloat(index))
                make.top.equalTo(20)
                make.width.height.equalTo(widthHeight)
            }
        }
    }
    
    //MARK: - update func
    
    /// 更新控制按钮状态
    /// - Parameters:
    ///   - itemType: 按钮类型
    ///   - isEnabled: 是否可点
    ///   - isSelected: 是否选中
    public func updateBarItem(itemType: LCIntercomControlItem, isEnabled: Bool, isSelected: Bool) {
        
        guard let itemButton = allItemButtons[itemType] else {
            return
        }
        itemButton.isSelected = isSelected
        itemButton.isEnabled = isEnabled
    }
    
    //MARK: - action

    @objc private func itemBtnAction(sender: LCButton) {
        
        guard let item = LCIntercomControlItem(rawValue: sender.tag) else { return }
        
        switch item {
        case .answer:
            self.controlBarDelegate?.controlBar(doAnswer: self)
            break
        case .hangup:
            self.controlBarDelegate?.controlBar(doHangup: self)
            break
        case .filp:
            sender.isSelected.toggle()
            self.controlBarDelegate?.controlBar(self, doFilp: sender.isSelected)
            break
        case .camera:
            self.controlBarDelegate?.controlBar(self, switchCamera: sender.isSelected)
            break
        case .microphone:
            sender.isSelected.toggle()
            self.controlBarDelegate?.controlBar(self, switchMicrophone: sender.isSelected)
            break
        }
    }
    
    
}
