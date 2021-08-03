/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_SetAllStorageStrategy_H_
#define _LC_OPENAPI_CLIENT_SetAllStorageStrategy_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
设置云存储套餐开或关

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class SetAllStorageStrategyRequest : public LCOpenApiRequest
	{
	public:
		class SetAllStorageStrategyRequestData
		{
		public:
			SetAllStorageStrategyRequestData();
			~SetAllStorageStrategyRequestData();
			
		public:
			/** [cstr]setAllStorageStrategy */
			#define _STATIC_SetAllStorageStrategyRequestData_method "setAllStorageStrategy"
			string method;
		public:
			/** 状态，1表示开启，0表示关闭 */
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
		SetAllStorageStrategyRequest();
		~SetAllStorageStrategyRequest();
	public:
		virtual int build();
	public:
		SetAllStorageStrategyRequestData data;
	};

	
	typedef typename SetAllStorageStrategyRequest::SetAllStorageStrategyRequestData SetAllStorageStrategyRequestData;


	class SetAllStorageStrategyResponse : public LCOpenApiResponse
	{
	public:
		class SetAllStorageStrategyResponseData
		{
		public:
			SetAllStorageStrategyResponseData();
			~SetAllStorageStrategyResponseData();
			
		public:
			/** [int][O]保留 */
			int _nouse;

		};
	public:
		SetAllStorageStrategyResponse();
		~SetAllStorageStrategyResponse();
	public:
		virtual int parse();
	public:
		SetAllStorageStrategyResponseData data;
	};

	
	typedef typename SetAllStorageStrategyResponse::SetAllStorageStrategyResponseData SetAllStorageStrategyResponseData;

}
}

#endif
