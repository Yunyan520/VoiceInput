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
    UIButton *_sendBtn;
    UIViewController *_selfController;
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
    if(_textView.text.length != 0)
    {
        _sendBtn.hidden = NO;
    }
}
- (void)configUI
{
    CGRect tectViewRect =CGRectMake(0, 0, IPHONE5sWIDTH, 80);
    _textView = [[UITextView alloc] initWithFrame:[MyFrame myRectWithX:tectViewRect]];
    _textView.delegate = self;
    _textView.editable = NO;
    _textView.font = [UIFont systemFontOfSize:18];
    [self addSubview:_textView];
    
    CGRect contentRect = CGRectMake(0, 90, IPHONE5sWIDTH, 110);
    _contenView = [[UIView alloc] initWithFrame:[MyFrame myRectWithX:contentRect]];
    [self addSubview:_contenView];
    [self configContentView];
}
- (void)configContentView
{
    CGRect labelRect = CGRectMake(120, 0, 80, 20);
    UILabel *label = [[UILabel alloc] initWithFrame:[MyFrame myRectWithX:labelRect]];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"按住说话";
    [_contenView addSubview:label];
    
    UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect recordBtnRect = CGRectMake(130, 25, 60, 60);
    recordBtn.frame = [MyFrame myRectWithX:recordBtnRect];
    [recordBtn setBackgroundColor:[UIColor redColor]];
    [recordBtn addTarget:self action:@selector(recordStart:) forControlEvents:UIControlEventTouchDown];
    [recordBtn addTarget:self action:@selector(recordFinish:) forControlEvents:UIControlEventTouchUpInside];
    [_contenView addSubview:recordBtn];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect cancleBtnRect = CGRectMake(20, 30, 50, 40);
    cancleBtn.frame = [MyFrame myRectWithX:cancleBtnRect];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
    [_contenView addSubview:cancleBtn];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect sendBtnRect = CGRectMake(250, 30, 50, 40);
    _sendBtn.frame = [MyFrame myRectWithX:sendBtnRect];
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
    CGFloat myY=[UIScreen mainScreen].bounds.size.height/IPHONE5sHEIGHT;
    CGFloat segMentY = 64/myY;
    CGRect viewRect = CGRectMake(0, segMentY, IPHONE5sWIDTH, IPHONE5sHEIGHT);
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = [MyFrame myRectWithX:viewRect];
    }];
    _contenView.hidden = YES;
    _isEdiding = YES;
    [self setSelfRootNavigation];
    return true;
}
- (void)textViewDidChange:(UITextView *)textView
{
    _sendBtn.hidden = textView.text.length?NO:YES;
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
