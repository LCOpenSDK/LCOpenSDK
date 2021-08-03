/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 48717, Author: 31554, Date: 2016-12-20 15:44:00 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_GroupDeviceList_H_
#define _LC_OPENAPI_CLIENT_GroupDeviceList_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
分页获取该分组下面的设备列表

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class GroupDeviceListRequest : public LCOpenApiRequest
	{
	public:
		class GroupDeviceListRequestData
		{
		public:
			GroupDeviceListRequestData();
			~GroupDeviceListRequestData();
			
		public:
			/** 分页取值范围,一次最多获取50条，格式为1-30 */
			string queryRange;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]groupDeviceList */
			#define _STATIC_GroupDeviceListRequestData_method "groupDeviceList"
			string method;
		public:
			/** [long]分组id */
			int64 groupId;

		};
	public:
		GroupDeviceListRequest();
		~GroupDeviceListRequest();
	public:
		virtual int build();
	public:
		GroupDeviceListRequestData data;
	};

	
	typedef typename GroupDeviceListRequest::GroupDeviceListRequestData GroupDeviceListRequestData;


	class GroupDeviceListResponse : public LCOpenApiResponse
	{
	public:
		class GroupDeviceListResponseData
		{
		public:
			GroupDeviceListResponseData();
			~GroupDeviceListResponseData();
			
		public:
			/** define a list with struct of GroupDeviceListResponseData_DevicesElement */
			class GroupDeviceListResponseData_DevicesElement : public LCOpenApiBase
			{
			public:
				GroupDeviceListResponseData_DevicesElement();
				~GroupDeviceListResponseData_DevicesElement();
			public:
				/** define a list with struct of GroupDeviceListResponseData_DevicesElement_ChannelsElement */
				class GroupDeviceListResponseData_DevicesElement_ChannelsElement : public LCOpenApiBase
				{
				public:
					GroupDeviceListResponseData_DevicesElement_ChannelsElement();
					~GroupDeviceListResponseData_DevicesElement_ChannelsElement();
				public:
					/** [int]报警布撤防状态，0-撤防，1-布防 */
					int alarmStatus;
				public:
					/** [int]云存储状态：-1-未开通 0-已失效 1-使用中 2-套餐暂停 */
					int csStatus;
				public:
					/** [O]如果是分享或者授权过来的通道，填分享或者授权的功能列表（逗号隔开） */
					string functions;
				public:
					/** [bool][O]是否分享或者授权给别人的 */
					bool channelBeSharedTo;
				public:
					/** [int]SD卡状态：0-异常，1-正常，2-无SD卡，3-格式化中 */
					int sdcardState;
				public:
					/** 公开视频的token */
					string publicToken;
				public:
					/** [long][O]公开时间，UNIX时间戳（秒） */
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
					/** [O]通道能力项，逗号隔开，如AlarmMD,AudioTalk,AlarmPIR,WLAN,VVP2P，详见华视微讯设备协议 */
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
					/** [int][O]channelBeSharedTo为true时有效，0表示同时分享和授权给别人的设备，1表示分享给别人的设备，2表示授权给别人的设备 */
					int channelBeShareToState;
				};
			public:
				LCOpenApiVector<GroupDeviceListResponseData_DevicesElement_ChannelsElement> channels;
			public:
				/** [O]全景图URL */
				string panoUrl;
			public:
				/** 设备logo图片url */
				string logoUrl;
			public:
				/** [int][O]beSharedTo为true时有效，0表示同时分享和授权给别人的设备，1表示分享给别人的设备，2表示授权给别人的设备 */
				int beShareToState;
			public:
				/** [bool]是否有新版本可以升级 */
				bool canBeUpgrade;
			public:
				/** [int]当前状态：0-离线，1-在线，3-升级中 */
				int status;
			public:
				/** [bool][O]是否从别人那里分享或者授权的，分享者信息填在ownerInfo结构中 */
				bool beSharedFrom;
			public:
				/** [O]设备分类【NVR/DVR/HCVR/IPC/SD/IHG】 */
				string deviceCatalog;
			public:
				/** [O]访问设备的DMS入口地址，例如122.233.34.45:9200 */
				string dms;
			public:
				/** [O]分享者头像URL */
				string ownerUserIcon;
			public:
				/** [O]设备能力项，逗号隔开，如AlarmMD,AudioTalk,AlarmPIR,WLAN,VVP2P，详见华视微讯设备协议 */
				string ability;
			public:
				/** [O]设备型号 */
				string deviceModel;
			public:
				/** [O]分享者的昵称 */
				string ownerNickname;
			public:
				/** 设备ID */
				string deviceId;
			public:
				/** [int][O]1表示别人分享给自己的设备，2表示别人授权给自己的设备 */
				int shareState;
			public:
				/** [bool]是否在线 */
				bool online;
			public:
				/** 设备名称 */
				string name;
			public:
				/** [O]分享者的用户名 */
				string ownerUsername;
			public:
				/** [O]设备基线类型，详见华视微讯设备协议 */
				string baseline;
			public:
				/** [int]加密模式, 0表示默认加密模式, 1表示用户加密模式 */
				int encryptMode;
			public:
				/** [bool][O]是否分享或者授权给别人的 */
				bool beSharedTo;
			public:
				/** 设备软件版本号 */
				string version;
			};
		public:
			LCOpenApiVector<GroupDeviceListResponseData_DevicesElement> devices;

		};
	public:
		GroupDeviceListResponse();
		~GroupDeviceListResponse();
	public:
		virtual int parse();
	public:
		GroupDeviceListResponseData data;
	};

	
	typedef typename GroupDeviceListResponse::GroupDeviceListResponseData GroupDeviceListResponseData;
	typedef typename GroupDeviceListResponse::GroupDeviceListResponseData::GroupDeviceListResponseData_DevicesElement GroupDeviceListResponseData_DevicesElement;
	typedef typename GroupDeviceListResponse::GroupDeviceListResponseData::GroupDeviceListResponseData_DevicesElement::GroupDeviceListResponseData_DevicesElement_ChannelsElement GroupDeviceListResponseData_DevicesElement_ChannelsElement;

}
}

#endif
