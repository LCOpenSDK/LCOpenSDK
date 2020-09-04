/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_SetDeviceSnap_H_
#define _LC_OPENAPI_CLIENT_SetDeviceSnap_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
设置摄像头抓图
注：客户端请求时间间隔需大于等于1s，若客户端请求时间间隔小于3s，默认返回上一次抓图图片；返回结果中，抓图访问地址（url）1年内有效。

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class SetDeviceSnapRequest : public LCOpenApiRequest
	{
	public:
		class SetDeviceSnapRequestData
		{
		public:
			SetDeviceSnapRequestData();
			~SetDeviceSnapRequestData();
			
		public:
			/** [bool]图片是否加密，true:加密,false:不加密 */
			bool encrypt;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 通道ID */
			string channelId;
		public:
			/** [cstr]setDeviceSnap */
			#define _STATIC_SetDeviceSnapRequestData_method "setDeviceSnap"
			string method;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		SetDeviceSnapRequest();
		~SetDeviceSnapRequest();
	public:
		virtual int build();
	public:
		SetDeviceSnapRequestData data;
	};

	
	typedef typename SetDeviceSnapRequest::SetDeviceSnapRequestData SetDeviceSnapRequestData;


	class SetDeviceSnapResponse : public LCOpenApiResponse
	{
	public:
		class SetDeviceSnapResponseData
		{
		public:
			SetDeviceSnapResponseData();
			~SetDeviceSnapResponseData();
			
		public:
			/** 抓图访问地址 */
			string url;

		};
	public:
		SetDeviceSnapResponse();
		~SetDeviceSnapResponse();
	public:
		virtual int parse();
	public:
		SetDeviceSnapResponseData data;
	};

	
	typedef typename SetDeviceSnapResponse::SetDeviceSnapResponseData SetDeviceSnapResponseData;

}
}

#endif
