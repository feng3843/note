//
//  UIImage+Resize.h
//  GuardAngel
//
//  Created by 朱鑫华 on 16/6/7.
//  Copyright © 2016年 GA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)
- (UIImage *)reSizeImagetoSize:(CGSize)reSize;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end
