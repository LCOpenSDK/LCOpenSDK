/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_ControlDeviceWifi_H_
#define _LC_OPENAPI_CLIENT_ControlDeviceWifi_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
控制设备连接热点

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class ControlDeviceWifiRequest : public LCOpenApiRequest
	{
	public:
		class ControlDeviceWifiRequestData
		{
		public:
			ControlDeviceWifiRequestData();
			~ControlDeviceWifiRequestData();
			
		public:
			/** wifi密码 */
			string password;
		public:
			/** [cstr]controlDeviceWifi */
			#define _STATIC_ControlDeviceWifiRequestData_method "controlDeviceWifi"
			string method;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [bool]连接或断开 */
			bool linkEnable;
		public:
			/** BSSID */
			string bssid;
		public:
			/** 填需要连接的SSID */
			string ssid;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		ControlDeviceWifiRequest();
		~ControlDeviceWifiRequest();
	public:
		virtual int build();
	public:
		ControlDeviceWifiRequestData data;
	};

	
	typedef typename ControlDeviceWifiRequest::ControlDeviceWifiRequestData ControlDeviceWifiRequestData;


	class ControlDeviceWifiResponse : public LCOpenApiResponse
	{
	public:
		class ControlDeviceWifiResponseData
		{
		public:
			ControlDeviceWifiResponseData();
			~ControlDeviceWifiResponseData();
			
		public:
			/** [int][O]保留 */
			int _nouse;

		};
	public:
		ControlDeviceWifiResponse();
		~ControlDeviceWifiResponse();
	public:
		virtual int parse();
	public:
		ControlDeviceWifiResponseData data;
	};

	
	typedef typename ControlDeviceWifiResponse::ControlDeviceWifiResponseData ControlDeviceWifiResponseData;

}
}

#endif
