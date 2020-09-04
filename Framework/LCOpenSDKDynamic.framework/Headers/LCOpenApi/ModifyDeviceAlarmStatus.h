/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_ModifyDeviceAlarmStatus_H_
#define _LC_OPENAPI_CLIENT_ModifyDeviceAlarmStatus_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
修改失败报警状态，开/关

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class ModifyDeviceAlarmStatusRequest : public LCOpenApiRequest
	{
	public:
		class ModifyDeviceAlarmStatusRequestData
		{
		public:
			ModifyDeviceAlarmStatusRequestData();
			~ModifyDeviceAlarmStatusRequestData();
			
		public:
			/** [cstr]modifyDeviceAlarmStatus */
			#define _STATIC_ModifyDeviceAlarmStatusRequestData_method "modifyDeviceAlarmStatus"
			string method;
		public:
			/** [bool]true:开;false:关 */
			bool enable;
		public:
			/** 通道ID */
			string channelId;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		ModifyDeviceAlarmStatusRequest();
		~ModifyDeviceAlarmStatusRequest();
	public:
		virtual int build();
	public:
		ModifyDeviceAlarmStatusRequestData data;
	};

	
	typedef typename ModifyDeviceAlarmStatusRequest::ModifyDeviceAlarmStatusRequestData ModifyDeviceAlarmStatusRequestData;


	class ModifyDeviceAlarmStatusResponse : public LCOpenApiResponse
	{
	public:
		class ModifyDeviceAlarmStatusResponseData
		{
		public:
			ModifyDeviceAlarmStatusResponseData();
			~ModifyDeviceAlarmStatusResponseData();
			
		public:
			/** [int][O]保留 */
			int _nouse;

		};
	public:
		ModifyDeviceAlarmStatusResponse();
		~ModifyDeviceAlarmStatusResponse();
	public:
		virtual int parse();
	public:
		ModifyDeviceAlarmStatusResponseData data;
	};

	
	typedef typename ModifyDeviceAlarmStatusResponse::ModifyDeviceAlarmStatusResponseData ModifyDeviceAlarmStatusResponseData;

}
}

#endif
