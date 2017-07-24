//
//  Screen.h
//  InsectScoring
//
//  Created by lidianchao on 2017/7/17.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#ifndef Screen_h
#define Screen_h


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIImageSize(image) image.size
#define RealSize(size) (size)/2
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenRect [UIScreen mainScreen].bounds
#define IPHONE5sWIDTH 320
#define IPHONE5sHEIGHT 568

#define ZeroX 0
#define ZeroY 0
#endif /* Screen_h */
