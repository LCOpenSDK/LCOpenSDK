//
//  LCVisualTalkViewController.swift
//  LCNewLivePreviewModule
//
//  Created by dahua on 2024/3/20.
//

import UIKit
import LCBaseModule
import LCOpenSDKDynamic
import LCMediaBaseModule
import KVOController


/// 双向对讲状态
@objc public enum LCVisualIntercomStatus: Int {
    case ringing = 0    // 响铃中，对端呼叫过来
    case answered = 1   // 已接听，手机呼叫设备，直接是已接听状态
    
    
    /// 获取对应状态的控制按钮
    /// - Returns: 控制开关
    func getControlItems() -> [LCIntercomControlItem] {
        
        switch self {
        case .ringing:
            return [.answer, .hangup, .filp, .camera]
        case .answered:
            return [.hangup, .filp, .camera, .microphone]
        }
    }
}
@objc public class LCVisualTalkViewController: LCBaseViewController {
    
    var isSampleAudio: Bool = false
    var isSampleVideo: Bool = false
    
    @objc public var isNeedSoftEncode: Bool = false //是否需要软编码
    
    public var intercomStatus: LCVisualIntercomStatus = .ringing                    
    
    // 是否开启了音视频渲染
    fileprivate var hasOpenedCapture: Bool = false
    /// 是否使用前置摄像头
    fileprivate var usingFrontCamera: Bool = true
    /// 摄像头是否打开
    fileprivate var isCameraOn: Bool = false
    /// 麦克风是否打开
    fileprivate var isMicrophoneOn: Bool = false
    /// 是否已经开启过对讲
    fileprivate var alreadyTalked: Bool = false
    /// 是否需要恢复对讲
    fileprivate var isNeedRecoverTalk = false
    /// 是否挂断
    fileprivate var hasHangup: Bool = false
    
    @objc public var dismissCallback: (() -> ())?
    
    //MARK: - private 计算属性
    /// 是否有摄像头权限
    fileprivate var hasCameraAuth: Bool {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        return cameraStatus == .authorized
    }
    /// 是否有麦克风权限
    fileprivate var hasMicrophoneAuth: Bool {
        let audioStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        return audioStatus == .authorized
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layout()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        hangupVideoCall()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for window in UIApplication.shared.windows {
            if window.isKind(of: NSClassFromString("UITextEffectsWindow")!) {
                window.isHidden = true
            }
        }
        //开始拉流
        if LCNewDeviceVideoManager.shareInstance().currentDevice.status == "online" || LCNewDeviceVideoManager.shareInstance().currentDevice.status == "sleep" {
            self.startPlay()
        }
        
        LCPermissionHelper.requestCameraAndAudioPermission { granted in
            if granted && self.hasOpenedCapture == false {
                self.h264Encoder.createEncodeSession(Int32(240), height: Int32(320), fps: 15, bite: Int32(240 * 320 * 12 * 4))
                self.captureSession.start()
                self.hasOpenedCapture = true
                self.isCameraOn = true   // 摄像头开启
                self.getPreviewView().isHidden = false  // 显示播放器
            }
            // 更新按钮状态
            self.updateControlBarContent()
        }
        layout()
    }
    
