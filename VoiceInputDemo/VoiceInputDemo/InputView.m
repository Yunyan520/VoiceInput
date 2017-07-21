//
//  InputView.m
//  VoiceInputDemo
//
//  Created by lidianchao on 2017/7/20.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "InputView.h"
#import <Speech/Speech.h>

@interface InputView()<SFSpeechRecognizerDelegate,UITextViewDelegate>
@property (nonatomic, strong) AVAudioEngine *audioEngine;                           // 声音处理器
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;                 // 语音识别器
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *speechRequest; // 语音请求对象
@property (nonatomic, strong) SFSpeechRecognitionTask *currentSpeechTask;           // 当前语音识别进程
@end

@implementation InputView
{
//    UITextView *_textView;
    UIButton *_sendBtn;
    UIViewController *_selfController;
//    UIView *_contenView;
    CGRect _frame;
}
- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _frame = frame;
        _selfController = controller;
//        self.backgroundColor = [UIColor greenColor];
        [self initAudioEngine];
        [self configUI];
    }
    return self;
}
- (void)initAudioEngine
{
    // 初始化
    self.audioEngine = [AVAudioEngine new];
    // 这里需要先设置一个AVAudioEngine和一个语音识别的请求对象SFSpeechAudioBufferRecognitionRequest
    self.speechRecognizer = [SFSpeechRecognizer new];
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status)
     {
         if (status != SFSpeechRecognizerAuthorizationStatusAuthorized)
         {
             // 如果状态不是已授权则return
             return;
         }
         
         // 初始化语音处理器的输入模式
         [self.audioEngine.inputNode installTapOnBus:0 bufferSize:1024 format:[self.audioEngine.inputNode outputFormatForBus:0] block:^(AVAudioPCMBuffer * _Nonnull buffer,AVAudioTime * _Nonnull when)
          {
              // 为语音识别请求对象添加一个AudioPCMBuffer，来获取声音数据
              [self.speechRequest appendAudioPCMBuffer:buffer];
          }];
         // 语音处理器准备就绪（会为一些audioEngine启动时所必须的资源开辟内存）
         [self.audioEngine prepare];
     }];
}
- (void)startDictating
{
    NSError *error;
    // 启动声音处理器
    [self.audioEngine startAndReturnError: &error];
    // 初始化
    self.speechRequest = [SFSpeechAudioBufferRecognitionRequest new];
    // 使用speechRequest请求进行识别
    self.currentSpeechTask =
    [self.speechRecognizer recognitionTaskWithRequest:self.speechRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result,NSError * _Nullable error)
     {
         // 识别结果，识别后的操作
         if (result == NULL) return;
         _textView.editable = YES;
         _textView.text = result.bestTranscription.formattedString;
     }];
}

- (void)stopDictating
{
    // 停止声音处理器，停止语音识别请求进程
    [self.audioEngine stop];
    [self.speechRequest endAudio];
    _sendBtn.hidden = NO;
}
- (void)configUI
{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    _textView.delegate = self;
    _textView.editable = NO;
    _textView.font = [UIFont systemFontOfSize:18];
    [self addSubview:_textView];
    
    _contenView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, [UIScreen mainScreen].bounds.size.width, 110)];
    [self addSubview:_contenView];
    [self configContentView];
}
- (void)configContentView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 120, 20)];
    label.text = @"按住说话";
    [_contenView addSubview:label];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(30, 30, 50, 40);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
    [_contenView addSubview:cancleBtn];
    
    UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recordBtn.frame = CGRectMake(152, 25, 60, 60);
    [recordBtn setBackgroundColor:[UIColor redColor]];
    [recordBtn addTarget:self action:@selector(recordStart:) forControlEvents:UIControlEventTouchDown];
    [recordBtn addTarget:self action:@selector(recordFinish:) forControlEvents:UIControlEventTouchUpInside];
    [_contenView addSubview:recordBtn];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame = CGRectMake(270, 30, 50, 50);
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(sendVoiceMessage:) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn.hidden = YES;
    [_contenView addSubview:_sendBtn];

}
- (void)cancle:(UIButton *)sender
{
    _cancleCallback();
}
- (void)recordStart:(UIButton *)sender
{
    sender.backgroundColor = [UIColor greenColor];
    [self startDictating];
}
- (void)recordFinish:(UIButton *)sender
{
    sender.backgroundColor = [UIColor redColor];
    [self stopDictating];
}
- (void)sendVoiceMessage:(UIButton *)sender
{
    NSLog(@"%@",_textView.text);
}
#pragma -mark UITextFieldDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }];
    _contenView.hidden = YES;
    _isEdiding = YES;
    [self setSelfRootNavigation];
    return true;
}
- (void)setSelfRootNavigation
{
    _selfController.navigationItem.title = @"编辑文字";
    _selfController.navigationItem.leftBarButtonItem.title = @"返回";
    _selfController.navigationItem.rightBarButtonItem.title = @"完成";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
