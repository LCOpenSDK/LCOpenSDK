/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_QueryCloudPlanRecordNum_H_
#define _LC_OPENAPI_CLIENT_QueryCloudPlanRecordNum_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
查询定时云录像的数目（建议beginTime和endTime不要跨天）

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class QueryCloudPlanRecordNumRequest : public LCOpenApiRequest
	{
	public:
		class QueryCloudPlanRecordNumRequestData
		{
		public:
			QueryCloudPlanRecordNumRequestData();
			~QueryCloudPlanRecordNumRequestData();
			
		public:
			/** [cstr]queryCloudPlanRecordNum */
			#define _STATIC_QueryCloudPlanRecordNumRequestData_method "queryCloudPlanRecordNum"
			string method;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 结束时间，如2010-05-25 23:59:59 */
			string endTime;
		public:
			/** 通道ID */
			string channelId;
		public:
			/** 开始时间，如2010-05-25 00:00:00 */
			string beginTime;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		QueryCloudPlanRecordNumRequest();
		~QueryCloudPlanRecordNumRequest();
	public:
		virtual int build();
	public:
		QueryCloudPlanRecordNumRequestData data;
	};

	
	typedef typename QueryCloudPlanRecordNumRequest::QueryCloudPlanRecordNumRequestData QueryCloudPlanRecordNumRequestData;


	class QueryCloudPlanRecordNumResponse : public LCOpenApiResponse
	{
	public:
		class QueryCloudPlanRecordNumResponseData
		{
		public:
			QueryCloudPlanRecordNumResponseData();
			~QueryCloudPlanRecordNumResponseData();
			
		public:
			/** [int]录像总数 */
			int recordNum;

		};
	public:
		QueryCloudPlanRecordNumResponse();
		~QueryCloudPlanRecordNumResponse();
	public:
		virtual int parse();
	public:
		QueryCloudPlanRecordNumResponseData data;
	};

	
	typedef typename QueryCloudPlanRecordNumResponse::QueryCloudPlanRecordNumResponseData QueryCloudPlanRecordNumResponseData;

}
}

#endif
