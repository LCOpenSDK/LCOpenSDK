/**
 *  Auto created by ApiCreator Tool.
 *  SVN Rev: unknown, Author: unknown, Date: unknown
 *  SHOULD NOT MODIFY!
 */
 
#ifndef _LC_OPENAPI_CLIENT_DeviceVersionList_H_
#define _LC_OPENAPI_CLIENT_DeviceVersionList_H_

#include "LCOpenApiDefine.h"
#include "LCOpenApiRequest.h"
#include "LCOpenApiResponse.h"

/** DESCRIPTION: 
获取设备可升级信息

 */

namespace Dahua{
namespace LCOpenApi{
	using namespace std;
	class DeviceVersionListRequest : public LCOpenApiRequest
	{
	public:
		class DeviceVersionListRequestData
		{
		public:
			DeviceVersionListRequestData();
			~DeviceVersionListRequestData();
			
		public:
			/** 授权token(userToken或accessToken) */
			string token;
		public:
			/** [cstr]deviceVersionList */
			#define _STATIC_DeviceVersionListRequestData_method "deviceVersionList"
			string method;
		public:
			/** 设备ID */
			string deviceIds;

		};
	public:
		DeviceVersionListRequest();
		~DeviceVersionListRequest();
	public:
		virtual int build();
	public:
		DeviceVersionListRequestData data;
	};

	
	typedef typename DeviceVersionListRequest::DeviceVersionListRequestData DeviceVersionListRequestData;


	class DeviceVersionListResponse : public LCOpenApiResponse
	{
	public:
		class DeviceVersionListResponseData
		{
		public:
			DeviceVersionListResponseData();
			~DeviceVersionListResponseData();
			
		public:
			/** [int]返回的设备列表总数 */
			int count;
		public:
			/** define a list with struct of DeviceVersionListResponseData_DeviceVersionListElement */
			class DeviceVersionListResponseData_DeviceVersionListElement : public LCOpenApiBase
			{
			public:
				DeviceVersionListResponseData_DeviceVersionListElement();
				~DeviceVersionListResponseData_DeviceVersionListElement();
			public:
				/** [bool]是否可以升级true : 有新版本可以升级,返回upgradeInfo字段信息, false : 不可以升级, 不需要返回upgradeInfo字段 */
				bool canBeUpgrade;
			public:
				/** define a list with struct of DeviceVersionListResponseData_DeviceVersionListElement_UpgradeInfo */
				class DeviceVersionListResponseData_DeviceVersionListElement_UpgradeInfo : public LCOpenApiBase
				{
				public:
					DeviceVersionListResponseData_DeviceVersionListElement_UpgradeInfo();
					~DeviceVersionListResponseData_DeviceVersionListElement_UpgradeInfo();
				public:
					/** [String]升级包url地址 */
					string packageUrl;
				public:
					/** [String]升级包描述信息 */
					string description;
				public:
					/** [String]升级包版本号 */
					string version;
				};
			public:
				DeviceVersionListResponseData_DeviceVersionListElement_UpgradeInfo* upgradeInfo;
			public:
				/** [String]设备当前版本号 */
				string version;
			public:
				/** [String]设备序列号 */
				string deviceId;
			};
		public:
			LCOpenApiVector<DeviceVersionListResponseData_DeviceVersionListElement> deviceVersionList;

		};
	public:
		DeviceVersionListResponse();
		~DeviceVersionListResponse();
	public:
		virtual int parse();
	public:
		DeviceVersionListResponseData data;
	};

	
	typedef typename DeviceVersionListResponse::DeviceVersionListResponseData DeviceVersionListResponseData;
	typedef typename DeviceVersionListResponse::DeviceVersionListResponseData::DeviceVersionListResponseData_DeviceVersionListElement DeviceVersionListResponseData_DeviceVersionListElement;
	typedef typename DeviceVersionListResponse::DeviceVersionListResponseData::DeviceVersionListResponseData_DeviceVersionListElement::DeviceVersionListResponseData_DeviceVersionListElement_UpgradeInfo DeviceVersionListResponseData_DeviceVersionListElement_UpgradeInfo;

}
}

#endif
