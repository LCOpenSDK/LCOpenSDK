/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_DeleteAlarmMessage_H_
#define _LC_OPENAPI_CLIENT_DeleteAlarmMessage_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
删除用户的报警消息

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class DeleteAlarmMessageRequest : public LCOpenApiRequest
	{
	public:
		class DeleteAlarmMessageRequestData
		{
		public:
			DeleteAlarmMessageRequestData();
			~DeleteAlarmMessageRequestData();
			
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]deleteAlarmMessage */
			#define _STATIC_DeleteAlarmMessageRequestData_method "deleteAlarmMessage"
			string method;
		public:
			/** [long]报警消息ID */
			int64 indexId;

		};
	public:
		DeleteAlarmMessageRequest();
		~DeleteAlarmMessageRequest();
	public:
		virtual int build();
	public:
		DeleteAlarmMessageRequestData data;
	};

	
	typedef typename DeleteAlarmMessageRequest::DeleteAlarmMessageRequestData DeleteAlarmMessageRequestData;


	class DeleteAlarmMessageResponse : public LCOpenApiResponse
	{
	public:
		class DeleteAlarmMessageResponseData
		{
		public:
			DeleteAlarmMessageResponseData();
			~DeleteAlarmMessageResponseData();
			
		public:
			/** [int][O]保留 */
			int _nouse;

		};
	public:
		DeleteAlarmMessageResponse();
		~DeleteAlarmMessageResponse();
	public:
		virtual int parse();
	public:
		DeleteAlarmMessageResponseData data;
	};

	
	typedef typename DeleteAlarmMessageResponse::DeleteAlarmMessageResponseData DeleteAlarmMessageResponseData;

}
}

#endif
