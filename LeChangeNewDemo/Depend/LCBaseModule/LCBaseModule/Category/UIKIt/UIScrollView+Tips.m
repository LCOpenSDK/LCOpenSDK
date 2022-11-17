//
//  Copyright (c) 2015年 Imou. All rights reserved.

#import <LCBaseModule/UIScrollView+Tips.h>
#import <LCBaseModule/UIColor+LeChange.h>
#import <LCBaseModule/UIFont+Imou.h>
#import <LCBaseModule/LCModuleConfig.h>
#import <objc/runtime.h>
#import <Masonry/Masonry.h>
#import <LCBaseModule/UIScrollView+Empty.h>


#define BLANKIMAGETAG        10001
static char UIScrollViewTipsButtonClickedBlock = '\0';

@implementation  UIScrollView(Tips)

- (UIView *)lc_getTipsView:(TipsType)type {
    
    __block UIView *emptyView;
    __weak typeof(self) weakSelf = self;
    
    [self tipsInfo:type completion:^(NSString *imageName, NSString *title) {
        
        emptyView = [weakSelf getEmptyViewByName:imageName title:title];
    }];
    return emptyView;
}

- (void)lc_addTipsView:(TipsType)type {
    
    __weak typeof(self) weakSelf = self;
    [self tipsInfo:type completion:^(NSString *imageName, NSString *title) {
        
        [weakSelf lc_setEmyptImageName:imageName andDescription:title];
    }];
}

- (void)lc_addTipsViewModifyFrame {
    UIImageView *imgView = (UIImageView *)[self viewWithTag:BLANKIMAGETAG];
    
    [imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.lc_emptyView).mas_offset(20);
    }];
}

- (void)tipsInfo:(TipsType)type completion:(void (^)(NSString *imageName, NSString *title))finish{
    NSString *title;
    NSString *imageName;
    
    switch (type) {
        case TipsTypeMessageNone:
            title = @"message_message_emptymsg".lc_T;
            imageName = @"common_pic_nomessage";
            break;
        case TipsTypeAlarmNone:
            title = @"common_tip_none_set_remind".lc_T;
            imageName = @"device_alarm_none";
            break;
        case TipsTypeDeviceNone:
            title = @"common_no_devices".lc_T;
            imageName = @"device_none";
            break;
        case TipsTypeDeviceAPNone:
            title = @"device_manager_no_ap".lc_T;
            imageName = @"common_pic_nodevice";
            break;
        case TipsTypeDeviceShareNone:
            title = @"common_tip_none_share_people".lc_T;
            imageName = @"device_share_none";
            break;
        case TipsTypeCloudNone:
            title = @"mobile_common_bec_cloud_storage_no_default".lc_T;
            imageName = @"cloudstorage_defaultpage_noticket";
            break;
        case TipsTypeWifiNone:
            title = @"mobile_common_img_no_internet_tip".lc_T;
            imageName = @"common_pic_nointernet";
            break;
        case TipsTypeDeviceOffline:
            title = @"Common_Tip_DeviceOffline".lc_T;
            imageName = @"device_none";
            break;
        case TipsTypeLiveListNone:
            title = @"common_tip_none_live".lc_T;
            imageName = @"live_icon_nolive";
            break;
        case  TipsTypeCommentListNone:
            title = @"common_tip_none_comment".lc_T;
            imageName = @"live_icon_noanswer";
            break;
        case TipsTypeFail:
            title = @"mobile_common_bec_common_network_unusual".lc_T;
            imageName = @"common_pic_nointernet";
            break;
        case TipsTypeNetError:
            title = @"device_manager_no_network_tip".lc_T;
            imageName = @"common_pic_nointernet";
            break;
        case TipsTypeUpdate:
            title = @"common_tip_click_refresh".lc_T;
            imageName = @"common_pic_nointernet";
            break;
        case TipsTypeNoVideoMsg:
            title = @"common_tip_none_message".lc_T;
            imageName = @"message_none";
            break;
        case TipsTypeNoCollection:
            title = @"play_module_media_play_no_fav_point".lc_T;
            imageName = @"common_pic_norecord";
            break;
        case TipsTypeNoOneDayVideo:
            title = @"Common_Tip_NoOneDayVideo".lc_T;
            imageName = @"common_pic_novideotape";
            break;
        case TipsTypeNoFriendMsg:
            title = @"Common_Tip_NoFriendMsg".lc_T;
            imageName = @"message_none";
            break;
        case TipsTypeNoVideotape:
            title = @"play_record_no_record".lc_T;
            imageName = @"common_pic_novideotape";
            break;
        case TipsTypeNoAuthority:
            title = @"common_no_authority".lc_T;
            imageName = @"common_pic_noauth";
            break;
        case TipsTypeNoSdCard:
            title = @"device_manager_no_storage".lc_T;
            imageName = @"devicemanage_icon_notfcard";
            break;
        case TipsTypeNoSearchResult:
            title = @"device_manager_list_no_device_find".lc_T;
            imageName = @"devicemanager_common_noresult";
            break;
        default:
            title = @"mobile_common_bec_common_network_unusual".lc_T;
            imageName = @"common_pic_nointernet";
            break;
    }
    
    if (finish) {
        finish(imageName, title);
    }
}

