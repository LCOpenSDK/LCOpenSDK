/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 77011, Author: 32725, Date: 2017-10-18 10:37:13 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_ModifyDevicePwd_H_
#define _LC_OPENAPI_CLIENT_ModifyDevicePwd_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
修改设备密码

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class ModifyDevicePwdRequest : public LCOpenApiRequest
	{
	public:
		class ModifyDevicePwdRequestData
		{
		public:
			ModifyDevicePwdRequestData();
			~ModifyDevicePwdRequestData();
			
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]modifyDevicePwd */
			#define _STATIC_ModifyDevicePwdRequestData_method "modifyDevicePwd"
			string method;
		public:
			/** 新密码 */
			string newPwd;
		public:
			/** 老密码 */
			string oldPwd;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		ModifyDevicePwdRequest();
		~ModifyDevicePwdRequest();
	public:
		virtual int build();
	public:
		ModifyDevicePwdRequestData data;
	};

	
	typedef typename ModifyDevicePwdRequest::ModifyDevicePwdRequestData ModifyDevicePwdRequestData;


	class ModifyDevicePwdResponse : public LCOpenApiResponse
	{
	public:
		class ModifyDevicePwdResponseData
		{
		public:
			ModifyDevicePwdResponseData();
			~ModifyDevicePwdResponseData();
			
		public:
			/** [int][O]保留 */
			int _nouse;

		};
	public:
		ModifyDevicePwdResponse();
		~ModifyDevicePwdResponse();
	public:
		virtual int parse();
	public:
		ModifyDevicePwdResponseData data;
	};

	
	typedef typename ModifyDevicePwdResponse::ModifyDevicePwdResponseData ModifyDevicePwdResponseData;

}
}

#endif
