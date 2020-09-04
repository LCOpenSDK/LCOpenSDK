/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_DeleteGroupDevice_H_
#define _LC_OPENAPI_CLIENT_DeleteGroupDevice_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
分组下删除设备

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class DeleteGroupDeviceRequest : public LCOpenApiRequest
	{
	public:
		class DeleteGroupDeviceRequestData
		{
		public:
			DeleteGroupDeviceRequestData();
			~DeleteGroupDeviceRequestData();
			
		public:
			/** [cstr]deleteGroupDevice */
			#define _STATIC_DeleteGroupDeviceRequestData_method "deleteGroupDevice"
			string method;
		public:
			/** [long]分组Id */
			int64 groupId;
		public:
			/** 通道ID */
			string channelId;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		DeleteGroupDeviceRequest();
		~DeleteGroupDeviceRequest();
	public:
		virtual int build();
	public:
		DeleteGroupDeviceRequestData data;
	};

	
	typedef typename DeleteGroupDeviceRequest::DeleteGroupDeviceRequestData DeleteGroupDeviceRequestData;


	class DeleteGroupDeviceResponse : public LCOpenApiResponse
	{
	public:
		class DeleteGroupDeviceResponseData
		{
		public:
			DeleteGroupDeviceResponseData();
			~DeleteGroupDeviceResponseData();
			
		public:
			/** [int][O]保留 */
			int _nouse;

		};
	public:
		DeleteGroupDeviceResponse();
		~DeleteGroupDeviceResponse();
	public:
		virtual int parse();
	public:
		DeleteGroupDeviceResponseData data;
	};

	
	typedef typename DeleteGroupDeviceResponse::DeleteGroupDeviceResponseData DeleteGroupDeviceResponseData;

}
}

#endif
