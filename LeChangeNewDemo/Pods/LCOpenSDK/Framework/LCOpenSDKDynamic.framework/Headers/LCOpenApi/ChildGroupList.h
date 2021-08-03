/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 49213, Author: 31554, Date: 2016-12-27 14:19:37 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_ChildGroupList_H_
#define _LC_OPENAPI_CLIENT_ChildGroupList_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
分页获取该分组下面的子分组

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class ChildGroupListRequest : public LCOpenApiRequest
	{
	public:
		class ChildGroupListRequestData
		{
		public:
			ChildGroupListRequestData();
			~ChildGroupListRequestData();
			
		public:
			/** 分页取值范围,一次最多获取50条，格式为1-30 */
			string queryRange;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]childGroupList */
			#define _STATIC_ChildGroupListRequestData_method "childGroupList"
			string method;
		public:
			/** [long]分组id */
			int64 groupId;

		};
	public:
		ChildGroupListRequest();
		~ChildGroupListRequest();
	public:
		virtual int build();
	public:
		ChildGroupListRequestData data;
	};

	
	typedef typename ChildGroupListRequest::ChildGroupListRequestData ChildGroupListRequestData;


	class ChildGroupListResponse : public LCOpenApiResponse
	{
	public:
		class ChildGroupListResponseData
		{
		public:
			ChildGroupListResponseData();
			~ChildGroupListResponseData();
			
		public:
			/** define a list with struct of ChildGroupListResponseData_GroupsElement */
			class ChildGroupListResponseData_GroupsElement : public LCOpenApiBase
			{
			public:
				ChildGroupListResponseData_GroupsElement();
				~ChildGroupListResponseData_GroupsElement();
			public:
				/** [long]分组的最后修改unix时间戳，精确到秒 */
				int64 ts;
			public:
				/** 2,分组层级 */
				string level;
			public:
				/** 分组名称 */
				string groupName;
			public:
				/** [long]分组id */
				int64 groupId;
			};
		public:
			LCOpenApiVector<ChildGroupListResponseData_GroupsElement> groups;

		};
	public:
		ChildGroupListResponse();
		~ChildGroupListResponse();
	public:
		virtual int parse();
	public:
		ChildGroupListResponseData data;
	};

	
	typedef typename ChildGroupListResponse::ChildGroupListResponseData ChildGroupListResponseData;
	typedef typename ChildGroupListResponse::ChildGroupListResponseData::ChildGroupListResponseData_GroupsElement ChildGroupListResponseData_GroupsElement;

}
}

#endif
