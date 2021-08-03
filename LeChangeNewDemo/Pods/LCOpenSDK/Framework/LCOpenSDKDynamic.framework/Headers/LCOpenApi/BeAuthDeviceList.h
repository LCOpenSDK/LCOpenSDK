/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 103366, Author: 32725, Date: 2018-07-18 10:43:06 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_BeAuthDeviceList_H_
#define _LC_OPENAPI_CLIENT_BeAuthDeviceList_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
获取授权的设备列表

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class BeAuthDeviceListRequest : public LCOpenApiRequest
	{
	public:
		class BeAuthDeviceListRequestData
		{
		public:
			BeAuthDeviceListRequestData();
			~BeAuthDeviceListRequestData();
			
		public:
			/** 比如1-50 */
			string queryRange;
		public:
			/** [cstr]beAuthDeviceList */
			#define _STATIC_BeAuthDeviceListRequestData_method "beAuthDeviceList"
			string method;
		public:
			/** 授权token(userToken或accessToken) */
			string token;

		};
	public:
		BeAuthDeviceListRequest();
		~BeAuthDeviceListRequest();
	public:
		virtual int build();
	public:
		BeAuthDeviceListRequestData data;
	};

	
	typedef typename BeAuthDeviceListRequest::BeAuthDeviceListRequestData BeAuthDeviceListRequestData;


	class BeAuthDeviceListResponse : public LCOpenApiResponse
	{
	public:
		class BeAuthDeviceListResponseData
		{
		public:
			BeAuthDeviceListResponseData();
			~BeAuthDeviceListResponseData();
			
		public:
			/** define a list with struct of BeAuthDeviceListResponseData_DevicesElement */
			class BeAuthDeviceListResponseData_DevicesElement : public LCOpenApiBase
			{
			public:
				BeAuthDeviceListResponseData_DevicesElement();
				~BeAuthDeviceListResponseData_DevicesElement();
			public:
				/** [O]设备品牌信息：lechange-乐橙设备，general-通用设备 */
				string brand;
			public:
				/** [int]云存储状态：-1-未开通 0-已失效 1-使用中 2-套餐暂停 */
				int csStatus;
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
				/** [O]设备分类【NVR/DVR/HCVR/IPC/SD/IHG/ARC】 */
				string deviceCatalog;
			public:
				/** [O]设备基线类型，详见华视微讯设备协议 */
				string baseline;
			public:
				/** 共享或者授权的功能列表（逗号隔开） */
				string functions;
			public:
				/** [O]设备能力项，逗号隔开，如AlarmMD,AudioTalk,AlarmPIR,WLAN,VVP2P，详见华视微讯设备协议 */
				string ability;
			public:
				/** [O]设备型号 */
				string deviceModel;
			public:
				/** 设备ID */
				string deviceId;
			public:
				/** 设备名称 */
				string name;
			public:
				/** 通道名称 */
				string channelName;
			public:
				/** 设备软件版本号 */
				string version;
			public:
				/** [int]通道号 */
				int channelId;
			public:
				/** 缩略图URL */
				string channelPicUrl;
			public:
				/** [int]加密模式 */
				int encryptMode;
			public:
				/** [bool]是否在线 */
				bool channelOnline;
			public:
				/** 设备登陆用户名 */
				string devLoginName;
			};
		public:
			LCOpenApiVector<BeAuthDeviceListResponseData_DevicesElement> devices;

		};
	public:
		BeAuthDeviceListResponse();
		~BeAuthDeviceListResponse();
	public:
		virtual int parse();
	public:
		BeAuthDeviceListResponseData data;
	};

	
	typedef typename BeAuthDeviceListResponse::BeAuthDeviceListResponseData BeAuthDeviceListResponseData;
	typedef typename BeAuthDeviceListResponse::BeAuthDeviceListResponseData::BeAuthDeviceListResponseData_DevicesElement BeAuthDeviceListResponseData_DevicesElement;

}
}

#endif
