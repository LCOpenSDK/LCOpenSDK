//
//  Copyright © 2015年 Imou. All rights reserved.
//

#import <LCBaseModule/LCWebViewController.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LCModule.h"
#import <MessageUI/MessageUI.h>
#import <LCBaseModule/LCModuleConfig.h>
#import <LCBaseModule/LCPubDefine.h>
#import <LCBaseModule/UIColor+LeChange.h>
#import <LCBaseModule/UIFont+Imou.h>
#import <LCBaseModule/UIDevice+LeChange.h>
#import <LCBaseModule/UINavigationItem+LeChange.h>
#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>
#import <Masonry/Masonry.h>

#define boundsWidth self.view.bounds.size.width
#define boundsHeight self.view.bounds.size.height

@interface LCWebViewController()<MFMailComposeViewControllerDelegate>
@property (strong, nonatomic)WKNavigation *backNavigation;
/**
 *  记录全部截屏视图
 */
@property (nonatomic,strong)NSMutableArray* snapShotsArray;

/**
 *  当前正在展示的截屏视图
 */
@property (nonatomic,strong)UIView* currentSnapShotView;

/**
 *  之前视图的截屏
 */
@property (nonatomic,strong)UIView* prevSnapShotView;

/**
 *  手势背景视图
 */
@property (nonatomic,strong)UIView* swipingBackgoundView;

/**
 *  右滑手势
 */
@property (nonatomic)UIPanGestureRecognizer* swipePanGesture;

/**
 *  是否正在滑动
 */
@property (nonatomic)BOOL isSwipingBack;
/**
 *  错误页面
 */
@property (nonatomic,strong)UIView* emptyView;

/**
 是否已经加载到H5页面
 */
@property (nonatomic,assign) BOOL hasLoadedH5Page;
@end

@implementation LCWebViewController

- (UIView *)emptyView {
    if(_emptyView == nil) {
        _emptyView = [self getEmptyViewByImage:[UIImage imageNamed:@"common_nullpic_faule"] title:@"loaded_net_failure_and_retry".lc_T];
    }
    return _emptyView;
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.isUseH5Title = YES;
        self.hasLoadedH5Page = false;
    }
    return self;
}

- (BOOL)shouldUseCustomBackButton
{
    return YES;
}

#pragma mark - Properties
- (void)setLocalTitle:(NSString *)localTitle
{
    _localTitle = localTitle;
    self.title = localTitle;
}

- (void)setPlayUrl:(NSString *)playUrl
{
    _playUrl = playUrl;
//    _playUrl = @"http://dvl.lechange.cn/lcview#/mycloud";
}

- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}

#pragma mark - ViewCycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lccolor_c43];
    _isShowErrorView = YES;
    
    _playUrl = [_playUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [WKWebViewJavascriptBridge enableLogging];
	
	//【*】设置视频自动内联播放
	WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
	if (@available(iOS 10.0, *)) {
		config.mediaTypesRequiringUserActionForPlayback = NO;
	}
	
	config.allowsInlineMediaPlayback = YES;
	
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:config];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    _webView.scrollView.bounces = NO;
	
	//禁止手势侧滑
//    [_webView addGestureRecognizer:self.swipePanGesture];
//    _webView.allowsBackForwardNavigationGestures = YES;
	
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView];
    [self.bridge setWebViewDelegate:self];
    [self.view addSubview: _webView];
    

    NSURL *URL = [NSURL URLWithString:_playUrl];
    
    if ([URL.scheme isEqualToString:@"file"]) {
        //本地文件 带file://
        URL = [self fileURLForBuggyWKWebView8:URL];
    } else {
        if ([_playUrl componentsSeparatedByString:@"?"].count <= 1) {
            NSString *url = [_playUrl stringByAppendingString:[NSString stringWithFormat:@"?random=%d", arc4random_uniform(10000)]];
            _playUrl = url;
            URL = [NSURL URLWithString:url];
        } else {
            NSString *url = [_playUrl stringByAppendingString:[NSString stringWithFormat:@"&random=%d", arc4random_uniform(10000)]];
            _playUrl = url;
            URL = [NSURL URLWithString:url];
        }
    }
    
    NSLog(@"URL : %@", URL);
	
	//【*】缓存策略：
	NSURLRequestCachePolicy cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:cachePolicy timeoutInterval:10.0];
    NSLog(@"28614-*-* cachePolicy:%lu",(unsigned long)request.cachePolicy );
    NSLog(@"28614-*-* allHTTPHeaderFields: %@", request.allHTTPHeaderFields);
    
    [_webView loadRequest:request];
    _shouldRotate = NO;
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
    self.progressView.backgroundColor = [UIColor clearColor];
    self.progressView.trackTintColor = [UIColor clearColor];
	self.progressView.progressTintColor = [UIColor lccolor_c0];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    //self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    // Do any additional setup after loading the view.
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerWillExitFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillExitFullscreen) name:UIWindowDidBecomeHiddenNotification object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (self.hasLoadedH5Page == false) {
        [self.webView reload];
    }
    //[self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[_progressView removeFromSuperview];
    
    [self.webView evaluateJavaScript:@"document.title"  completionHandler:^(NSString* response, NSError * _Nullable error) {
        NSLog(@"-----------viewWillDisappear H5 title is %@",response);
        if (response.length != 0) {
            self.hasLoadedH5Page = true;
        }
    }];
}

