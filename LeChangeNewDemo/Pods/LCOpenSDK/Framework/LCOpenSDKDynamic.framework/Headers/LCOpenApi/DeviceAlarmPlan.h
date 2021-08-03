/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_DeviceAlarmPlan_H_
#define _LC_OPENAPI_CLIENT_DeviceAlarmPlan_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
获取设备的动检计划

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class DeviceAlarmPlanRequest : public LCOpenApiRequest
	{
	public:
		class DeviceAlarmPlanRequestData
		{
		public:
			DeviceAlarmPlanRequestData();
			~DeviceAlarmPlanRequestData();
			
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 通道ID */
			string channelId;
		public:
			/** [cstr]deviceAlarmPlan */
			#define _STATIC_DeviceAlarmPlanRequestData_method "deviceAlarmPlan"
			string method;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		DeviceAlarmPlanRequest();
		~DeviceAlarmPlanRequest();
	public:
		virtual int build();
	public:
		DeviceAlarmPlanRequestData data;
	};

	
	typedef typename DeviceAlarmPlanRequest::DeviceAlarmPlanRequestData DeviceAlarmPlanRequestData;


	class DeviceAlarmPlanResponse : public LCOpenApiResponse
	{
	public:
		class DeviceAlarmPlanResponseData
		{
		public:
			DeviceAlarmPlanResponseData();
			~DeviceAlarmPlanResponseData();
			
		public:
			/** define a list with struct of DeviceAlarmPlanResponseData_RulesElement */
			class DeviceAlarmPlanResponseData_RulesElement : public LCOpenApiBase
			{
			public:
				DeviceAlarmPlanResponseData_RulesElement();
				~DeviceAlarmPlanResponseData_RulesElement();
			public:
				/** 重复周期 */
				string period;
			public:
				/** [bool]是否有效(true:开;false:关) */
				bool enable;
			public:
				/** 开始时间 */
				string beginTime;
			public:
				/** 结束时间 */
				string endTime;
			public:
				/** [long]时间戳 */
				int64 timestamp;
			};
		public:
			LCOpenApiVector<DeviceAlarmPlanResponseData_RulesElement> rules;
		public:
			/** 通道ID */
			string channelId;

		};
	public:
		DeviceAlarmPlanResponse();
		~DeviceAlarmPlanResponse();
	public:
		virtual int parse();
	public:
		DeviceAlarmPlanResponseData data;
	};

	
	typedef typename DeviceAlarmPlanResponse::DeviceAlarmPlanResponseData DeviceAlarmPlanResponseData;
	typedef typename DeviceAlarmPlanResponse::DeviceAlarmPlanResponseData::DeviceAlarmPlanResponseData_RulesElement DeviceAlarmPlanResponseData_RulesElement;

}
}

#endif
