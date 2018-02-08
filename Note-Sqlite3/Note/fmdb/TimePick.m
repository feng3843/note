//
//  TimePick.m
//  GuardAngel
//
//  Created by 朱鑫华 on 16/10/11.
//  Copyright © 2016年 GA. All rights reserved.
//

#import "TimePick.h"
#import "HexColors.h"



#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height

@interface TimePick () <UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger selectYear;
    NSInteger selectMonth;
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
}
@end

@implementation TimePick
-(instancetype)init{
    self = [super init];
    if(self){
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.frame = CGRectMake(0, 0, screenW, screenH);
    self.backgroundColor = [UIColor clearColor];
    
    //遮罩
    UIButton *coverBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - 248)];
    [coverBtn addTarget:self action:@selector(popPickerView) forControlEvents:UIControlEventTouchUpInside];
    [coverBtn setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"7f7f7f"]];
    [self addSubview:coverBtn];
    coverBtn.alpha = 0.3;
    //背景
    UIView *bgV = [[UIView alloc]initWithFrame:CGRectMake(0, screenH - 248, screenW, 248)];
    bgV.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"ffffff"];
    [self addSubview:bgV];
    //取消
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 18, 38, 20)];
    [cancelBtn addTarget:self action:@selector(popPickerView) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"999999"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [bgV addSubview:cancelBtn];
    //重置筛选
    UIButton *noBtn = [[UIButton alloc]initWithFrame:CGRectMake(15+100, 18, 80, 20)];
    [noBtn addTarget:self action:@selector(popPickerViewchongzhi) forControlEvents:UIControlEventTouchUpInside];
    [noBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"999999"] forState:UIControlStateNormal];
    [noBtn setTitle:@"重置筛选" forState:UIControlStateNormal];
    noBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [bgV addSubview:noBtn];
    
    //确定
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenW -15 - 38, 18, 38, 20)];
    [sureBtn addTarget:self action:@selector(pickerViewBtnOK) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"2e68dd"] forState:UIControlStateNormal];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [bgV addSubview:sureBtn];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 36, screenW, 212)];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate new];
    int year = (int)[calendar component:NSCalendarUnitYear fromDate:date];
    yearArray = [NSMutableArray array];
    monthArray = [NSMutableArray array];
    for (int i = 0 ; i < 80 ; i++){
        if (year - i > 2015) {
        [yearArray addObject:[NSNumber numberWithInt:year - i]];
        }else{
            break;
        }
        
    }
    for (int i = 1 ; i <= 12 ; i++){
        [monthArray addObject:[NSNumber numberWithInt:i]];
    }
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [bgV addSubview:_pickerView];
}

-(void)popPickerView{
    NSLog(@"移除控件!");
    [self removeFromSuperview];
}

-(void)popPickerViewchongzhi{
    if (self.selectBlock) {
        self.selectBlock(nil);
    }
    [self popPickerView];
}

-(void)pickerViewBtnOK{
    if (self.selectBlock) {
        int year = [yearArray[selectYear] intValue];
        int month = [monthArray[selectMonth] intValue];
        NSString *str;
        if(!self.onlyShowYear){
            str = [NSString stringWithFormat:@"%d-%02d",year,month];
        }else{
            str = [NSString stringWithFormat:@"%d",year];
        }
        self.selectBlock(str);
    }
    [self popPickerView];
}

#pragma mark - UIPickerViewDataSource

//返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.onlyShowYear) {
        return 1;
    }else{
        return 2;
    }
}

//每列对应多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return yearArray.count;
    }else{
        return monthArray.count;
    }
}

//每行显示的数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        int year = [yearArray[row] intValue];
        return [NSString stringWithFormat:@"%d",year];
    }else{
        int month = [monthArray[row] intValue];
        return [NSString stringWithFormat:@"%02d",month];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return (screenW - 60) * 0.5;
}

#pragma mark - UIPickerViewDelegate

//选中pickerView的某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        selectYear = row;
    }else{
        selectMonth = row;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"333333"]];
        [pickerLabel setFont:[UIFont systemFontOfSize:24]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

@end
