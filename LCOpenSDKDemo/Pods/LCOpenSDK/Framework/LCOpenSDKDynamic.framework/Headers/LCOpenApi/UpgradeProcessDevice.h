/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_UpgradeProcessDevice_H_
#define _LC_OPENAPI_CLIENT_UpgradeProcessDevice_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
查询设备升级状态和进度

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class UpgradeProcessDeviceRequest : public LCOpenApiRequest
	{
	public:
		class UpgradeProcessDeviceRequestData
		{
		public:
			UpgradeProcessDeviceRequestData();
			~UpgradeProcessDeviceRequestData();
			
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]upgradeProcessDevice */
			#define _STATIC_UpgradeProcessDeviceRequestData_method "upgradeProcessDevice"
			string method;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		UpgradeProcessDeviceRequest();
		~UpgradeProcessDeviceRequest();
	public:
		virtual int build();
	public:
		UpgradeProcessDeviceRequestData data;
	};

	
	typedef typename UpgradeProcessDeviceRequest::UpgradeProcessDeviceRequestData UpgradeProcessDeviceRequestData;


	class UpgradeProcessDeviceResponse : public LCOpenApiResponse
	{
	public:
		class UpgradeProcessDeviceResponseData
		{
		public:
			UpgradeProcessDeviceResponseData();
			~UpgradeProcessDeviceResponseData();
			
		public:
			/** 升级状态，idle:没有升级,downloading:正在下载升级包,upgrading:升级中 */
			string status;
		public:
			/** 版本号 */
			string version;
		public:
			/** 百分比 */
			string percent;

		};
	public:
		UpgradeProcessDeviceResponse();
		~UpgradeProcessDeviceResponse();
	public:
		virtual int parse();
	public:
		UpgradeProcessDeviceResponseData data;
	};

	
	typedef typename UpgradeProcessDeviceResponse::UpgradeProcessDeviceResponseData UpgradeProcessDeviceResponseData;

}
}

#endif
