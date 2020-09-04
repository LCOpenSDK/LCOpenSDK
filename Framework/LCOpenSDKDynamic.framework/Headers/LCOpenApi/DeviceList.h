/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 103366, Author: 32725, Date: 2018-07-18 10:43:06 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_DeviceList_H_
#define _LC_OPENAPI_CLIENT_DeviceList_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
设备列表获取
只返回在该应用下添加的设备列表,openapi层会做下过滤

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class DeviceListRequest : public LCOpenApiRequest
	{
	public:
		class DeviceListRequestData
		{
		public:
			DeviceListRequestData();
			~DeviceListRequestData();
			
		public:
			/** 第几条到第几条,数字取值范围为：[1,N](N为正整数，且后者＞前者),单次查询上限100 */
			string queryRange;
		public:
			/** [cstr]deviceList */
			#define _STATIC_DeviceListRequestData_method "deviceList"
			string method;
		public:
			/** 授权token(userToken或accessToken) */
			string token;

		};
	public:
		DeviceListRequest();
		~DeviceListRequest();
	public:
		virtual int build();
	public:
		DeviceListRequestData data;
	};

	
	typedef typename DeviceListRequest::DeviceListRequestData DeviceListRequestData;


	class DeviceListResponse : public LCOpenApiResponse
	{
	public:
		class DeviceListResponseData
		{
		public:
			DeviceListResponseData();
			~DeviceListResponseData();
			
		public:
			/** [int]当前获取的设备总数 */
			int count;
		public:
			/** define a list with struct of DeviceListResponseData_DevicesElement */
			class DeviceListResponseData_DevicesElement : public LCOpenApiBase
			{
			public:
				DeviceListResponseData_DevicesElement();
				~DeviceListResponseData_DevicesElement();
			public:
				/** 设备品牌信息：lechange-乐橙设备，general-通用设备 */
				string brand;
			public:
				/** [int]平台类型 */
				int platForm;
			public:
				/** define a list with struct of DeviceListResponseData_DevicesElement_ChannelsElement */
				class DeviceListResponseData_DevicesElement_ChannelsElement : public LCOpenApiBase
				{
				public:
					DeviceListResponseData_DevicesElement_ChannelsElement();
					~DeviceListResponseData_DevicesElement_ChannelsElement();
				public:
					/** 通道名称 */
					string channelName;
				public:
					/** [bool]是否分享给别人的,true表示分享给了别人,false表示未分享给别人 */
					bool shareStatus;
				public:
					/** 通道能力项，逗号隔开，如AlarmMD,AudioTalk,AlarmPIR,WLAN,VVP2P，详见乐橙设备协议 */
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
					/** [int]云存储状态：-1-未开通 0-已失效 1-使用中 2-套餐暂停 */
					int csStatus;
				};
			public:
				LCOpenApiVector<DeviceListResponseData_DevicesElement_ChannelsElement> channels;
			public:
				/** [int]p2p拉流端口 */
				int streamPort;
			public:
				/** [bool]是否有新版本可以升级 */
				bool canBeUpgrade;
			public:
				/** [int]当前状态：0-离线，1-在线，3-升级中 */
				int status;
			public:
				/** 设备登陆密码 */
				string devLoginPassword;
			public:
				/** 设备分类（NVR/DVR/HCVR/IPC/SD/IHG/ARC) */
				string deviceCatalog;
			public:
				/** 设备基线类型，详见华视微讯设备协议 */
				string baseline;
			public:
				/** 绑定设备的appId（若为乐橙App绑定，该字段为空字符串） */
				string appId;
			public:
				/** [O]设备能力项，逗号隔开，如AlarmMD,AudioTalk,AlarmPIR,WLAN,VVP2P，详见乐橙开放平台设备协议 */
				string ability;
			public:
				/** 设备ID */
				string deviceId;
			public:
				/** [int]总的视频通道数，包含未接入的通道 */
				int channelNum;
			public:
				/** 设备软件版本号 */
				string version;
			public:
				/** [int]私有协议p2p拉流端口 */
				int privateStreamPort;
			public:
				/** [O]设备型号 */
				string deviceModel;
			public:
				/** [int]加密模式 */
				int encryptMode;
			public:
				/** 设备名称 */
				string name;
			public:
				/** 设备登陆用户名 */
				string devLoginName;
			};
		public:
			LCOpenApiVector<DeviceListResponseData_DevicesElement> devices;

		};
	public:
		DeviceListResponse();
		~DeviceListResponse();
	public:
		virtual int parse();
	public:
		DeviceListResponseData data;
	};

	
	typedef typename DeviceListResponse::DeviceListResponseData DeviceListResponseData;
	typedef typename DeviceListResponse::DeviceListResponseData::DeviceListResponseData_DevicesElement DeviceListResponseData_DevicesElement;
	typedef typename DeviceListResponse::DeviceListResponseData::DeviceListResponseData_DevicesElement::DeviceListResponseData_DevicesElement_ChannelsElement DeviceListResponseData_DevicesElement_ChannelsElement;

}
}

#endif
