/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_WifiAround_H_
#define _LC_OPENAPI_CLIENT_WifiAround_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
获取设备周边wifi信息，enable表示设备是否开启WIFI：false表示WIFI功能关闭，true表示WIFI功能开启，当enable为true时同时返回设备当前环境中的热点列表。

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class WifiAroundRequest : public LCOpenApiRequest
	{
	public:
		class WifiAroundRequestData
		{
		public:
			WifiAroundRequestData();
			~WifiAroundRequestData();
			
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]wifiAround */
			#define _STATIC_WifiAroundRequestData_method "wifiAround"
			string method;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		WifiAroundRequest();
		~WifiAroundRequest();
	public:
		virtual int build();
	public:
		WifiAroundRequestData data;
	};

	
	typedef typename WifiAroundRequest::WifiAroundRequestData WifiAroundRequestData;


	class WifiAroundResponse : public LCOpenApiResponse
	{
	public:
		class WifiAroundResponseData
		{
		public:
			WifiAroundResponseData();
			~WifiAroundResponseData();
			
		public:
			/** [bool]是否开启了wifi */
			bool enable;
		public:
			/** define a list with struct of WifiAroundResponseData_WLanElement */
			class WifiAroundResponseData_WLanElement : public LCOpenApiBase
			{
			public:
				WifiAroundResponseData_WLanElement();
				~WifiAroundResponseData_WLanElement();
			public:
				/**  SSID  */
				string ssid;
			public:
				/** [int]强度 */
				int intensity;
			public:
				/** BSSID */
				string bssid ;
			public:
				/** 加密方式 */
				string auth;
			public:
				/** [int]状态 */
				int linkStatus;
			};
		public:
			LCOpenApiVector<WifiAroundResponseData_WLanElement> wLan;

		};
	public:
		WifiAroundResponse();
		~WifiAroundResponse();
	public:
		virtual int parse();
	public:
		WifiAroundResponseData data;
	};

	
	typedef typename WifiAroundResponse::WifiAroundResponseData WifiAroundResponseData;
	typedef typename WifiAroundResponse::WifiAroundResponseData::WifiAroundResponseData_WLanElement WifiAroundResponseData_WLanElement;

}
}

#endif