-(void)setNavgationLeftItem:(BOOL)canGoBack
{
    if (canGoBack)
    {
        //返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 30, 30);
        [backButton setImage:[UIImage imageNamed:@"common_icon_nav_back"] forState:UIControlStateNormal];
//        [backButton setImage:[UIImage imageNamed:@"nav_icon_back_click"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(onLeftNaviItemClick:) forControlEvents:UIControlEventTouchUpInside];
        //取消按钮
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(0, 0, 40, 40);
        [closeButton setImage:[UIImage imageNamed:@"common_image_nav_cancel"] forState:UIControlStateNormal];
        [closeButton setImage:[UIImage imageNamed:@"common_image_nav_cancel"] forState:UIControlStateHighlighted];
        [closeButton addTarget:self action:@selector(onCloseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.lc_leftBarButtons = @[backButton,closeButton];
    }
    else
    {
        [self initLeftNavigationItem];
    }
}

- (void)onCloseButtonClick:(UIButton *)btn
{
    if (self.closeBlock) {
        self.closeBlock();
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onLeftNaviItemClick:(UIButton *)btn
{
    if ([_webView canGoBack]) {
        [_webView endEditing:YES];
        self.backNavigation = [_webView goBack];;
    } else {
        if (self.closeBlock) {
            self.closeBlock();
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        
    } else if ([keyPath isEqualToString:@"title"]) {
        [_webView evaluateJavaScript:@"document.title"  completionHandler:^(NSString* response, NSError * _Nullable error) {

            if(response.length!=0 && self.isUseH5Title) {
                self.title = response;
            }
        }];
        
    } else if ([keyPath isEqualToString:@"URL"])
    {
//        NSLog(@"url == %@",self.webView.URL.absoluteString);
//        [self setNavgationLeftItem:self.webView.canGoBack];
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = _webView.estimatedProgress;
    } else if ([keyPath isEqualToString:@"canGoBack"]) {
        
        [self setNavgationLeftItem:[[change objectForKey:NSKeyValueChangeNewKey] boolValue]];
    }
   
    if (object == _webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"URL"];
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView removeObserver:self forKeyPath:@"canGoBack"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playerWillExitFullScreen
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resetShouldRotate) object:nil];
    [self performSelector:@selector(resetShouldRotate) withObject:nil afterDelay:0.5];
}

- (void)moviePlayerWillExitFullscreen
{
    [self performSelector:@selector(adjustStateBarAndNavigationBar) withObject:nil afterDelay:0.1];
}

- (void)adjustStateBarAndNavigationBar
{
    if (self.isTopController) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}

- (void)resetShouldRotate
{
    _shouldRotate = YES;
    [UIDevice lc_setOrientation:UIInterfaceOrientationPortrait];
    _shouldRotate = NO;
}

- (BOOL)shouldAutorotate
{
    return _shouldRotate;
}


- (void)videoDidRotate {
    [self performSelector:@selector(resetNavbarFrame) withObject:nil afterDelay:0.1];
}

- (void)resetNavbarFrame {
    
    CGRect windowFrame = [UIScreen mainScreen].applicationFrame;
    CGFloat statusBarH = (LC_IS_IPHONEX ? 44.0 : 20.0);
    CGFloat navBarH = self.navBar.frame.size.height;
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        self.navBar.frame = CGRectMake(0.0, statusBarH, windowFrame.size.width, navBarH);
        self.view.frame = CGRectMake(0.0, self.navBar.frame.origin.y + self.navBar.frame.size.height, LC_SCREEN_SIZE_WIDTH, LC_SCREEN_SIZE_HEIGHT - statusBarH - navBarH);
    }
}

#pragma mark - custom methods
- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    NSString *desPath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"www"] stringByAppendingPathComponent:fileURL.lastPathComponent];
        
    return [NSURL fileURLWithPath:desPath];
    
}

