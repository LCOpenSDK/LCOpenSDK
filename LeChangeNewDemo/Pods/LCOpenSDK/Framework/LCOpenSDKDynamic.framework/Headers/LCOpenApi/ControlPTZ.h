/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_ControlPTZ_H_
#define _LC_OPENAPI_CLIENT_ControlPTZ_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
云台控制

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class ControlPTZRequest : public LCOpenApiRequest
	{
	public:
		class ControlPTZRequestData
		{
		public:
			ControlPTZRequestData();
			~ControlPTZRequestData();
			
		public:
			/** [cstr]controlPTZ */
			#define _STATIC_ControlPTZRequestData_method "controlPTZ"
			string method;
		public:
			/** 操作行为；move表示移动，locate表示定位 */
			string operation;
		public:
			/** 移动持续时间，单位为毫秒。没有duration字段或duration字段填“last”表示一直运动下去 */
			string duration;
		public:
			/** 设备ID */
			string deviceId;
		public:
			/** [double]水平操作参数 */
			double h;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [double]变倍参数 */
			double z;
		public:
			/** 通道号 */
			string channelId;
		public:
			/** [double]垂直操作参数 */
			double v;

		};
	public:
		ControlPTZRequest();
		~ControlPTZRequest();
	public:
		virtual int build();
	public:
		ControlPTZRequestData data;
	};

	
	typedef typename ControlPTZRequest::ControlPTZRequestData ControlPTZRequestData;


	class ControlPTZResponse : public LCOpenApiResponse
	{
	public:
		class ControlPTZResponseData
		{
		public:
			ControlPTZResponseData();
			~ControlPTZResponseData();
			
		public:
			/** [int][O]保留 */
			int _nouse;

		};
	public:
		ControlPTZResponse();
		~ControlPTZResponse();
	public:
		virtual int parse();
	public:
		ControlPTZResponseData data;
	};

	
	typedef typename ControlPTZResponse::ControlPTZResponseData ControlPTZResponseData;

}
}

#endif
