//
//  NSDate+Attribute.m
//  LdDatePicker
//
//  Created by lv on 2017/12/20.
//  Copyright © 2017年 lv. All rights reserved.
//

#import "NSDate+Attribute.h"

@implementation NSDate (Attribute)

/**
 *  获取当前NSDate对象对应的年
 */
- (NSInteger) dateYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components: NSCalendarUnitYear fromDate: self];
    return components.year;
}

/**
 *  获取当前NSDate对象对应的月
 */
- (NSInteger) dateMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components: NSCalendarUnitMonth fromDate: self];
    return components.month;
}

/**
 *  获取当前NSDate对象对应的日
 */
- (NSInteger) dateDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components: NSCalendarUnitDay fromDate: self];
    return components.day;
}

/**
 *  获取当前NSDate对象对应的时
 */
- (NSInteger) dateHour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components: NSCalendarUnitHour fromDate: self];
    return components.hour;
}

/**
 *  获取当前NSDate对象对应的分
 */
- (NSInteger) dateMinute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components: NSCalendarUnitMinute fromDate: self];
    return components.minute;
}

/**
 *  获取当前NSDate对象对应的秒
 */
- (NSInteger) dateSecond
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components: NSCalendarUnitSecond fromDate: self];
    return components.second;
}


@end
