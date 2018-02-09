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
    NSInteger selectDay;
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSMutableArray *dayArray;
}
/**只显示年*/
@property (nonatomic,assign) BOOL  onlyShowYear;

/**只显示年和月*/
@property (nonatomic,assign) BOOL  onlyShowYearAndMonth;
@end

@implementation TimePick

+(instancetype)timePcikWithStyle:(TimePickStyle)style{
    TimePick *timePick = [[TimePick alloc]init];
    if (style == TimePickStyleOnlyShowYear) {
        timePick.onlyShowYear = YES;
        timePick.onlyShowYearAndMonth = NO;
    }else if (style == TimePickStyleOnlyShowYearAndMonth){
        timePick.onlyShowYearAndMonth = YES;
        timePick.onlyShowYear = NO;
    }else{
        timePick.onlyShowYearAndMonth = NO;
        timePick.onlyShowYear = NO;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [dateFormatter stringFromDate:[NSDate date]];
    timePick.selectTime = timeStr;
    return timePick;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
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
    UIButton *noBtn = [[UIButton alloc]initWithFrame:CGRectMake(15+38+(screenW - 186)*0.5, 18, 80, 20)];
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
    for (int i = 0 ; i < 80 ; i++){
        if (year - i > 2015) {
        [yearArray addObject:[NSNumber numberWithInt:year - i]];
        }else{
            break;
        }
    }
    
    monthArray = [NSMutableArray array];
    for (int i = 1 ; i <= 12 ; i++){
        [monthArray addObject:[NSNumber numberWithInt:i]];
    }
    dayArray = [NSMutableArray array];
    for (int i = 1 ; i <= 31 ; i++){
        [dayArray addObject:[NSNumber numberWithInt:i]];
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
        NSString *str;
        if(self.onlyShowYear){
            str = [NSString stringWithFormat:@"%d",year];
        }else if(self.onlyShowYearAndMonth){
            selectMonth = [self.pickerView selectedRowInComponent:1];
            int month = [monthArray[selectMonth] intValue];
            str = [NSString stringWithFormat:@"%d-%02d",year,month];
        }else{
            selectMonth = [self.pickerView selectedRowInComponent:1];
            int month = [monthArray[selectMonth] intValue];
            selectDay = [self.pickerView selectedRowInComponent:2];
            int day = [dayArray[selectDay] intValue];
            str = [NSString stringWithFormat:@"%d-%02d-%02d",year,month,day];
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
    }else if (self.onlyShowYearAndMonth){
        return 2;
    }else{
        return 3;
    }
}

//每列对应多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return yearArray.count;
    }else if (component == 1){
        return monthArray.count;
    }else{
//        if (!self.onlyShowYear && !self.onlyShowYearAndMonth) {
//            if (selectYear % 4 == 0 && selectMonth == 2) {
//                dayArray = [NSMutableArray array];
//                for (int i = 1 ; i <= 29 ; i++){
//                    [dayArray addObject:[NSNumber numberWithInt:i]];
//                }
//            }else if (selectYear % 4 != 0 && selectMonth == 2) {
//                dayArray = [NSMutableArray array];
//                for (int i = 1 ; i <= 28 ; i++){
//                    [dayArray addObject:[NSNumber numberWithInt:i]];
//                }
//            }else if (selectMonth == 4 ||selectMonth == 6 ||selectMonth == 9 || selectMonth == 11){
//                dayArray = [NSMutableArray array];
//                for (int i = 1 ; i <= 30 ; i++){
//                    [dayArray addObject:[NSNumber numberWithInt:i]];
//                }
//            }else{
//                dayArray = [NSMutableArray array];
//                for (int i = 1 ; i <= 31 ; i++){
//                    [dayArray addObject:[NSNumber numberWithInt:i]];
//                }
//            }
//        }
        return dayArray.count;
    }
}