#pragma mark -
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
{
    NSLog(@"28614 didReceiveServerRedirectForProvisionalNavigation");
    
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    if ([self.backNavigation isEqual:navigation]) {
        // 这次的加载是点击返回产生的，刷新
        [webView reload];
        self.backNavigation = nil;
        
        [self setNavgationLeftItem:webView.canGoBack];
    }
    
    if (![webView canGoBack] && self.localTitle.length > 0) {
        return;
    }

	//【*】webview 长按及复制功能
//    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';"  completionHandler:^(NSString* response, NSError * _Nullable error) {
//
//    }];
//     [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';"  completionHandler:^(NSString* response, NSError * _Nullable error) {
//
//    }];
	
    //加载完成,如果当前导航栏无标题,根据url网页获取标题
    [webView evaluateJavaScript:@"document.title"  completionHandler:^(NSString* response, NSError * _Nullable error) {

        if(response.length!=0 && self.isUseH5Title)
        {
            self.title = response;
        }
    }];
    
    [self setNavgationLeftItem:webView.canGoBack];
    NSLog(@"-------------------- webProgress: finished");
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.loadCount ++;
    NSLog(@"28614 didStartProvisionalNavigation");
}

// 内容返回时
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.loadCount --;
    NSLog(@"28614 didCommitNavigation");
}
//失败
- (void)webView:(WKWebView *)webView didFailNavigation: (null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.loadCount --;
    NSLog(@"28614 didFailNavigation : %@",error);
    if (_isShowErrorView == YES) {
        [self.view addSubview:self.emptyView];
    }
    _isShowErrorView = YES;
}
//失败回调(上面的失败不会回调)
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"28614 didFailProvisionalNavigation : %@",error);
    if (_isShowErrorView == YES) {
        [self.view addSubview:self.emptyView];
    }
    _isShowErrorView = YES;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"28614-*-* decidePolicyForNavigationResponse");
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    
    NSDictionary *headers = response.allHeaderFields;
    NSLog(@"28614-*-* url :%@", response.URL.relativeString);
    NSLog(@"28614-*-* statue code: %ld", (long)response.statusCode);
    NSLog(@"28614-*-* headers %@", headers);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"28614 decidePolicyForNavigationAction");

    NSURLRequest *req = navigationAction.request;
    NSLog(@"28614-*-* url :%@", req.URL.relativeString);
    NSLog(@"28614-*-* headers %@", req.allHTTPHeaderFields);
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    NSURL *URL = navigationAction.request.URL;
    NSLog(@"28614 : %@", URL);
   
    NSString *scheme = [URL scheme];
    
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        decisionHandler(WKNavigationActionPolicyCancel);
        return ;
    }
    
    //加入唤醒邮件功能
    if([scheme isEqualToString:@"mailto"]){
        [self sendEmai:URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return ;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}
    
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"common_hint".lc_T message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"common_confirm".lc_T style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
    
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"common_hint".lc_T message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"common_cancel".lc_T style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"common_confirm".lc_T style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
    
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"common_complete".lc_T style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


#pragma mark - Gesture Recognizer
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    return !self.disableNavigationGestures;
}

