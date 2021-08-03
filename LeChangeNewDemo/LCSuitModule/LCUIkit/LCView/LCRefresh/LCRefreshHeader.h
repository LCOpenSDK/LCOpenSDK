//
//  Copyright © 2015年 dahua. All rights reserved.
//

#import <MJRefresh/MJRefreshHeader.h>
#import <MJRefresh/MJRefresh.h>

@interface LCRefreshHeader : MJRefreshHeader

@property (assign,nonatomic) BOOL hideTips;
@property (strong,nonatomic) NSString *pullString;
@property (strong,nonatomic) NSString *releaseString;
@property (strong,nonatomic) NSString *refreshString;
@end
