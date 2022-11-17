//
//  Copyright © 2017 lechange. All rights reserved.LANGUAGE_TXT
//

#ifndef LCOpenSDK_Prefix_pch
#define LCOpenSDK_Prefix_pch

// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.
#import <UIKit/UIKit.h>
#import <LCMediaBaseModule/UIImage+MediaBaseModule.h>

// Wifi
#define AddDevice_Wifi_Png @"adddevice_icon_wifi.png"
#define AddDevice_Wired_Png @"adddevice_icon_wired.png"
#define AddDevice_SoftAp_Png @"adddevice_icon_softap.png"

// Common png
#define Back_Btn_Png @"common_btn_back.png"
#define DefaultCover_Png @"common_defaultcover.png"
#define Reind_Icon_Png @"common_icon_remind.png"
#define Search_Icon_Png @"common_icon_search.png"
#define Toast_Png @"common_toast_bg.png"

// User
#define Admin_Png @"icon_admin.png"
#define User_Png @"icon_user.png"
#define AddDevice_Png @"list_icon_adddevice.png"
#define CloudVideo_Png @"list_icon_cloudvideo.png"
#define LiveVideo_Png @"list_icon_livevideo.png"
#define Message_Png @"list_icon_message.png"
#define Offline_Png @"list_icon_offline.png"
#define Setting_Png @"list_icon_setting.png"
#define Trash_Png @"list_icon_trash.png"
#define Video_Png @"list_icon_video.png"
#define Replay_Btn_Png @"videotape_icon_replay.png"
#define LiveVideo_Screenshot_Click_Png @"livevideo_icon_screenshot_click.png"
#define LiveVideo_Screenshot_Nor_Png @"livevideo_icon_screenshot_nor.png"
#define LiveVideo_Speak_Click_Png @"livevideo_icon_speak_click.png"
#define LiveVideo_Speak_Nor_Png @"livevideo_icon_speak_nor.png"
#define LiveVideo_Click_Png @"livevideo_icon_video_click.png"
#define LiveVideo_Nor_Png @"livevideo_icon_video_nor.png"
#define LocalVideo_Defaultpage_Png @"localvideo_defaultpage.png"
#define Message_None_Png @"message_icon_nomessage.png"
#define Message_Trash_Png @"message_icon_trash.png"
#define Start_Png @"start_bg.png"
#define Video_Download_Png @"video_download.png"
#define Video_Download_Cancel_Png @"video_download_cancel.png"
#define Video_Fluent_Png @"video_fluent.png"
#define Video_Fullscreen @"video_fullscreen.png"
#define Video_HD_Png @"video_hd.png"
#define Video_None_Png @"video_icon_novideo.png"
#define Video_Smallscreen @"video_smallscreen.png"
#define Video_SoundOff_Png @"video_sound_off.png"
#define Video_SoundOn_Png @"video_sound_on.png"
#define Video_PTZ_Off_Png @"video_yuntai_off.png"
#define Video_PTZ_On_Png @"video_yuntai_on.png"
#define VideoPlay_FullScreen_Png @"videoplay_icon_fullscreen.png"
#define VideoPlay_SmallScreen_Png @"videoplay_icon_smallscreen.png"
#define VideoPlay_Pause_Png @"videoplay_icon_pause.png"
#define VideoPlay_Play_Png @"videoplay_icon_play.png"

#define Admin_Info_Path @"lechange/openSDK/adminAccount.txt"
#define User_Info_Path @"lechange/openSDK/userAccount.txt"


#define LANGUAGE_TXT @"LANGUAGE"
#define SECOND_TXT @"SECOND"
#define NETWORK_TIMEOUT_TXT @"NETWORK_TIMEOUT"
#define REST_LINK_FAILED_TXT @"REST_LINK_FAILED"

/*HintView*/
#define HINT_TITLE_TXT @"HINT_TITLE"

/*Download*/
#define CANCEL_DOWNLOAD_TXT @"CANCEL_DOWNLOAD"
#define DOWNLOADING_TXT @"DOWNLOADING"
#define DOWNLOAD_SUCCESS_TXT @"DOWNLOAD_SUCCESS"
#define DOWNLOAD_FAILED_TXT @"DOWNLOAD_FAILED"

/*StartView*/
#define CONFIG_TIP_TXT @"CONFIG_TIP"


/*AdminModelView*/
#define ADMIN_TITLE_TXT @"ADMIN_TITLE"
#define ADMIN_PHONE_TIP_TXT @"ADMIN_PHONE_TIP"
#define ADMIN_PHONE_HINT_TXT @"ADMIN_PHONE_HINT"
#define ACCESSTOKEN_TIP_TXT @"ACCESSTOKEN_TIP"
#define ENTER_DEVICE_LIST_TXT @"ENTER_DEVICE_LIST"

/*DeviceView*/
#define DEVICE_TITLE_TXT @"DEVICE_TITLE"
#define ENTER_ENCRYPTED_KEY_TXT @"ENTER_ENCRYPTED_KEY"

/*AddDeviceView*/
#define ADD_DEVICE_TITLE_TXT @"ADD_DEVICE_TITLE"
#define DEVICE_ID_TXT @"DEVICE_ID_LABEL"
#define DEVICE_KEY_TXT @"DEVICE_KEY_LABEL"
#define WIF_SSID_TXT @"WIFI_SSID_LABEL"
#define DEVICE_ID_TIP_TXT @"DEVICE_ID_TIP"
#define DEVICE_KEY_TIP_TXT @"DEVICE_KEY_TIP"
#define WIFI_PASSWORD_TIP_TXT @"WIFI_PASSWORD_TIP"
#define READY_BIND_TXT @"READY_BIND"
#define BIND_SUCCESS_TXT @"BIND_SUCCESS"
#define INSTRUCTION_TIP_TXT @"INSTRUCTION_TIP"
#define START_LINK_NETWORK_TXT @"START_LINK_NETWORK"
#define WAIT_TIME_TXT @"WAIT_TIME"
#define DEVICE_OFFLINE_TXT @"DEVICE_OFFLINE"
#define DEVICE_SCCODE_TXT @"DEVICE_SCCODE"

/*DeviceOperationView*/
#define DEVICE_OPERATE_TITLE_TXT @"DEVICE_OPERATE_TITLE"
#define ALARM_PLAN_TXT @"ALARM_PLAN"
#define CLOUD_STORAGE_TXT @"CLOUD_STORAGE"
#define PASSWORD_TXT @"PASSWORD"
#define DEVICE_PROGRAME_TXT @"DEVICE_PROGRAME"
#define MODIFY_TXT @"MODIFY"
#define UPGRADE_TXT @"UPGRADE"
/*LiveVideoView*/
#define LIVE_VIDEO_TITLE_TXT @"LIVE_VIDEO_TITLE"

/*MessageView*/
#define MESSAGE_TITLE_TXT @"MESSAGE_TITLE"
#define ALARM_TIME_TXT @"ALARM_TIME"

/*RecordView*/
#define LOCAL_RECORD_TITLE_TXT @"LOCAL_RECORD_TITLE"
#define NET_RECORD_TITLE_TXT @"NET_RECORD_TITLE"
#define DATE_CANCEL_TXT @"DATE_CANCEL"
#define DATE_QUERY_TXT @"DATE_QUERY"
#define DATE_TIP_TXT @"DATE_TIP"

/*RecordPlayView*/
#define RECORD_PLAY_TITLE_TXT @"RECORD_PLAY_TITLE"

#endif /* LCOpenSDK_Prefix_pch */
