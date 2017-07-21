//
//  ViewController.m
//  VoiceInputDemo
//
//  Created by lidianchao on 2017/7/20.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "RootViewController.h"
#import "InputView.h"
#import "BankViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController
{
    InputView *_inputView;
    UIButton *_inputBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigation];
    [self configUI];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)initNavigation
{
    self.navigationItem.title = @"语音输入";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"微信" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"查看" style:UIBarButtonItemStyleDone target:self action:@selector(finish:)];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;
}
- (void)back:(id)sender
{
    if(_inputView.isEdiding)
    {
        [self finishEditing];
    }
}
- (void)finish:(id)sender
{
    if(_inputView.isEdiding)
    {
        [self finishEditing];
        return;
    }
    BankViewController *bankVc = [[BankViewController alloc] init];
    [self.navigationController pushViewController:bankVc animated:YES];
}
- (void)finishEditing
{
    [UIView animateWithDuration:0.5 animations:^{
        _inputView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 200, [UIScreen mainScreen].bounds.size.width, 200);
    }];
    self.navigationItem.title = @"语音输入";
    self.navigationItem.leftBarButtonItem.title = @"微信";
    self.navigationItem.rightBarButtonItem.title = @"查看";
    _inputView.isEdiding = NO;
    [_inputView.textView resignFirstResponder];
    _inputView.contenView.hidden = NO;
}
- (void)configUI
{
    _inputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _inputBtn.frame = CGRectMake(120, 80, 120, 50);
    [_inputBtn setBackgroundColor:[UIColor redColor]];
    [_inputBtn setTitle:@"语音输入" forState:UIControlStateNormal];
    [_inputBtn addTarget:self action:@selector(voiceInput:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_inputBtn];
}
- (void)voiceInput:(UIButton *)sender
{
    _inputBtn.hidden = YES;
    _inputView = [[InputView alloc] initWithFrame:CGRectMake(0, 700, [UIScreen mainScreen].bounds.size.width, 200) controller:self];
    __weak RootViewController *weakSelf = self;
    _inputView.cancleCallback = ^(){
        [weakSelf cancleInput];
    };
    [self.view addSubview:_inputView];
    [UIView animateWithDuration:0.5 animations:^{
        _inputView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 200, [UIScreen mainScreen].bounds.size.width, 200);
    }];
}
- (void)cancleInput
{
    [UIView animateWithDuration:0.5 animations:^{
        _inputView.frame = CGRectMake(0, 700, [UIScreen mainScreen].bounds.size.width, 200);
    }];
    self.navigationItem.title = @"语音输入";
    _inputBtn.hidden = NO;
    _inputView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
