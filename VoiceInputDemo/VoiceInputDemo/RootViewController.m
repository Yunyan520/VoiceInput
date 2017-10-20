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
    CGRect _viewBeforeShow;
    CGRect _viewAfterShow;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNavigation];
    [self configUI];

    // Do any additional setup after loading the view, typically from a nib.
}
- (void)initData
{
    _viewBeforeShow = CGRectMake(0, 700, IPHONE5sWIDTH, 200);
    _viewAfterShow = CGRectMake(0, IPHONE5sHEIGHT - 200, IPHONE5sWIDTH, 200);
}
- (void)initNavigation
{
    self.navigationItem.title = @"语音输入";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"微信" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"查看" style:UIBarButtonItemStyleDone target:self action:@selector(finish:)];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;
}
- (void)configUI
{
    CGRect btnRect = CGRectMake(120, 80, 80, 50);
    _inputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _inputBtn.frame = [MyFrame myRectWithX:btnRect];//    CGRectMake(120, 80, 120, 50);
    [_inputBtn setBackgroundColor:[UIColor redColor]];
    [_inputBtn setTitle:@"语音输入" forState:UIControlStateNormal];
    [_inputBtn addTarget:self action:@selector(voiceInput:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_inputBtn];
}

- (void)cancleInput
{
    [UIView animateWithDuration:0.5 animations:^{
        _inputView.frame = [MyFrame myRectWithX:_viewBeforeShow];//CGRectMake(0, 700, [UIScreen mainScreen].bounds.size.width, 200);
    }];
    self.navigationItem.title = @"语音输入";
    _inputBtn.hidden = NO;
    _inputView = nil;
}
#pragma -mark buttonEvent
- (void)voiceInput:(UIButton *)sender
{
    _inputBtn.hidden = YES;
    _inputView = [[InputView alloc] initWithFrame:[MyFrame myRectWithX:[MyFrame myRectWithX:_viewBeforeShow]] controller:self];
    __weak RootViewController *weakSelf = self;
    _inputView.cancleCallback = ^(){
        [weakSelf cancleInput];
    };
    [self.view addSubview:_inputView];
    [UIView animateWithDuration:0.5 animations:^{
        _inputView.frame = [MyFrame myRectWithX:_viewAfterShow];
    }];
}
- (void)back:(id)sender
{
    if(_inputView.isEdiding)
    {
        [self finishEditing];
        return;
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
    _inputView.isEdiding = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _inputView.frame = [MyFrame myRectWithX:_viewAfterShow];
    }];
    self.navigationItem.title = @"语音输入";
    self.navigationItem.leftBarButtonItem.title = @"微信";
    self.navigationItem.rightBarButtonItem.title = @"查看";
    if(_inputView.textView.text.length == 0)
    {
        _inputView.textView.editable = NO;
    }
    [_inputView.textView resignFirstResponder];
    _inputView.contenView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
