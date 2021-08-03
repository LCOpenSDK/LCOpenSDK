//
//  Copyright © 2019 dahua. All rights reserved.
//


#import "LCUIKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCAccountPresenter :LCBasicPresenter

/// AppID
@property (nonatomic, strong) NSString *appId;

/// AppScrect
@property (nonatomic, strong) NSString *appSecret;

/// HostAPI
@property (nonatomic, strong) NSString *hostApi;

/// 用户模式手机号
@property (nonatomic, strong) NSString *userEmail;

/// 注册验证码
@property (nonatomic, strong) NSString *verificationCode;

/// 是否免验证码
@property (nonatomic) BOOL isAvoidRegister;

//输入APPID页面确认按钮点击事件
- (void)accountJointClickAction:(LCButton *)sender;

// 子账户
- (void)subAccountBtnClick:(LCButton *)sender;

//选择对接模式页面点击事件
- (void)modeSelectBtnClick:(LCButton *)sender;

//用户注册页面点击事件
- (void)userModeRegisterBtnClick:(LCButton *)sender;

//用户登录页面点击事件
- (void)userModeLoginBtnClick:(LCButton *)sender;

///获取验证码
- (void)userModeRegisterGetSMSCode;

///保存子账号
- (void)saveSubAccount:(NSString *)account;

///加载保存的子账号
- (NSString *)loadSubAccount;

@end

NS_ASSUME_NONNULL_END
