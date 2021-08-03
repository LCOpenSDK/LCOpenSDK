/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_QueryLocalRecordNum_H_
#define _LC_OPENAPI_CLIENT_QueryLocalRecordNum_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
查询设备录像的数目（建议beginTime和endTime不要跨天）

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class QueryLocalRecordNumRequest : public LCOpenApiRequest
	{
	public:
		class QueryLocalRecordNumRequestData
		{
		public:
			QueryLocalRecordNumRequestData();
			~QueryLocalRecordNumRequestData();
			
		public:
			/** [cstr]All */
			#define _STATIC_QueryLocalRecordNumRequestData_type "All"
			string type;
		public:
			/** [cstr]queryLocalRecordNum */
			#define _STATIC_QueryLocalRecordNumRequestData_method "queryLocalRecordNum"
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
		QueryLocalRecordNumRequest();
		~QueryLocalRecordNumRequest();
	public:
		virtual int build();
	public:
		QueryLocalRecordNumRequestData data;
	};

	
	typedef typename QueryLocalRecordNumRequest::QueryLocalRecordNumRequestData QueryLocalRecordNumRequestData;


	class QueryLocalRecordNumResponse : public LCOpenApiResponse
	{
	public:
		class QueryLocalRecordNumResponseData
		{
		public:
			QueryLocalRecordNumResponseData();
			~QueryLocalRecordNumResponseData();
			
		public:
			/** [int]录像总数 */
			int recordNum;

		};
	public:
		QueryLocalRecordNumResponse();
		~QueryLocalRecordNumResponse();
	public:
		virtual int parse();
	public:
		QueryLocalRecordNumResponseData data;
	};

	
	typedef typename QueryLocalRecordNumResponse::QueryLocalRecordNumResponseData QueryLocalRecordNumResponseData;

}
}

#endif