#pragma mark - wwebView功能性扩展
- (void)sendEmai:(NSURL *)url{
    
    if (NO == [MFMailComposeViewController canSendMail]) {
        [UIApplication.sharedApplication openURL:url];
      
    }
    else{
        //
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        NSString *email = [url.relativeString stringByReplacingOccurrencesOfString:@"mailto:" withString:@""];
        NSArray *toRecipients = [NSArray arrayWithObject:email];
        [picker setToRecipients:toRecipients];
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"邮件发送取消");  // 邮件发送取消
            break;
        case MFMailComposeResultSaved:
            NSLog(@"邮件保存成功");  // 邮件保存成功
            break;
        case MFMailComposeResultSent:
            NSLog(@"邮件发送成功");  // 邮件发送成功
            break;
        case MFMailComposeResultFailed:
            NSLog(@"邮件发送失败");  // 邮件发送失败
            break;
        default:
            NSLog(@"邮件未发送");
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 属性
-(NSMutableArray*)snapShotsArray{
    if (!_snapShotsArray) {
        _snapShotsArray = [NSMutableArray array];
    }
    return _snapShotsArray;
}

/**
 滑动手势
 */
-(UIPanGestureRecognizer*)swipePanGesture {
    if (!_swipePanGesture) {
        _swipePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipePanGestureHandler:)];
    }
    return _swipePanGesture;
}
-(UIView*)swipingBackgoundView {
    if (!_swipingBackgoundView) {
        _swipingBackgoundView = [[UIView alloc] initWithFrame:self.view.bounds];
        _swipingBackgoundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _swipingBackgoundView;
}
#pragma mark - 截取屏幕快照

-(void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request {
    //    NSLog(@"push with request %@",request);
    NSURLRequest* lastRequest = (NSURLRequest*)[[self.snapShotsArray lastObject] objectForKey:@"request"];
    
    //如果url是很奇怪的就不push
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        //        NSLog(@"about blank!! return");
        return;
    }
    //如果url一样就不进行push
    if ([lastRequest.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
        return;
    }
    
    
    UIView* currentSnapShotView = [self.webView snapshotViewAfterScreenUpdates:YES];
    if(request!=nil && currentSnapShotView!=nil){
        [self.snapShotsArray addObject:
         @{
           @"request":request,
           @"snapShotView":currentSnapShotView
           }
         ];
    }
    
}
-(void)startPopSnapshotView{
    if (self.isSwipingBack) {
        return;
    }
    if (!self.webView.canGoBack) {
        return;
    }
    self.isSwipingBack = YES;
    //create a center of scrren
    CGPoint center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    
    self.currentSnapShotView = [self.webView snapshotViewAfterScreenUpdates:YES];
    
    //add shadows just like UINavigationController
    self.currentSnapShotView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.currentSnapShotView.layer.shadowOffset = CGSizeMake(3, 3);
    self.currentSnapShotView.layer.shadowRadius = 5;
    self.currentSnapShotView.layer.shadowOpacity = 0.75;
    
    //move to center of screen
    self.currentSnapShotView.center = center;
    
    self.prevSnapShotView = (UIView*)[[self.snapShotsArray lastObject] objectForKey:@"snapShotView"];
    center.x -= 60;
    self.prevSnapShotView.center = center;
    self.prevSnapShotView.alpha = 1;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.prevSnapShotView];
    [self.view addSubview:self.swipingBackgoundView];
    [self.view addSubview:self.currentSnapShotView];
}

-(void)popSnapShotViewWithPanGestureDistance:(CGFloat)distance{
    if (!self.isSwipingBack) {
        return;
    }
    
    if (distance <= 0) {
        return;
    }
    
    CGPoint currentSnapshotViewCenter = CGPointMake(boundsWidth/2, boundsHeight/2);
    currentSnapshotViewCenter.x += distance;
    CGPoint prevSnapshotViewCenter = CGPointMake(boundsWidth/2, boundsHeight/2);
    prevSnapshotViewCenter.x -= (boundsWidth - distance)*60/boundsWidth;
    //    NSLog(@"prev center x%f",prevSnapshotViewCenter.x);
    
    self.currentSnapShotView.center = currentSnapshotViewCenter;
    self.prevSnapShotView.center = prevSnapshotViewCenter;
    self.swipingBackgoundView.alpha = (boundsWidth - distance)/boundsWidth;
}

-(void)endPopSnapShotView{
    if (!self.isSwipingBack) {
        return;
    }
    
    //prevent the user touch for now
    self.view.userInteractionEnabled = NO;
    
    if (self.currentSnapShotView.center.x >= boundsWidth) {
        [self.webView goBack];
        // pop success
        [UIView animateWithDuration:0.2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            self.currentSnapShotView.center = CGPointMake(boundsWidth*3/2, boundsHeight/2);
            self.prevSnapShotView.center = CGPointMake(boundsWidth/2, boundsHeight/2);
            self.swipingBackgoundView.alpha = 0;
        }completion:^(BOOL finished) {
            [self.prevSnapShotView removeFromSuperview];
            [self.swipingBackgoundView removeFromSuperview];
            [self.currentSnapShotView removeFromSuperview];
            
            [self.snapShotsArray removeLastObject];
            self.view.userInteractionEnabled = YES;
            
            self.isSwipingBack = NO;
        }];
    }else{
        //pop fail
        [UIView animateWithDuration:0.2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            self.currentSnapShotView.center = CGPointMake(boundsWidth/2, boundsHeight/2);
            self.prevSnapShotView.center = CGPointMake(boundsWidth/2-60, boundsHeight/2);
            self.prevSnapShotView.alpha = 1;
        }completion:^(BOOL finished) {
            [self.prevSnapShotView removeFromSuperview];
            [self.swipingBackgoundView removeFromSuperview];
            [self.currentSnapShotView removeFromSuperview];
            self.view.userInteractionEnabled = YES;
            
            self.isSwipingBack = NO;
        }];
    }
}
#pragma mark - 手势方法
-(void)swipePanGestureHandler:(UIPanGestureRecognizer*)panGesture{
    CGPoint translation = [panGesture translationInView:self.webView];
    CGPoint location = [panGesture locationInView:self.webView];
    //    NSLog(@"pan x %f,pan y %f",translation.x,translation.y);
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        if (location.x <= 50 && translation.x > 0) {  //开始动画
            [self startPopSnapshotView];
        }
    }else if (panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateEnded){
        [self endPopSnapShotView];
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        [self popSnapShotViewWithPanGestureDistance:translation.x];
    }
}
- (void)decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
{
    NSLog(@"点击跳转----%@",navigationAction.request.URL.absoluteString);
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated:
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        case WKNavigationTypeFormSubmitted:
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        case WKNavigationTypeOther:
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        case WKNavigationTypeBackForward:
            break;
        case WKNavigationTypeReload:
            break;
        case WKNavigationTypeFormResubmitted:
            break;
        default:
            break;
    }
}

