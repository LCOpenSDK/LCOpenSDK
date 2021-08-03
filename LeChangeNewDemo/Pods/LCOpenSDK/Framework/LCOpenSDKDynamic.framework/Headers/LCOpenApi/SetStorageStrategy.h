/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_SetStorageStrategy_H_
#define _LC_OPENAPI_CLIENT_SetStorageStrategy_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
设置免费云存储套餐开或关

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class SetStorageStrategyRequest : public LCOpenApiRequest
	{
	public:
		class SetStorageStrategyRequestData
		{
		public:
			SetStorageStrategyRequestData();
			~SetStorageStrategyRequestData();
			
		public:
			/** [cstr]setStorageStrategy */
			#define _STATIC_SetStorageStrategyRequestData_method "setStorageStrategy"
			string method;
		public:
			/** 状态，on表示开启，off表示关闭 */
			string status;
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
		SetStorageStrategyRequest();
		~SetStorageStrategyRequest();
	public:
		virtual int build();
	public:
		SetStorageStrategyRequestData data;
	};

	
	typedef typename SetStorageStrategyRequest::SetStorageStrategyRequestData SetStorageStrategyRequestData;


	class SetStorageStrategyResponse : public LCOpenApiResponse
	{
	public:
		class SetStorageStrategyResponseData
		{
		public:
			SetStorageStrategyResponseData();
			~SetStorageStrategyResponseData();
			
		public:
			/** [int][O]保留 */
			int _nouse;

		};
	public:
		SetStorageStrategyResponse();
		~SetStorageStrategyResponse();
	public:
		virtual int parse();
	public:
		SetStorageStrategyResponseData data;
	};

	
	typedef typename SetStorageStrategyResponse::SetStorageStrategyResponseData SetStorageStrategyResponseData;

}
}

#endif
