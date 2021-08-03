/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 46611, Author: 31834, Date: 2016-11-22 17:50:53 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_QueryCloudRecordCallNum_H_
#define _LC_OPENAPI_CLIENT_QueryCloudRecordCallNum_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
查询开发者开通云存储套餐策略接口的剩余调用次数

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class QueryCloudRecordCallNumRequest : public LCOpenApiRequest
	{
	public:
		class QueryCloudRecordCallNumRequestData
		{
		public:
			QueryCloudRecordCallNumRequestData();
			~QueryCloudRecordCallNumRequestData();
			
		public:
			/** [cstr]queryCloudRecordCallNum */
			#define _STATIC_QueryCloudRecordCallNumRequestData_method "queryCloudRecordCallNum"
			string method;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [long]云存储套餐ID */
			int64 strategyId;

		};
	public:
		QueryCloudRecordCallNumRequest();
		~QueryCloudRecordCallNumRequest();
	public:
		virtual int build();
	public:
		QueryCloudRecordCallNumRequestData data;
	};

	
	typedef typename QueryCloudRecordCallNumRequest::QueryCloudRecordCallNumRequestData QueryCloudRecordCallNumRequestData;


	class QueryCloudRecordCallNumResponse : public LCOpenApiResponse
	{
	public:
		class QueryCloudRecordCallNumResponseData
		{
		public:
			QueryCloudRecordCallNumResponseData();
			~QueryCloudRecordCallNumResponseData();
			
		public:
			/** [int]录像总数 */
			int callNum;

		};
	public:
		QueryCloudRecordCallNumResponse();
		~QueryCloudRecordCallNumResponse();
	public:
		virtual int parse();
	public:
		QueryCloudRecordCallNumResponseData data;
	};

	
	typedef typename QueryCloudRecordCallNumResponse::QueryCloudRecordCallNumResponseData QueryCloudRecordCallNumResponseData;

}
}

#endif
