/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_UpgradeDevice_H_
#define _LC_OPENAPI_CLIENT_UpgradeDevice_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
设备升级

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class UpgradeDeviceRequest : public LCOpenApiRequest
	{
	public:
		class UpgradeDeviceRequestData
		{
		public:
			UpgradeDeviceRequestData();
			~UpgradeDeviceRequestData();
			
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]upgradeDevice */
			#define _STATIC_UpgradeDeviceRequestData_method "upgradeDevice"
			string method;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		UpgradeDeviceRequest();
		~UpgradeDeviceRequest();
	public:
		virtual int build();
	public:
		UpgradeDeviceRequestData data;
	};

	
	typedef typename UpgradeDeviceRequest::UpgradeDeviceRequestData UpgradeDeviceRequestData;


	class UpgradeDeviceResponse : public LCOpenApiResponse
	{
	public:
		class UpgradeDeviceResponseData
		{
		public:
			UpgradeDeviceResponseData();
			~UpgradeDeviceResponseData();
			
		public:
			/** [int][O]保留 */
			int _nouse;

		};
	public:
		UpgradeDeviceResponse();
		~UpgradeDeviceResponse();
	public:
		virtual int parse();
	public:
		UpgradeDeviceResponseData data;
	};

	
	typedef typename UpgradeDeviceResponse::UpgradeDeviceResponseData UpgradeDeviceResponseData;

}
}

#endif