    public func getPreviewView() -> UIView {
        if self.previewView.previewLayer == nil {
            let previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession.session)
            previewLayer.videoGravity = .resizeAspectFill
            self.previewView.addPreviewLayer(previewLayer)
        }
        return previewView
    }

    func layout() {
        //初始化播放窗口
        guard let player = self.playWindow.getWindowView() else {
            return
        }
        
        topBar.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(LC_statusBarHeight)
            make.height.equalTo(88)
        }
        
        controlToolBar.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-LC_bottomSafeMargin)
            make.height.equalTo(138)
        }
        
        playView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
            make.bottom.equalTo(controlToolBar.snp.top)
        }
        
        player.snp.remakeConstraints({ make in
            make.top.equalToSuperview()
            make.width.equalTo(lc_screenWidth)
            make.height.equalTo(211)
            make.leading.equalToSuperview()
        })
        
        let livePlayer = self.getPreviewView()
        let moveViewWidth: CGFloat = lc_screenWidth / 3.0
        livePlayer.snp.remakeConstraints({ make in
            make.top.equalTo(player.snp.bottom).offset(10)
            make.width.equalTo(moveViewWidth)
            make.height.equalTo(moveViewWidth * 1.34)
            make.centerX.equalTo(player)
        })
        
        self.playWindow.setWindowFrame(CGRectMake(0, 0, lc_screenWidth, 211))
        
        errorBtn.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(70)
            make.width.equalTo(100)
            make.height.equalTo(60)
        }
        
        errorMsgLab.snp.remakeConstraints { make in
            make.top.equalTo(errorBtn.snp.bottom).offset(10)
            make.width.equalTo(lc_screenWidth)
            make.height.equalTo(30)
            make.centerX.equalTo(errorBtn.snp.centerX)
        }

    }

    func setupView() {
        self.view.backgroundColor = .lc_color(withHexString: "212121")
        
        //初始化播放窗口
        guard let player = self.playWindow.getWindowView() else {
            return
        }
        view.addSubview(topBar)
        topBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(LC_statusBarHeight)
            make.height.equalTo(88)
        }
        
        self.view.addSubview(controlToolBar)
        controlToolBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-LC_bottomSafeMargin)
            make.height.equalTo(138)
        }
        
        //        //显示输出图片
        self.view.addSubview(playView)
        playView.addSubview(self.getPreviewView())
        playView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
            make.bottom.equalTo(controlToolBar.snp.top)
        }
        
        playView.addSubview(player)
        player.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.width.equalTo(lc_screenWidth)
            make.height.equalTo(211)
            make.leading.equalToSuperview()
        })
        
        player.addSubview(self.errorBtn)
        errorBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(70)
            make.width.equalTo(100)
            make.height.equalTo(60)
        }
        
        player.addSubview(errorMsgLab)
        errorMsgLab.snp.makeConstraints { make in
            make.top.equalTo(errorBtn.snp.bottom).offset(10)
            make.width.equalTo(lc_screenWidth)
            make.height.equalTo(30)
            make.centerX.equalTo(errorBtn.snp.centerX)
        }
        errorMsgLab.isHidden = true
