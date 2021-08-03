/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 48717, Author: 31554, Date: 2016-12-20 15:44:00 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_AddGroup_H_
#define _LC_OPENAPI_CLIENT_AddGroup_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
添加分组

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class AddGroupRequest : public LCOpenApiRequest
	{
	public:
		class AddGroupRequestData
		{
		public:
			AddGroupRequestData();
			~AddGroupRequestData();
			
		public:
			/** [long]父分组Id */
			int64 parentGroupId;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 分组名称 */
			string groupName;
		public:
			/** [cstr]addGroup */
			#define _STATIC_AddGroupRequestData_method "addGroup"
			string method;

		};
	public:
		AddGroupRequest();
		~AddGroupRequest();
	public:
		virtual int build();
	public:
		AddGroupRequestData data;
	};

	
	typedef typename AddGroupRequest::AddGroupRequestData AddGroupRequestData;


	class AddGroupResponse : public LCOpenApiResponse
	{
	public:
		class AddGroupResponseData
		{
		public:
			AddGroupResponseData();
			~AddGroupResponseData();
			
		public:
			/** [long]分组id */
			int64 groupId;

		};
	public:
		AddGroupResponse();
		~AddGroupResponse();
	public:
		virtual int parse();
	public:
		AddGroupResponseData data;
	};

	
	typedef typename AddGroupResponse::AddGroupResponseData AddGroupResponseData;

}
}

#endif
