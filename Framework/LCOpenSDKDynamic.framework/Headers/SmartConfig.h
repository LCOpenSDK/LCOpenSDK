//
//  SmartConfig.h
//  SmartConfig
//
//  Created by 绪亮文 on 2018/12/14.
//  Copyright © 2018 dahuatech. All rights reserved.
//

#ifndef __SMART_CONFIG_H__
#define __SMART_CONFIG_H__

#ifdef  __cplusplus
extern "C" {
#endif

typedef struct _CONFIG_INFO_{
    char deviceID[64];
    char ssid[64];
    char password[64];
    char security[64];
}CONFIG_INFO;

#define Config_Type_None        0
#define Config_Type_Multicast   1
#define Config_Type_Broadcast   2
#define Config_Type_Audio       4

/* 参数说明：
   cfgInfo：配网信息；
   cfgType：配网方式，1--组播，2--广播，4--声波，可按位或运算组合使用；
   voiceConfigFilePath：声波配对的音频文件的生成路径，由上层调用者传入；
   enableBgMusic：声波配对是否使用背景声，默认是布谷鸟叫声；
   freq：声波配对收发信号的基带频率；
   fsk_tx_mode：fsk发送方式，0--新的fsk发送方式，1--老的fsk发送方式，2--新的和老的fsk波形发送方式； */
int startConfig(CONFIG_INFO* cfgInfo, int cfgType, const char* voiceConfigFilePath, bool enableBgMusic, int freq, int fsk_tx_mode);
    
int stopConfig();
    
#ifdef __cplusplus
}
#endif
    
#endif /* __SMART_CONFIG_H__ */
