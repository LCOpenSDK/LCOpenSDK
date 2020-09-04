/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_ModifyDeviceName_H_
#define _LC_OPENAPI_CLIENT_ModifyDeviceName_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
修改设备/通道名称

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class ModifyDeviceNameRequest : public LCOpenApiRequest
	{
	public:
		class ModifyDeviceNameRequestData
		{
		public:
			ModifyDeviceNameRequestData();
			~ModifyDeviceNameRequestData();
			
		public:
			/** [cstr]modifyDeviceName */
			#define _STATIC_ModifyDeviceNameRequestData_method "modifyDeviceName"
			string method;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 通道ID，留空表示设置设备 */
			string channelId;
		public:
			/** 待设置的名称 */
			string name;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		ModifyDeviceNameRequest();
		~ModifyDeviceNameRequest();
	public:
		virtual int build();
	public:
		ModifyDeviceNameRequestData data;
	};

	
	typedef typename ModifyDeviceNameRequest::ModifyDeviceNameRequestData ModifyDeviceNameRequestData;


	class ModifyDeviceNameResponse : public LCOpenApiResponse
	{
	public:
		class ModifyDeviceNameResponseData
		{
		public:
			ModifyDeviceNameResponseData();
			~ModifyDeviceNameResponseData();
			
		public:
			/** [int][O]保留 */
			int _nouse;

		};
	public:
		ModifyDeviceNameResponse();
		~ModifyDeviceNameResponse();
	public:
		virtual int parse();
	public:
		ModifyDeviceNameResponseData data;
	};

	
	typedef typename ModifyDeviceNameResponse::ModifyDeviceNameResponseData ModifyDeviceNameResponseData;

}
}

#endif
