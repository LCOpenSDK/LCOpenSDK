/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 89883, Author: 32725, Date: 2018-02-24 09:56:01 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_UnBindDeviceInfo_H_
#define _LC_OPENAPI_CLIENT_UnBindDeviceInfo_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
获取未绑定的设备信息
 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class UnBindDeviceInfoRequest : public LCOpenApiRequest
	{
	public:
		class UnBindDeviceInfoRequestData
		{
		public:
			UnBindDeviceInfoRequestData();
			~UnBindDeviceInfoRequestData();
			
		public:
			/** [cstr]unBindDeviceInfo */
			#define _STATIC_UnBindDeviceInfoRequestData_method "unBindDeviceInfo"
			string method;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		UnBindDeviceInfoRequest();
		~UnBindDeviceInfoRequest();
	public:
		virtual int build();
	public:
		UnBindDeviceInfoRequestData data;
	};

	
	typedef typename UnBindDeviceInfoRequest::UnBindDeviceInfoRequestData UnBindDeviceInfoRequestData;


	class UnBindDeviceInfoResponse : public LCOpenApiResponse
	{
	public:
		class UnBindDeviceInfoResponseData
		{
		public:
			UnBindDeviceInfoResponseData();
			~UnBindDeviceInfoResponseData();
			
		public:
			/** [O]设备能力项，逗号隔开，如AlarmMD,AudioTalk,AlarmPIR,WLAN,VVP2P，详见乐橙开放平台设备协议 */
			string ability;

		};
	public:
		UnBindDeviceInfoResponse();
		~UnBindDeviceInfoResponse();
	public:
		virtual int parse();
	public:
		UnBindDeviceInfoResponseData data;
	};

	
	typedef typename UnBindDeviceInfoResponse::UnBindDeviceInfoResponseData UnBindDeviceInfoResponseData;

}
}

#endif