//        //加载Loading
        self.showVideoLoadImage()
        self.loadStatusView()

        
        controlToolBar.configItems(intercomStatus.getControlItems())
        // 配置标题
        topBar.configIntercomInfo(LCNewDeviceVideoManager.shareInstance().currentDevice.name)
        
        let livePlayer = self.getPreviewView()
        livePlayer.isHidden = true  //没有开启视频前需要先隐藏
        livePlayer.clipsToBounds = true
        // 绑定可移动视图
        let moveViewWidth: CGFloat = lc_screenWidth / 3.0
        playView.combindMoveTargetView(standardView:player, moveTargetView:livePlayer, targetViewSize: CGSize(width: moveViewWidth, height: moveViewWidth * 1.34), containerSize: CGSize(width: self.view.frame.width, height: self.view.frame.height - LC_statusBarHeight - 88 - 138))
        // 配置手机播放器样式
        livePlayer.layer.cornerRadius = 5.0
        livePlayer.layer.shadowColor = UIColor.lccolor_c51().cgColor
        livePlayer.layer.shadowRadius = 15.0
        livePlayer.layer.shadowOpacity = 1
        livePlayer.layer.shadowOffset = CGSizeZero
        
        self.playView.bringSubviewToFront(livePlayer)
        
        let defaultImageView: UIImageView = self.playWindow.getWindowView().viewWithTag(10000) as! UIImageView
        defaultImageView.isHidden = false
        defaultImageView.lc_setThumbImage(withURL: LCNewDeviceVideoManager.shareInstance().mainChannelInfo.picUrl, placeholderImage: UIImage.init(named: "common_defaultcover_big")!, deviceId: LCNewDeviceVideoManager.shareInstance().currentDevice.deviceId, channelId: LCNewDeviceVideoManager.shareInstance().mainChannelInfo.channelId)
    }

    //加载重放，异常按钮弹窗，默认图等
    func loadStatusView() {
        let player = self.playWindow.getWindowView()
        player?.addSubview(defaultImageView)
        defaultImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        self.defaultImageView.lc_setThumbImage(withURL: LCNewDeviceVideoManager.shareInstance().mainChannelInfo.picUrl, placeholderImage: UIImage.init(named: "common_defaultcover_big") ?? UIImage(), deviceId: LCNewDeviceVideoManager.shareInstance().currentDevice.deviceId, channelId: LCNewDeviceVideoManager.shareInstance().mainChannelInfo.channelId)
        weak var weakImageView = defaultImageView
        self.defaultImageView.kvoController.observe(LCNewDeviceVideoManager.shareInstance(), keyPath: "playStatus", options: .new) { observer, object, change in
            if (change["new"] as! NSNumber).intValue != 1001 {
                return
            }
            DispatchQueue.main.async {
                weakImageView?.isHidden = true //状态改变时隐藏默认图，成功时会播放，不成功时会展示重试按钮
            }
        }
        player?.addSubview(loadImageview)
        loadImageview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    

    func startTalk(isCall:Bool) {
        let param = LCOpenSDK_ParamTalk.init()
        param.isOpt = true
        param.accessToken = LCApplicationDataManager.token()
        param.deviceID = LCNewDeviceVideoManager.shareInstance().currentDevice.deviceId
        param.channel = (LCNewDeviceVideoManager.shareInstance().mainChannelInfo.ability as NSString).contains("AudioTalkV1") ? LCNewDeviceVideoManager.shareInstance().mainChannelInfo.channelId.intValue() : -1
        param.psk = LCNewDeviceVideoManager.shareInstance().currentPsk
        param.playToken = LCNewDeviceVideoManager.shareInstance().currentDevice.playToken
        param.talkType = isCall == true ? "call" : "talk"
        param.productId = LCNewDeviceVideoManager.shareInstance().currentDevice.productId
        param.useTLS = LCNewDeviceVideoManager.shareInstance().currentDevice.tlsEnable
        
        self.isSampleAudio = true
        self.isSampleVideo = true
        let videoSampleCfg = LCOpenSDK_MediaVideoSampleConfigParam.initWithParam(240, height: 320, i_frame_interval: 15, encodeType: 2, frameRate: 15, isCameraOpen: true, softEncodeMode: isSampleVideo)
        
        self.talker.playVisualTalk(param, videoSampleCfg: videoSampleCfg)
    }
    func uninitPlayWindow() {
        self.playWindow.uninitPlayWindow()
    }

    func stopPlay(isKeepLastFrame: Bool) {
        self.hideVideoLoadImage()
//        LCNewDeviceVideoManager.shareInstance().isPlay = false
        LCNewDeviceVideoManager.shareInstance().isOpenAudioTalk = false
        self.playWindow.stopRtspReal(isKeepLastFrame)
        self.playWindow.stopAudio()
    }

    func startPlay() {
        self.showVideoLoadImage()
//        LCNewDeviceVideoManager.shareInstance().isPlay = true
        self.playFirst()
    }
    
    func startSampleVideo() {
        self.isSampleVideo = true
        self.talker.enableVideo(true)
        self.h264Encoder.forceKeyFrame()
    }
    
    func stopSampleVideo() {
        self.isSampleVideo = false
        self.talker.enableVideo(false)
    }

    func startSampleAudio() {
        self.isSampleAudio = true
        self.talker.startSampleAudio()
    }
    
    func stopSampleAudio() {
        self.isSampleAudio = false
        self.talker.stopSampleAudio()
    }
    
    func playFirst() {
        self.defaultImageView.isHidden = false
        self.playWindow.stopRtspReal(true)
        self.playWindow.stopAudio()
        let param = LCOpenSDK_ParamReal.init()
        param.isOpt = true
        param.useTLS = LCNewDeviceVideoManager.shareInstance().currentDevice.tlsEnable
        param.accessToken = LCApplicationDataManager.token()
        param.deviceID = LCNewDeviceVideoManager.shareInstance().currentDevice.deviceId
        param.productId = LCNewDeviceVideoManager.shareInstance().currentDevice.productId
        param.channel = LCNewDeviceVideoManager.shareInstance().mainChannelInfo.channelId.intValue()
        param.psk = LCNewDeviceVideoManager.shareInstance().currentPsk
        param.playToken = LCNewDeviceVideoManager.shareInstance().currentDevice.playToken
        param.isOpenAudio = true
        param.defiMode = LCNewDeviceVideoManager.shareInstance().isSD ? .SD : .HG
        param.isAssistFrame = true
        param.isSupportVideoTalk = true
        let retVal = self.playWindow.playRtspReal(param)
        if retVal != 0 {
            
        }
    }
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if size.width < size.height {
            layout()
        }
    }
    public override var shouldAutorotate: Bool {
        return true
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func hideVideoLoadImage() {
        DispatchQueue.main.async {
            self.loadImageview.isHidden = true
            self.loadImageview.releaseImgs()
            self.defaultImageView.isHidden = true
        }
    }
    
    func showVideoLoadImage() {
        DispatchQueue.main.async {
            self.loadImageview.isHidden = false
            self.loadImageview.loadGifImage(with: ["video_waiting_gif_1","video_waiting_gif_2","video_waiting_gif_3","video_waiting_gif_4"], timeInterval: 0.3, style: LCMediaIMGCirclePlayStyleCircle)
        }
    }

    func hideErrorBtn() {
        self.errorBtn.isHidden = true
        self.errorMsgLab.isHidden = true
    }

    func showErrorBtn() {
        self.errorBtn.isHidden = false
        self.errorMsgLab.isHidden = false
        self.hideVideoLoadImage()
//        LCNewDeviceVideoManager.shareInstance().isPlay = false
    }

    func onPlay(btn: LCButton) {
        if LCNewDeviceVideoManager.shareInstance().isPlay {
            self.stopPlay(isKeepLastFrame: true)
        } else {
            self.startPlay()
        }
    }
    
    //MARK: - public func
    
    /// 配置内容，仅作为配置信息使用，不要在内部调用UI相关的方法
    /// - Parameters:
    ///   - videoSource: 设备信息
    ///   - status: 呼入/呼出   0：呼入  1：呼出
    @objc public func configIntercom(status: Int) {
        
        guard let intercomStatus = LCVisualIntercomStatus(rawValue: status) else { return }
        self.intercomStatus = intercomStatus
    }
    
    //MARK: - private func
    
    /// 更新控制按钮状态
    private func updateControlBarContent() {
        
        let playStatus = self.playWindow.playStatus
        
        // 摄像头翻转
        self.controlToolBar.updateBarItem(itemType: .filp, isEnabled: isCameraOn, isSelected: usingFrontCamera)
        // 摄像头
        self.controlToolBar.updateBarItem(itemType: .camera, isEnabled: true, isSelected: isCameraOn)
        // 麦克风
        self.controlToolBar.updateBarItem(itemType: .microphone, isEnabled: hasMicrophoneAuth , isSelected: isMicrophoneOn)
        //接听按钮
        if intercomStatus == .ringing {
            self.controlToolBar.updateBarItem(itemType: .answer, isEnabled: playStatus == .playing, isSelected: false)
        }
    }
    
    //MARK: - 内部操作
    
    /// 挂断通话
    fileprivate func hangupVideoCall() {
        DispatchQueue.main.async {
//            guard !self.hasHangup else {
//                return
//            }
            self.hasHangup = true
            // 挂断关闭视频以及对讲
            
            
            self.captureSession.stop()
            self.h264Encoder.stopEncodeSession()
            self.stopSampleVideo()
            self.stopSampleAudio()
            self.captureSession.toggleCamera(with: .front)
            self.talker.stop()
            self.uninitPlayWindow()
            self.stopPlay(isKeepLastFrame: true)
            self.dismissCallback?()
            DispatchQueue.main.async {
                LCProgressHUD.showMsg("对讲挂断".lcMedia_T())
            }
            self.dismiss(animated: true)
        }
    }
    /// 第一次对讲成功调用
    private func answerSuccessed() {
        // 设置状态
        if alreadyTalked == false {
            alreadyTalked = true
            // 设置为接听状态，更新页面
            intercomStatus = .answered
            controlToolBar.configItems(intercomStatus.getControlItems())
            
            topBar.subTitleLabel.text = "已接通"
        }
    }
    /// 播放窗口视图
    fileprivate lazy var playView: LCVisualIntercomPlayContainer = {
        let result = LCVisualIntercomPlayContainer(frame: .zero)
        result.backgroundColor = .clear
        return result
    }()

    lazy var previewView:LCVisualTalkPreviewView = {
        let view = LCVisualTalkPreviewView()
        return view
    }()
    
    lazy var controlToolBar: LCVisualIntercomControlBar = {
        let controlToolBar = LCVisualIntercomControlBar.init(barWidth: self.view.frame.width)
        controlToolBar.controlBarDelegate = self
        
        return controlToolBar
    }()
    func reportCallAction() {
        LCDeviceHandleInterface.deviceCallRefuse(LCNewDeviceVideoManager.shareInstance().currentDevice.deviceId, productId: LCNewDeviceVideoManager.shareInstance().currentDevice.productId) {
            self.hangupVideoCall()
        } failure: { error in
        }

    }
    /// 顶部工具栏
    fileprivate lazy var topBar: LCVisualIntercomTopBar = {
        let result = LCVisualIntercomTopBar(frame: .zero)
        return result
    }()
    
    lazy var captureSession: LCVisualTalkCaptureSession = {
        let captureSession = LCVisualTalkCaptureSession(captureWith: .preset640x480)
        captureSession.delegate = self
        
        return captureSession
    }()
    
    lazy var talker: LCOpenSDK_AudioTalk = {
        let talker = LCOpenSDK_AudioTalk()
        talker.setListener(self)
        
        return talker
    }()
    
    ///播放窗口懒加载
    lazy var playWindow: LCOpenSDK_PlayRealWindow = {
        let playWindow = LCOpenSDK_PlayRealWindow(playWindow: CGRect(x: 50, y: 50, width: self.view.frame.width, height: 221), index: 11)
        playWindow?.isZoomEnabled = false;
        //设置背景色为黑色
        playWindow?.setSurfaceBGColor(.black)
        playWindow?.setPlayRealListener(self)
        playWindow?.setTouchListener(self)
        //开启降噪
        playWindow?.setSEnhanceMode(.level5)
        
        return playWindow ?? LCOpenSDK_PlayRealWindow()
    }()

    lazy var defaultImageView: UIImageView = {
        let defaultImageView = UIImageView()
        defaultImageView.tag = 10000;
        
        return defaultImageView
    }()

    lazy var cameraNameLabel: UILabel = {
        let cameraNameLabel = UILabel()
        cameraNameLabel.textColor = .white
        cameraNameLabel.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.3)
        cameraNameLabel.layer.cornerRadius = 13
        cameraNameLabel.layer.masksToBounds = false
        cameraNameLabel.font = .systemFont(ofSize: 11)
        cameraNameLabel.text = "移动镜头"
        cameraNameLabel.textAlignment = .center
        cameraNameLabel.isHidden = true
        
        return cameraNameLabel
    }()
    
    lazy var loadImageview: UIImageView = {
        let loadImageview = UIImageView.init()
        loadImageview.contentMode = .center
        return loadImageview
    }()
    
    lazy var errorBtn: LCButton = {
        let errorBtn = LCButton.createButton(with: LCButtonTypeVertical)
        errorBtn.setImage(UIImage.init(named: "videotape_icon_replay"), for: .normal)
        errorBtn.isHidden = true
        return errorBtn
    }()
    
    lazy var errorMsgLab: UILabel = {
        let errorMsgLab = UILabel()
        errorMsgLab.text = "play_module_video_replay_description".lcMedia_T()
        errorMsgLab.textColor = .white
        errorMsgLab.font = .lcFont_t3()
        errorMsgLab.textAlignment = .center
        errorMsgLab.isHidden = true
        return errorMsgLab
    }()
    
    lazy var h264Encoder: LCH264Encoder = {
        let h264Encoder = LCH264Encoder()
        h264Encoder.delegate = self
        
        return h264Encoder
    }()

}

