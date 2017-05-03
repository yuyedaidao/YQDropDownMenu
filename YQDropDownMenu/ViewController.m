//
//  ViewController.m
//  YQDropDownMenu
//
//  Created by Wang on 2017/5/3.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import "ViewController.h"
#import "YQDropDownMenu.h"

@interface ViewController () <YQDropDownMenuDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showAction:(UIButton *)sender {
    YQDropDownMenu *menu = [YQDropDownMenu create];
    menu.delegate = self;
    menu.locationReferView = sender;
    menu.titleArray = @[@"喝咯", @"adaga"];
    [menu show];
}

- (void)dropDownMenu:(YQDropDownMenu *)menu didClickRow:(NSInteger)row {
    NSLog(@"row :%ld",row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
