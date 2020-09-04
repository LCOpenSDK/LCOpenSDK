/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_RoleList_H_
#define _LC_OPENAPI_CLIENT_RoleList_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
获取角色列表
 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class RoleListRequest : public LCOpenApiRequest
	{
	public:
		class RoleListRequestData
		{
		public:
			RoleListRequestData();
			~RoleListRequestData();
			
		public:
			/** [int]需要查的最大条数，不大于50 */
			int count;
		public:
			/** [long]下一个角色id,若要从最新开始查，填-1 */
			int64 nextRoleId;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]roleList */
			#define _STATIC_RoleListRequestData_method "roleList"
			string method;

		};
	public:
		RoleListRequest();
		~RoleListRequest();
	public:
		virtual int build();
	public:
		RoleListRequestData data;
	};

	
	typedef typename RoleListRequest::RoleListRequestData RoleListRequestData;


	class RoleListResponse : public LCOpenApiResponse
	{
	public:
		class RoleListResponseData
		{
		public:
			RoleListResponseData();
			~RoleListResponseData();
			
		public:
			/** define a list with struct of RoleListResponseData_RolesElement */
			class RoleListResponseData_RolesElement : public LCOpenApiBase
			{
			public:
				RoleListResponseData_RolesElement();
				~RoleListResponseData_RolesElement();
			public:
				/** [int]是否为默认角色：0 - 普通角色，1 - 默认角色 */
				int isDefault;
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
			LCOpenApiVector<RoleListResponseData_RolesElement> roles;
		public:
			/** [long]下一个角色ID */
			int64 nextRoleId;

		};
	public:
		RoleListResponse();
		~RoleListResponse();
	public:
		virtual int parse();
	public:
		RoleListResponseData data;
	};

	
	typedef typename RoleListResponse::RoleListResponseData RoleListResponseData;
	typedef typename RoleListResponse::RoleListResponseData::RoleListResponseData_RolesElement RoleListResponseData_RolesElement;

}
}

#endif
