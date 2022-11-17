//
//

#import "LCDateFormatter.h"

@implementation LCDateFormatter

- (instancetype)initWithGregorianCalendar
{
    self = [super init];
    if (self) {
        /*
         设置日历
         NSCalendarIdentifierGregorian : 公历
         NSCalendarIdentifierBuddhist  : 佛历
         NSCalendarIdentifierChinese   : 中国阴历
         NSCalendarIdentifierIndian    : 印度日历
         NSCalendarIdentifierJapanese  : 日本日历
         NSCalendarIdentifierRepublicOfChina : 台湾日历
         */
        [self setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
        [self setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        /*
         设置日历
         NSCalendarIdentifierGregorian : 公历
         NSCalendarIdentifierBuddhist  : 佛历
         NSCalendarIdentifierChinese   : 中国阴历
         NSCalendarIdentifierIndian    : 印度日历
         NSCalendarIdentifierJapanese  : 日本日历
         NSCalendarIdentifierRepublicOfChina : 台湾日历
         */
        [self setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
        // 适配iOS13 12小时进制转换问题
        [self setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    }
    return self;
}

- (nullable instancetype)initWithCalendarIdentifier:(NSCalendarIdentifier)ident;
{
    self = [super init];
    if (self) {
        /*
         设置日历
         NSCalendarIdentifierGregorian : 公历
         NSCalendarIdentifierBuddhist  : 佛历
         NSCalendarIdentifierChinese   : 中国阴历
         NSCalendarIdentifierIndian    : 印度日历
         NSCalendarIdentifierJapanese  : 日本日历
         NSCalendarIdentifierRepublicOfChina : 台湾日历
         */
        [self setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:ident]];
        
    }
    return self;
}





@end
