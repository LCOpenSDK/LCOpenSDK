//
//  Copyright (c) 2015年 Anson. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MMSHEETVIEW_DISMISS_NOTIFICATION @"MMSheetView_DISMISS_NOTIFICATION"


typedef NS_ENUM(NSInteger, LCSheetViewStyle) {
    LCSheetViewStyleDefault = 0,
    LCSheetViewSecureTextInput,
    LCSheetViewStylePlainTextInput
};

@class LCSheetView;
@protocol LCSheetViewDelegate <NSObject>
@optional

- (void)sheetView:(LCSheetView *)sheetView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)sheetViewCancel:(LCSheetView *)sheetView;
@end

/*!
 *  @author peng_kongan, 15-09-21 11:09:43
 *
 *  @brief  自定义抽屉弹出视图类  模仿UIAlertView
 *  协议实现了简单的两个常用的协议 以及常用的接口
 *  本类只支持一个文本框
 *
 *  使用须知：由于LCSheetView 是添加到KeyWindow中的  所以如果LCSheetView在显示之后 后台如果有push present操作 LCSheetView不会消失
 */

//其他定义
typedef void(^LCSheetViewCancleBlock)(void);
typedef void(^LCSheetViewClickedBlock)(NSInteger index);

@interface LCSheetView : UIView

@property (nonatomic,assign) LCSheetViewStyle sheetViewStyle;
@property (nonatomic,weak) id<LCSheetViewDelegate> delegate;

@property (nonatomic, copy) LCSheetViewCancleBlock cancleBlock;
@property (nonatomic, copy) LCSheetViewClickedBlock clickedBlock;

@property (nonatomic,copy,readonly) NSString *title;
@property (nonatomic,copy,readonly) NSString *message;
@property (strong, nonatomic) id userInfo;

/// 设置带属性的消息
@property (nonatomic, copy) NSAttributedString *attrMessage;

/// 显示按钮背景
@property (nonatomic, assign) BOOL showButtonBackground;


- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<MMSheetViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... ;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<MMSheetViewDelegate>*/)delegate cancelButton:(NSString *)cancelTitle otherButtons:(NSArray*)otherTitles;

- (void)show;
- (void)showAtView:(UIView *)view;
- (void)dismiss;

//*************************

/// 按钮背景颜色，在showButtonBackground为YES时生效
@property (strong, nonatomic)UIColor *buttonBgColor;
@property (strong, nonatomic)UIColor *separateLineColor;
@property (strong, nonatomic)UIColor *titleColor;
@property (strong, nonatomic)UIFont *titleFont;
@property (strong, nonatomic)UIFont *msgFont;
@property (strong, nonatomic)UIColor *msgColor;
@property (strong, nonatomic)UIColor *containerBgColor;
@property (strong, nonatomic)UIFont *btnFont;
@property (strong, nonatomic)UIColor *btnTitleColor;
@property (strong, nonatomic)UIColor *cancleTitleColor;

@property (nonatomic)CGFloat paddingTop;    //标题的上边距
@property (nonatomic)CGFloat paddingBetwennTiltAndMsg; //标题和消息的垂直间距
@property (nonatomic)CGFloat paddingMsgBottom;  //消息的下边距
@property (nonatomic)CGFloat paddingBetwennCancleAndOther; //取消按钮和其它按钮的间距
@property (nonatomic)CGFloat buttonPaddingTop; //按钮与上部的距离，在标题、消息都为空时有效，默认为0

///////////////////////////

/*!
 *  @author peng_kongan, 15-12-10 16:12:35
 *
 *  @brief  关掉所有已经显示的 MMSheetView
 */
+ (void)dismissAll;

/*!
 *  @author peng_kongan, 15-12-10 17:12:58
 *
 *  @brief  返回textUiew  因为只有一个UITextView  所以这里的textFieldIndex 暂时无用
 *
 *  @param textFieldIndex
 *
 *  @return
 */
- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;


/*!
 *  @author peng_kongan, 15-12-10 17:12:10
 *
 *  @brief  根据索引返回按钮 取消按钮索引为0 其它的依次排列
 *
 *  @param buttonIndex 按钮所以呢
 *
 *  @return 返回的按钮
 */
- (UIButton *)buttonAtIndex:(NSInteger)buttonIndex;
@end
