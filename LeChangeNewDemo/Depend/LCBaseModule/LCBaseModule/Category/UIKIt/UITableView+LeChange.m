//
//  Copyright (c) 2015年 Anson. All rights reserved.
//

#import "UITableView+LeChange.h"
#import "NSString+LeChange.h"
#import <objc/runtime.h>
#import <LCBaseModule/LCPubDefine.h>

#define SECTION_FONT_SIZE 13

@implementation UITableView (LeChange)

- (void)lc_hiddenExternLine
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
    /*
     当tableview的dataSource为空时，也就是没有数据可显示时，该方法无效，只能在numberOfRowsInsection函数，通过判断dataSouce的数据个数，如果为零可以将tableview的separatorStyle设置为UITableViewCellSeparatorStyleNone去掉分割线，然后在大于零时将其设置为
     
     UITableViewCellSeparatorStyleSingleLine
     */
}

- (CGFloat)lc_getHeightOfSectionString:(NSString*)content {
    if (content == nil || content.length == 0) {
        return 0;
    }
    return [self lc_getHeightOfSectionString:content margin:15 defaultHeight:35 fontSize:SECTION_FONT_SIZE];
}

- (CGFloat)lc_getHeightOfSectionString:(NSString*)content margin:(CGFloat)margin defaultHeight:(CGFloat)defaultHeight fontSize:(CGFloat)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize size = CGSizeMake((CGFloat)(LC_SCREEN_SIZE_WIDTH - margin * 2), CGFLOAT_MAX);
    CGFloat headerHeight = [content lc_sizeWithFont:font  size:size].height + 15;
    headerHeight = headerHeight < defaultHeight ? defaultHeight : headerHeight;
    return headerHeight;
}

- (UIView*)lc_getSectionViewOfString:(NSString*)content {
    UIView *contentView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, LC_SCREEN_SIZE_WIDTH, [self lc_getHeightOfSectionString:content])];
    contentView.backgroundColor = [UIColor clearColor];
    UILabel *contentLabel = UILabel.new;
    contentLabel.frame = CGRectMake(15, 0, contentView.frame.size.width - 30, contentView.frame.size.height);
    contentLabel.font = [UIFont systemFontOfSize:SECTION_FONT_SIZE];
    contentLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    contentLabel.text = content;
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentJustified;
    [contentView addSubview:contentLabel];
    
    return contentView;
}

@end
