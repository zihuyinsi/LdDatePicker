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

#define k_SupViewLRMargin 30.f
#define k_SupViewTBMargin 64.f
#define k_TitleHeight 20.f
#define k_OnePickerHeight 200.f
#define k_ButtonHeight 50.f
#define k_PickerItemHeight 45.f
#define k_PickerLineMargin 10.f
#define k_PickerLRMargin 15.f
#define k_TitleTopMargin 15.f

@interface LdDatePickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *ldPickerViewBackground;   // 整个日期选择器背景
@property (nonatomic, strong) UILabel *beginTitleLabel;         // 开始日期选择器标题
@property (nonatomic, strong) UILabel *endTitleLabel;           // 结束日期选择器标题
@property (nonatomic, strong) UIButton *confirmBtn;             // 确定选择按钮
@property (nonatomic, strong) UIButton *cannelBtn;              // 取消选择按钮
@property (nonatomic, strong) UILabel *line1;                   //按钮分割线
@property (nonatomic, strong) UILabel *line2;                   //按钮分割线
@property (nonatomic, strong) UIPickerView *beginPicker;        // 开始选择器
@property (nonatomic, strong) UIPickerView *endPicker;          // 结束选择器

@property (nonatomic, strong) NSMutableArray *dataBeginArr;     // 开始数据
@property (nonatomic, strong) NSMutableArray *dataEndArr;       // 结束数据

@property (nonatomic, copy) NSString *selectBeginStr;           // 开始选中
@property (nonatomic, copy) NSString *selectEndStr;             // 结束选中

/** 开始选择器分割线 */
@property (nonatomic, strong) UIView *beginLineView;
/** 结束选择器分割线 */
@property (nonatomic, strong) UIView *endLineView;

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
    self.selectBeginStr = @"";
    self.selectEndStr = @"";
    
    self.showType = ShowTypeDefault;
    self.dismissType = DismissTypeDefault;
    
    self.pickerType = PickerTypeDefault;
    self.beginTitleStr = @"开始";
    self.endTitleStr = @"结束";
    self.confirmTitleStr = @"确定";
    self.cannelTitleStr = @"取消";
    self.dateMode = DateModeAll;
    
    self.defaultBeginTime = [[LdDatePickerManager gainDateFormatterWithDateMode: self.dateMode] stringFromDate: [NSDate date]];
    self.defaultEndTime = [[LdDatePickerManager gainDateFormatterWithDateMode: self.dateMode] stringFromDate: [NSDate date]];
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
    
    [self.ldPickerViewBackground addSubview: self.line1];
    [self.ldPickerViewBackground addSubview: self.line2];
    
    //开始标题
    [self.ldPickerViewBackground addSubview: self.beginTitleLabel];
    [self.beginTitleLabel setText: self.beginTitleStr];

    //开始选择器
    [self.ldPickerViewBackground addSubview: self.beginPicker];
    for (UIView *tempview in self.beginPicker.subviews)
    {
        if (tempview.frame.size.height < 1)
        {
            [tempview setBackgroundColor: [UIColor clearColor]];
        }
    }
    
    //添加分割线
    [self.ldPickerViewBackground addSubview: self.beginLineView];
}

- (void) initializationEndPickerView
{
    //结束标题
    [self.ldPickerViewBackground addSubview: self.endTitleLabel];
    [self.endTitleLabel setText: self.endTitleStr];

    //结束选择器
    [self.ldPickerViewBackground addSubview: self.endPicker];
    
    //添加分割线
    [self.ldPickerViewBackground addSubview: self.endLineView];
}

#pragma mark ********* 选中 *********
- (void) loadCustomSelectLineAtLineView: (UIView *)lineView
{
    for (UIView *tempView in [lineView subviews])
    {
        [tempView removeFromSuperview];
    }
    
    NSInteger count = [LdDatePickerManager numberOfComponentsInPickerView: self.dateMode];
    CGFloat rowWidth = CGRectGetWidth(lineView.frame)/count;
    NSInteger height = 2.f;//设置view的高度
    CGFloat itemH = CGRectGetHeight(lineView.frame);
    
    for (int i = 0; i < 2; i ++)
    {
        for (int j = 0; j < count; j++)
        {
            UILabel * line = [[UILabel alloc] initWithFrame: CGRectMake(k_PickerLineMargin/2 + j * rowWidth,
                                                                        i * (itemH - height),
                                                                        rowWidth - k_PickerLineMargin,
                                                                        height)];
            [line setBackgroundColor: [UIColor colorWithRed: 1.f green: 96/255.f blue: 0.f alpha: 1.f]];
            line.layer.masksToBounds = YES;
            line.layer.cornerRadius = 1.f;
            [lineView addSubview: line];
        }
    }
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
        if (component < [self.dataBeginArr count])
        {
            return [self.dataBeginArr[component] count];
        }
    }
    else if (pickerView.tag == 91002)
    {
        if (component < [self.dataEndArr count])
        {
            return [self.dataEndArr[component] count];
        }
    }
    
    return 0;
}

