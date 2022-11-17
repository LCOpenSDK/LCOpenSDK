//
//  Copyright © 2018年 Imou. All rights reserved.
//

#import "LCActionSheet.h"
#define kDHActionSheetWindowTag         4590
#define kDHActionSheetButtonTag         990
#define kDHActionSheetAnimationTime     .3
#define kDHActionSheetTitleTag          4591

@interface LCActionSheet () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSString *_unit;
    NSString *firstSelectedText;
    NSString *secondSelectedText;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *keyArray;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) UILabel *unitLabel;

@end

@implementation LCActionSheet

- (instancetype)initWithDataArray:(NSArray *)dataArray delegate:(id<LCActionSheetDelegate>)delegate title:(NSString *)title unit:(NSString *)unit cancelButtonTitle:(NSString *)cancelButtonTitle submitButtonTitle:(NSString *)submitButtonTitle {
    _unit = unit;
    
    [self setDataSourceWithDataArr:dataArray];
    
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    CGRect winRect = keyWin.frame;
    
    self.backgroundView = [[UIView alloc] initWithFrame:winRect];
    self.backgroundView.backgroundColor = [UIColor lccolor_c51];
    
    self.backgroundView.tag = kDHActionSheetWindowTag;
    self.backgroundView.userInteractionEnabled = YES;
    [keyWin addSubview: self.backgroundView];
    
    self = [self initWithFrame:CGRectMake(0, winRect.size.height, winRect.size.width, 240)];
    [keyWin addSubview:self];
    
    UIView *cancelTap = [[UIView alloc]initWithFrame:CGRectMake(0, 0, winRect.size.width, winRect.size.height - 240)];
    cancelTap.backgroundColor = [UIColor lccolor_c43];
    cancelTap.alpha = .1;
    UIGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleBtnAction:)];
    [cancelTap addGestureRecognizer:tap];
    [self.backgroundView addSubview:cancelTap];
    
    self.backgroundColor = [UIColor lccolor_c43];
    
    _delegate = delegate;
    
    self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleBtn.frame = CGRectMake(0, 0, 70, 40);
    [self.cancleBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancleBtn addTarget:self action:@selector(cancleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancleBtn];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, winRect.size.width - 140, 40)];
    self.titleLabel.text = title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];

    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn.frame = CGRectMake(winRect.size.width - 70, 0, 70, 40);
    [self.submitBtn setTitle:submitButtonTitle forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitBtn];
    
    // 初始化pickerView
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, winRect.size.width, 200)];
    //指定数据源和委托
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.backgroundColor = [UIColor lccolor_c43];
    
    [self addSubview:self.pickerView];
    [self layoutUnitLabel];
    return self;
}
- (void)setDataSourceWithDataArr:(NSArray *)dataArr {
    
    self.keyArray = [NSMutableArray arrayWithCapacity:0];
    self.dataDic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < dataArr.count; i++) {
        NSString *dataStr = dataArr[i];
        if ([dataStr containsString:@"."]) {
            NSArray *sepDataArr = [dataStr componentsSeparatedByString:@"."];
            if ([self.keyArray containsObject:sepDataArr[0]]) {
                NSMutableArray *value = [self.dataDic valueForKey:sepDataArr[0]];
                [value addObject:sepDataArr[1]];
                [self.dataDic setValue:value forKey:sepDataArr[0]];
            } else {
                NSMutableArray *valueArr = [NSMutableArray arrayWithObject:sepDataArr[1]];
                [self.keyArray addObject:sepDataArr[0]];
                [self.dataDic setValue:valueArr forKey:sepDataArr[0]];
            }
        } else {
            [self.keyArray addObject:dataArr[i]];
            [self.dataDic setValue:@[] forKey:dataArr[i]];
        }
    }
}
- (void)layoutUnitLabel {
    if (![_unit containsString:@"C"] && ![_unit containsString:@"%"]) {
        return;
    }
    self.unitLabel = [[UILabel alloc] init];
    if ([_unit containsString:@"C"]) {
        self.unitLabel.frame = CGRectMake(self.pickerView.frame.size.width - 100, self.pickerView.frame.size.height / 2 - 22, 44, 44);
        UILabel *dot = [[UILabel alloc] initWithFrame:CGRectMake(self.pickerView.frame.size.width  / 2 - 22, self.pickerView.frame.size.height / 2 - 22, 44, 44)];
        dot.text = @".";
        dot.textAlignment = NSTextAlignmentCenter;
        dot.font = [UIFont lcFont_t1];
        [self.pickerView addSubview:dot];
    } else {
        self.unitLabel.frame = CGRectMake(self.pickerView.frame.size.width  / 2 + 20, self.pickerView.frame.size.height / 2 - 22, 44, 44);
    }
    self.unitLabel.text = [self unitChange:_unit];
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
    self.unitLabel.font = [UIFont lcFont_t1];
    [self.pickerView addSubview:self.unitLabel];
}

