//
//  NSDate+Attribute.h
//  LdDatePicker
//
//  Created by lv on 2017/12/20.
//  Copyright © 2017年 lv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Attribute)

/**
 *  获取当前NSDate对象对应的年
 */
- (NSInteger) dateYear;

/**
 *  获取当前NSDate对象对应的月
 */
- (NSInteger) dateMonth;

/**
 *  获取当前NSDate对象对应的日
 */
- (NSInteger) dateDay;

/**
 *  获取当前NSDate对象对应的时
 */
- (NSInteger) dateHour;

/**
 *  获取当前NSDate对象对应的分
 */
- (NSInteger) dateMinute;

/**
 *  获取当前NSDate对象对应的秒
 */
- (NSInteger) dateSecond;

@end
