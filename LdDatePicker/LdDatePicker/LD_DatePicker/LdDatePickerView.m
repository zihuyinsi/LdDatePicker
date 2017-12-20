//
//  LdDatePickerView.m
//  LdDatePicker
//
//  Created by lv on 2017/12/19.
//  Copyright © 2017年 lv. All rights reserved.
//

#import "LdDatePickerView.h"
#import "LdConstant.h"
#import "LdDatePickerManager.h"
#import "NSDate+Attribute.h"

@interface LdDatePickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *ldPickerViewBackground;   // 整个日期选择器背景
@property (nonatomic, strong) UILabel *beginTitleLabel;         // 开始日期选择器标题
@property (nonatomic, strong) UILabel *endTitleLabel;           // 结束日期选择器标题
@property (nonatomic, strong) UIButton *confirmBtn;             // 确定选择按钮
@property (nonatomic, strong) UIButton *cannelBtn;              // 取消选择按钮
@property (nonatomic, strong) UIPickerView *beginPicker;        // 开始选择器
@property (nonatomic, strong) UIPickerView *endPicker;          // 结束选择器

@property (nonatomic, strong) NSMutableArray *dataBeginArr;     // 开始数据
@property (nonatomic, strong) NSMutableArray *dataEndArr;       // 结束数据

@property (nonatomic, copy) NSString *selectBeginStr;           // 开始选中
@property (nonatomic, copy) NSString *selectEndStr;             // 结束选中

@end

@implementation LdDatePickerView

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        [self initializationDatePickerView];
        [self setupDefaultData];
    }
    
    return self;
}

/** 数据 */
- (void) setupDefaultData
{
    self.showType = ShowTypeDefault;
    self.dismissType = DismissTypeDefault;
    
    self.pickerType = PickerTypeDefault;
    self.beginTitleStr = @"开始";
    self.endTitleStr = @"结束";
    self.confirmTitleStr = @"确定";
    self.cannelTitleStr = @"取消";
    self.dateMode = DateModeAll;
}

/** 视图 */
- (void) initializationDatePickerView
{
    [self setFrame: CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    [self setBackgroundColor: [UIColor colorWithWhite: 0.f alpha: 0.5f]];
    [self setHidden: YES];
    
    //添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                 action: @selector(dismiss)];
    [self addGestureRecognizer: tapGesture];
    
    //选择器背景
    [self addSubview: self.ldPickerViewBackground];
    self.ldPickerViewBackground.layer.cornerRadius = 3.f;
    self.ldPickerViewBackground.layer.masksToBounds = YES;
    
    //确定
    [self.ldPickerViewBackground addSubview: self.confirmBtn];
    [self.confirmBtn setTitle: self.confirmTitleStr forState: UIControlStateNormal];
    
    //取消
    [self.ldPickerViewBackground addSubview: self.cannelBtn];
    [self.cannelBtn setTitle: self.cannelTitleStr forState: UIControlStateNormal];
    
    //开始标题
    [self.ldPickerViewBackground addSubview: self.beginTitleLabel];
    [self.beginTitleLabel setText: self.beginTitleStr];

    //开始选择器
    [self.ldPickerViewBackground addSubview: self.beginPicker];
}


- (void) initializationEndPickerView
{
    //结束标题
    [self.ldPickerViewBackground addSubview: self.endTitleLabel];
    [self.endTitleLabel setText: self.endTitleStr];

    //结束选择器
    [self.ldPickerViewBackground addSubview: self.endPicker];
}

#pragma mark - UIPickerViewDelegate / UIPickerViewDataSource
/** 列数 */
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 91001)
    {
        return [self.dataBeginArr count];
    }
    else if (pickerView.tag == 91002)
    {
        return [self.dataEndArr count];
    }
    else
    {
        return 0;
    }
}

/** 每列行数 */
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 91001)
    {
        return [self.dataBeginArr[component] count];
    }
    else if (pickerView.tag == 91002)
    {
        return [self.dataEndArr[component] count];
    }
    
    return 0;
}

/** 高度 */
- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.f;
}

/** 每个item宽度 */
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    NSInteger num = [LdDatePickerManager numberOfComponentsInPickerView: self.dateMode];
    CGFloat rowWidth = (DeviceWidth - 70 - 8*(num-1))/num;
    if ((rowWidth - 80.f) > 0.f)
    {
        rowWidth = 80.f;
    }
    
    return rowWidth;
}

