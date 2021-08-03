/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_UserAuthList_H_
#define _LC_OPENAPI_CLIENT_UserAuthList_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
获取授权列表
 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class UserAuthListRequest : public LCOpenApiRequest
	{
	public:
		class UserAuthListRequestData
		{
		public:
			UserAuthListRequestData();
			~UserAuthListRequestData();
			
		public:
			/** [int]需要查的最大条数 */
			int count;
		public:
			/** [long]从该授权ID开始查询。若要从最新开始查，填-1 */
			int64 nextAuthId;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]userAuthList */
			#define _STATIC_UserAuthListRequestData_method "userAuthList"
			string method;

		};
	public:
		UserAuthListRequest();
		~UserAuthListRequest();
	public:
		virtual int build();
	public:
		UserAuthListRequestData data;
	};

	
	typedef typename UserAuthListRequest::UserAuthListRequestData UserAuthListRequestData;


	class UserAuthListResponse : public LCOpenApiResponse
	{
	public:
		class UserAuthListResponseData
		{
		public:
			UserAuthListResponseData();
			~UserAuthListResponseData();
			
		public:
			/** define a list with struct of UserAuthListResponseData_AuthorizationsElement */
			class UserAuthListResponseData_AuthorizationsElement : public LCOpenApiBase
			{
			public:
				UserAuthListResponseData_AuthorizationsElement();
				~UserAuthListResponseData_AuthorizationsElement();
			public:
				/** define a list with struct of UserAuthListResponseData_AuthorizationsElement_Role */
				class UserAuthListResponseData_AuthorizationsElement_Role : public LCOpenApiBase
				{
				public:
					UserAuthListResponseData_AuthorizationsElement_Role();
					~UserAuthListResponseData_AuthorizationsElement_Role();
				public:
					/** [long]角色Id */
					int64 roleId;
				public:
					/** 角色名称 */
					string roleName;
				public:
					/** 权限列表 */
					string authFunctions;
				};
			public:
				UserAuthListResponseData_AuthorizationsElement_Role* role;
			public:
				/** [long]授权Id */
				int64 authId;
			public:
				/** 手机号 */
				string phoneNumber;
			public:
				/** 授权名称 */
				string authName;
			public:
				/** define a list with struct of UserAuthListResponseData_AuthorizationsElement_AuthDevicesElement */
				class UserAuthListResponseData_AuthorizationsElement_AuthDevicesElement : public LCOpenApiBase
				{
				public:
					UserAuthListResponseData_AuthorizationsElement_AuthDevicesElement();
					~UserAuthListResponseData_AuthorizationsElement_AuthDevicesElement();
				public:
					/** 通道ID */
					string channelId;
				public:
					/** 通道名称 */
					string channelName;
				public:
					/** 设备ID */
					string deviceId;
				};
			public:
				LCOpenApiVector<UserAuthListResponseData_AuthorizationsElement_AuthDevicesElement> authDevices;
			};
		public:
			LCOpenApiVector<UserAuthListResponseData_AuthorizationsElement> authorizations;
		public:
			/** 下一个授权ID */
			string nextAuthId;

		};
	public:
		UserAuthListResponse();
		~UserAuthListResponse();
	public:
		virtual int parse();
	public:
		UserAuthListResponseData data;
	};

	
	typedef typename UserAuthListResponse::UserAuthListResponseData UserAuthListResponseData;
	typedef typename UserAuthListResponse::UserAuthListResponseData::UserAuthListResponseData_AuthorizationsElement UserAuthListResponseData_AuthorizationsElement;
	typedef typename UserAuthListResponse::UserAuthListResponseData::UserAuthListResponseData_AuthorizationsElement::UserAuthListResponseData_AuthorizationsElement_Role UserAuthListResponseData_AuthorizationsElement_Role;
	typedef typename UserAuthListResponse::UserAuthListResponseData::UserAuthListResponseData_AuthorizationsElement::UserAuthListResponseData_AuthorizationsElement_AuthDevicesElement UserAuthListResponseData_AuthorizationsElement_AuthDevicesElement;

}
}

#endif
