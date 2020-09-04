/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: unknown, Author: unknown, Date: unknown
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_BindDeviceChannelInfo_H_
#define _LC_OPENAPI_CLIENT_BindDeviceChannelInfo_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
获取绑定的单个设备通道的信息

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class BindDeviceChannelInfoRequest : public LCOpenApiRequest
	{
	public:
		class BindDeviceChannelInfoRequestData
		{
		public:
			BindDeviceChannelInfoRequestData();
			~BindDeviceChannelInfoRequestData();
			
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [String][Not Null]通道号 */
			string channelId;
		public:
			/** [cstr]bindDeviceChannelInfo */
			#define _STATIC_BindDeviceChannelInfoRequestData_method "bindDeviceChannelInfo"
			string method;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		BindDeviceChannelInfoRequest();
		~BindDeviceChannelInfoRequest();
	public:
		virtual int build();
	public:
		BindDeviceChannelInfoRequestData data;
	};

	
	typedef typename BindDeviceChannelInfoRequest::BindDeviceChannelInfoRequestData BindDeviceChannelInfoRequestData;


	class BindDeviceChannelInfoResponse : public LCOpenApiResponse
	{
	public:
		class BindDeviceChannelInfoResponseData
		{
		public:
			BindDeviceChannelInfoResponseData();
			~BindDeviceChannelInfoResponseData();
			
		public:
			/** [int]动检开关状态 0:关闭状态，1：开启状态 */
			int alarmStatus;
		public:
			/** [String]云存储状态 notExist:未开通套餐，using：开通云存储且没有过期， expired：套餐过期 */
			string csStatus;
		public:
			/** [String]设备ID */
			string deviceId;
		public:
			/** [String]可选,被共享和授权的权限功能列表（逗号隔开） */
			string shareFunctions;
		public:
			/** [String]通道名称 */
			string channelName;
		public:
			/** [String]缩略图URL */
			string channelPicUrl;
		public:
			/** [int]通道号 */
			int channelId;
		public:
			/** [string]是否在线 ，online-在线 offline-在线 close-未配置 sleep-休眠 */
			string channelOnline;
		public:
			/** 设备共享状态 */
			string shareStatus;

		};
	public:
		BindDeviceChannelInfoResponse();
		~BindDeviceChannelInfoResponse();
	public:
		virtual int parse();
	public:
		BindDeviceChannelInfoResponseData data;
	};

	
	typedef typename BindDeviceChannelInfoResponse::BindDeviceChannelInfoResponseData BindDeviceChannelInfoResponseData;

}
}

#endif