extension LCVisualTalkViewController:LCOpenSDK_TalkerListener,LCOpenSDK_TouchListener {
    
    public func onTalkResult(_ error: String!, type: Int) {
            let errArrStr: NSArray = ["0", "1", "2", "3", "4", "5", "6", "7", "99", "100"]
            DispatchQueue.main.async {
                print("开启对讲回调error = \(error) type = \(type)")
                LCProgressHUD.hideAllHuds(nil)
                if 99 == type {
                    DispatchQueue.main.async {
                        LCNewDeviceVideoManager.shareInstance().isOpenAudioTalk = false
                        LCProgressHUD.showMsg("play_module_video_preview_talk_failed".lcMedia_T())
                    }
                    return
                }
                if nil != error && errArrStr.object(at: RTSP_STATE.STATE_RTSP_DESCRIBE_READY.rawValue) as? String == error {
                    DispatchQueue.main.async {
                    }
                    return
                }
                if nil != error && RTSP_STATE.STATE_RTSP_PLAY_READY.rawValue == error.intValue() {
                    DispatchQueue.main.async { [weak self] in
                        //对讲连接成功建立
                        // 更新麦克风状态
                        if self?.intercomStatus == .answered {
                            self?.isMicrophoneOn = true
                            self?.updateControlBarContent()
                            
                            LCNewDeviceVideoManager.shareInstance().isOpenAudioTalk = true
                            LCProgressHUD.showMsg("device_mid_open_talk_success".lcMedia_T())
                            self?.h264Encoder.createEncodeSession(240, height: 320, fps: 15, bite: 240 * 320 * 12 * 4)
                            self?.captureSession.start()
                            self?.topBar.subTitleLabel.text = "已接通"
                        } else {
                            self?.answerSuccessed()
                            self?.isMicrophoneOn = true
                            self?.updateControlBarContent()
                            
                            LCNewDeviceVideoManager.shareInstance().isOpenAudioTalk = true
                            LCProgressHUD.showMsg("device_mid_open_talk_success".lcMedia_T())
                            self?.h264Encoder.createEncodeSession(240, height: 320, fps: 15, bite: 240 * 320 * 12 * 4)
                            self?.captureSession.start()
                        }
                    }
                    return
                }else if error.intValue() == LCHTTP_STATE.STATE_LCHTTP_HUNG_UP.rawValue {
                    //挂断
                    if self.intercomStatus == .answered {
                        self.hangupVideoCall()
                    } else {
//                        guard !self.hasHangup else {
//                            return
//                        }
                        self.hasHangup = true
                        // 挂断关闭视频以及对讲
                        
                        
                        self.captureSession.stop()
                        self.h264Encoder.stopEncodeSession()
                        self.stopSampleVideo()
                        self.stopSampleAudio()
                        self.captureSession.toggleCamera(with: .front)
                        self.talker.stop()
                        self.uninitPlayWindow()
                        self.stopPlay(isKeepLastFrame: true)
                        
                        self.topBar.subTitleLabel.text = "接听失败"
                        DispatchQueue.main.async {
                            LCProgressHUD.showMsg("对讲挂断".lcMedia_T())
                        }
                    }
                } else if error.intValue() == LCHTTP_STATE.STATE_LCHTTP_BUSY_LINE.rawValue {
                    self.hasHangup = true
                    // 挂断关闭视频以及对讲
                    
                    
                    self.captureSession.stop()
                    self.h264Encoder.stopEncodeSession()
                    self.stopSampleVideo()
                    self.stopSampleAudio()
                    self.captureSession.toggleCamera(with: .front)
                    self.talker.stop()
                    self.uninitPlayWindow()
                    self.stopPlay(isKeepLastFrame: true)
                    
                    self.topBar.subTitleLabel.text = "接听失败"
                    LCProgressHUD.showMsg("正在被接听".lcMedia_T())
                }
                else {
                    DispatchQueue.main.async {
                        LCProgressHUD.showMsg("play_module_video_preview_talk_failed".lcMedia_T())
                        LCNewDeviceVideoManager.shareInstance().isOpenAudioTalk = false
                    }
                }
            }
        }
    
