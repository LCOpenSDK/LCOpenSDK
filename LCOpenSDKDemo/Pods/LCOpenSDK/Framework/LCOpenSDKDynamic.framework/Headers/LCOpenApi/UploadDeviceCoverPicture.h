/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 110414, Author: 43243, Date: 2018-09-19 09:21:55 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_UploadDeviceCoverPicture_H_
#define _LC_OPENAPI_CLIENT_UploadDeviceCoverPicture_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
上传设备封面图
 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class UploadDeviceCoverPictureRequest : public LCOpenApiRequest
	{
	public:
		class UploadDeviceCoverPictureRequestData
		{
		public:
			UploadDeviceCoverPictureRequestData();
			~UploadDeviceCoverPictureRequestData();
			
		public:
			/** [cstr]uploadDeviceCoverPicture */
			#define _STATIC_UploadDeviceCoverPictureRequestData_method "uploadDeviceCoverPicture"
			string method;
		public:
			/** 图片二进制数据的base64编码的字符串 */
			string pictureData;
		public:
			/** 通道id */
			string channelId;
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		UploadDeviceCoverPictureRequest();
		~UploadDeviceCoverPictureRequest();
	public:
		virtual int build();
	public:
		UploadDeviceCoverPictureRequestData data;
	};

	
	typedef typename UploadDeviceCoverPictureRequest::UploadDeviceCoverPictureRequestData UploadDeviceCoverPictureRequestData;


	class UploadDeviceCoverPictureResponse : public LCOpenApiResponse
	{
	public:
		class UploadDeviceCoverPictureResponseData
		{
		public:
			UploadDeviceCoverPictureResponseData();
			~UploadDeviceCoverPictureResponseData();
			
		public:
			/** id值 */
			string id;
		public:
			/** define a list with struct of UploadDeviceCoverPictureResponseData_Result */
			class UploadDeviceCoverPictureResponseData_Result : public LCOpenApiBase
			{
			public:
				UploadDeviceCoverPictureResponseData_Result();
				~UploadDeviceCoverPictureResponseData_Result();
			public:
				/** 操作结果 */
				string msg;
			public:
				/** define a list with struct of UploadDeviceCoverPictureResponseData_Result_Data */
				class UploadDeviceCoverPictureResponseData_Result_Data : public LCOpenApiBase
				{
				public:
					UploadDeviceCoverPictureResponseData_Result_Data();
					~UploadDeviceCoverPictureResponseData_Result_Data();
				public:
					/** 图片的url */
					string url;
				};
			public:
				UploadDeviceCoverPictureResponseData_Result_Data* data;
			public:
				/** 0 */
				string code;
			};
		public:
			UploadDeviceCoverPictureResponseData_Result* result;

		};
	public:
		UploadDeviceCoverPictureResponse();
		~UploadDeviceCoverPictureResponse();
	public:
		virtual int parse();
	public:
		UploadDeviceCoverPictureResponseData data;
	};

	
	typedef typename UploadDeviceCoverPictureResponse::UploadDeviceCoverPictureResponseData UploadDeviceCoverPictureResponseData;
	typedef typename UploadDeviceCoverPictureResponse::UploadDeviceCoverPictureResponseData::UploadDeviceCoverPictureResponseData_Result UploadDeviceCoverPictureResponseData_Result;
	typedef typename UploadDeviceCoverPictureResponse::UploadDeviceCoverPictureResponseData::UploadDeviceCoverPictureResponseData_Result::UploadDeviceCoverPictureResponseData_Result_Data UploadDeviceCoverPictureResponseData_Result_Data;

}
}

#endif
