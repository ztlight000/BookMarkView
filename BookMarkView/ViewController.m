//
//  ViewController.m
//  BookMarkView
//
//  Created by 张涛 on 2018/3/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ViewController.h"
#import "ProgramPageController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"首页";
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 170, 44)];
    
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    nextBtn.backgroundColor = [UIColor redColor];
    
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [nextBtn setTitle:@"前往BookMark" forState:UIControlStateNormal];
    
    [self.view addSubview:nextBtn];
    
}

- (void)nextBtnClick {
    
    ProgramPageController *programVC = [[ProgramPageController alloc] init];
    
    [self.navigationController pushViewController:programVC animated:YES];
    
}

@end



