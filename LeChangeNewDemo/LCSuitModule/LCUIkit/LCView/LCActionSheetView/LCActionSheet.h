//
//  Copyright © 2018年 Imou. All rights reserved.
//

#import "LCUIKit.h"


@class LCActionSheet;
@protocol LCActionSheetDelegate <NSObject>

- (void)actionSheetSubmit:(LCActionSheet *)actionSheet;
- (void)actionSheetCancel:(LCActionSheet *)actionSheet;

@end

@interface LCActionSheet : UIView

@property (nonatomic, assign) id<LCActionSheetDelegate> delegate;
@property (nonatomic, strong) NSString *selectedData;//当前选中的数据

- (instancetype)initWithDataArray:(NSArray *)dataArray delegate:(id<LCActionSheetDelegate>)delegate title:(NSString *)title unit:(NSString *)unit cancelButtonTitle:(NSString *)cancelButtonTitle submitButtonTitle:(NSString *)submitButtonTitle;

- (void)show;
- (void)dismiss;
@end
