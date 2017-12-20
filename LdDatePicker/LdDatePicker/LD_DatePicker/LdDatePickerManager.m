//
//  LdDatePickerManager.m
//  LdDatePicker
//
//  Created by lv on 2017/12/20.
//  Copyright © 2017年 lv. All rights reserved.
//

#import "LdDatePickerManager.h"
#import "NSDate+Attribute.h"

@implementation LdDatePickerManager
/**
 *  isBlankString:
 *  字符串是否为空
 *  @param  string          输入要判断的字符串
 */
+ (BOOL) isBlankString: (NSString *)string
{
    if (string == nil || string == NULL)
    {
        return YES;
    }
    if ([string isKindOfClass: [NSNull class]])
    {
        return YES;
    }
    if ([string isKindOfClass: [NSString class]] &&
        [[string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] == 0)
    {
        return YES;
    }
    if ([string isEqualToString: @""])
    {
        return YES;
    }
    
    return NO;
}

/**
 *  日期格式字符串
 *  @param  mode    日期类型
 */
+ (NSString *)dateFormatterStrWithMode: (DateMode)mode
{
    NSString *dateFormatterStr = @"";
    switch (mode) {
        case DateModeAll:
            dateFormatterStr = @"yyyy-MM-dd HH:mm:ss";
            break;
            
        case DateModeNoSecond:
            dateFormatterStr = @"yyyy-MM-dd HH:mm";
            break;
            
        case DateModeNoMinute:
            dateFormatterStr = @"yyyy-MM-dd HH";
            break;
            
        case DateModeNoTime:
            dateFormatterStr = @"yyyy-MM-dd";
            break;
            
        case DateModeNoDay:
            dateFormatterStr = @"yyyy-MM";
            break;
            
        case DateModeDT_YAll:
            dateFormatterStr = @"MM-dd HH:mm:ss";
            break;
            
        case DateModeDT_YNoSecond:
            dateFormatterStr = @"MM-dd HH:mm";
            break;
            
        case DateModeDT_YNoMinute:
            dateFormatterStr = @"MM-dd HH";
            break;
            
        case DateModeDT_YNoTime:
            dateFormatterStr = @"MM-dd";
            break;
            
        case DateModeTimeAll:
            dateFormatterStr = @"HH:mm:ss";
            break;
            
        case DateModeTimeNoSecond:
            dateFormatterStr = @"HH:mm";
            break;
            
        default:
            dateFormatterStr = @"yyyy-MM-dd HH:mm:ss";
            break;
    }
    
    return dateFormatterStr;
}

/**
 *  获取日期格式
 *  @param  mode        日期格式
 */
+ (NSDateFormatter *) gainDateFormatterWithDateMode: (DateMode)mode
{
    NSString *dateFormatterStr = [LdDatePickerManager dateFormatterStrWithMode: mode];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat: dateFormatterStr];
    
    return dateFormatter;
}

/**
 *  获取pickerView列数
 *  @param  mode    日期格式
 */
+ (NSInteger) numberOfComponentsInPickerView: (DateMode)mode
{
    NSInteger components = 6;
    switch (mode) {
        case DateModeAll:
            components = 6;
            break;
            
        case DateModeNoSecond:
        case DateModeDT_YAll:
            components = 5;
            break;
            
        case DateModeNoMinute:
        case DateModeDT_YNoSecond:
            components = 4;
            break;
            
        case DateModeNoTime:
        case DateModeDT_YNoMinute:
        case DateModeTimeAll:
            components = 3;
            break;
            
        case DateModeNoDay:
        case DateModeDT_YNoTime:
        case DateModeTimeNoSecond:
            components = 2;
            break;

        default:
            components = 6;
            break;
    }
    
    return components;
}

/**
 *  根据日期类型获取日期
 *  @param  mode        日期格式
 *  @param  pendingStr  待处理日期
 */