/** 内容 */
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 91001)
    {
        NSString *resultStr = self.dataBeginArr[component][row];
        return resultStr;
    }
    else if (pickerView.tag == 91002)
    {
        NSString *resultStr = self.dataEndArr[component][row];
        return resultStr;
    }
    else
    {
        return @"";
    }
}

/** 选中行 */
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.dateMode == DateModeAll ||
        self.dateMode == DateModeNoSecond ||
        self.dateMode == DateModeNoMinute ||
        self.dateMode == DateModeNoTime)
    {
        if (component == 0)
        {
            if (pickerView.tag == 91001)
            {
                NSString *yearStr = self.dataBeginArr[component][row];
                NSInteger monthRow = [pickerView selectedRowInComponent: (component+1)];
                NSString *monthStr = self.dataBeginArr[(component+1)][monthRow];
                
                NSArray *dayArr = [LdDatePickerManager gainDayArrWithYear: [yearStr integerValue]
                                                                    month: [monthStr integerValue]];
                [self.dataBeginArr replaceObjectAtIndex: (component+2) withObject: dayArr];
                [pickerView reloadComponent: (component+2)];
            }
            else if (pickerView.tag == 91002)
            {
                NSString *yearStr = self.dataEndArr[component][row];
                NSInteger monthRow = [pickerView selectedRowInComponent: (component+1)];
                NSString *monthStr = self.dataEndArr[(component+1)][monthRow];
                
                NSArray *dayArr = [LdDatePickerManager gainDayArrWithYear: [yearStr integerValue]
                                                                    month: [monthStr integerValue]];
                [self.dataEndArr replaceObjectAtIndex: (component+2) withObject: dayArr];
                [pickerView reloadComponent: (component+2)];
            }
        }
        else if (component == 1)
        {
            if (pickerView.tag == 91001)
            {
                NSString *monthStr = self.dataBeginArr[component][row];
                NSInteger yearRow = [pickerView selectedRowInComponent: (component-1)];
                NSString *yearStr = self.dataBeginArr[(component-1)][yearRow];
                
                NSArray *dayArr = [LdDatePickerManager gainDayArrWithYear: [yearStr integerValue]
                                                                    month: [monthStr integerValue]];
                [self.dataBeginArr replaceObjectAtIndex: (component+1) withObject: dayArr];
                [pickerView reloadComponent: (component+1)];
            }
            else if (pickerView.tag == 91002)
            {
                NSString *monthStr = self.dataEndArr[component][row];
                NSInteger yearRow = [pickerView selectedRowInComponent: (component-1)];
                NSString *yearStr = self.dataEndArr[(component-1)][yearRow];
                
                NSArray *dayArr = [LdDatePickerManager gainDayArrWithYear: [yearStr integerValue]
                                                                    month: [monthStr integerValue]];
                [self.dataEndArr replaceObjectAtIndex: (component+1) withObject: dayArr];
                [pickerView reloadComponent: (component+1)];
            }
        }
    }
    else if (self.dateMode == DateModeDT_YAll ||
             self.dateMode == DateModeDT_YNoSecond ||
             self.dateMode == DateModeDT_YNoMinute ||
             self.dateMode == DateModeDT_YNoTime)
    {
        if (component == 0)
        {
            if (pickerView.tag == 91001)
            {
                NSInteger year = [NSDate date].dateYear;
                NSString *monthStr = self.dataBeginArr[component][row];
                
                NSArray *dayArr = [LdDatePickerManager gainDayArrWithYear: year
                                                                    month: [monthStr integerValue]];
                [self.dataBeginArr replaceObjectAtIndex: (component+1) withObject: dayArr];
                [pickerView reloadComponent: (component+1)];
            }
            else if (pickerView.tag == 91002)
            {
                NSInteger year = [NSDate date].dateYear;
                NSString *monthStr = self.dataEndArr[component][row];
                
                NSArray *dayArr = [LdDatePickerManager gainDayArrWithYear: year
                                                                    month: [monthStr integerValue]];
                [self.dataEndArr replaceObjectAtIndex: (component+1) withObject: dayArr];
                [pickerView reloadComponent: (component+1)];
            }
        }
    }
    
    //各item标题
    NSString *pendingStr = @"";
    if (pickerView.tag == 91001)
    {
        NSInteger numComponent = [LdDatePickerManager numberOfComponentsInPickerView: self.dateMode];
        for (int i = 0; i < numComponent; i ++)
        {
            NSInteger rowInCompoent = [pickerView selectedRowInComponent: i];
            NSString *tempStr = self.dataBeginArr[i][rowInCompoent];
            
            if (i == 0)
            {
                pendingStr = tempStr;
            }
            else
            {
                pendingStr = [pendingStr stringByAppendingFormat: @"-%@", tempStr];
            }
        }
    }
    else if (pickerView.tag == 91002)
    {
        NSInteger numComponent = [LdDatePickerManager numberOfComponentsInPickerView: self.dateMode];
        for (int i = 0; i < numComponent; i ++)
        {
            NSInteger rowInCompoent = [pickerView selectedRowInComponent: i];
            NSString *tempStr = self.dataEndArr[i][rowInCompoent];
            
            if (i == 0)
            {
                pendingStr = tempStr;
            }
            else
            {
                pendingStr = [pendingStr stringByAppendingFormat: @"-%@", tempStr];
            }
        }
    }
    NSLog(@"pendingStr = %@", pendingStr);
    NSString *resultStr = [LdDatePickerManager handleDataStrWithDateMode: self.dateMode
                                                              pendingStr: pendingStr];
    NSLog(@"resultStr = %@", resultStr);
}

