//
//  LdDatePickerView.h
//  LdDatePicker
//
//  Created by lv on 2017/12/19.
//  Copyright © 2017年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  视图出现方式
 */
typedef NS_ENUM(NSInteger, ShowType)
{
    ShowTypeDefault = 0,    // 无效果，直接显示
    ShowTypeDown_Up,        // 下_上
    ShowTypeUp_Down,        // 上_下
    ShowTypeLeft_Right,     // 左_右
    ShowTypeRight_Left,     // 右_左
};

/**
 *  视图消失方式
 */
typedef NS_ENUM(NSInteger, DismissType)
{
    DismissTypeDefault = 0,     //无效果，直接消失
    DismissTypeDown_Up,         // 下_上
    DismissTypeUp_Down,         // 上_下
    DismissTypeLeft_Right,      // 左_右
    DismissTypeRight_Left,      // 右_左
};

/**
 *  选择器个数
 */
typedef NS_ENUM(NSInteger, PickerType)
{
    PickerTypeDefault = 0,      // 单一    一个选择器
    PickerTypeBeginEnd,         // 开始结束 两个选择器
};

/**
 *  日期类型
 */
typedef NS_ENUM(NSInteger, DateMode)
{
    DateModeAll = 0,            //2017-12-20 14:12:13
    DateModeNoSecond,           //2017-12-20 14:12
    DateModeNoMinute,           //2017-12-20 14
    DateModeNoTime,             //2017-12-20
    DateModeNoDay,              //2017-12
    DateModeDT_YAll,            //12-20 14:12:13
    DateModeDT_YNoSecond,       //12-20 14:12
    DateModeDT_YNoMinute,       //12-20 14
    DateModeDT_YNoTime,         //12-20
    DateModeTimeAll,            //14:12:13
    DateModeTimeNoSecond,       //14:12
};


@interface LdDatePickerView : UIView

/** 确认结果 */
@property (nonatomic, copy) void (^confirmResult)(NSString *beginResultStr, NSString *endResultStr);
/** 取消结果 */
@property (nonatomic, copy) void (^cannelResult)(void);


/** LdDatePickerView出现样式 */
@property (nonatomic, assign) ShowType showType;
/** LdDatePickerView隐藏样式 */
@property (nonatomic, assign) DismissType dismissType;
/** 选择器样式（单个、两个） */
@property (nonatomic, assign) PickerType pickerType;
/** 日期格式 */
@property (nonatomic, assign) DateMode dateMode;
/** 默认时间 yyyy-MM-dd HH:mm:ss */
@property (nonatomic, copy) NSString *defaultTime;
/** 最大时间 yyyy-MM-dd HH:mm:ss */
@property (nonatomic, copy) NSString *maxTime;
/** 最小时间 yyyy-MM-dd HH:mm:ss */
@property (nonatomic, copy) NSString *minTime;

/** 开始标题 */
@property (nonatomic, copy) NSString *beginTitleStr;
/** 结束标题 */
@property (nonatomic, copy) NSString *endTitleStr;
/** 确定标题 */
@property (nonatomic, copy) NSString *confirmTitleStr;
/** 取消标题 */
@property (nonatomic, copy) NSString *cannelTitleStr;

/**
 *  展示、出现
 */
- (void) show;
/**
 *  消失、隐藏
 */
- (void) dismiss;


@end
