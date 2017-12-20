//
//  LdDatePickerManager.h
//  LdDatePicker
//
//  Created by lv on 2017/12/20.
//  Copyright © 2017年 lv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LdDatePickerView.h"

@interface LdDatePickerManager : NSObject
/**
 *  isBlankString:
 *  字符串是否为空
 *  @param  string          输入要判断的字符串
 */
+ (BOOL) isBlankString: (NSString *)string;

/**
 *  日期格式字符串
 *  @param  mode    日期类型
 */
+ (NSString *)dateFormatterStrWithMode: (DateMode)mode;

/**
 *  获取日期格式
 *  @param  mode    日期格式
 */
+ (NSDateFormatter *) gainDateFormatterWithDateMode: (DateMode)mode;

/**
 *  获取pickerView列数
 *  @param  mode    日期格式
 */
+ (NSInteger) numberOfComponentsInPickerView: (DateMode)mode;

/**
 *  根据日期类型获取日期
 *  @param  mode        日期格式
 *  @param  pendingStr  待处理日期
 */
+ (NSString *) handleDataStrWithDateMode: (DateMode)mode
                              pendingStr: (NSString *)pendingStr;

/**
 *  预设数据通过日期格式
 *  @param  mode        日期格式
 */
+ (NSMutableArray *) presetDataWithMode: (DateMode)mode;

/**
 *  年
 */
+ (NSArray *)gainYearArrWithCurrentYear: (NSInteger)currentYear;
+ (NSArray *)gainYearArrWithMaxYear: (NSInteger)max
                            minYear: (NSInteger)min;

/**
 *  月
 */
+ (NSArray *)gainMonthArr;

/**
 *  日
 */
+ (NSArray *)gainDayArr;
+ (NSArray *)gainDayArrWithYear: (NSInteger)year
                          month: (NSInteger)month;

/**
 *  时
 */
+ (NSArray *)gainHourArr;

/**
 *  分
 */
+ (NSArray *)gainMinuteArr;

/**
 *  秒
 */
+ (NSArray *)gainSecondArr;

@end