/** 高度 */
- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return k_PickerItemHeight;
}

/** 每个item宽度 */
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    NSInteger num = [LdDatePickerManager numberOfComponentsInPickerView: self.dateMode];
    CGFloat rowWidth = (DeviceWidth - k_SupViewLRMargin*2 - k_PickerLRMargin * 2 - 6*(num - 1))/num;
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
    if (pickerView.tag == 91001)
    {
        _selectBeginStr = [LdDatePickerManager pickerView: pickerView
                                             didSelectRow: row
                                              inComponent: component
                                                 dateMode: self.dateMode
                                                  dataArr: self.dataBeginArr];
    }
    else if (pickerView.tag == 91002)
    {
        _selectEndStr = [LdDatePickerManager pickerView: pickerView
                                           didSelectRow: row
                                            inComponent: component
                                               dateMode: self.dateMode
                                                dataArr: self.dataEndArr];
    }
}

/** 改变字体和颜色 */
- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    for (UIView *tempview in pickerView.subviews)
    {
        if (tempview.frame.size.height < 1)
        {
            [tempview setBackgroundColor: [UIColor clearColor]];
        }
    }
    
    UILabel *pickerLabel = (UILabel*)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment: NSTextAlignmentCenter];
        [pickerLabel setTextColor: [UIColor blackColor]];
        [pickerLabel setFont: [UIFont systemFontOfSize: 18.f]];
    }
    
    if (pickerView.tag == 91001)
    {
        NSString *resultStr = self.dataBeginArr[component][row];
        pickerLabel.text = resultStr;
    }
    else if (pickerView.tag == 91002)
    {
        NSString *resultStr = self.dataEndArr[component][row];
        pickerLabel.text = resultStr;
    }

    return pickerLabel;
}

#pragma mark - 确定、取消
- (void) confirmBtnClick
{
    if (self.confirmResult)
    {
        if ([LdDatePickerManager isBlankString: _selectBeginStr])
        {
            _selectBeginStr = [LdDatePickerManager pickerView: self.beginPicker
                                                 didSelectRow: 0
                                                  inComponent: [self.dataBeginArr count]
                                                     dateMode: self.dateMode
                                                      dataArr: self.dataBeginArr];
        }
        
        if (self.pickerType == PickerTypeBeginEnd)
        {
            if ([LdDatePickerManager isBlankString: _selectEndStr])
            {
                _selectEndStr = [LdDatePickerManager pickerView: self.endPicker
                                                   didSelectRow: 0
                                                    inComponent: [self.dataEndArr count]
                                                       dateMode: self.dateMode
                                                        dataArr: self.dataEndArr];
            }
            
            //比较选择的开始日期是否大于结束日期
            BOOL result = [LdDatePickerManager confirmFrontCompare: _selectBeginStr
                                                            endStr: _selectEndStr
                                                          dateMode: self.dateMode];
            if (result)
            {
                //开始日期大于结束日期，弹框进行提示
                NSLog(@"开始日期大于结束日期");
                self.confirmResult(_selectBeginStr, _selectEndStr);
            }
            else
            {
                self.confirmResult(_selectBeginStr, _selectEndStr);
            }
        }
        else
        {
            self.confirmResult(_selectBeginStr, _selectEndStr);
        }
    }
    [self dismiss];
}