#pragma mark UIPickerViewDelegate & UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([_unit containsString:@"C"]) {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([_unit containsString:@"C"]) {
        if (component == 0) {
           return self.keyArray.count;
        } else {
            NSArray *secondArr = [self.dataDic valueForKey:firstSelectedText];
            return secondArr.count;
        }
    }
    return self.keyArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (0 == component) {
        return self.keyArray[row];;
    } else if (1 == component) {
        NSArray *secondDataArr = self.dataDic[firstSelectedText];
        return secondDataArr[row];
    }
    return nil;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    NSArray *valueArr = [self.dataDic valueForKey:self.keyArray[0]];
    if (valueArr.count > 0) {
        return 100;
    }
    return 150.0;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        firstSelectedText = self.keyArray[row];
        NSArray *secondArr = self.dataDic[firstSelectedText];
        if (secondArr && secondArr.count > 0) {
            secondSelectedText = secondArr[0];
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        } else {
            secondSelectedText = @"";
        }
    } else if (component == 1) {
        // 设置第二个标题
        NSArray *secondArr = self.dataDic[firstSelectedText];
        if (secondArr && secondArr.count > 0) {
            secondSelectedText = secondArr[row];
        }
    }
    if (secondSelectedText.length > 0) {
        self.selectedData = [NSString stringWithFormat:@"%@.%@", firstSelectedText, secondSelectedText];
    } else {
        self.selectedData = firstSelectedText;
    }
    NSLog(@"TEXT======%@", self.selectedData);
}



- (void)setSelectedData:(NSString *)selectedData {
    _selectedData = selectedData;
    if ([selectedData containsString:@"."]) {
        NSArray *selectedArr = [selectedData componentsSeparatedByString:@"."];
        if ([self.keyArray containsObject:selectedArr[0]]) {
            NSInteger index1 = [self.keyArray indexOfObject:selectedArr[0]];
            NSArray *compArr = [self.dataDic valueForKey:selectedArr[0]];
            NSInteger index2 = 0;
            if ([compArr containsObject:selectedArr[1]]) {
                index2 = [compArr indexOfObject:selectedArr[1]];
            }
            firstSelectedText = selectedArr[0];
            secondSelectedText = selectedArr[1];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:index1 inComponent:0 animated:YES];
            [self.pickerView selectRow:index2 inComponent:1 animated:YES];
        }
    } else if ([self.keyArray containsObject:selectedData]) {
        firstSelectedText = selectedData;
        NSInteger index = [self.keyArray indexOfObject:selectedData];
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:index inComponent:0 animated:YES];
    }
}

- (void)show {
    [UIView animateWithDuration:kDHActionSheetAnimationTime animations:^{
        CGPoint point = self.center;
        CGFloat height = self.frame.size.height;
        self.center = CGPointMake(point.x, point.y - height);
    }];
}

- (void)submitBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(actionSheetSubmit:)]) {
        [_delegate actionSheetSubmit:self];
    }
    [self dismiss];
}

- (void)cancleBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(actionSheetCancel:)]) {
        [_delegate actionSheetCancel:self];
    }
    [self dismiss];
}

- (void)dismiss {
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    [UIView animateWithDuration:kDHActionSheetAnimationTime animations:^{
        CGPoint point = self.center;
        CGFloat height = self.frame.size.height;
        
        self.center = CGPointMake(point.x, point.y + height);
    } completion:^(BOOL beFinished){
        [self removeFromSuperview];
    }];
}
- (NSString *)unitChange:(NSString *)unit {
    if ([unit containsString:@"C"]) {
        unit = @"°C";
    }
    return unit;
}


@end
