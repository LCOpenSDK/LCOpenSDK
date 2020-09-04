/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 103366, Author: 32725, Date: 2018-07-18 10:43:06 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_ShareDeviceList_H_
#define _LC_OPENAPI_CLIENT_ShareDeviceList_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
获取分享的设备列表

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class ShareDeviceListRequest : public LCOpenApiRequest
	{
	public:
		class ShareDeviceListRequestData
		{
		public:
			ShareDeviceListRequestData();
			~ShareDeviceListRequestData();
			
		public:
			/** 第几条到第几条,数字取值范围为：[1,N](N为正整数，且后者＞前者),单次查询上限100 */
			string queryRange;
		public:
			/** [cstr]shareDeviceList */
			#define _STATIC_ShareDeviceListRequestData_method "shareDeviceList"
			string method;
		public:
			/** 授权token(userToken或accessToken) */
			string token;

		};
	public:
		ShareDeviceListRequest();
		~ShareDeviceListRequest();
	public:
		virtual int build();
	public:
		ShareDeviceListRequestData data;
	};

	
	typedef typename ShareDeviceListRequest::ShareDeviceListRequestData ShareDeviceListRequestData;


	class ShareDeviceListResponse : public LCOpenApiResponse
	{
	public:
		class ShareDeviceListResponseData
		{
		public:
			ShareDeviceListResponseData();
			~ShareDeviceListResponseData();
			
		public:
			/** [int]当前获取的设备总数 */
			int count;
		public:
			/** define a list with struct of ShareDeviceListResponseData_DevicesElement */
			class ShareDeviceListResponseData_DevicesElement : public LCOpenApiBase
			{
			public:
				ShareDeviceListResponseData_DevicesElement();
				~ShareDeviceListResponseData_DevicesElement();
			public:
				/** 设备品牌信息：lechange-乐橙设备，general-通用设备 */
				string brand;
			public:
				/** 设备基线类型，详见华视微讯设备协议 */
				string baseline;
			public:
				/** define a list with struct of ShareDeviceListResponseData_DevicesElement_ChannelsElement */
				class ShareDeviceListResponseData_DevicesElement_ChannelsElement : public LCOpenApiBase
				{
				public:
					ShareDeviceListResponseData_DevicesElement_ChannelsElement();
					~ShareDeviceListResponseData_DevicesElement_ChannelsElement();
				public:
					/** 缩略图URL */
					string channelPicUrl;
				public:
					/** [int]通道ID */
					int channelId;
				public:
					/** [bool]是否在线 */
					bool channelOnline;
				public:
					/** 通道名称 */
					string channelName;
				};
			public:
				LCOpenApiVector<ShareDeviceListResponseData_DevicesElement_ChannelsElement> channels;
			public:
				/** [O]设备型号 */
				string deviceModel;
			public:
				/** [int]加密模式 */
				int encryptMode;
			public:
				/** [bool]是否有新版本可以升级 */
				bool canBeUpgrade;
			public:
				/** 设备ID */
				string deviceId;
			public:
				/** [O]设备能力项，逗号隔开，如AlarmMD,AudioTalk,AlarmPIR,WLAN,VVP2P，详见乐橙开放平台设备协议 */
				string ability;
			public:
				/** [int]p2p拉流端口 */
				int streamPort;
			public:
				/** 设备登陆用户名 */
				string devLoginName;
			public:
				/** 设备名称 */
				string name;
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
				/** 设备软件版本号 */
				string version;
			};
		public:
			LCOpenApiVector<ShareDeviceListResponseData_DevicesElement> devices;

		};
	public:
		ShareDeviceListResponse();
		~ShareDeviceListResponse();
	public:
		virtual int parse();
	public:
		ShareDeviceListResponseData data;
	};

	
	typedef typename ShareDeviceListResponse::ShareDeviceListResponseData ShareDeviceListResponseData;
	typedef typename ShareDeviceListResponse::ShareDeviceListResponseData::ShareDeviceListResponseData_DevicesElement ShareDeviceListResponseData_DevicesElement;
	typedef typename ShareDeviceListResponse::ShareDeviceListResponseData::ShareDeviceListResponseData_DevicesElement::ShareDeviceListResponseData_DevicesElement_ChannelsElement ShareDeviceListResponseData_DevicesElement_ChannelsElement;

}
}

#endif