    public func onAudioRecord(_ pData: UnsafeMutablePointer<UInt8>!, dataLen: Int32, audioFormat: Int32, sampleRate: Int32, sampleDepth: Int32) {
        
    }
    
    public func onAudioReceive(_ pData: UnsafeMutablePointer<UInt8>!, dataLen: Int32, audioFormat: Int32, sampleRate: Int32, sampleDepth: Int32) {
    }
    
}
extension LCVisualTalkViewController :LCOpenSDK_PlayRealListener {
    public func onPlayBegan(_ index: Int) {
        LCNewDeviceVideoManager.shareInstance().playStatus = RTSP_STATE.STATE_RTSP_PLAY_READY
        self.hideVideoLoadImage()
        
        self.hideErrorBtn()
        if intercomStatus == .answered {
            startTalk(isCall: false)
        }
        updateControlBarContent()
    }
    public func onPlayFail(_ errCode: String!, errMsg: String!, type: Int, index: Int) {
        print("LIVE_PLAY-CODE: \(errCode) TYPE: \(type), INDEX: \(index)")
        DispatchQueue.main.async {
            if 99 == type {
                //请求超时处理
//                LCNewDeviceVideoManager.shareInstance().isPlay = false
                self.showErrorBtn()
            }
            if 5 == type {
                if errCode.intValue() == LCHTTP_STATE.STATE_LCHTTP_KEY_ERROR.rawValue {
                    self.showErrorBtn()
                }
            }
            if type == 0 {
                LCNewDeviceVideoManager.shareInstance().playStatus = RTSP_STATE(rawValue: errCode.intValue()) ?? RTSP_STATE.STATE_RTSP_PLAY_READY
//                if errArrStr.object(at: RTSP_STATE.STATE_RTSP_KEY_MISMATCH) == code {
//
//                }
                self.showErrorBtn()
            }
        }
    }
}


