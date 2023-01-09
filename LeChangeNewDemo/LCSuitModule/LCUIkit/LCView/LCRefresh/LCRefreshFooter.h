//
//  Copyright © 2015 LeChange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefreshFooter.h>
#import <MJRefresh/MJRefresh.h>

@interface LCRefreshFooter : MJRefreshBackStateFooter

@property (strong,nonatomic) NSString *pullString;
@property (strong,nonatomic) NSString *noMoreDataString;
@property (strong,nonatomic) NSString *refreshString;

@end

