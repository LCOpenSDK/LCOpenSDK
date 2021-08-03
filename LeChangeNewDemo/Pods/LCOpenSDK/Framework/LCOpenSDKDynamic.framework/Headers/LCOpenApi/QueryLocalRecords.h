/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 115716, Author: 32725, Date: 2018-11-07 14:31:28 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_QueryLocalRecords_H_
#define _LC_OPENAPI_CLIENT_QueryLocalRecords_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
按照开始和结束时间查询设备录像

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class QueryLocalRecordsRequest : public LCOpenApiRequest
	{
	public:
		class QueryLocalRecordsRequestData
		{
		public:
			QueryLocalRecordsRequestData();
			~QueryLocalRecordsRequestData();
			
		public:
			/** 从第几条到第几条,单次查询上限100,1-100表示第1条到第100条,包含100,云录像查询相同 */
			string queryRange;
		public:
			/** [cstr]All */
			#define _STATIC_QueryLocalRecordsRequestData_type "All"
			string type;
		public:
			/** [cstr]queryLocalRecords */
			#define _STATIC_QueryLocalRecordsRequestData_method "queryLocalRecords"
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
		QueryLocalRecordsRequest();
		~QueryLocalRecordsRequest();
	public:
		virtual int build();
	public:
		QueryLocalRecordsRequestData data;
	};

	
	typedef typename QueryLocalRecordsRequest::QueryLocalRecordsRequestData QueryLocalRecordsRequestData;


	class QueryLocalRecordsResponse : public LCOpenApiResponse
	{
	public:
		class QueryLocalRecordsResponseData
		{
		public:
			QueryLocalRecordsResponseData();
			~QueryLocalRecordsResponseData();
			
		public:
			/** define a list with struct of QueryLocalRecordsResponseData_RecordsElement */
			class QueryLocalRecordsResponseData_RecordsElement : public LCOpenApiBase
			{
			public:
				QueryLocalRecordsResponseData_RecordsElement();
				~QueryLocalRecordsResponseData_RecordsElement();
			public:
				/** 类型，Manual、Event、All */
				string type;
			public:
				/** 结束时间，如2010-05-25 23:59:59 */
				string endTime;
			public:
				/** 录像文件名 */
				string recordId;
			public:
				/** 开始时间，如2010-05-25 00:00:00 */
				string beginTime;
			public:
				/** 通道ID */
				string channelID;
			public:
				/** [long]录像文件长度 */
				int64 fileLength;
			};
		public:
			LCOpenApiVector<QueryLocalRecordsResponseData_RecordsElement> records;

		};
	public:
		QueryLocalRecordsResponse();
		~QueryLocalRecordsResponse();
	public:
		virtual int parse();
	public:
		QueryLocalRecordsResponseData data;
	};

	
	typedef typename QueryLocalRecordsResponse::QueryLocalRecordsResponseData QueryLocalRecordsResponseData;
	typedef typename QueryLocalRecordsResponse::QueryLocalRecordsResponseData::QueryLocalRecordsResponseData_RecordsElement QueryLocalRecordsResponseData_RecordsElement;

}
}

#endif
