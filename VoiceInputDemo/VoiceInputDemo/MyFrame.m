//
//  MyFrame.m
//  OMESPACE
//
//  Created by lidianchao on 15/6/10.
//  Copyright (c) 2015年 lidianchao. All rights reserved.
//

#import "MyFrame.h"

@implementation MyFrame
+ (CGRect)myRectWithX:(CGRect)rect
{
    CGFloat myX = ScreenWidth/IPHONE5sWIDTH;
    CGFloat myY = ScreenHeight/IPHONE5sHEIGHT;
    return CGRectMake(rect.origin.x*myX, rect.origin.y*myY, rect.size.width*myX, rect.size.height*myY);
}
+ (CGSize)mySizeWithWidth:(CGSize)size
{
    CGFloat myX = ScreenWidth/IPHONE5sWIDTH;
    CGFloat myY = ScreenHeight/IPHONE5sHEIGHT;
    return CGSizeMake(size.width*myX, size.height*myY);
}
+ (CGPoint)myPointWithX:(CGPoint)point
{
    CGFloat myX = ScreenWidth/IPHONE5sWIDTH;
    CGFloat myY = ScreenHeight/IPHONE5sHEIGHT;
    return CGPointMake(point.x*myX, point.y*myY);
}
+ (CGFloat)myValue:(CGFloat)value
{
    CGFloat myValue = ScreenHeight/IPHONE5sHEIGHT;
    return (value * myValue);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
