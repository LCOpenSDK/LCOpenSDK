//
//  LCVisualIntercomClockView.swift
//  LCNewLivePreviewModule
//
//  Created by dahua on 2024/3/21.
//

import UIKit
class LCVisualIntercomClockView: UIView {
    
    
    fileprivate var timer: DispatchSourceTimer?
    fileprivate var timeInterval: TimeInterval = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    deinit {
        if self.timer != nil {
            self.timer?.cancel()
            self.timer = nil
        }
    }
    
    
    //MARK: - public func
    public func startTimer() {
        
        if timer != nil {
            if timer?.isCancelled == false {
                timer?.cancel()
            }
            timer = nil
        }
        timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        timer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(1), leeway: .microseconds(10))
        timer?.setEventHandler { [weak self] in
            if let sSelf = self {
                sSelf.timeInterval += 1
                sSelf.calculateShowTime(sSelf.timeInterval)
            }
        }
        timer?.resume()
    }
    
    public func stopTimer() {
        
        if self.timer != nil {
            timer?.cancel()
            timer = nil
        }
    }
    
    public func resetTimer() {
        self.timeInterval = 0
    }
    
    
    //MARK: - private func
    private func calculateShowTime(_ timeInterval: TimeInterval) {
        
        let intValue = Int(timeInterval)
        if intValue > 60 * 60 {
            // 超过一个小时
            let hour = intValue / 3600
            let min = intValue % 3600 / 60
            let sec = intValue % 60
            titleLabel.text = String(format: "%02d:%02d:%02d", hour, min, sec)
        } else {
            let min = intValue % 3600 / 60
            let sec = intValue % 60
            titleLabel.text = String(format: "%02d:%02d", min, sec)
        }
    }
    
    //MARK: - lazy
    
    lazy var titleLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.textColor = UIColor.lccolor_c43()
        result.font = UIFont.lcFont_t5()
        return result
    }()
    
    
}
