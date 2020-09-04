/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_PassengerFlow_H_
#define _LC_OPENAPI_CLIENT_PassengerFlow_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
人数统计查询
 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class PassengerFlowRequest : public LCOpenApiRequest
	{
	public:
		class PassengerFlowRequestData
		{
		public:
			PassengerFlowRequestData();
			~PassengerFlowRequestData();
			
		public:
			/** 开始时间，yyyyMMddHHmm */
			string beginTime;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 粒度 */
			string granularity;
		public:
			/** 结束时间，yyyyMMddHHmm */
			string endTime;
		public:
			/** 通道ID */
			string channelId;
		public:
			/** [cstr]passengerFlow */
			#define _STATIC_PassengerFlowRequestData_method "passengerFlow"
			string method;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		PassengerFlowRequest();
		~PassengerFlowRequest();
	public:
		virtual int build();
	public:
		PassengerFlowRequestData data;
	};

	
	typedef typename PassengerFlowRequest::PassengerFlowRequestData PassengerFlowRequestData;


	class PassengerFlowResponse : public LCOpenApiResponse
	{
	public:
		class PassengerFlowResponseData
		{
		public:
			PassengerFlowResponseData();
			~PassengerFlowResponseData();
			
		public:
			/** [List]进入人数 */
			string in;
		public:
			/** [int]查询到的记录总数 */
			int total;
		public:
			/** [List]离开人数 */
			string out;

		};
	public:
		PassengerFlowResponse();
		~PassengerFlowResponse();
	public:
		virtual int parse();
	public:
		PassengerFlowResponseData data;
	};

	
	typedef typename PassengerFlowResponse::PassengerFlowResponseData PassengerFlowResponseData;

}
}

#endif
