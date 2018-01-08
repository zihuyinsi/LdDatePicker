//
//  ViewController.m
//  LdDatePicker
//
//  Created by lv on 2017/12/19.
//  Copyright © 2017年 lv. All rights reserved.
//

#import "ViewController.h"
#import "LdDatePickerView.h"

@interface ViewController ()

@property (nonatomic, strong) LdDatePickerView *ld_DPView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeSystem];
    [btn setTitle: @"picker view" forState: UIControlStateNormal];
    [btn addTarget: self
            action: @selector(btnClick)
  forControlEvents: UIControlEventTouchUpInside];
    [btn setFrame: CGRectMake(100, 100, 100, 40)];
    [self.view addSubview: btn];
    
    _ld_DPView = [[LdDatePickerView alloc] init];
    _ld_DPView.showType = ShowTypeDown_Up;
    _ld_DPView.dismissType = DismissTypeRight_Left;
    _ld_DPView.pickerType = PickerTypeBeginEnd;
    _ld_DPView.dateMode = DateModeNoMinuteFake;
//    _ld_DPView.isShow24 = YES;
    _ld_DPView.minTime = @"2000-12-20 12:24:36";
    _ld_DPView.maxTime = @"2030-12-20 12:23:34";
    _ld_DPView.defaultBeginTime = @"2012-2-12 13:27:24";
    _ld_DPView.defaultEndTime = @"2017-12-2 17:27:24";
    _ld_DPView.beginTitleStr = @"开始日期";
    _ld_DPView.endTitleStr = @"结束日期";
    
    _ld_DPView.confirmResult = ^(NSString *beginResultStr, NSString *endResultStr) {
        NSLog(@"beginResultStr = %@", beginResultStr);
        NSLog(@"endResultStr = %@", endResultStr);
    };
}

- (void) btnClick
{
    [_ld_DPView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
