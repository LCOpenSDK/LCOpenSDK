/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_CurrentDeviceWifi_H_
#define _LC_OPENAPI_CLIENT_CurrentDeviceWifi_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
设备当前连接的热点信息

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class CurrentDeviceWifiRequest : public LCOpenApiRequest
	{
	public:
		class CurrentDeviceWifiRequestData
		{
		public:
			CurrentDeviceWifiRequestData();
			~CurrentDeviceWifiRequestData();
			
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]currentDeviceWifi */
			#define _STATIC_CurrentDeviceWifiRequestData_method "currentDeviceWifi"
			string method;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		CurrentDeviceWifiRequest();
		~CurrentDeviceWifiRequest();
	public:
		virtual int build();
	public:
		CurrentDeviceWifiRequestData data;
	};

	
	typedef typename CurrentDeviceWifiRequest::CurrentDeviceWifiRequestData CurrentDeviceWifiRequestData;


	class CurrentDeviceWifiResponse : public LCOpenApiResponse
	{
	public:
		class CurrentDeviceWifiResponseData
		{
		public:
			CurrentDeviceWifiResponseData();
			~CurrentDeviceWifiResponseData();
			
		public:
			/** 若连接了热点，填热点的名称；若未连接，填空 */
			string ssid;
		public:
			/** [bool]是否连接了wifi */
			bool linkEnable;

		};
	public:
		CurrentDeviceWifiResponse();
		~CurrentDeviceWifiResponse();
	public:
		virtual int parse();
	public:
		CurrentDeviceWifiResponseData data;
	};

	
	typedef typename CurrentDeviceWifiResponse::CurrentDeviceWifiResponseData CurrentDeviceWifiResponseData;

}
}

#endif