///** 改变字体和颜色 */
//- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    return nil;
//}

#pragma mark - 确定、取消
- (void) confirmBtnClick
{
    
}

- (void) cannelBtnClick
{
    
}

#pragma mark - 隐藏、消失
- (void) dismiss
{
    if (self.dismissType == DismissTypeDefault)
    {
        [self setHidden: YES];
        [self removeFromSuperview];
    }
    else
    {
        CGFloat dismissX = 0.f;
        CGFloat dismissY = 0.f;
        switch (self.dismissType) {
            case DismissTypeDefault:
                break;
            case DismissTypeDown_Up:
                dismissX = 0.f;
                dismissY = DeviceHeight;
                break;
                
            case DismissTypeUp_Down:
                dismissX = 0.f;
                dismissY = -DeviceHeight;
                break;
                
            case DismissTypeLeft_Right:
                dismissX = DeviceWidth;
                dismissY = 0.f;
                break;
                
            case DismissTypeRight_Left:
                dismissX = -DeviceWidth;
                dismissY = 0.f;
                break;
                
            default:
                break;
        }
        
        [UIView animateWithDuration: .25f
                         animations:^{
                             [self setFrame: CGRectMake(dismissX, dismissY, DeviceWidth, DeviceHeight)];
                         }
                         completion:^(BOOL finished) {
                             if (finished)
                             {
                                 [self setHidden: YES];
                                 [self loadShowFrame: self.showType];
                                 [self removeFromSuperview];
                             }
                         }];
    }
}

#pragma mark - 展示
- (void) show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview: self];
    [keyWindow bringSubviewToFront: self];
    
    if (self.showType == ShowTypeDefault)
    {
        [self setFrame: CGRectMake( 0, 0, DeviceWidth, DeviceHeight)];
        [self setHidden: NO];
    }
    else
    {
        [self setHidden: NO];
        [UIView animateWithDuration: .25f
                         animations:^{
                             [self setFrame: CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
                         }];
    }
}

#pragma mark - setter / getter
/** 选择器背景 */
- (UIView *) ldPickerViewBackground
{
    if (_ldPickerViewBackground == nil)
    {
        _ldPickerViewBackground = [[UIView alloc] init];
        [_ldPickerViewBackground setBackgroundColor: [UIColor whiteColor]];
        [_ldPickerViewBackground setFrame: CGRectMake(30.f, (DeviceHeight - 150.f)/2, DeviceWidth - 60.f, 150.f)];
    }
    
    return _ldPickerViewBackground;
}

/** 开始标题 */
- (UILabel *) beginTitleLabel
{
    if (_beginTitleLabel == nil)
    {
        _beginTitleLabel = [[UILabel alloc] init];
        [_beginTitleLabel setTextColor: [UIColor colorWithWhite: 0.1f alpha: 1.f]];
        [_beginTitleLabel setFont: [UIFont systemFontOfSize: 15.f]];
        [_beginTitleLabel setTextAlignment: NSTextAlignmentCenter];
    }
    
    return _beginTitleLabel;
}

