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

#pragma mark - 日期格式
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
 *  setDate (默认时间、最小时间、最大时间) 转换为NSDate
 */
+ (NSDate *) defaultDateStr: (NSString *)string;

#pragma mark - PickerView
/**
 *  获取pickerView列数
 *  @param  mode    日期格式
 */
+ (NSInteger) numberOfComponentsInPickerView: (DateMode)mode;

/**
 *  获取pickerView选择结果
 */
+ (NSString *) pickerView:(UIPickerView *)pickerView
             didSelectRow:(NSInteger)row
              inComponent:(NSInteger)component
                 dateMode:(DateMode)mode
                  dataArr:(NSMutableArray *)dateArr;

#pragma mark - 选择结果处理
/**
 *  根据日期类型获取日期
 *  @param  mode        日期格式
 *  @param  pendingStr  待处理日期
 */
+ (NSString *) handleDataStrWithDateMode: (DateMode)mode
                              pendingStr: (NSString *)pendingStr;

#pragma mark - 预设数据
/**
 *  预设数据通过日期格式
 *  @param  mode        日期格式
 */
+ (NSMutableArray *) presetDataWithMode: (DateMode)mode;

#pragma mark - 年月日时分秒
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

#pragma mark - 更新数据
+ (void) loadPickerDataWithTime: (NSString *)defaultTime
                        minTime: (NSString *)minTime
                        maxTime: (NSString *)maxTime
                       dateMode: (DateMode)dateMode
                        dataArr: (NSMutableArray *)dataArr
                     pickerView: (UIPickerView *)pickerView;

@end
