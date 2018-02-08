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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *count;
@property (weak, nonatomic) IBOutlet UITextField *detial;
@property (nonatomic,strong) FMDatabase *db;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *deletebtn;
@property (weak, nonatomic) IBOutlet UIButton *addnewbtn;
@property (nonatomic,copy) NSString  * kind;
@property (weak, nonatomic) IBOutlet UILabel *kindL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.addnewbtn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"0b5fff"];
    self.addnewbtn.layer.cornerRadius = 4;
    self.addnewbtn.layer.masksToBounds = YES;
    //获取路径
    NSString *filepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [filepath stringByAppendingPathComponent:@"bill.sqlite"];
    self.deletebtn.hidden = YES;
    self.deletebtn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"FF4444"];
    self.deletebtn.layer.cornerRadius = 4;
    self.deletebtn.layer.masksToBounds = YES;
    
    self.db = [FMDatabase databaseWithPath:filename];
    // 4.打开数据库
    if ([_db open]) {
        // 5.创表
        BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_bill (id integer PRIMARY KEY AUTOINCREMENT, kind text NOT NULL, count Double NOT NULL, date datetime NOT NULL,detail text);"];
        if (result) {
            NSLog(@"成功创表");
        } else {
            NSLog(@"创表失败");
        }
    }
    
    if (self.bill) {
        self.kind = self.bill.kind;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [dateFormatter stringFromDate:[NSDate date]];
    if(self.bill){
        //修改
        NSString *sql = [NSString stringWithFormat:@"update t_bill  set kind = '%@' ,count = %.2f ,date = '%@' ,detail = '%@' where id = %d",_kind, [self.count.text floatValue] ,timeStr,detail,self.bill.ID];
        BOOL result = [self.db executeUpdate:sql];
        if (result) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }

    }else{
        //新增
        BOOL result = [self.db executeUpdateWithFormat:@"INSERT INTO t_bill (kind, count , date,detail) VALUES (%@,%f,%@,%@);", _kind, [self.count.text floatValue] ,timeStr,detail];
        if (result) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }

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
        NSString *sql = [NSString stringWithFormat:@"delete from t_bill where id = %d",self.bill.ID];
        BOOL res = [self.db executeUpdate:sql];
        if (res) {
            [self back:nil];
        }else{
            [MBProgressHUD showError:@"数据出错！稍后重试！"];
        }
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

@end