- (void) cannelBtnClick
{
    if (self.cannelResult)
    {
        self.cannelResult();
    }
    [self dismiss];
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
        
        [UIView animateWithDuration: 0.35
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
        [UIView animateWithDuration: 0.35
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
        [_ldPickerViewBackground setFrame: CGRectMake(k_SupViewLRMargin, (DeviceHeight - k_OnePickerHeight)/2, DeviceWidth - k_SupViewLRMargin*2, k_OnePickerHeight)];
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

/** 分割线 */
- (UILabel *) line1
{
    if (_line1 == nil)
    {
        _line1 = [[UILabel alloc] init];
        [_line1 setText: @""];
        [_line1 setBackgroundColor: [UIColor colorWithRed:229/255.f green:229/255.f blue:229/255.f alpha: 1.f]];
    }
    
    return _line1;
}
- (UILabel *) line2
{
    if (_line2 == nil)
    {
        _line2 = [[UILabel alloc] init];
        [_line2 setText: @""];
        [_line2 setBackgroundColor: [UIColor colorWithRed:229/255.f green:229/255.f blue:229/255.f alpha: 1.f]];
    }
    
    return _line2;
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

/** 开始分割线 */
- (UIView *) beginLineView
{
    if (_beginLineView == nil)
    {
        _beginLineView = [[UIView alloc] init];
        [_beginLineView setBackgroundColor: [UIColor clearColor]];
    }
    
    return _beginLineView;
}

/** 结束分割线 */
- (UIView *) endLineView
{
    if (_endLineView == nil)
    {
        _endLineView = [[UIView alloc] init];
        [_endLineView setBackgroundColor: [UIColor clearColor]];
    }
    
    return _endLineView;
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
    [self loadDataWithTime];
}

/** 日期样式 */
- (void) setDateMode:(DateMode)dateMode
{
    _dateMode = dateMode;
    
    //更新数据
    [self reloadData];
    [self loadDataWithTime];
}

/** 默认时间 */
- (void) setDefaultBeginTime:(NSString *)defaultBeginTime
{
    _defaultBeginTime = defaultBeginTime;
    
    [self loadDataWithTime];
}
- (void) setDefaultEndTime:(NSString *)defaultEndTime
{
    _defaultEndTime = defaultEndTime;
    
    [self loadDataWithTime];
}

/** 最大时间 */
- (void) setMaxTime:(NSString *)maxTime
{
    _maxTime = maxTime;
    
    [self loadDataWithTime];
}

/** 最小时间 */
- (void) setMinTime:(NSString *)minTime
{
    _minTime = minTime;
    
    [self loadDataWithTime];
}

/** 是否需要显示 24点 只能在DateModeNoMinute/DateModeNoMinuteFake/DateModeDT_YNoMinute情况下使用 */
- (void) setIsShow24:(BOOL)isShow24
{
    _isShow24 = isShow24;
    [self reloadData];
}

- (void) loadDataWithTime
{
    if (self.pickerType == PickerTypeDefault)
    {
        //开始选择器
        [LdDatePickerManager loadPickerDataWithTime: self.defaultBeginTime
                                            minTime: self.minTime
                                            maxTime: self.maxTime
                                           dateMode: self.dateMode
                                            dataArr: self.dataBeginArr
                                         pickerView: self.beginPicker];
    }
    else if (self.pickerType == PickerTypeBeginEnd)
    {
        //开始选择器
        [LdDatePickerManager loadPickerDataWithTime: self.defaultBeginTime
                                            minTime: self.minTime
                                            maxTime: self.maxTime
                                           dateMode: self.dateMode
                                            dataArr: self.dataBeginArr
                                         pickerView: self.beginPicker];
        
        //结束选择器
        [LdDatePickerManager loadPickerDataWithTime: self.defaultEndTime
                                            minTime: self.minTime
                                            maxTime: self.maxTime
                                           dateMode: self.dateMode
                                            dataArr: self.dataEndArr
                                         pickerView: self.endPicker];
    }
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
    if (self.dateMode == DateModeNoMinute ||
        self.dateMode == DateModeNoMinuteFake ||
        self.dateMode == DateModeDT_YNoMinute)
    {
        [self.dataBeginArr addObjectsFromArray: [LdDatePickerManager presetDataWithMode: self.dateMode
                                                                              isShow24H: self.isShow24]];
    }
    else
    {
        [self.dataBeginArr addObjectsFromArray: [LdDatePickerManager presetDataWithMode: self.dateMode]];
    }
    [self.beginPicker reloadAllComponents];
    [self loadCustomSelectLineAtLineView: self.beginLineView];

    if (self.pickerType == PickerTypeBeginEnd)
    {
        //结束选择器
        [self.dataEndArr removeAllObjects];
        if (self.dateMode == DateModeNoMinute ||
            self.dateMode == DateModeNoMinuteFake ||
            self.dateMode == DateModeDT_YNoMinute)
        {
            [self.dataEndArr addObjectsFromArray: [LdDatePickerManager presetDataWithMode: self.dateMode
                                                                                isShow24H: self.isShow24]];
        }
        else
        {
            [self.dataEndArr addObjectsFromArray: [LdDatePickerManager presetDataWithMode: self.dateMode]];
        }
        [self.endPicker reloadAllComponents];
        [self loadCustomSelectLineAtLineView: self.endLineView];
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
        bgHeight = k_OnePickerHeight + k_ButtonHeight + k_TitleHeight + k_TitleTopMargin;
    }
    else if (type == PickerTypeBeginEnd)
    {
        bgHeight = DeviceHeight - k_SupViewTBMargin * 2;
        [self initializationEndPickerView];
    }
    
    [self.ldPickerViewBackground setFrame: CGRectMake(k_SupViewLRMargin,
                                                      (DeviceHeight - bgHeight)/2,
                                                      DeviceWidth - k_SupViewLRMargin*2,
                                                      bgHeight)];

    //开始标题
    [self.beginTitleLabel setFrame: CGRectMake(0,
                                               k_TitleTopMargin,
                                               CGRectGetWidth(self.ldPickerViewBackground.frame),
                                               k_TitleHeight)];

    if (type == PickerTypeDefault)
    {
        //开始日期选择器
        [self.beginPicker setFrame: CGRectMake(k_PickerLRMargin,
                                               k_TitleTopMargin + k_TitleHeight,
                                               CGRectGetWidth(self.ldPickerViewBackground.frame) - k_PickerLRMargin * 2,
                                               k_OnePickerHeight)];
        //分线
        [self.beginLineView setFrame: CGRectMake(k_PickerLRMargin,
                                                 k_TitleTopMargin + k_TitleHeight + (k_OnePickerHeight - (k_PickerItemHeight+2))/2,
                                                 CGRectGetWidth(self.ldPickerViewBackground.frame) - k_PickerLRMargin * 2,
                                                 (k_PickerItemHeight+2))];
    }
    else if (type == PickerTypeBeginEnd)
    {
        [self initializationEndPickerView];

        //开始日期选择器
        [self.beginPicker setFrame: CGRectMake(k_PickerLRMargin,
                                               k_TitleTopMargin + k_TitleHeight,
                                               CGRectGetWidth(self.ldPickerViewBackground.frame) - k_PickerLRMargin * 2,
                                               (CGRectGetHeight(self.ldPickerViewBackground.frame) - k_ButtonHeight - k_TitleHeight * 2 - k_TitleTopMargin * 2)/2)];
        //分线
        [self.beginLineView setFrame: CGRectMake(k_PickerLRMargin,
                                                 k_TitleTopMargin + k_TitleHeight + (CGRectGetHeight(self.beginPicker.frame) - (k_PickerItemHeight+2))/2,
                                                 CGRectGetWidth(self.ldPickerViewBackground.frame) - k_PickerLRMargin * 2,
                                                 (k_PickerItemHeight+2))];

        //结束标题
        [self.endTitleLabel setFrame: CGRectMake(0,
                                                 CGRectGetMaxY(self.beginPicker.frame) + k_TitleTopMargin,
                                                 CGRectGetWidth(self.ldPickerViewBackground.frame),
                                                 k_TitleHeight)];

        //结束日期选择器
        [self.endPicker setFrame: CGRectMake(k_PickerLRMargin,
                                             CGRectGetMaxY(self.endTitleLabel.frame),
                                             CGRectGetWidth(self.ldPickerViewBackground.frame) - k_PickerLRMargin * 2,
                                             (CGRectGetHeight(self.ldPickerViewBackground.frame) - k_ButtonHeight - k_TitleHeight * 2 - k_TitleTopMargin * 2)/2)];
        //分线
        [self.endLineView setFrame: CGRectMake(k_PickerLRMargin,
                                                 CGRectGetMaxY(self.endTitleLabel.frame) + (CGRectGetHeight(self.endPicker.frame) - (k_PickerItemHeight+2))/2,
                                                 CGRectGetWidth(self.ldPickerViewBackground.frame) - k_PickerLRMargin * 2,
                                                 (k_PickerItemHeight+2))];
    }

    //取消选择按钮
    [self.cannelBtn setFrame: CGRectMake(0,
                                         CGRectGetHeight(self.ldPickerViewBackground.frame) - k_ButtonHeight,
                                         CGRectGetWidth(self.ldPickerViewBackground.frame) / 2.f,
                                         k_ButtonHeight)];
    
    //确认选择按钮
    [self.confirmBtn setFrame: CGRectMake(CGRectGetWidth(self.ldPickerViewBackground.frame)/2,
                                          CGRectGetHeight(self.ldPickerViewBackground.frame) - k_ButtonHeight,
                                          CGRectGetWidth(self.ldPickerViewBackground.frame)/2,
                                          k_ButtonHeight)];
    
    [self.line1 setFrame: CGRectMake(0,
                                     CGRectGetHeight(self.ldPickerViewBackground.frame) - k_ButtonHeight,
                                     CGRectGetWidth(self.ldPickerViewBackground.frame),
                                     0.5f)];
    
    [self.line2 setFrame: CGRectMake(CGRectGetWidth(self.ldPickerViewBackground.frame)/2,
                                     CGRectGetHeight(self.ldPickerViewBackground.frame) - k_ButtonHeight,
                                     0.5f,
                                     k_ButtonHeight)];
}

@end
