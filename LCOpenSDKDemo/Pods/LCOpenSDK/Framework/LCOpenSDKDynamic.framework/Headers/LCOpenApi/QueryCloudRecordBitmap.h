/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_QueryCloudRecordBitmap_H_
#define _LC_OPENAPI_CLIENT_QueryCloudRecordBitmap_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
按月查询有报警云录像的日期（以“天”为单位）

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class QueryCloudRecordBitmapRequest : public LCOpenApiRequest
	{
	public:
		class QueryCloudRecordBitmapRequestData
		{
		public:
			QueryCloudRecordBitmapRequestData();
			~QueryCloudRecordBitmapRequestData();
			
		public:
			/** [cstr]queryCloudRecordBitmap */
			#define _STATIC_QueryCloudRecordBitmapRequestData_method "queryCloudRecordBitmap"
			string method;
		public:
			/** [int]月 */
			int month;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 通道ID */
			string channelId;
		public:
			/** [int]年 */
			int year;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		QueryCloudRecordBitmapRequest();
		~QueryCloudRecordBitmapRequest();
	public:
		virtual int build();
	public:
		QueryCloudRecordBitmapRequestData data;
	};

	
	typedef typename QueryCloudRecordBitmapRequest::QueryCloudRecordBitmapRequestData QueryCloudRecordBitmapRequestData;


	class QueryCloudRecordBitmapResponse : public LCOpenApiResponse
	{
	public:
		class QueryCloudRecordBitmapResponseData
		{
		public:
			QueryCloudRecordBitmapResponseData();
			~QueryCloudRecordBitmapResponseData();
			
		public:
			/** 日掩码-1111100000111110000011111000001 */
			string bitmap;

		};
	public:
		QueryCloudRecordBitmapResponse();
		~QueryCloudRecordBitmapResponse();
	public:
		virtual int parse();
	public:
		QueryCloudRecordBitmapResponseData data;
	};

	
	typedef typename QueryCloudRecordBitmapResponse::QueryCloudRecordBitmapResponseData QueryCloudRecordBitmapResponseData;

}
}

#endif