//每行显示的数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        int year = [yearArray[row] intValue];
        return [NSString stringWithFormat:@"%d",year];
    }else if (component == 1){
        int month = [monthArray[row] intValue];
        return [NSString stringWithFormat:@"%02d",month];
    }else{
//        if (!self.onlyShowYear && !self.onlyShowYearAndMonth) {
//            if (selectYear % 4 == 0 && selectMonth == 2) {
//                dayArray = [NSMutableArray array];
//                for (int i = 1 ; i <= 29 ; i++){
//                    [dayArray addObject:[NSNumber numberWithInt:i]];
//                }
//            }else if (selectYear % 4 != 0 && selectMonth == 2) {
//                dayArray = [NSMutableArray array];
//                for (int i = 1 ; i <= 28 ; i++){
//                    [dayArray addObject:[NSNumber numberWithInt:i]];
//                }
//            }else if (selectMonth == 4 ||selectMonth == 6 ||selectMonth == 9 || selectMonth == 11){
//                dayArray = [NSMutableArray array];
//                for (int i = 1 ; i <= 30 ; i++){
//                    [dayArray addObject:[NSNumber numberWithInt:i]];
//                }
//            }else{
//                dayArray = [NSMutableArray array];
//                for (int i = 1 ; i <= 31 ; i++){
//                    [dayArray addObject:[NSNumber numberWithInt:i]];
//                }
//            }
//        }
        int day = [dayArray[row] intValue];
        return [NSString stringWithFormat:@"%02d",day];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (self.onlyShowYearAndMonth || self.onlyShowYear) {
        return (screenW - 60) *0.5 ;
    }else{
        return (screenW - 90) /3.0 ;
    }
}

-(void)setSelectTime:(NSString *)selectTime{
    _selectTime = selectTime;
    if (selectTime.length < 4) return;
    NSString *year = [selectTime substringToIndex:4];
    //设置年
    for (int i = 0; i < yearArray.count; i ++) {
        if ([year intValue] == [yearArray[i] intValue]) {
            [self.pickerView selectRow:i inComponent:0 animated:NO];
        }
    }
    
    if (self.onlyShowYear) return;
    //设置月
    if (selectTime.length < 7) return;
    NSString *month = [selectTime substringWithRange:NSMakeRange(5, 2)];
    for (int i = 0; i < monthArray.count; i ++) {
        if ([month intValue] == [monthArray[i] intValue]) {
            [self.pickerView selectRow:i inComponent:1 animated:NO];
        }
    }
    
    if (self.onlyShowYearAndMonth) return;
    //设置日
    if (selectTime.length < 10) return;
    NSString *day = [selectTime substringWithRange:NSMakeRange(8, 2)];
    for (int i = 0; i < dayArray.count; i ++) {
        if ([day intValue] == [dayArray[i] intValue]) {
            [self.pickerView selectRow:i inComponent:2 animated:NO];
        }
    }
    
    
    
}

#pragma mark - UIPickerViewDelegate

//选中pickerView的某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        selectYear = row;
    }else if (component == 1){
        selectMonth = row;
        if (!self.onlyShowYear && !self.onlyShowYearAndMonth) {
//            selectMonth是数据下标 所以实际月数要+1
            if (selectYear % 4 == 0 && selectMonth + 1 == 2) {
                dayArray = [NSMutableArray array];
                for (int i = 1 ; i <= 29 ; i++){
                    [dayArray addObject:[NSNumber numberWithInt:i]];
                }
            }else if (selectYear % 4 != 0 && selectMonth + 1 == 2) {
                dayArray = [NSMutableArray array];
                for (int i = 1 ; i <= 28 ; i++){
                    [dayArray addObject:[NSNumber numberWithInt:i]];
                }
            }else if (selectMonth + 1 == 4 ||selectMonth + 1 == 6 ||selectMonth + 1 == 9 || selectMonth + 1 == 11){
                dayArray = [NSMutableArray array];
                for (int i = 1 ; i <= 30 ; i++){
                    [dayArray addObject:[NSNumber numberWithInt:i]];
                }
            }else{
                dayArray = [NSMutableArray array];
                for (int i = 1 ; i <= 31 ; i++){
                    [dayArray addObject:[NSNumber numberWithInt:i]];
                }
            }
            [pickerView reloadComponent:2];
        }

        
    }else{
        selectDay = row;
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
