//
//  TimePick.h
//  GuardAngel
//
//  Created by 朱鑫华 on 16/10/11.
//  Copyright © 2016年 GA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MyBasicBlock)(id result);

typedef NS_ENUM(NSInteger, TimePickStyle){
    TimePickStyleAll,
    TimePickStyleOnlyShowYear,
    TimePickStyleOnlyShowYearAndMonth
};


@interface TimePick : UIView

+(instancetype)timePcikWithStyle:(TimePickStyle)style;

@property (retain, nonatomic) UIPickerView *pickerView;

@property (nonatomic, copy) MyBasicBlock selectBlock;

@property (nonatomic,copy) NSString  * selectTime;

-(void)popPickerView;

@end
