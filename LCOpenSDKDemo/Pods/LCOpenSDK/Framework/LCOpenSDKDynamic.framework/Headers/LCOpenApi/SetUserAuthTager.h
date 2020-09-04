/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_SetUserAuthTager_H_
#define _LC_OPENAPI_CLIENT_SetUserAuthTager_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
设置授权对象(单一设备授权)
 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class SetUserAuthTagerRequest : public LCOpenApiRequest
	{
	public:
		class SetUserAuthTagerRequestData
		{
		public:
			SetUserAuthTagerRequestData();
			~SetUserAuthTagerRequestData();
			
		public:
			/** [long]角色ID */
			int64 roleId;
		public:
			/** [cstr]setUserAuthTager */
			#define _STATIC_SetUserAuthTagerRequestData_method "setUserAuthTager"
			string method;
		public:
			/** 被授权的手机号 */
			string userPhone;
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
		SetUserAuthTagerRequest();
		~SetUserAuthTagerRequest();
	public:
		virtual int build();
	public:
		SetUserAuthTagerRequestData data;
	};

	
	typedef typename SetUserAuthTagerRequest::SetUserAuthTagerRequestData SetUserAuthTagerRequestData;


	class SetUserAuthTagerResponse : public LCOpenApiResponse
	{
	public:
		class SetUserAuthTagerResponseData
		{
		public:
			SetUserAuthTagerResponseData();
			~SetUserAuthTagerResponseData();
			
		public:
			/** [long]授权Id */
			int64 authId;

		};
	public:
		SetUserAuthTagerResponse();
		~SetUserAuthTagerResponse();
	public:
		virtual int parse();
	public:
		SetUserAuthTagerResponseData data;
	};

	
	typedef typename SetUserAuthTagerResponse::SetUserAuthTagerResponseData SetUserAuthTagerResponseData;

}
}

#endif
