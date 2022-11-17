//
//  Copyright © 2015年 Imou. All rights reserved.
//

#import <MJRefresh/MJRefreshHeader.h>
#import <MJRefresh/MJRefresh.h>

@interface LCMessageRefreshHeader : MJRefreshHeader

@property (assign,nonatomic) BOOL hideTips;
@property (strong,nonatomic) NSString *pullString;
@property (strong,nonatomic) NSString *releaseString;
@property (strong,nonatomic) NSString *refreshString;
@end
