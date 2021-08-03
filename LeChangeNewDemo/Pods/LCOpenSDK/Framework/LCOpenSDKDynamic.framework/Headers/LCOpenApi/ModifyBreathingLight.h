/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_ModifyBreathingLight_H_
#define _LC_OPENAPI_CLIENT_ModifyBreathingLight_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
设置呼吸灯状态

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class ModifyBreathingLightRequest : public LCOpenApiRequest
	{
	public:
		class ModifyBreathingLightRequestData
		{
		public:
			ModifyBreathingLightRequestData();
			~ModifyBreathingLightRequestData();
			
		public:
			/** 状态，on表示开启，off表示关闭 */
			string status;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]modifyBreathingLight */
			#define _STATIC_ModifyBreathingLightRequestData_method "modifyBreathingLight"
			string method;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		ModifyBreathingLightRequest();
		~ModifyBreathingLightRequest();
	public:
		virtual int build();
	public:
		ModifyBreathingLightRequestData data;
	};

	
	typedef typename ModifyBreathingLightRequest::ModifyBreathingLightRequestData ModifyBreathingLightRequestData;


	class ModifyBreathingLightResponse : public LCOpenApiResponse
	{
	public:
		class ModifyBreathingLightResponseData
		{
		public:
			ModifyBreathingLightResponseData();
			~ModifyBreathingLightResponseData();
			
		public:
			/** [int][O]保留 */
			int _nouse;

		};
	public:
		ModifyBreathingLightResponse();
		~ModifyBreathingLightResponse();
	public:
		virtual int parse();
	public:
		ModifyBreathingLightResponseData data;
	};

	
	typedef typename ModifyBreathingLightResponse::ModifyBreathingLightResponseData ModifyBreathingLightResponseData;

}
}

#endif
