//
//  ViewController.m
//  Note
//
//  Created by 朱鑫华 on 2017/11/22.
//  Copyright © 2017年 朱鑫华. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
#import <sqlite3.h>
#import "Bill.h"
#import "MBProgressHUD+MJ.h"
#import "HexColors.h"
#import "StringPick.h"
#import <AVOSCloud/AVOSCloud.h>
#import "TimePick.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *count;
@property (weak, nonatomic) IBOutlet UITextField *detial;
@property (nonatomic,strong) FMDatabase *db;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *deletebtn;
@property (weak, nonatomic) IBOutlet UIButton *addnewbtn;
@property (nonatomic,copy) NSString  * kind;
@property (nonatomic,copy) NSString  * date;
@property (weak, nonatomic) IBOutlet UILabel *kindL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.addnewbtn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"0b5fff"];
    self.addnewbtn.layer.cornerRadius = 4;
    self.addnewbtn.layer.masksToBounds = YES;
    //获取路径
//    NSString *filepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *filename = [filepath stringByAppendingPathComponent:@"bill.sqlite"];
    self.deletebtn.hidden = YES;
    self.deletebtn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"FF4444"];
    self.deletebtn.layer.cornerRadius = 4;
    self.deletebtn.layer.masksToBounds = YES;
    
    if (self.bill) {
        self.kind = self.bill.kind;
        self.date = self.bill.date;
        self.kindL.text = self.kind;
        self.count.text = [NSString stringWithFormat:@"%.2f",self.bill.count];
        self.detial.text = self.bill.detail;
        self.deletebtn.hidden = NO;
        [self.addnewbtn setTitle:@"修改保存" forState:UIControlStateNormal];
    }
    
}



- (IBAction)selBtnClick:(UIButton *)selBtn {
    StringPick *strPick = [StringPick new];
    strPick.dataArray = @[@"衣服",@"饮食",@"居住",@"交通",@"人情往来",@"医疗",@"娱乐",@"其他"];
    strPick.selectBlock = ^(NSString *str){
        if (str.length > 0) {
            self.kind = str;
            NSLog(@"%@",self.kind);
            self.kindL.text = self.kind;
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:strPick];
}


- (IBAction)addNewBill:(UIButton *)sender {
    [self.count resignFirstResponder];
    [self.detial resignFirstResponder];
    [self.view resignFirstResponder];
    NSLog(@"%@",self.kind);
    if (self.kind.length <= 0) {
        [MBProgressHUD showError:@"未选择类型！"];
        return;
    }
    if([self.count.text floatValue] <= 0){
        [MBProgressHUD showError:@"请输入消费金额！"];
        return;
    }
    NSString *detail = self.detial.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [dateFormatter stringFromDate:[NSDate date]];
    if (self.date) {
        timeStr = self.date;
    }
    if(self.bill){
        //修改
        // 第一个参数是 className，第二个参数是 objectId
        AVObject *billOBJ =[AVObject objectWithClassName:@"Bill" objectId:self.bill.objectId];
        // 修改属性
        [billOBJ setObject:self.kind forKey:@"kind"];
        [billOBJ setObject:@([self.count.text floatValue]) forKey:@"count"];
        [billOBJ setObject:timeStr forKey:@"date"];
        [billOBJ setObject:detail forKey:@"detail"];
        // 保存到云端
        [billOBJ saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [MBProgressHUD showSuccess:@"修改成功！"];
                if (self.needRefreshData) {
                    self.needRefreshData(YES);
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                NSDictionary *dict = error.userInfo;
                [MBProgressHUD showError:[NSString stringWithFormat:@"修改失败：%@",dict[@"error"]]];
            }
        }];
    }else{
        //新增
        AVUser *currentUser = [AVUser currentUser];
        AVObject *billOBJ = [AVObject objectWithClassName:@"Bill"];
        [billOBJ setObject:self.kind forKey:@"kind"];
        // owner 字段为 Pointer 类型，指向 _User 表
        [billOBJ setObject:currentUser forKey:@"owner"];
        // image 字段为 File 类型
        [billOBJ setObject:@([self.count.text floatValue]) forKey:@"count"];
        [billOBJ setObject:timeStr forKey:@"date"];
        [billOBJ setObject:detail forKey:@"detail"];
        [billOBJ saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [MBProgressHUD showSuccess:@"上传成功"];
                if (self.needRefreshData) {
                    self.needRefreshData(YES);
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                if(error.code == 137){
                   [MBProgressHUD showError:@"请勿重复上传！"];
                }else{
                   NSDictionary *dict = error.userInfo;
                   [MBProgressHUD showError:[NSString stringWithFormat:@"%@",dict[@"error"]]];
                }
                    
            }
        }];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view resignFirstResponder];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)delete{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定删除该条数据吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AVObject *billOBJ =[AVObject objectWithClassName:@"Bill" objectId:self.bill.objectId];
        [billOBJ deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [MBProgressHUD showSuccess:@"成功删除！"];
                if (self.needRefreshData) {
                    self.needRefreshData(YES);
                }
                [self back:nil];
            }else{
                NSDictionary *dict = error.userInfo;
                [MBProgressHUD showError:[NSString stringWithFormat:@"操作失败！%@",dict[@"error"]]];
            }
        }];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (IBAction)selectDate:(id)sender {
    //开始时间
    TimePick *pick = [TimePick timePcikWithStyle:0];
    pick.selectTime = self.date;
    pick.selectBlock = ^(NSString *str){
        if (str.length > 0) {
            NSLog(@"%@",str);
            self.date = str;
            self.dateL.text = str;
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:pick];
    
}




@end