- (void)lc_clearTipsView {
    
   [self lc_clearEmptyViewInfo];
    objc_setAssociatedObject(self, &UIScrollViewTipsButtonClickedBlock, nil, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)getEmptyViewByImage:(UIImage *)image title:(NSString *)title {
    UIView *emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    
    UIImage *emptyImage = image;
    UIImageView *emptyImageView = [[UIImageView alloc]initWithImage:emptyImage];
    [emptyView addSubview:emptyImageView];
    emptyImageView.tag = BLANKIMAGETAG;
    
    [emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if ([self isKindOfClass:[UITableView class]])
        {
            NSLog(@"%@", @"contentSize change----");
            UITableView *tv = (UITableView *)self;
            make.centerY.equalTo(emptyView).offset((tv.tableHeaderView.frame.size.height + emptyImage.size.height)/6).multipliedBy(2.0/3.0);
        }
        else
        {
            make.centerY.equalTo(emptyView).offset(emptyImage.size.height/6).multipliedBy(2.0/3.0);
        }
        
        make.width.mas_equalTo(emptyImage.size.width);
        make.height.mas_equalTo(emptyImage.size.height);
        make.centerX.equalTo(emptyView);
    }];
    
    UILabel *wordLbl = [[UILabel alloc]initWithFrame:CGRectZero];
    wordLbl.tag = 100;
    wordLbl.textColor = [UIColor lccolor_c41];
    wordLbl.textAlignment = NSTextAlignmentCenter;
    wordLbl.font = [UIFont lcFont_t2];
    wordLbl.numberOfLines = 0;
    wordLbl.lineBreakMode = NSLineBreakByWordWrapping;
    
    if([title isKindOfClass:[NSAttributedString class]])
    {
        wordLbl.attributedText = (NSAttributedString *)title;
    }else
    {
        wordLbl.text = title;
    }
    [emptyView addSubview:wordLbl];
    
    [wordLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emptyImageView.mas_bottom).offset(6.0);
        make.centerX.equalTo(emptyView);
        make.left.mas_equalTo(5);
    }];
    
    return emptyView;
}


- (UIView *)getEmptyViewByName:(NSString *)imageName title:(NSString *)title {
	UIImage *image = [UIImage imageNamed:imageName];
	return [self getEmptyViewByImage:image title:title];
}

-(void)buttonClicked:(UIButton *)btn
{
    void(^buttonClickedBlock)() = objc_getAssociatedObject(self,  &UIScrollViewTipsButtonClickedBlock);
    if (buttonClickedBlock)
    {
        buttonClickedBlock();
    }
}

#pragma mark - lechange ui

