//
//  Copyright (c) 2016年 LeChange. All rights reserved.
//
//  错误码汇总

/**************HTTP**************/

enum ErrorCodeHttp {
    //成功
    EC_HTTP_OK                  = 200,

    //API格式错误
    EC_HTTP_FORMAT              = 400,

    //用户名密码认证失败，无返回内容
    EC_HTTP_AUTH                = 401,

    //认证成功但无权限
    EC_HTTP_FORBIDDEN           = 403,

    //服务器无响应
    EC_HTTP_NOT_FOUND           = 404,

    //服务器内部错误
    EC_HTTP_INTERNAL_SERVER     = 500,

    //网关错误
    EC_HTTP_BAD_GATEWAY         = 502,

    //服务不可用，服务器暂停或者维护中
    EC_HTTP_SERVICE_UNAVAILABLE = 503
};

/**************自定义获取图片错误码**************/

enum ErrorCodeImage {
    //图片下载地址为空
    EC_IMAGE_URL_NONE          = 800,
    //下载失败
    EC_IMAGE_DOWNLOAD          = 801,
    //图片密码错误
    EC_IMAGE_ENCRYPT_KEY_WRONG = 802,
    //图片解密失败
    EC_IMAGE_ENCRYPT_FAIL      = 803,
    //图片不存在
    EC_IMAGE_NOT_EXISTED       = 804,
};

/**************云存储**************/

enum ErrorCodeCloud {
    //云存储录像未找到
    EC_CLOUD_RECORD_NOT_FOUND = 1621,
};

#pragma mark - SaaS
enum ErrorSaasRequestParamater {
    ///参数格式错误 【400】
    EC_SAAS_PARAM_ERROR_FORMAT = 11001,
};

/// 用户相关错误
enum ErrorSaasUser {
    ///手机号已存在
    EC_SAAS_USER_PHONE_EXISTED = 12003,

    ///用户没有权限
    EC_SAAS_USER_NO_AUTHORITY  = 12100,
};

enum ErrorSaasVerifyCode {
    //Todo::
    EC_SAAS_VERITYCODE_ERROR              = 15000,

    /// 无效的验证码（过期） 1151 验证码
    EC_SAAS_VERITYCODE_EXPIRED            = 15001,

    /// 15002 验证码请求已达上限 1150 验证码
    EC_SAAS_VERITYCODE_ERROR_TIMES_LIMIT  = 15002,

    /// 验证码请求过于频繁 1110 验证码
    EC_SAAS_VERITYCODE_REQUEST_FREQUENT   = 15003,

    /// 验证码发送失败 1103 验证码
    EC_SAAS_VERITYCODE_SEND_FAILD         = 15005,

    /// 验证码发送超过10次 1115 验证码
    EC_SAAS_VERITYCODE_REQUEST_OVER_TIMES = 15006,
};


/// SaaS设备相关错误码
enum ErrorSaasDevice {
    ///设备离线 1321 设备
    EC_SAAS_DEVICE_OFFLINE              = 51007,

    ///设备已被绑定失败10次
    EC_SAAS_DEVICE_BIND_ERROR_10_TIMES  = 51014,

    ///设备已被绑定失败20次
    EC_SAAS_DEVICE_BIND_ERROR_20_TIMES  = 51015,

    ///设备用户名或密码错误
    EC_SAAS_DEVICE_ERROR_USERNAMEORPWD  = 51025,

    ///设备已经被绑锁定
    EC_SAAS_DEVICE_IS_BINDEDLOCK        = 51042,

    ///设备IP不在同一局域网内
    EC_SAAS_DEVICE_BIND_NOT_IN_SAME_NET = 51044,

    ///设备无存储介质【设备本地录像】
    EC_SAAS_DEVICE_NO_LOCAL_STORAGE     = 51049,
};
