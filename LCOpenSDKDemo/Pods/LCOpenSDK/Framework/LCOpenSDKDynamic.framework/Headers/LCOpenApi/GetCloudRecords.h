/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_GetCloudRecords_H_
#define _LC_OPENAPI_CLIENT_GetCloudRecords_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
按条件查询所有录像记录(倒序展示)

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class GetCloudRecordsRequest : public LCOpenApiRequest
	{
	public:
		class GetCloudRecordsRequestData
		{
		public:
			GetCloudRecordsRequestData();
			~GetCloudRecordsRequestData();
			
		public:
			/** 上次取到的最后录像的ID */
			string nextRecordId;
		public:
			/** [cstr]getCloudRecords */
			#define _STATIC_GetCloudRecordsRequestData_method "getCloudRecords"
			string method;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 开始时间，yyyy-MM-dd HH:mm:ss */
			string beginTime;
		public:
			/** 结束时间，yyyy-MM-dd HH:mm:ss */
			string endTime;
		public:
			/** 通道ID */
			string channelId;
		public:
			/** [int]分页查询的数量 */
			int count;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		GetCloudRecordsRequest();
		~GetCloudRecordsRequest();
	public:
		virtual int build();
	public:
		GetCloudRecordsRequestData data;
	};

	
	typedef typename GetCloudRecordsRequest::GetCloudRecordsRequestData GetCloudRecordsRequestData;


	class GetCloudRecordsResponse : public LCOpenApiResponse
	{
	public:
		class GetCloudRecordsResponseData
		{
		public:
			GetCloudRecordsResponseData();
			~GetCloudRecordsResponseData();
			
		public:
			/** define a list with struct of GetCloudRecordsResponseData_RecordsElement */
			class GetCloudRecordsResponseData_RecordsElement : public LCOpenApiBase
			{
			public:
				GetCloudRecordsResponseData_RecordsElement();
				~GetCloudRecordsResponseData_RecordsElement();
			public:
				/** 缩略图Url */
				string thumbUrl;
			public:
				/** [long]云录像大小，单位byte */
				int64 size;
			public:
				/** 结束时间 */
				string endTime;
			public:
				/** 开始时间 */
				string beginTime;
			public:
				/** 录像Id */
				string recordId;
			public:
				/** 通道ID */
				string channelId;
			public:
				/** [int]加密模式, 0表示默认加密模式, 1表示用户加密模式 */
				int encryptMode;
			public:
				/** 设备ID */
				string deviceId;
			};
		public:
			LCOpenApiVector<GetCloudRecordsResponseData_RecordsElement> records;

		};
	public:
		GetCloudRecordsResponse();
		~GetCloudRecordsResponse();
	public:
		virtual int parse();
	public:
		GetCloudRecordsResponseData data;
	};

	
	typedef typename GetCloudRecordsResponse::GetCloudRecordsResponseData GetCloudRecordsResponseData;
	typedef typename GetCloudRecordsResponse::GetCloudRecordsResponseData::GetCloudRecordsResponseData_RecordsElement GetCloudRecordsResponseData_RecordsElement;

}
}

#endif
