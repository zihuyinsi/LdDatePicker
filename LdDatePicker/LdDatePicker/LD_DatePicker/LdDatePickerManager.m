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

#pragma mark - 日期格式
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
 *  setDate (默认时间、最小时间、最大时间) 转换为NSDate
 */
+ (NSDate *) defaultDateStr: (NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString: string];
    return date;
}

#pragma mark - PickerView
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
 *  获取pickerView选择结果
 */
+ (NSString *) pickerView:(UIPickerView *)pickerView
             didSelectRow:(NSInteger)row
              inComponent:(NSInteger)component
                 dateMode:(DateMode)mode
                  dataArr:(NSMutableArray *)dateArr
{
    //    UILabel *label = (UILabel *)[pickerView viewForRow: row forComponent: component];
    //    label.textColor = [UIColor colorWithRed: 1 green: 0.1 blue: 0.1 alpha: 1.f];
    
    if (mode == DateModeAll ||
        mode == DateModeNoSecond ||
        mode == DateModeNoMinute ||
        mode == DateModeNoTime)
    {
        if (component == 0)
        {
            NSString *yearStr = dateArr[component][row];
            NSInteger monthRow = [pickerView selectedRowInComponent: (component+1)];
            NSString *monthStr = dateArr[(component+1)][monthRow];
            
            NSArray *dayArr = [LdDatePickerManager gainDayArrWithYear: [yearStr integerValue]
                                                                month: [monthStr integerValue]];
            [dateArr replaceObjectAtIndex: (component+2) withObject: dayArr];
            [pickerView reloadComponent: (component+2)];
        }
        else if (component == 1)
        {
            NSString *monthStr = dateArr[component][row];
            NSInteger yearRow = [pickerView selectedRowInComponent: (component-1)];
            NSString *yearStr = dateArr[(component-1)][yearRow];
            
            NSArray *dayArr = [LdDatePickerManager gainDayArrWithYear: [yearStr integerValue]
                                                                month: [monthStr integerValue]];
            [dateArr replaceObjectAtIndex: (component+1) withObject: dayArr];
            [pickerView reloadComponent: (component+1)];
        }
    }
    else if (mode == DateModeDT_YAll ||
             mode == DateModeDT_YNoSecond ||
             mode == DateModeDT_YNoMinute ||
             mode == DateModeDT_YNoTime)
    {
        if (component == 0)
        {
            NSInteger year = [NSDate date].dateYear;
            NSString *monthStr = dateArr[component][row];
            
            NSArray *dayArr = [LdDatePickerManager gainDayArrWithYear: year
                                                                month: [monthStr integerValue]];
            [dateArr replaceObjectAtIndex: (component+1) withObject: dayArr];
            [pickerView reloadComponent: (component+1)];
        }
    }
    
    //各item标题
    NSString *pendingStr = @"";
    NSInteger numComponent = [LdDatePickerManager numberOfComponentsInPickerView: mode];
    for (int i = 0; i < numComponent; i ++)
    {
        NSInteger rowInCompoent = [pickerView selectedRowInComponent: i];
        NSString *tempStr = dateArr[i][rowInCompoent];
        
        if (i == 0)
        {
            pendingStr = tempStr;
        }
        else
        {
            pendingStr = [pendingStr stringByAppendingFormat: @"-%@", tempStr];
        }
    }
    NSLog(@"pendingStr = %@", pendingStr);
    NSString *resultStr = [LdDatePickerManager handleDataStrWithDateMode: mode
                                                              pendingStr: pendingStr];
    NSLog(@"resultStr = %@", resultStr);

    return resultStr;
}

#pragma mark - 选择结果处理
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

#pragma mark - 预设数据
/**
 *  预设数据 根据不同日期格式来进行数据的预设
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

#pragma mark - 年月日时分秒
/**
 *  年 默认年份，上下加50年作为年的数据
 */
+ (NSArray *)gainYearArrWithCurrentYear: (NSInteger)currentYear
{
    NSInteger max = currentYear + 50;
    NSInteger min = currentYear - 50;
    return [LdDatePickerManager gainYearArrWithMaxYear: max minYear: min];
}

/**
 *  年 更加设置的最大、最小年份 来处理年的数据
 */
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
 *  月 一年有12个月
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
 *  日 默认一天31天，特殊情况特殊处理
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

/**
 *  日 特殊情况处理，根据不同年份2月有不同天数，同时根据不同月份天数也不相同
 */
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
 *  时 一天24小时
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
 *  分 一小时60分钟
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
 *  秒 一分钟60秒
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

#pragma mark - 更新数据
+ (void) loadPickerDataWithTime: (NSString *)defaultTime
                        minTime: (NSString *)minTime
                        maxTime: (NSString *)maxTime
                       dateMode: (DateMode)dateMode
                        dataArr: (NSMutableArray *)dataArr
                     pickerView: (UIPickerView *)pickerView

