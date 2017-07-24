//
//  MyFrame.h
//  OMESPACE
//
//  Created by lidianchao on 15/6/10.
//  Copyright (c) 2015年 lidianchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Screen.h"

struct UIMessage {
    CGRect rect;
    CGFloat font;
    __unsafe_unretained NSString *text;
};
typedef struct UIMessage UIMessage;

CG_INLINE UIMessage
UIMessageMake(CGRect rect, CGFloat font)
{
    UIMessage message;
    message.rect = rect;
    message.font = font;
    return message;
}
CG_INLINE UIMessage
UIMessageMakeWithText(CGRect rect, CGFloat font, NSString *text)
{
    UIMessage message;
    message.rect = rect;
    message.font = font;
    message.text = text;
    return message;
}

@interface MyFrame : UIView

+ (CGRect)myRectWithX:(CGRect)rect;
+ (CGSize)mySizeWithWidth:(CGSize)size;
+ (CGPoint)myPointWithX:(CGPoint)point;
+ (CGFloat)myValue:(CGFloat)value;
@end
