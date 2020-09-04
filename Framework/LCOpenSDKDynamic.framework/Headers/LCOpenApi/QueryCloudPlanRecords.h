/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_QueryCloudPlanRecords_H_
#define _LC_OPENAPI_CLIENT_QueryCloudPlanRecords_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
按照开始和结束时间查询定时云录像

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class QueryCloudPlanRecordsRequest : public LCOpenApiRequest
	{
	public:
		class QueryCloudPlanRecordsRequestData
		{
		public:
			QueryCloudPlanRecordsRequestData();
			~QueryCloudPlanRecordsRequestData();
			
		public:
			/** 从第几条到第几条,单次查询上限100,1-100表示第1条到第100条,包含100,云录像查询相同 */
			string queryRange;
		public:
			/** [cstr]queryCloudPlanRecords */
			#define _STATIC_QueryCloudPlanRecordsRequestData_method "queryCloudPlanRecords"
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
		QueryCloudPlanRecordsRequest();
		~QueryCloudPlanRecordsRequest();
	public:
		virtual int build();
	public:
		QueryCloudPlanRecordsRequestData data;
	};

	
	typedef typename QueryCloudPlanRecordsRequest::QueryCloudPlanRecordsRequestData QueryCloudPlanRecordsRequestData;


	class QueryCloudPlanRecordsResponse : public LCOpenApiResponse
	{
	public:
		class QueryCloudPlanRecordsResponseData
		{
		public:
			QueryCloudPlanRecordsResponseData();
			~QueryCloudPlanRecordsResponseData();
			
		public:
			/** define a list with struct of QueryCloudPlanRecordsResponseData_RecordsElement */
			class QueryCloudPlanRecordsResponseData_RecordsElement : public LCOpenApiBase
			{
			public:
				QueryCloudPlanRecordsResponseData_RecordsElement();
				~QueryCloudPlanRecordsResponseData_RecordsElement();
			public:
				/** [int]加密模式（0：默认加密模式；1：用户加密模式） */
				int encryptMode;
			public:
				/** 云录像的大小，单位byte */
				string size;
			public:
				/** 结束时间，如2010-05-25 23:59:59 */
				string endTime;
			public:
				/** 开始时间，如2010-05-25 00:00:00 */
				string beginTime;
			public:
				/** 加密图片下载地址 */
				string thumbUrl;
			public:
				/** 通道ID */
				string channelId;
			public:
				/** 录像ID */
				string recordId;
			public:
				/** 设备ID */
				string deviceId;
			};
		public:
			LCOpenApiVector<QueryCloudPlanRecordsResponseData_RecordsElement> records;

		};
	public:
		QueryCloudPlanRecordsResponse();
		~QueryCloudPlanRecordsResponse();
	public:
		virtual int parse();
	public:
		QueryCloudPlanRecordsResponseData data;
	};

	
	typedef typename QueryCloudPlanRecordsResponse::QueryCloudPlanRecordsResponseData QueryCloudPlanRecordsResponseData;
	typedef typename QueryCloudPlanRecordsResponse::QueryCloudPlanRecordsResponseData::QueryCloudPlanRecordsResponseData_RecordsElement QueryCloudPlanRecordsResponseData_RecordsElement;

}
}

#endif
