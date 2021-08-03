/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 97578, Author: 32725, Date: 2018-05-17 15:27:18 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_GetRecordByLinkageId_H_
#define _LC_OPENAPI_CLIENT_GetRecordByLinkageId_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
根据联动消息ID获取云录像

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class GetRecordByLinkageIdRequest : public LCOpenApiRequest
	{
	public:
		class GetRecordByLinkageIdRequestData
		{
		public:
			GetRecordByLinkageIdRequestData();
			~GetRecordByLinkageIdRequestData();
			
		public:
			/** 录像类型,1000报警云录像,2000定时云录像,3000透传报警录像 */
			string type;
		public:
			/** [cstr]getRecordByLinkageId */
			#define _STATIC_GetRecordByLinkageIdRequestData_method "getRecordByLinkageId"
			string method;
		public:
			/** 联动消息id */
			string linkageId;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		GetRecordByLinkageIdRequest();
		~GetRecordByLinkageIdRequest();
	public:
		virtual int build();
	public:
		GetRecordByLinkageIdRequestData data;
	};

	
	typedef typename GetRecordByLinkageIdRequest::GetRecordByLinkageIdRequestData GetRecordByLinkageIdRequestData;


	class GetRecordByLinkageIdResponse : public LCOpenApiResponse
	{
	public:
		class GetRecordByLinkageIdResponseData
		{
		public:
			GetRecordByLinkageIdResponseData();
			~GetRecordByLinkageIdResponseData();
			
		public:
			/** 设备本地结束时间 */
			string localEndTime;
		public:
			/** 录像文件路径 */
			string recordPath;
		public:
			/** 缩略图URL */
			string thumbUrl;
		public:
			/** 区域 */
			string region;
		public:
			/** 录像ID */
			string recordId;
		public:
			/** [int]加密模式, 0表示默认加密模式, 1表示用户加密模式 */
			int encryptMode;
		public:
			/** 设备本地开始时间 */
			string localBeginTime;
		public:
			/** 云录像的大小，单位byte */
			string size;

		};
	public:
		GetRecordByLinkageIdResponse();
		~GetRecordByLinkageIdResponse();
	public:
		virtual int parse();
	public:
		GetRecordByLinkageIdResponseData data;
	};

	
	typedef typename GetRecordByLinkageIdResponse::GetRecordByLinkageIdResponseData GetRecordByLinkageIdResponseData;

}
}

#endif
