/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_BindDevice_H_
#define _LC_OPENAPI_CLIENT_BindDevice_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
设备绑定

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class BindDeviceRequest : public LCOpenApiRequest
	{
	public:
		class BindDeviceRequestData
		{
		public:
			BindDeviceRequestData();
			~BindDeviceRequestData();
			
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 设备ID */
			string deviceId;
		public:
			/** [cstr]bindDevice */
			#define _STATIC_BindDeviceRequestData_method "bindDevice"
			string method;
		public:
			/** 安全码或设备密码，若无则填空 */
			string code;

		};
	public:
		BindDeviceRequest();
		~BindDeviceRequest();
	public:
		virtual int build();
	public:
		BindDeviceRequestData data;
	};

	
	typedef typename BindDeviceRequest::BindDeviceRequestData BindDeviceRequestData;


	class BindDeviceResponse : public LCOpenApiResponse
	{
	public:
		class BindDeviceResponseData
		{
		public:
			BindDeviceResponseData();
			~BindDeviceResponseData();
			
		public:
			/** [int][O]保留 */
			int _nouse;

		};
	public:
		BindDeviceResponse();
		~BindDeviceResponse();
	public:
		virtual int parse();
	public:
		BindDeviceResponseData data;
	};

	
	typedef typename BindDeviceResponse::BindDeviceResponseData BindDeviceResponseData;

}
}

#endif
