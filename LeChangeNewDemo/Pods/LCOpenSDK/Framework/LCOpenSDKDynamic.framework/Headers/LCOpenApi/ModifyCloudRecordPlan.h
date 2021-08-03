/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_ModifyCloudRecordPlan_H_
#define _LC_OPENAPI_CLIENT_ModifyCloudRecordPlan_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
修改设备通道的云录像存储计划
 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class ModifyCloudRecordPlanRequest : public LCOpenApiRequest
	{
	public:
		class ModifyCloudRecordPlanRequestData
		{
		public:
			ModifyCloudRecordPlanRequestData();
			~ModifyCloudRecordPlanRequestData();
			
		public:
			/** 参考开放平台Wiki对应modifyCloudRecordPlan方法的rules规则 */
			string rules;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 通道ID */
			string channelId;
		public:
			/** [cstr]modifyCloudRecordPlan */
			#define _STATIC_ModifyCloudRecordPlanRequestData_method "modifyCloudRecordPlan"
			string method;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		ModifyCloudRecordPlanRequest();
		~ModifyCloudRecordPlanRequest();
	public:
		virtual int build();
	public:
		ModifyCloudRecordPlanRequestData data;
	};

	
	typedef typename ModifyCloudRecordPlanRequest::ModifyCloudRecordPlanRequestData ModifyCloudRecordPlanRequestData;


	class ModifyCloudRecordPlanResponse : public LCOpenApiResponse
	{
	public:
		class ModifyCloudRecordPlanResponseData
		{
		public:
			ModifyCloudRecordPlanResponseData();
			~ModifyCloudRecordPlanResponseData();
			
		public:
			/** [int][O]保留 */
			int _nouse;

		};
	public:
		ModifyCloudRecordPlanResponse();
		~ModifyCloudRecordPlanResponse();
	public:
		virtual int parse();
	public:
		ModifyCloudRecordPlanResponseData data;
	};

	
	typedef typename ModifyCloudRecordPlanResponse::ModifyCloudRecordPlanResponseData ModifyCloudRecordPlanResponseData;

}
}

#endif
