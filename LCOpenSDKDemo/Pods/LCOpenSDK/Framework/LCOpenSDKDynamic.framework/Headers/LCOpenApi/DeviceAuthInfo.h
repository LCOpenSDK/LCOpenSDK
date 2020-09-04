/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_DeviceAuthInfo_H_
#define _LC_OPENAPI_CLIENT_DeviceAuthInfo_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
获取设备通道的授权信息
 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class DeviceAuthInfoRequest : public LCOpenApiRequest
	{
	public:
		class DeviceAuthInfoRequestData
		{
		public:
			DeviceAuthInfoRequestData();
			~DeviceAuthInfoRequestData();
			
		public:
			/** [cstr]deviceAuthInfo */
			#define _STATIC_DeviceAuthInfoRequestData_method "deviceAuthInfo"
			string method;
		public:
			/** 通道号 */
			string channelId;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 设备Id */
			string deviceId;

		};
	public:
		DeviceAuthInfoRequest();
		~DeviceAuthInfoRequest();
	public:
		virtual int build();
	public:
		DeviceAuthInfoRequestData data;
	};

	
	typedef typename DeviceAuthInfoRequest::DeviceAuthInfoRequestData DeviceAuthInfoRequestData;


	class DeviceAuthInfoResponse : public LCOpenApiResponse
	{
	public:
		class DeviceAuthInfoResponseData
		{
		public:
			DeviceAuthInfoResponseData();
			~DeviceAuthInfoResponseData();
			
		public:
			/** define a list with struct of DeviceAuthInfoResponseData_ShareInfosElement */
			class DeviceAuthInfoResponseData_ShareInfosElement : public LCOpenApiBase
			{
			public:
				DeviceAuthInfoResponseData_ShareInfosElement();
				~DeviceAuthInfoResponseData_ShareInfosElement();
			public:
				/** 被授权的手机号码 */
				string phoneNumber;
			public:
				/** 授权的功能，可选项见说明，用逗号分隔 */
				string functions;
			};
		public:
			LCOpenApiVector<DeviceAuthInfoResponseData_ShareInfosElement> shareInfos;
		public:
			/** [int]剩余分享和授权的数量 */
			int leftShareCount;
		public:
			/** [int]允许分享数量, 999表示不限制,999表示为vip */
			int allowShareCount;

		};
	public:
		DeviceAuthInfoResponse();
		~DeviceAuthInfoResponse();
	public:
		virtual int parse();
	public:
		DeviceAuthInfoResponseData data;
	};

	
	typedef typename DeviceAuthInfoResponse::DeviceAuthInfoResponseData DeviceAuthInfoResponseData;
	typedef typename DeviceAuthInfoResponse::DeviceAuthInfoResponseData::DeviceAuthInfoResponseData_ShareInfosElement DeviceAuthInfoResponseData_ShareInfosElement;

}
}

#endif