{
    switch (dateMode) {
        case DateModeAll:
        case DateModeNoSecond:
        case DateModeNoMinute:
        case DateModeNoTime:
        case DateModeNoDay:
        {

            //最小时间
            if (![LdDatePickerManager isBlankString: minTime])
            {
                //设置有最小时间，更新picker数据
                NSMutableArray *yearArr = [NSMutableArray arrayWithArray: dataArr[0]];
                NSString *yearStr = yearArr[0];

                NSDate *date = [LdDatePickerManager defaultDateStr: minTime];
                NSInteger year = date.dateYear;
                //如果原始数据中年份大于最小限定年份
                if ([yearStr integerValue] > year)
                {
                    for (int i = 0; i < ([yearStr integerValue] - year); i++)
                    {
                        //向原始数据中添加年份（从原始数据中最小年份向下）直到年份等于最小限定年份
                        NSString *insertYearStr = [NSString stringWithFormat: @"%ld", (long)([yearStr integerValue] - (i+1))];
                        [yearArr insertObject: insertYearStr atIndex: 0];
                    }
                }
                //如果原始数据中年份小于最小限定年份
                else if ([yearStr integerValue] < year)
                {
                    for (int i = 0; i < [yearArr count]; i ++)
                    {
                        NSString *arrYearStr = yearArr[i];
                        if ([arrYearStr integerValue] < year)
                        {
                            //删除原始数据中年份小于最小限定年份的数据
                            [yearArr removeObject: arrYearStr];
                            
                            //数组减一，保证循环正常进行，对循环计数减一
                            i -= 1;
                        }
                        else
                        {
                            break;
                        }
                    }
                }
                
                //更新原始数据，刷新pickerView
                [dataArr replaceObjectAtIndex: 0 withObject: yearArr];
                [pickerView reloadComponent: 0];
            }
            
            //最大时间
            if (![LdDatePickerManager isBlankString: maxTime])
            {
                //设置有最大时间，更新picker数据
                NSMutableArray *yearArr = [NSMutableArray arrayWithArray: dataArr[0]];
                NSString *yearStr = [yearArr lastObject];
                
                NSDate *date = [LdDatePickerManager defaultDateStr: maxTime];
                NSInteger year = date.dateYear;
                //如果原始数据中年份小于最大限定年份
                if ([yearStr integerValue] < year)
                {
                    for (int i = 0; i < (year - [yearStr integerValue]); i++)
                    {
                        //向原始数据中添加年份（从原始数据中最大年份开始向上）直到年份等于最大限定年
                        NSString *insertYearStr = [NSString stringWithFormat: @"%ld", (long)([yearStr integerValue] + (i+1))];
                        [yearArr addObject: insertYearStr];
                    }
                }
                //如果原始数据中年份大于最大限定年份
                else if ([yearStr integerValue] > year)
                {
                    for (int i = 0; i < [yearArr count]; i ++)
                    {
                        NSString *arrYearStr = [yearArr lastObject];
                        if ([arrYearStr integerValue] > year)
                        {
                            //删除原始数据中年份大于最大限定年的数据
                            [yearArr removeObject: arrYearStr];
                            
                            //数组减一，保证循环正常进行，对循环计数减一
                            i -= 1;
                        }
                        else
                        {
                            break;
                        }
                    }
                }
                
                //更新原始数据，刷新pickerView
                [dataArr replaceObjectAtIndex: 0 withObject: yearArr];
                [pickerView reloadComponent: 0];
            }
            
            //默认时间
            if (![LdDatePickerManager isBlankString: defaultTime])
            {
                //设置有默认时间，获取默认时间在picker中位置，设置picker默认值
                NSDate *date = [LdDatePickerManager compareDate: [LdDatePickerManager defaultDateStr: minTime]
                                                            max: [LdDatePickerManager defaultDateStr: maxTime]
                                                    defaultTime: [LdDatePickerManager defaultDateStr: defaultTime]];
                for (int i = 0; i < 6; i ++)
                {
                    if (i < [dataArr count])
                    {
                        NSString *str = @"";
                        if (i == 0)
                        {
                            str = [NSString stringWithFormat: @"%ld", (long)date.dateYear];
                        }
                        else if (i == 1)
                        {
                            str = [NSString stringWithFormat: @"%02ld", (long)date.dateMonth];
                        }
                        else if (i == 2)
                        {
                            str = [NSString stringWithFormat: @"%02ld", (long)date.dateDay];
                        }
                        else if (i == 3)
                        {
                            str = [NSString stringWithFormat: @"%02ld", (long)date.dateHour];
                        }
                        else if (i == 4)
                        {
                            str = [NSString stringWithFormat: @"%02ld", (long)date.dateMinute];
                        }
                        else if (i == 5)
                        {
                            str = [NSString stringWithFormat: @"%02ld", (long)date.dateSecond];
                        }
                        
                        NSArray *arr = dataArr[i];
                        
                        NSInteger row = 0;
                        if ([arr containsObject: str])
                        {
                            row = [arr indexOfObject: str];
                        }
                        else
                        {
                            row = 0;
                        }
                        [pickerView selectRow: row inComponent: i animated: NO];
                    }
                }
            }
        }
            break;
            
        case DateModeDT_YAll:
        case DateModeDT_YNoSecond:
        case DateModeDT_YNoMinute:
        case DateModeDT_YNoTime:
        {

            //默认时间
            if (![LdDatePickerManager isBlankString: defaultTime])
            {
                //设置有默认时间，获取默认时间在picker中位置，设置picker默认值
                NSDate *date = [LdDatePickerManager compareDate: [LdDatePickerManager defaultDateStr: minTime]
                                                            max: [LdDatePickerManager defaultDateStr: maxTime]
                                                    defaultTime: [LdDatePickerManager defaultDateStr: defaultTime]];
                for (int i = 0; i < 5; i ++)
                {
                    if (i < [dataArr count])
                    {
                        NSString *str = @"";
                        if (i == 0)
                        {
                            str = [NSString stringWithFormat: @"%02ld", (long)date.dateMonth];
                        }
                        else if (i == 1)
                        {
                            str = [NSString stringWithFormat: @"%02ld", (long)date.dateDay];
                        }
                        else if (i == 2)
                        {
                            str = [NSString stringWithFormat: @"%02ld", (long)date.dateHour];
                        }
                        else if (i == 3)
                        {
                            str = [NSString stringWithFormat: @"%02ld", (long)date.dateMinute];
                        }
                        else if (i == 4)
                        {
                            str = [NSString stringWithFormat: @"%02ld", (long)date.dateSecond];
                        }
                        
                        NSArray *arr = dataArr[i];
                        NSInteger row = 0;
                        if ([arr containsObject: str])
                        {
                            row = [arr indexOfObject: str];
                        }
                        else
                        {
                            row = 0;
                        }
                        [pickerView selectRow: row inComponent: i animated: NO];
                    }
                }
            }
        }
            
            break;
            
        case DateModeTimeAll:
        case DateModeTimeNoSecond:
        {
            //默认时间
            if (![LdDatePickerManager isBlankString: defaultTime])
            {
                //设置有默认时间，获取默认时间在picker中位置，设置picker默认值
                NSDate *date = [LdDatePickerManager defaultDateStr: defaultTime];
                for (int i = 0; i < 3; i ++)
                {
                    if (i < [dataArr count])
                    {
                        NSString *str = @"";
                        if (i == 0)
                        {
                            str = [NSString stringWithFormat: @"%02ld", (long)date.dateHour];
                        }
                        else if (i == 1)
                        {
                            str = [NSString stringWithFormat: @"%02ld", (long)date.dateMinute];
                        }
                        else if (i == 2)
                        {
                            str = [NSString stringWithFormat: @"%02ld", (long)date.dateSecond];
                        }
                        
                        NSArray *arr = dataArr[i];
                        NSInteger row = 0;
                        if ([arr containsObject: str])
                        {
                            row = [arr indexOfObject: str];
                        }
                        else
                        {
                            row = 0;
                        }
                        [pickerView selectRow: row inComponent: i animated: NO];
                    }
                }
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 时间比较
/**
 *  根据需要比较的时间 和最大限定时间以及最小限定时间进行比较，来返回一个相对比较合理的时间
 *  @param  minTime 最小限定时间
 *  @param  maxTime 最大限定时间
 *  @param  defaultTime 需要进行比较的时间
 */
+ (NSDate *) compareDate: (NSDate *)minTime
                     max: (NSDate *)maxTime
             defaultTime: (NSDate *)defaultTime
{
    //默认选择时间和最小时间比较
    NSComparisonResult result = [defaultTime compare: minTime];
    if (result == NSOrderedDescending)
    {
        //大于最小时间,和最大时间比较
        NSComparisonResult result2 = [defaultTime compare: maxTime];
        if (result2 == NSOrderedDescending)
        {
            //大于最大时间，取最大时间
            return maxTime;
        }
        else
        {
            //小于、等于 最大时间，直接返回
            return defaultTime;
        }
    }
    else if (result == NSOrderedAscending)
    {
        //小于最小时间,取最小时间
        return minTime;
    }
    else
    {
        //等于最小时间，直接返回
        return defaultTime;
    }
}

/**
 *  确认提交前 进行日期比较，确保开始日期大于结束日期
 *  @param  beginStr    开始日期
 *  @param  endStr      结束日期
 *  @param  mode        日期格式
 */
+ (BOOL) confirmFrontCompare: (NSString *)beginStr
                      endStr: (NSString *)endStr
                    dateMode: (DateMode)mode
{
    NSDateFormatter *dateFormatter = [LdDatePickerManager gainDateFormatterWithDateMode: mode];
    NSDate *beginDate = [dateFormatter dateFromString: beginStr];
    NSDate *endDate = [dateFormatter dateFromString: endStr];
    NSComparisonResult result = [beginDate compare: endDate];
    if (result == NSOrderedAscending)
    {
        return NO;
    }
    else if (result == NSOrderedSame)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
