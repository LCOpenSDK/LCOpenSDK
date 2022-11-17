//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

import UIKit

struct LCAddDeviceTest {
	
#if DEBUG
	/// 【Warning...】调用时使用，发测必须重置为false.
	static let openTest: Bool = false
#else
	/// 【Warning...】调用时使用，发测必须重置为false.
	static let openTest: Bool = false
#endif

	
	static var failureIndex: Int = 0
	
	static var testSoundWave: Bool = true
	
	/// 软AP连接乐橙云平台超时界面
	static let apConnectTimeoutType: LCNetConnectFailureType = .overseasDoorbell
}
