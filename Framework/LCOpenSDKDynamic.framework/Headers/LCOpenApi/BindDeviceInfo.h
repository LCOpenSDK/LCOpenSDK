/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 103366, Author: 32725, Date: 2018-07-18 10:43:06 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_BindDeviceInfo_H_
#define _LC_OPENAPI_CLIENT_BindDeviceInfo_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
获取绑定的单台设备的信息

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class BindDeviceInfoRequest : public LCOpenApiRequest
	{
	public:
		class BindDeviceInfoRequestData
		{
		public:
			BindDeviceInfoRequestData();
			~BindDeviceInfoRequestData();
			
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]bindDeviceInfo */
			#define _STATIC_BindDeviceInfoRequestData_method "bindDeviceInfo"
			string method;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		BindDeviceInfoRequest();
		~BindDeviceInfoRequest();
	public:
		virtual int build();
	public:
		BindDeviceInfoRequestData data;
	};

	
	typedef typename BindDeviceInfoRequest::BindDeviceInfoRequestData BindDeviceInfoRequestData;


	class BindDeviceInfoResponse : public LCOpenApiResponse
	{
	public:
		class BindDeviceInfoResponseData
		{
		public:
			BindDeviceInfoResponseData();
			~BindDeviceInfoResponseData();
			
		public:
			/** 设备品牌信息：lechange-乐城设备，general-通用设备 */
			string brand;
		public:
			/** 设备基线类型，详见华视微讯设备协议 */
			string baseline;
		public:
			/** 绑定设备的appId（若为乐橙App绑定，该字段为空字符串） */
			string appId;
		public:
			/** 设备型号 */
			string deviceModel;
		public:
			/** define a list with struct of BindDeviceInfoResponseData_ChannelsElement */
			class BindDeviceInfoResponseData_ChannelsElement : public LCOpenApiBase
			{
			public:
				BindDeviceInfoResponseData_ChannelsElement();
				~BindDeviceInfoResponseData_ChannelsElement();
			public:
				/** [int]报警布撤防状态，0-撤防，1-布防 */
				int alarmStatus;
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
			LCOpenApiVector<BindDeviceInfoResponseData_ChannelsElement> channels;
		public:
			/** 设备名称 */
			string name;
		public:
			/** 设备ID */
			string deviceId;
		public:
			/** [int]总的视频通道数，包含未接入的通道 */
			int channelNum;
		public:
			/** [bool]是否有新版本可以升级 */
			bool canBeUpgrade;
		public:
			/** 设备软件版本号 */
			string version;
		public:
			/** [O]设备能力项，逗号隔开，如AlarmMD,AudioTalk,AlarmPIR,WLAN,VVP2P，详见乐橙开放平台设备协议 */
			string ability;
		public:
			/** [int]当前状态：0-离线，1-在线，3-升级中 */
			int status;
		public:
			/** [int]加密模式 */
			int encryptMode;
		public:
			/** 设备分类 */
			string deviceCatalog;
		public:
			/** [int]平台类型 */
			int platForm;

		};
	public:
		BindDeviceInfoResponse();
		~BindDeviceInfoResponse();
	public:
		virtual int parse();
	public:
		BindDeviceInfoResponseData data;
	};

	
	typedef typename BindDeviceInfoResponse::BindDeviceInfoResponseData BindDeviceInfoResponseData;
	typedef typename BindDeviceInfoResponse::BindDeviceInfoResponseData::BindDeviceInfoResponseData_ChannelsElement BindDeviceInfoResponseData_ChannelsElement;

}
}

#endif
