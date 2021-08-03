/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: unknown, Author: unknown, Date: unknown
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_QueryCloudRecords_H_
#define _LC_OPENAPI_CLIENT_QueryCloudRecords_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
按照开始和结束时间查询报警云录像

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class QueryCloudRecordsRequest : public LCOpenApiRequest
	{
	public:
		class QueryCloudRecordsRequestData
		{
		public:
			QueryCloudRecordsRequestData();
			~QueryCloudRecordsRequestData();
			
		public:
			/** 从第几条到第几条,单次查询上限100,1-100表示第1条到第100条,包含100,云录像查询相同 */
			string queryRange;
		public:
			/** [cstr]queryCloudRecords */
			#define _STATIC_QueryCloudRecordsRequestData_method "queryCloudRecords"
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
		QueryCloudRecordsRequest();
		~QueryCloudRecordsRequest();
	public:
		virtual int build();
	public:
		QueryCloudRecordsRequestData data;
	};

	
	typedef typename QueryCloudRecordsRequest::QueryCloudRecordsRequestData QueryCloudRecordsRequestData;


	class QueryCloudRecordsResponse : public LCOpenApiResponse
	{
	public:
		class QueryCloudRecordsResponseData
		{
		public:
			QueryCloudRecordsResponseData();
			~QueryCloudRecordsResponseData();
			
		public:
			/** define a list with struct of QueryCloudRecordsResponseData_RecordsElement */
			class QueryCloudRecordsResponseData_RecordsElement : public LCOpenApiBase
			{
			public:
				QueryCloudRecordsResponseData_RecordsElement();
				~QueryCloudRecordsResponseData_RecordsElement();
			public:
                /** 录像ID */
                string recordId;
            public:
                /** 设备ID */
                string deviceId;
            public:
                /** [必传] */
                string recordRegionId;
            public:
                /** [int]加密模式（0：默认加密模式；1：用户加密模式） */
                int encryptMode;
            public:
                /** 加密图片下载地址 */
                string thumbUrl;
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
                /** 云录像的大小，单位byte */
                string size;
			};
		public:
			LCOpenApiVector<QueryCloudRecordsResponseData_RecordsElement> records;

		};
	public:
		QueryCloudRecordsResponse();
		~QueryCloudRecordsResponse();
	public:
		virtual int parse();
	public:
		QueryCloudRecordsResponseData data;
	};

	
	typedef typename QueryCloudRecordsResponse::QueryCloudRecordsResponseData QueryCloudRecordsResponseData;
	typedef typename QueryCloudRecordsResponse::QueryCloudRecordsResponseData::QueryCloudRecordsResponseData_RecordsElement QueryCloudRecordsResponseData_RecordsElement;

}
}

#endif