- (void)lc_setEmyptImageName:(NSString *)imageName andDescription:(id )description
{
    UIView *emptyView = [self getEmptyViewByName:imageName title:description];
    self.lc_emptyView = emptyView;
}
- (void)lc_setEmyptImageName:(NSString *)imageName andDescription:(id )description ClickedBlock:(void (^)(void))block
{
    UIView *emptyView = [self getEmptyViewByName:imageName title:description];
    self.lc_emptyView = emptyView;
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [emptyView addSubview:button];
    
    button.frame = emptyView.bounds;
    
    objc_setAssociatedObject(self, &UIScrollViewTipsButtonClickedBlock, block, OBJC_ASSOCIATION_COPY);
}
- (void)lc_setEmyptImageName:(NSString *)imageName andDescription:(id )description userInteractionEnabled:(BOOL)enable
{
	UIView *emptyView = [self getEmptyViewByName:imageName title:description];
	emptyView.userInteractionEnabled = enable;
	self.lc_emptyView = emptyView;
    
}

- (void)lc_setEmyptImageName:(NSString *)imageName andDescription:(id )description andButtonTitle:(NSString *)buttonTitle withButtonClickedBlock:(void(^)(void))block
{
    UIView *emptyView = [self getEmptyViewByName:imageName title:description];
    self.lc_emptyView = emptyView;
    
    UILabel *titleLabel = (UILabel *)[emptyView viewWithTag:100];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor lccolor_c0];
    button.layer.cornerRadius = 20;
    button.titleLabel.font = UIFont.lcFont_t4;
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lccolor_c43] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [emptyView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(emptyView);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    
    objc_setAssociatedObject(self, &UIScrollViewTipsButtonClickedBlock, block, OBJC_ASSOCIATION_COPY);
}

- (void)lc_setEmptyImage:(UIImage *)image description:(id)description {
	UIView *emptyView = [self getEmptyViewByImage:image title:description];
    self.lc_emptyView = emptyView;
}

- (void)lc_setEmyptImageName:(NSString *)imageName emptyTitle:(NSString *)title emptyDescription:(NSString *)description {
    UIView *emptyView = [self getEmptyViewByName:imageName title:title];
    self.lc_emptyView = emptyView;
    
    UILabel *titleLabel = (UILabel *)[emptyView viewWithTag:100];
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.textColor = UIColor.lccolor_c5;
    desLabel.font = [UIFont lcFont_t6];
    desLabel.text = description;
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.numberOfLines = 0;
    [emptyView addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(7.0);
        make.centerX.equalTo(emptyView);
        make.left.mas_equalTo(5);
    }];
}

-(void)lc_setEmyptImageName:(NSString *)imageName emptyDescription:(NSString *)description customView:(UIView *)customView{
    UIView *emptyView = [self getEmptyViewByName:imageName title:description];
    self.lc_emptyView = emptyView;
    [emptyView addSubview:customView];
    UILabel *titleLabel = (UILabel *)[emptyView viewWithTag:100];
    [customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.centerX.equalTo(emptyView);
    }];
}

- (void)setTapBtn:(UIButton *)tapBtn
{
    objc_setAssociatedObject(self, @"emptyBtnClick", tapBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)tapBtn
{
    return objc_getAssociatedObject(self, @"emptyBtnClick");
}

- (void)setTapImageView:(UIImageView *)tapImageView
{
    objc_setAssociatedObject(self, @"emptyTapGestureClick", tapImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)tapImageView
{
    return objc_getAssociatedObject(self, @"emptyTapGestureClick");
}

//由于空视图页面层级最高，覆盖住了其他页面的响应事件，故作此响应事件穿透
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 1.这是当前点击的视图，如果没有找到合适的响应操作的视图，则直接返回这个
    UIView *view = [super hitTest:point withEvent:event];

    //2.将父视图坐标转成我想要响应事件的视图的坐标
    CGPoint buttonPoint = [self convertPoint:point toView:self.tapBtn];
    CGPoint tapPoint    = [self convertPoint:point toView:self.tapImageView];

    // 3.判断该坐标是否在视图内部，如果是，则返回该视图
    if ([self.tapBtn pointInside:buttonPoint withEvent:event]) {
        return self.tapBtn;
    } else if ([self.tapImageView pointInside:tapPoint withEvent:event]) {
        return self.tapImageView;
    }
    return view;
}

@end
