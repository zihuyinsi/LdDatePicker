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
