/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 48717, Author: 31554, Date: 2016-12-20 15:44:00 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_GroupList_H_
#define _LC_OPENAPI_CLIENT_GroupList_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
分页获取用户的设备分组列表(最顶层的分组)

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class GroupListRequest : public LCOpenApiRequest
	{
	public:
		class GroupListRequestData
		{
		public:
			GroupListRequestData();
			~GroupListRequestData();
			
		public:
			/** 第几条到第几条,数字取值范围为：[1,N](N为正整数，且后者＞前者),单次查询上限50 */
			string queryRange;
		public:
			/** [cstr]groupList */
			#define _STATIC_GroupListRequestData_method "groupList"
			string method;
		public:
			/** 授权token(userToken或accessToken) */
			string token;

		};
	public:
		GroupListRequest();
		~GroupListRequest();
	public:
		virtual int build();
	public:
		GroupListRequestData data;
	};

	
	typedef typename GroupListRequest::GroupListRequestData GroupListRequestData;


	class GroupListResponse : public LCOpenApiResponse
	{
	public:
		class GroupListResponseData
		{
		public:
			GroupListResponseData();
			~GroupListResponseData();
			
		public:
			/** define a list with struct of GroupListResponseData_GroupsElement */
			class GroupListResponseData_GroupsElement : public LCOpenApiBase
			{
			public:
				GroupListResponseData_GroupsElement();
				~GroupListResponseData_GroupsElement();
			public:
				/** [long]分组的最后修改unix时间戳，精确到秒 */
				int64 ts;
			public:
				/** 分组名称 */
				string groupName;
			public:
				/** [long]分组id */
				int64 groupId;
			};
		public:
			LCOpenApiVector<GroupListResponseData_GroupsElement> groups;

		};
	public:
		GroupListResponse();
		~GroupListResponse();
	public:
		virtual int parse();
	public:
		GroupListResponseData data;
	};

	
	typedef typename GroupListResponse::GroupListResponseData GroupListResponseData;
	typedef typename GroupListResponse::GroupListResponseData::GroupListResponseData_GroupsElement GroupListResponseData_GroupsElement;

}
}

#endif
