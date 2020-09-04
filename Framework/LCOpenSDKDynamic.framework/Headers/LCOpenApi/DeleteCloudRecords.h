/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_DeleteCloudRecords_H_
#define _LC_OPENAPI_CLIENT_DeleteCloudRecords_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
删除动检云录像片段

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class DeleteCloudRecordsRequest : public LCOpenApiRequest
	{
	public:
		class DeleteCloudRecordsRequestData
		{
		public:
			DeleteCloudRecordsRequestData();
			~DeleteCloudRecordsRequestData();
			
		public:
			/** 云录像Id */
			string recordId;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]deleteCloudRecords */
			#define _STATIC_DeleteCloudRecordsRequestData_method "deleteCloudRecords"
			string method;

		};
	public:
		DeleteCloudRecordsRequest();
		~DeleteCloudRecordsRequest();
	public:
		virtual int build();
	public:
		DeleteCloudRecordsRequestData data;
	};

	
	typedef typename DeleteCloudRecordsRequest::DeleteCloudRecordsRequestData DeleteCloudRecordsRequestData;


	class DeleteCloudRecordsResponse : public LCOpenApiResponse
	{
	public:
		class DeleteCloudRecordsResponseData
		{
		public:
			DeleteCloudRecordsResponseData();
			~DeleteCloudRecordsResponseData();
			
		public:
			/** [int][O]保留 */
			int _nouse;

		};
	public:
		DeleteCloudRecordsResponse();
		~DeleteCloudRecordsResponse();
	public:
		virtual int parse();
	public:
		DeleteCloudRecordsResponseData data;
	};

	
	typedef typename DeleteCloudRecordsResponse::DeleteCloudRecordsResponseData DeleteCloudRecordsResponseData;

}
}

#endif
