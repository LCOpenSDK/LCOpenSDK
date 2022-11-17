//
//  Copyright © 2015年 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <LCBaseModule/LCBaseViewController.h>
typedef void (^closeWebViewController)(void);

@class WKWebViewJavascriptBridge;
@interface LCWebViewController : LCBaseViewController<WKNavigationDelegate,WKUIDelegate>
{
    BOOL            _shouldRotate;
//    WKWebView*      _webView;
}
@property (strong, nonatomic) WKWebViewJavascriptBridge *bridge;
@property (strong, nonatomic) WKWebView *webView;

@property (nonatomic, copy) NSString *playUrl;

//是否导航栏使用H5的titile  默认YES
@property (nonatomic) BOOL isUseH5Title;
/**
 本地标题，如果设置了在一级网页显示本地的标题，二级网页加载网页的标题
 */
@property (nonatomic, copy) NSString *localTitle;

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) NSUInteger loadCount;

@property (nonatomic, copy) closeWebViewController closeBlock;

/// 是否启用左滑手势返回
@property (nonatomic, assign) BOOL disableNavigationGestures;

//是否需要展示错误页面
@property (nonatomic, assign) BOOL isShowErrorView;

-(void)setNavgationLeftItem:(BOOL)canGoBack;
/**
 关闭按钮点击

 @param btn UIButton
 */
- (void)onCloseButtonClick:(UIButton *)btn;
/**
 关闭返回点击
 
 @param btn UIButton
 */
- (void)onLeftNaviItemClick:(UIButton *)btn;

/**
 网页跳转时处理
 */
- (void)decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction;

@end