extension LCVisualTalkViewController :LCVisualTalkCaptureSessionDelegate, LCH264EncoderDelegate {
    public func h264Encoder(_ encoder: LCH264Encoder, encode data: Data) {
        self.talker.pushMediaData(1, mediaData: data, datalen: Int32(data.count), needSoftEncode: isNeedSoftEncode)
    }
    
    public func video(with sampleBuffer: CMSampleBuffer) {
        let data = self.captureSession.convertVideoSmapleBuffer(toYuvData: sampleBuffer, scaleWidth: 240, scaleHeight: 320)
        if data.count > 0, isNeedSoftEncode == true {
            self.talker.pushMediaData(1, mediaData: data, datalen: Int32(data.count), needSoftEncode: isNeedSoftEncode)
        } else {
            self.h264Encoder.createEncodeSession(240, height: 320, fps: 15, bite: 240 * 320 * 12 * 4)
            if self.h264Encoder.isInvalidSession() {
                let scaleWidth = 240
                let scaleHeight = 320
                self.h264Encoder.createEncodeSession(Int32(scaleWidth), height: Int32(scaleHeight), fps: 15, bite: Int32(scaleWidth * scaleHeight * 12 * 4))
            }
            self.h264Encoder.encodeSmapleBuffer(sampleBuffer)
        }
    }
    
    
}