#pragma mark - 错误页面
- (UIView *)getEmptyViewByImage:(UIImage *)image title:(NSString *)title
{
    UIView *emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    UIImage *emptyImage = image;
    UIImageView *emptyImageView = [[UIImageView alloc]initWithImage:emptyImage];
    [emptyView addSubview:emptyImageView];
    
    [emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyView).offset(emptyImage.size.height/6).multipliedBy(2.0/3.0);
        make.width.mas_equalTo(emptyImage.size.width);
        make.height.mas_equalTo(emptyImage.size.height);
        make.centerX.equalTo(emptyView);
    }];
    
    UILabel *wordLbl = [[UILabel alloc]initWithFrame:CGRectZero];
    wordLbl.tag = 100;
    wordLbl.textColor = [UIColor lccolor_c2];
    wordLbl.textAlignment = NSTextAlignmentCenter;
    wordLbl.font = [UIFont lcFont_t4];
    wordLbl.numberOfLines = 0;
    wordLbl.lineBreakMode = NSLineBreakByWordWrapping;
    wordLbl.text = title;
    [emptyView addSubview:wordLbl];
    
    [wordLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emptyImageView.mas_bottom).offset(6.0);
        make.centerX.equalTo(emptyView);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = emptyView.bounds;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [emptyView addSubview:button];
    
    return emptyView;
}

- (void)buttonClicked:(UIButton *)button
{
    [self.emptyView removeFromSuperview];
    
    // 重新加载
    NSURL *URL = [NSURL URLWithString:_playUrl];
    NSLog(@"28614 : %@", URL);
    
    //【*】缓存策略：由于海外前端的原因，使用NSURLRequestUseProtocolCachePolicy会导致页面加载不正确
    NSURLRequestCachePolicy cachePolicy = [LCModuleConfig shareInstance].isChinaMainland ? NSURLRequestUseProtocolCachePolicy : NSURLRequestReloadIgnoringLocalCacheData;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:cachePolicy timeoutInterval:10.0];
    NSLog(@"28614-*-* cachePolicy:%lu",(unsigned long)request.cachePolicy );
    NSLog(@"28614-*-* allHTTPHeaderFields: %@", request.allHTTPHeaderFields);
    
    [_webView loadRequest:request];
}

@end

