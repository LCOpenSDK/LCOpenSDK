/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_UnGroupDeviceList_H_
#define _LC_OPENAPI_CLIENT_UnGroupDeviceList_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
分页获取返回所有未分组的设备，包括绑定、共享和授权的设备
 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class UnGroupDeviceListRequest : public LCOpenApiRequest
	{
	public:
		class UnGroupDeviceListRequestData
		{
		public:
			UnGroupDeviceListRequestData();
			~UnGroupDeviceListRequestData();
			
		public:
			/** 分页取值范围，一次最多获取50条，格式为“1-30” */
			string queryRange;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]unGroupDeviceList */
			#define _STATIC_UnGroupDeviceListRequestData_method "unGroupDeviceList"
			string method;

		};
	public:
		UnGroupDeviceListRequest();
		~UnGroupDeviceListRequest();
	public:
		virtual int build();
	public:
		UnGroupDeviceListRequestData data;
	};

	
	typedef typename UnGroupDeviceListRequest::UnGroupDeviceListRequestData UnGroupDeviceListRequestData;


	class UnGroupDeviceListResponse : public LCOpenApiResponse
	{
	public:
		class UnGroupDeviceListResponseData
		{
		public:
			UnGroupDeviceListResponseData();
			~UnGroupDeviceListResponseData();
			
		public:
			/** define a list with struct of UnGroupDeviceListResponseData_DevicesElement */
			class UnGroupDeviceListResponseData_DevicesElement : public LCOpenApiBase
			{
			public:
				UnGroupDeviceListResponseData_DevicesElement();
				~UnGroupDeviceListResponseData_DevicesElement();
			public:
				/** 访问设备的DMS入口地址，例如122.233.34.45:9200 */
				string dms;
			public:
				/** 设备基线类型，详见华视微讯设备协议 */
				string baseline;
			public:
				/** [int]加密模式, 0表示默认加密模式, 1表示用户加密模式 */
				int encryptMode;
			public:
				/** define a list with struct of UnGroupDeviceListResponseData_DevicesElement_ChannelsElement */
				class UnGroupDeviceListResponseData_DevicesElement_ChannelsElement : public LCOpenApiBase
				{
				public:
					UnGroupDeviceListResponseData_DevicesElement_ChannelsElement();
					~UnGroupDeviceListResponseData_DevicesElement_ChannelsElement();
				public:
					/** [int]报警布撤防状态，0-撤防，1-布防 */
					int alarmStatus;
				public:
					/** [int]云存储状态：-1-未开通 0-已失效 1-使用中 2-套餐暂停 */
					int csStatus;
				public:
					/** 如果是分享或者授权过来的通道，填分享或者授权的功能列表（逗号隔开） */
					string functions;
				public:
					/** [bool]是否分享或者授权给别人的 */
					bool channelBeSharedTo;
				public:
					/** [int]SD卡状态：0-异常，1-正常，2-无SD卡，3-格式化中 */
					int sdcardState;
				public:
					/** 公开视频的token */
					string publicToken;
				public:
					/** [long]公开时间，UNIX时间戳（秒） */
					int64 shareTime;
				public:
					/** [int]提醒状态，0-不提醒，1-提醒 */
					int remindStatus;
				public:
					/** 通道名称 */
					string channelName;
				public:
					/** [long]公开到期时间，UNIX时间戳，单位秒。为0表示设置为非公共视频。 */
					int64 publicExpire;
				public:
					/** 通道能力项，逗号隔开，如AlarmMD,AudioTalk,AlarmPIR,WLAN,VVP2P，详见华视微讯设备协议 */
					string channelAbility;
				public:
					/** 缩略图URL */
					string channelPicUrl;
				public:
					/** [int]通道号 */
					int channelId;
				public:
					/** [bool]是否在线 */
					bool channelOnline;
				public:
					/** [int]channelBeSharedTo为true时有效，0表示同时分享和授权给别人的设备，1表示分享给别人的设备，2表示授权给别人的设备 */
					int channelBeShareToState;
				};
			public:
				LCOpenApiVector<UnGroupDeviceListResponseData_DevicesElement_ChannelsElement> channels;
			public:
				/** 设备型号 */
				string deviceModel;
			public:
				/** [int]beSharedTo为true时有效，0表示同时分享和授权给别人的设备，1表示分享给别人的设备，2表示授权给别人的设备 */
				int beShareToState;
			public:
				/** [bool]是否分享或者授权给别人的 */
				bool beSharedTo;
			public:
				/** 设备ID */
				string deviceId;
			public:
				/** [bool]是否有新版本可以升级 */
				bool canBeUpgrade;
			public:
				/** [bool]是否在线 */
				bool online;
			public:
				/** 设备软件版本号 */
				string version;
			public:
				/** 设备能力项，逗号隔开，如AlarmMD,AudioTalk,AlarmPIR,WLAN,VVP2P，详见华视微讯设备协议 */
				string ability;
			public:
				/** [int]当前状态：0-离线，1-在线，3-升级中 */
				int status;
			public:
				/** [bool]是否从别人那里分享或者授权的，分享者信息填在ownerInfo结构中 */
				bool beSharedFrom;
			public:
				/** 设备分类【NVR/DVR/HCVR/IPC/SD/IHG】 */
				string deviceCatalog;
			public:
				/** 设备名称 */
				string name;
			};
		public:
			LCOpenApiVector<UnGroupDeviceListResponseData_DevicesElement> devices;

		};
	public:
		UnGroupDeviceListResponse();
		~UnGroupDeviceListResponse();
	public:
		virtual int parse();
	public:
		UnGroupDeviceListResponseData data;
	};

	
	typedef typename UnGroupDeviceListResponse::UnGroupDeviceListResponseData UnGroupDeviceListResponseData;
	typedef typename UnGroupDeviceListResponse::UnGroupDeviceListResponseData::UnGroupDeviceListResponseData_DevicesElement UnGroupDeviceListResponseData_DevicesElement;
	typedef typename UnGroupDeviceListResponse::UnGroupDeviceListResponseData::UnGroupDeviceListResponseData_DevicesElement::UnGroupDeviceListResponseData_DevicesElement_ChannelsElement UnGroupDeviceListResponseData_DevicesElement_ChannelsElement;

}
}

#endif
