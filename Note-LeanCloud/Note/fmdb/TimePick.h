//
//  TimePick.h
//  GuardAngel
//
//  Created by 朱鑫华 on 16/10/11.
//  Copyright © 2016年 GA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MyBasicBlock)(id result);
@interface TimePick : UIView

@property (retain, nonatomic) UIPickerView *pickerView;

@property (nonatomic,assign) BOOL  onlyShowYear;

@property (nonatomic,assign) BOOL  onlyShowYearAndMonth;

@property (nonatomic, copy) MyBasicBlock selectBlock;

- (void)popPickerView;
@end