+ (NSString *) handleDataStrWithDateMode: (DateMode)mode
                              pendingStr: (NSString *)pendingStr
{
    NSString *dateFormatterStr = [LdDatePickerManager dateFormatterStrWithMode: mode];
    dateFormatterStr = [dateFormatterStr stringByReplacingOccurrencesOfString: @" " withString: @"-"];
    dateFormatterStr = [dateFormatterStr stringByReplacingOccurrencesOfString: @":" withString: @"-"];
    NSDateFormatter *pendingFormatter = [[NSDateFormatter alloc] init];
    [pendingFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [pendingFormatter setDateFormat: dateFormatterStr];
    NSDate *pendingDate = [pendingFormatter dateFromString: pendingStr];
    
    NSDateFormatter *dateFormatter = [LdDatePickerManager gainDateFormatterWithDateMode: mode];
    NSString *resultStr = [dateFormatter stringFromDate: pendingDate];
    return resultStr;
}

/**
 *  预设数据通过日期格式
 *  @param  mode        日期格式
 */
+ (NSMutableArray *) presetDataWithMode: (DateMode)mode
{
    NSDate *date = [NSDate date];
    NSInteger year = date.dateYear;
    NSInteger month = date.dateMonth;
    
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    
    switch (mode) {
        case DateModeAll:
            
            [dataArr removeAllObjects];
            [dataArr addObject: [LdDatePickerManager gainYearArrWithCurrentYear: year]];
            [dataArr addObject: [LdDatePickerManager gainMonthArr]];
            [dataArr addObject: [LdDatePickerManager gainDayArrWithYear: year month: month]];
            [dataArr addObject: [LdDatePickerManager gainHourArr]];
            [dataArr addObject: [LdDatePickerManager gainMinuteArr]];
            [dataArr addObject: [LdDatePickerManager gainSecondArr]];

            break;
            
        case DateModeNoSecond:

            [dataArr removeAllObjects];
            [dataArr addObject: [LdDatePickerManager gainYearArrWithCurrentYear: year]];
            [dataArr addObject: [LdDatePickerManager gainMonthArr]];
            [dataArr addObject: [LdDatePickerManager gainDayArrWithYear: year month: month]];
            [dataArr addObject: [LdDatePickerManager gainHourArr]];
            [dataArr addObject: [LdDatePickerManager gainMinuteArr]];
            
            break;
            
        case DateModeNoMinute:
            
            [dataArr removeAllObjects];
            [dataArr addObject: [LdDatePickerManager gainYearArrWithCurrentYear: year]];
            [dataArr addObject: [LdDatePickerManager gainMonthArr]];
            [dataArr addObject: [LdDatePickerManager gainDayArrWithYear: year month: month]];
            [dataArr addObject: [LdDatePickerManager gainHourArr]];
            
            break;
            
        case DateModeNoTime:

            [dataArr removeAllObjects];
            [dataArr addObject: [LdDatePickerManager gainYearArrWithCurrentYear: year]];
            [dataArr addObject: [LdDatePickerManager gainMonthArr]];
            [dataArr addObject: [LdDatePickerManager gainDayArrWithYear: year month: month]];
            
            break;
            
        case DateModeNoDay:

            [dataArr removeAllObjects];
            [dataArr addObject: [LdDatePickerManager gainYearArrWithCurrentYear: year]];
            [dataArr addObject: [LdDatePickerManager gainMonthArr]];
            
            break;
            
        case DateModeDT_YAll:
            
            [dataArr removeAllObjects];
            [dataArr addObject: [LdDatePickerManager gainMonthArr]];
            [dataArr addObject: [LdDatePickerManager gainDayArrWithYear: year month: month]];
            [dataArr addObject: [LdDatePickerManager gainHourArr]];
            [dataArr addObject: [LdDatePickerManager gainMinuteArr]];
            [dataArr addObject: [LdDatePickerManager gainSecondArr]];
            
            break;
            
        case DateModeDT_YNoSecond:

            [dataArr removeAllObjects];
            [dataArr addObject: [LdDatePickerManager gainMonthArr]];
            [dataArr addObject: [LdDatePickerManager gainDayArrWithYear: year month: month]];
            [dataArr addObject: [LdDatePickerManager gainHourArr]];
            [dataArr addObject: [LdDatePickerManager gainMinuteArr]];
            
            break;
            
        case DateModeDT_YNoMinute:

            [dataArr removeAllObjects];
            [dataArr addObject: [LdDatePickerManager gainMonthArr]];
            [dataArr addObject: [LdDatePickerManager gainDayArrWithYear: year month: month]];
            [dataArr addObject: [LdDatePickerManager gainHourArr]];
            
            break;
            
        case DateModeDT_YNoTime:

            [dataArr removeAllObjects];
            [dataArr addObject: [LdDatePickerManager gainMonthArr]];
            [dataArr addObject: [LdDatePickerManager gainDayArrWithYear: year month: month]];
            
            break;
            
        case DateModeTimeAll:

            [dataArr removeAllObjects];
            [dataArr addObject: [LdDatePickerManager gainHourArr]];
            [dataArr addObject: [LdDatePickerManager gainMinuteArr]];
            [dataArr addObject: [LdDatePickerManager gainSecondArr]];
            
            break;
            
        case DateModeTimeNoSecond:

            [dataArr removeAllObjects];
            [dataArr addObject: [LdDatePickerManager gainHourArr]];
            [dataArr addObject: [LdDatePickerManager gainMinuteArr]];
            
            break;
            
        default:
            
            [dataArr removeAllObjects];
            [dataArr addObject: [LdDatePickerManager gainYearArrWithCurrentYear: year]];
            [dataArr addObject: [LdDatePickerManager gainMonthArr]];
            [dataArr addObject: [LdDatePickerManager gainDayArrWithYear: year month: month]];
            [dataArr addObject: [LdDatePickerManager gainHourArr]];
            [dataArr addObject: [LdDatePickerManager gainMinuteArr]];
            [dataArr addObject: [LdDatePickerManager gainSecondArr]];
            
            break;
    }
    
    return dataArr;
}

/**
 *  年
 */
+ (NSArray *)gainYearArrWithCurrentYear: (NSInteger)currentYear
{
    NSInteger max = currentYear + 50;
    NSInteger min = currentYear - 50;
    return [LdDatePickerManager gainYearArrWithMaxYear: max minYear: min];
}

+ (NSArray *)gainYearArrWithMaxYear: (NSInteger)max
                            minYear: (NSInteger)min
{
    NSMutableArray *yearArr = [[NSMutableArray alloc] init];
    for (NSInteger i = min; i <= max; i++)
    {
        [yearArr addObject: [NSString stringWithFormat: @"%ld", (long)i]];
    }
    
    NSArray *resultArr = [NSArray arrayWithArray: yearArr];
    return resultArr;
}

/**
 *  月
 */
+ (NSArray *)gainMonthArr
{
    NSMutableArray *monthArr = [[NSMutableArray alloc] init];
    for (int i = 1; i < 13; i ++)
    {
        [monthArr addObject: [NSString stringWithFormat: @"%02d", i]];
    }
    
    NSArray *resultArr = [NSArray arrayWithArray: monthArr];
    return resultArr;
}

/**
 *  日
 */
+ (NSArray *)gainDayArr
{
    NSMutableArray *dayArr = [[NSMutableArray alloc] init];
    for (int i = 1; i < 32; i ++)
    {
        [dayArr addObject: [NSString stringWithFormat: @"%02d", i]];
    }
    
    NSArray *resultArr = [NSArray arrayWithArray: dayArr];
    return resultArr;
}
+ (NSArray *)gainDayArrWithYear: (NSInteger)year
                          month: (NSInteger)month
{
    int dayTemp = 0;
    if (month == 2)
    {
        if (year % 4 == 0)
        {
            dayTemp = 29;
        }
        else
        {
            dayTemp = 28;
        }
    }
    else if (month == 1 ||
             month == 3 ||
             month == 5 ||
             month == 7 ||
             month == 8 ||
             month == 10 ||
             month == 12)
    {
        dayTemp = 31;
    }
    else
    {
        dayTemp = 30;
    }
    
    NSMutableArray *dayArr = [[NSMutableArray alloc] init];
    for (int i = 1; i <= dayTemp; i ++)
    {
        NSString *dayStr = [NSString stringWithFormat: @"%02d", i];
        [dayArr addObject: dayStr];
    }
    
    return dayArr;
}

/**
 *  时
 */
+ (NSArray *)gainHourArr
{
    NSMutableArray *hourArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 24; i ++)
    {
        [hourArr addObject: [NSString stringWithFormat: @"%02d", i]];
    }
    
    NSArray *resultArr = [NSArray arrayWithArray: hourArr];
    return resultArr;
}

/**
 *  分
 */
+ (NSArray *)gainMinuteArr
{
    NSMutableArray *minuteArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 60; i ++)
    {
        [minuteArr addObject: [NSString stringWithFormat: @"%02d", i]];
    }
    
    NSArray *resultArr = [NSArray arrayWithArray: minuteArr];
    return resultArr;
}

/**
 *  秒
 */
+ (NSArray *)gainSecondArr
{
    NSMutableArray *secondArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 60; i ++)
    {
        [secondArr addObject: [NSString stringWithFormat: @"%02d", i]];
    }
    
    NSArray *resultArr = [NSArray arrayWithArray: secondArr];
    return resultArr;
}

@end
