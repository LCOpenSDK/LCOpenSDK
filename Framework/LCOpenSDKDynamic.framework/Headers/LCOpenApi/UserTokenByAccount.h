/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 140502, Author: 39890, Date: 2019-06-26 20:23:15 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_UserTokenByAccount_H_
#define _LC_OPENAPI_CLIENT_UserTokenByAccount_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
根据账号获取用户token
 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class UserTokenByAccountRequest : public LCOpenApiRequest
	{
	public:
		class UserTokenByAccountRequestData
		{
		public:
			UserTokenByAccountRequestData();
			~UserTokenByAccountRequestData();
			
		public:
			/** [String][Not Null]国内 手机号 ，国外输入邮箱 */
			string account;

		};
	public:
		UserTokenByAccountRequest();
		~UserTokenByAccountRequest();
	public:
		virtual int build();
	public:
		UserTokenByAccountRequestData data;
	};

	
	typedef typename UserTokenByAccountRequest::UserTokenByAccountRequestData UserTokenByAccountRequestData;


	class UserTokenByAccountResponse : public LCOpenApiResponse
	{
	public:
		class UserTokenByAccountResponseData
		{
		public:
			UserTokenByAccountResponseData();
			~UserTokenByAccountResponseData();
			
		public:
			/** [String]获取的用户Token */
			string userToken;
		public:
			/** 剩余过期时间，单位：秒 */
			string expireTime;

		};
	public:
		UserTokenByAccountResponse();
		~UserTokenByAccountResponse();
	public:
		virtual int parse();
	public:
		UserTokenByAccountResponseData data;
	};

	
	typedef typename UserTokenByAccountResponse::UserTokenByAccountResponseData UserTokenByAccountResponseData;

}
}

#endif
