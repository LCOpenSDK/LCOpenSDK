/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_CloudRecordPlan_H_
#define _LC_OPENAPI_CLIENT_CloudRecordPlan_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
获取设备通道的云录像存储计划
Period：生效的周期
        everyday：每天 等价于周一到周日
        Monday：每周一
        Tuesday：每周二
        Wednesday：每周三
        Thursday：每周四
        Friday：每周五
        Saturday：每周六
        Sunday：每周日
    可出现“Monday, Wednesday, Friday”的方式多选。
 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class CloudRecordPlanRequest : public LCOpenApiRequest
	{
	public:
		class CloudRecordPlanRequestData
		{
		public:
			CloudRecordPlanRequestData();
			~CloudRecordPlanRequestData();
			
		public:
			/** [cstr]cloudRecordPlan */
			#define _STATIC_CloudRecordPlanRequestData_method "cloudRecordPlan"
			string method;
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
		CloudRecordPlanRequest();
		~CloudRecordPlanRequest();
	public:
		virtual int build();
	public:
		CloudRecordPlanRequestData data;
	};

	
	typedef typename CloudRecordPlanRequest::CloudRecordPlanRequestData CloudRecordPlanRequestData;


	class CloudRecordPlanResponse : public LCOpenApiResponse
	{
	public:
		class CloudRecordPlanResponseData
		{
		public:
			CloudRecordPlanResponseData();
			~CloudRecordPlanResponseData();
			
		public:
			/** define a list with struct of CloudRecordPlanResponseData_RulesElement */
			class CloudRecordPlanResponseData_RulesElement : public LCOpenApiBase
			{
			public:
				CloudRecordPlanResponseData_RulesElement();
				~CloudRecordPlanResponseData_RulesElement();
			public:
				/** 结束时间 */
				string endTime;
			public:
				/** [long]时间戳 */
				int64 timestamp;
			public:
				/** 重复周期 */
				string period;
			public:
				/** 开始时间 */
				string beginTime;
			};
		public:
			LCOpenApiVector<CloudRecordPlanResponseData_RulesElement> rules;
		public:
			/** 通道ID */
			string channelId;
		public:
			/** [int]每日最长拉流时间（单位：小时） */
			int limitTime;
		public:
			/** [int]上行带宽（单位：M） */
			int upstream;

		};
	public:
		CloudRecordPlanResponse();
		~CloudRecordPlanResponse();
	public:
		virtual int parse();
	public:
		CloudRecordPlanResponseData data;
	};

	
	typedef typename CloudRecordPlanResponse::CloudRecordPlanResponseData CloudRecordPlanResponseData;
	typedef typename CloudRecordPlanResponse::CloudRecordPlanResponseData::CloudRecordPlanResponseData_RulesElement CloudRecordPlanResponseData_RulesElement;

}
}

#endif
