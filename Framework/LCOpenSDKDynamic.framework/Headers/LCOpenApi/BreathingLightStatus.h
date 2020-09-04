/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_BreathingLightStatus_H_
#define _LC_OPENAPI_CLIENT_BreathingLightStatus_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
获取呼吸灯状态

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class BreathingLightStatusRequest : public LCOpenApiRequest
	{
	public:
		class BreathingLightStatusRequestData
		{
		public:
			BreathingLightStatusRequestData();
			~BreathingLightStatusRequestData();
			
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]breathingLightStatus */
			#define _STATIC_BreathingLightStatusRequestData_method "breathingLightStatus"
			string method;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		BreathingLightStatusRequest();
		~BreathingLightStatusRequest();
	public:
		virtual int build();
	public:
		BreathingLightStatusRequestData data;
	};

	
	typedef typename BreathingLightStatusRequest::BreathingLightStatusRequestData BreathingLightStatusRequestData;


	class BreathingLightStatusResponse : public LCOpenApiResponse
	{
	public:
		class BreathingLightStatusResponseData
		{
		public:
			BreathingLightStatusResponseData();
			~BreathingLightStatusResponseData();
			
		public:
			/** 状态，1表示开启，0表示关闭 */
			string status;

		};
	public:
		BreathingLightStatusResponse();
		~BreathingLightStatusResponse();
	public:
		virtual int parse();
	public:
		BreathingLightStatusResponseData data;
	};

	
	typedef typename BreathingLightStatusResponse::BreathingLightStatusResponseData BreathingLightStatusResponseData;

}
}

#endif
