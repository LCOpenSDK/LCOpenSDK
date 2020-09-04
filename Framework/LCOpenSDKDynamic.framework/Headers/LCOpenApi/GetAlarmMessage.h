/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: 79835, Author: 32725, Date: 2017-11-10 11:03:30 +0800 
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_GetAlarmMessage_H_
#define _LC_OPENAPI_CLIENT_GetAlarmMessage_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
分页查询报警信息

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class GetAlarmMessageRequest : public LCOpenApiRequest
	{
	public:
		class GetAlarmMessageRequestData
		{
		public:
			GetAlarmMessageRequestData();
			~GetAlarmMessageRequestData();
			
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** 开始时间，如2010-05-25 00:00:00 */
			string beginTime;
		public:
			/** [cstr]getAlarmMessage */
			#define _STATIC_GetAlarmMessageRequestData_method "getAlarmMessage"
			string method;
		public:
			/** 拉取报警消息的个数，最大值为100 */
			string count;
		public:
			/** 结束时间，如2010-05-25 23:59:59 */
			string endTime;
		public:
			/** 通道ID */
			string channelId;
		public:
			/** 不填写默认从头开始拉去 */
			string nextAlarmId;
		public:
			/** 设备ID */
			string deviceId;

		};
	public:
		GetAlarmMessageRequest();
		~GetAlarmMessageRequest();
	public:
		virtual int build();
	public:
		GetAlarmMessageRequestData data;
	};

	
	typedef typename GetAlarmMessageRequest::GetAlarmMessageRequestData GetAlarmMessageRequestData;


	class GetAlarmMessageResponse : public LCOpenApiResponse
	{
	public:
		class GetAlarmMessageResponseData
		{
		public:
			GetAlarmMessageResponseData();
			~GetAlarmMessageResponseData();
			
		public:
			/** 当前报警消息列表最后一条报警消息Id */
			string nextAlarmId;
		public:
			/** [int]当前获取到的报警消息总数 */
			int count;
		public:
			/** define a list with struct of GetAlarmMessageResponseData_AlarmsElement */
			class GetAlarmMessageResponseData_AlarmsElement : public LCOpenApiBase
			{
			public:
				GetAlarmMessageResponseData_AlarmsElement();
				~GetAlarmMessageResponseData_AlarmsElement();
			public:
				/** [int]报警类型 */
				int type;
			public:
				/** 缩略图URL */
				string thumbUrl;
			public:
				/** 设备ID */
				string deviceId;
			public:
				/** [long]报警消息ID */
				int64 alarmId;
			public:
				/** [long]报警时间UNIX时间戳秒 */
				int64 time;
			public:
				/** 报警图片url */
				LCOpenApiVector<string> picurlArray;
			public:
				/** 通道号 */
				string channelId;
			public:
				/** 设备或通道的名称 */
				string name;
			public:
				/** 报警时设备本地时间，格式如2014-12-12 12:12:12 */
				string localDate;
			};
		public:
			LCOpenApiVector<GetAlarmMessageResponseData_AlarmsElement> alarms;

		};
	public:
		GetAlarmMessageResponse();
		~GetAlarmMessageResponse();
	public:
		virtual int parse();
	public:
		GetAlarmMessageResponseData data;
	};

	
	typedef typename GetAlarmMessageResponse::GetAlarmMessageResponseData GetAlarmMessageResponseData;
	typedef typename GetAlarmMessageResponse::GetAlarmMessageResponseData::GetAlarmMessageResponseData_AlarmsElement GetAlarmMessageResponseData_AlarmsElement;

}
}

#endif