/** 结束标题 */
- (UILabel *) endTitleLabel
{
    if (_endTitleLabel == nil)
    {
        _endTitleLabel = [[UILabel alloc] init];
        [_endTitleLabel setTextColor: [UIColor colorWithWhite: 0.1f alpha: 1.f]];
        [_endTitleLabel setFont: [UIFont systemFontOfSize: 15.f]];
        [_endTitleLabel setTextAlignment: NSTextAlignmentCenter];
    }
    
    return _endTitleLabel;
}

/** 确认按钮 */
- (UIButton *) confirmBtn
{
    if (_confirmBtn == nil)
    {
        _confirmBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [_confirmBtn setTitleColor: [UIColor colorWithWhite: 0.1f alpha: 1.f]
                          forState: UIControlStateNormal];
        [_confirmBtn.titleLabel setFont: [UIFont systemFontOfSize: 15.f]];
        [_confirmBtn addTarget: self
                        action: @selector(confirmBtnClick)
              forControlEvents: UIControlEventTouchUpInside];
    }
    
    return _confirmBtn;
}

/** 取消按钮 */
- (UIButton *) cannelBtn
{
    if (_cannelBtn == nil)
    {
        _cannelBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [_cannelBtn setTitleColor: [UIColor colorWithWhite: 0.1f alpha: 1.f]
                         forState: UIControlStateNormal];
        [_cannelBtn.titleLabel setFont: [UIFont systemFontOfSize: 15.f]];
        [_cannelBtn addTarget: self
                       action: @selector(cannelBtnClick)
             forControlEvents: UIControlEventTouchUpInside];
    }
    
    return _cannelBtn;
}

/** 开始选择器 */
- (UIPickerView *) beginPicker
{
    if (_beginPicker == nil)
    {
        _beginPicker = [[UIPickerView alloc] init];
        _beginPicker.delegate = self;
        _beginPicker.dataSource = self;
        _beginPicker.tag = 91001;
    }
    
    return _beginPicker;
}

/** 结束选择器 */
- (UIPickerView *) endPicker
{
    if (_endPicker == nil)
    {
        _endPicker = [[UIPickerView alloc] init];
        _endPicker.delegate = self;
        _endPicker.dataSource = self;
        _endPicker.tag = 91002;
    }
    
    return _endPicker;
}

/** 开始选择器数据 */
- (NSMutableArray *) dataBeginArr
{
    if (_dataBeginArr == nil)
    {
        _dataBeginArr = [[NSMutableArray alloc] init];
    }
    
    return _dataBeginArr;
}

/** 结束选择器数据 */
- (NSMutableArray *) dataEndArr
{
    if (_dataEndArr == nil)
    {
        _dataEndArr = [[NSMutableArray alloc] init];
    }
    
    return _dataEndArr;
}

/** 显示方式 */
- (void) setShowType:(ShowType)showType
{
    _showType = showType;
    
    [self loadShowFrame: showType];
}

/** 隐藏方式 */
- (void) setDismissType:(DismissType)dismissType
{
    _dismissType = dismissType;
}

/** 选择器样式个数 */
- (void) setPickerType:(PickerType)pickerType
{
    _pickerType = pickerType;
    [self loadPickerBackgroundSizeWithType: pickerType];
    
    //更新数据
    [self reloadData];
}

/** 日期样式 */
- (void) setDateMode:(DateMode)dateMode
{
    _dateMode = dateMode;
    
    //更新数据
    [self reloadData];
}

/** 开始标题 */
- (void) setBeginTitleStr:(NSString *)beginTitleStr
{
    _beginTitleStr = beginTitleStr;
    [self.beginTitleLabel setText: beginTitleStr];
}

/** 结束标题 */
- (void) setEndTitleStr:(NSString *)endTitleStr
{
    _endTitleStr = endTitleStr;
    [self.endTitleLabel setText: endTitleStr];
}

/** 确定标题 */
- (void) setConfirmTitleStr:(NSString *)confirmTitleStr
{
    _confirmTitleStr = confirmTitleStr;
    [self.confirmBtn setTitle: confirmTitleStr forState: UIControlStateNormal];
}

/** 取消标题 */
- (void) setCannelTitleStr:(NSString *)cannelTitleStr
{
    _cannelTitleStr = cannelTitleStr;
    [self.cannelBtn setTitle: cannelTitleStr forState: UIControlStateNormal];
}

