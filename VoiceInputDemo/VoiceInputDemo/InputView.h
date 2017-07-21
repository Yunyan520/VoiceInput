//
//  InputView.h
//  VoiceInputDemo
//
//  Created by lidianchao on 2017/7/20.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InputViewCancleInputCallback)(void);


@interface InputView : UIView

@property(nonatomic, strong) UIView *contenView;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, copy) InputViewCancleInputCallback cancleCallback;
@property(nonatomic, assign) BOOL isEdiding;
- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controller;

@end
