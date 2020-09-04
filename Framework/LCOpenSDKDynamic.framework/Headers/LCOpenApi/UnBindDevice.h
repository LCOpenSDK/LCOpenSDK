/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_UnBindDevice_H_
#define _LC_OPENAPI_CLIENT_UnBindDevice_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
解绑设备

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class UnBindDeviceRequest : public LCOpenApiRequest
	{
	public:
		class UnBindDeviceRequestData
		{
		public:
			UnBindDeviceRequestData();
			~UnBindDeviceRequestData();
			
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]unBindDevice */
			#define _STATIC_UnBindDeviceRequestData_method "unBindDevice"
			string method;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		UnBindDeviceRequest();
		~UnBindDeviceRequest();
	public:
		virtual int build();
	public:
		UnBindDeviceRequestData data;
	};

	
	typedef typename UnBindDeviceRequest::UnBindDeviceRequestData UnBindDeviceRequestData;


	class UnBindDeviceResponse : public LCOpenApiResponse
	{
	public:
		class UnBindDeviceResponseData
		{
		public:
			UnBindDeviceResponseData();
			~UnBindDeviceResponseData();
			
		public:
			/** [int][O]保留 */
			int _nouse;

		};
	public:
		UnBindDeviceResponse();
		~UnBindDeviceResponse();
	public:
		virtual int parse();
	public:
		UnBindDeviceResponseData data;
	};

	
	typedef typename UnBindDeviceResponse::UnBindDeviceResponseData UnBindDeviceResponseData;

}
}

#endif