#pragma mark - request Data reload Picker
- (void) reloadData
{
    //开始选择器 数据
    [self.dataBeginArr removeAllObjects];
    [self.dataBeginArr addObjectsFromArray: [LdDatePickerManager presetDataWithMode: self.dateMode]];
    [self.beginPicker reloadAllComponents];
    
    if (self.pickerType == PickerTypeBeginEnd)
    {
        //结束选择器
        [self.dataEndArr removeAllObjects];
        [self.dataEndArr addObjectsFromArray: [LdDatePickerManager presetDataWithMode: self.dateMode]];
        [self.endPicker reloadAllComponents];
    }
}

#pragma mark - 调整
/**
 *  视图展示前进行位置调整，方便展示时动画效果
 */
- (void) loadShowFrame: (ShowType)showType
{
    switch (showType) {
        case ShowTypeDefault:
            [self setFrame: CGRectMake( 0, 0, DeviceWidth, DeviceHeight)];
            break;
            
        case ShowTypeDown_Up:
            [self setFrame: CGRectMake( 0, DeviceHeight, DeviceWidth, DeviceHeight)];
            break;
            
        case ShowTypeUp_Down:
            [self setFrame: CGRectMake(0, -DeviceHeight, DeviceWidth, DeviceHeight)];
            break;
            
        case ShowTypeLeft_Right:
            [self setFrame: CGRectMake(-DeviceWidth, 0, DeviceWidth, DeviceHeight)];
            break;
            
        case ShowTypeRight_Left:
            [self setFrame: CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight)];
            break;
            
        default:
            break;
    }
}

/**
 *  调整整个选择器尺寸
 */
- (void) loadPickerBackgroundSizeWithType: (PickerType)type
{
    CGFloat bgHeight = 0.f;
    
    if (type == PickerTypeDefault)
    {
        bgHeight = 150.f;
    }
    else if (type == PickerTypeBeginEnd)
    {
        bgHeight = 410;
        [self initializationEndPickerView];
    }
    
    [self.ldPickerViewBackground setFrame: CGRectMake(30.f,
                                                      (DeviceHeight - bgHeight)/2,
                                                      DeviceWidth - 60.f,
                                                      bgHeight)];

    //开始标题
    [self.beginTitleLabel setFrame: CGRectMake(0,
                                               5,
                                               CGRectGetWidth(self.ldPickerViewBackground.frame),
                                               20.f)];

    if (type == PickerTypeDefault)
    {
        //开始日期选择器
        [self.beginPicker setFrame: CGRectMake(5.f,
                                               CGRectGetMaxY(self.beginTitleLabel.frame),
                                               CGRectGetWidth(self.ldPickerViewBackground.frame) - 10.f,
                                               CGRectGetHeight(self.ldPickerViewBackground.frame) - 75.f)];
    }
    else if (type == PickerTypeBeginEnd)
    {
        [self initializationEndPickerView];

        //开始日期选择器
        [self.beginPicker setFrame: CGRectMake(5.f,
                                               CGRectGetMaxY(self.beginTitleLabel.frame),
                                               CGRectGetWidth(self.ldPickerViewBackground.frame) - 10.f,
                                               (CGRectGetHeight(self.ldPickerViewBackground.frame) - 110)/2)];


        //结束标题
        [self.endTitleLabel setFrame: CGRectMake(0,
                                                 CGRectGetMaxY(self.beginPicker.frame) + 15.f,
                                                 CGRectGetWidth(self.ldPickerViewBackground.frame),
                                                 20.f)];

        //结束日期选择器
        [self.endPicker setFrame: CGRectMake(5.f,
                                             CGRectGetMaxY(self.endTitleLabel.frame),
                                             CGRectGetWidth(self.ldPickerViewBackground.frame) - 10.f,
                                             (CGRectGetHeight(self.ldPickerViewBackground.frame) - 110)/2)];
    }

    //确认选择按钮
    [self.confirmBtn setFrame: CGRectMake(0,
                                          CGRectGetHeight(self.ldPickerViewBackground.frame) - 40.f,
                                          CGRectGetWidth(self.ldPickerViewBackground.frame) / 2.f,
                                          40.f)];

    //取消选择按钮
    [self.cannelBtn setFrame: CGRectMake(CGRectGetWidth(self.ldPickerViewBackground.frame)/2,
                                         CGRectGetHeight(self.ldPickerViewBackground.frame) - 40.f,
                                         CGRectGetWidth(self.ldPickerViewBackground.frame)/2,
                                         40.f)];
}

@end