extension LCVisualTalkViewController: ILCVisualIntercomControlBar {
    public func controlBar(doHangup controlBar: LCVisualIntercomControlBar) {
        // 上报状态
        if intercomStatus == .ringing {
            reportCallAction()
            hangupVideoCall()
        } else {
            // 挂断
            hangupVideoCall()
        }
    }
    
    public func controlBar(doAnswer controlBar: LCVisualIntercomControlBar) {
        LCPermissionHelper.requestAudioPermission { granted in
            if granted {
                self.startTalk(isCall: true)
            }
        }
    }
    
    public func controlBar(_ controlBar: LCVisualIntercomControlBar, doFilp isFrontCamera: Bool) {
        usingFrontCamera = isFrontCamera
        let position = usingFrontCamera == true ? LCCaptureDevicePosition.front : LCCaptureDevicePosition.back
        self.captureSession.toggleCamera(with: position)
    }
    
    public func controlBar(_ controlBar: LCVisualIntercomControlBar, switchCamera isCameraOn: Bool) {
        func switchCamera(_ isCameraOn: Bool) {
            if isCameraOn {
                self.startSampleVideo()
            } else {
                self.stopSampleVideo()
            }
            // 更新状态
            self.isCameraOn = isCameraOn
            self.getPreviewView().isHidden = !isCameraOn
            self.updateControlBarContent()
        }
        guard hasCameraAuth else {
            LCPermissionHelper.requestCameraPermission { success in
                if success {
                    switchCamera(!isCameraOn)
                }
            }
            return
        }
        // 摄像头按钮内部未改变状态，需要在这里改变
        switchCamera(!isCameraOn)
    }
    
    public func controlBar(_ controlBar: LCVisualIntercomControlBar, switchMicrophone isMicrophoneOn: Bool) {
//        startTalk()
        // 更新状态
        if isMicrophoneOn {
            self.startSampleAudio()
        } else {
            self.stopSampleAudio()
            LCProgressHUD.showMsg("麦克风已关闭")
        }
        self.isMicrophoneOn = isMicrophoneOn
        self.updateControlBarContent()
    }
    
    
}
