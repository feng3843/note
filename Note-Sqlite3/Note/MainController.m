//
//  MainController.m
//  Note
//
//  Created by 朱鑫华 on 2017/11/22.
//  Copyright © 2017年 朱鑫华. All rights reserved.
//

#import "MainController.h"
#import "FMDB.h"
#import <sqlite3.h>
#import "Bill.h"
#import "BillCell.h"
#import "ViewController.h"
#import "TimePick.h"
#import "HexColors.h"

@interface MainController ()<UITableViewDelegate,UITableViewDataSource,BillCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray  * dataArray;
@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,copy) NSString  * pickdate;


@property (weak, nonatomic) IBOutlet UILabel *yf;
@property (weak, nonatomic) IBOutlet UILabel *ys;
@property (weak, nonatomic) IBOutlet UILabel *jz;
@property (weak, nonatomic) IBOutlet UILabel *jt;
@property (weak, nonatomic) IBOutlet UILabel *rqwlL;
@property (weak, nonatomic) IBOutlet UILabel *ylL;
@property (weak, nonatomic) IBOutlet UILabel *yulL;
@property (weak, nonatomic) IBOutlet UILabel *qtL;
@property (weak, nonatomic) IBOutlet UIButton *addnewbtn;



@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    self.selectBtn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"FFFF00"];
    self.selectBtn.layer.cornerRadius = 2;
    self.selectBtn.layer.masksToBounds = YES;
    
    
    self.addnewbtn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"0b5fff"];
    self.addnewbtn.layer.cornerRadius = 4;
    self.addnewbtn.layer.masksToBounds = YES;
    //获取路径
    NSString *filepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [filepath stringByAppendingPathComponent:@"bill.sqlite"];
    
    
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
    [self query:nil];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BillCell" bundle:nil] forCellReuseIdentifier:@"BillCell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
}




//查询
- (void)query:(NSString *)dateStr
{
    NSString *sql;
    if (dateStr == nil) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_bill ORDER BY date ASC"];
        self.timeLabel.text = @"我的账单（所有时间段）";
    }else{
        sql = [NSString stringWithFormat:@"SELECT * FROM t_bill where date like '%%%@%%' ORDER BY date ASC",dateStr];
    }
    // 1.执行查询语句
    
    FMResultSet *resultSet = [self.db executeQuery:sql];
    self.dataArray = [NSMutableArray array];

    // 2.遍历结果
    while ([resultSet next]) {
        Bill *bill = [Bill new];
        bill.ID = [resultSet intForColumn:@"id"];
        bill.kind = [resultSet stringForColumn:@"kind"];
        bill.count = [resultSet doubleForColumn:@"count"];
        bill.date = [resultSet stringForColumn:@"date"];
        bill.detail = [resultSet stringForColumn:@"detail"];
        [self.dataArray insertObject:bill atIndex:0];
    }
    
    float total = 0;
    float yf = 0;
    float ys = 0;
    float jz = 0;
    float jt = 0;
    float rqwl = 0;
    float yl = 0;
    float yul = 0;
    float qt = 0;
    for (int i = 0 ; i<self.dataArray.count; i++) {
        Bill *bill = self.dataArray[i];
        total = total + bill.count;
        if ([bill.kind isEqualToString:@"衣服"]) {
            yf = yf + bill.count;
        }else if ([bill.kind isEqualToString:@"饮食"]){
            ys = ys + bill.count;
        }else if ([bill.kind isEqualToString:@"居住"]){
            jz = jz + bill.count;
        }else if ([bill.kind isEqualToString:@"交通"]){
            jt = jt + bill.count;
        }else if ([bill.kind isEqualToString:@"人情往来"]){
            rqwl = rqwl + bill.count;
        }else if ([bill.kind isEqualToString:@"医疗"]){
            yl = yl + bill.count;
        }else if ([bill.kind isEqualToString:@"娱乐"]){
            yul = yul + bill.count;
        }else if ([bill.kind isEqualToString:@"其他"]){
            qt = qt + bill.count;
        }
    }
    self.countLabel.text = [NSString stringWithFormat:@"%.2f",total];
    self.ys.text = [NSString stringWithFormat:@"%.2f 元",ys];
    self.yf.text = [NSString stringWithFormat:@"%.2f 元",yf];
    self.jz.text = [NSString stringWithFormat:@"%.2f 元",jz];
    self.jt.text = [NSString stringWithFormat:@"%.2f 元",jt];
    self.rqwlL.text = [NSString stringWithFormat:@"%.2f 元",rqwl];
    self.ylL.text = [NSString stringWithFormat:@"%.2f 元",yl];
    self.yulL.text = [NSString stringWithFormat:@"%.2f 元",yul];
    self.qtL.text = [NSString stringWithFormat:@"%.2f 元",qt];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillCell" forIndexPath:indexPath];
    Bill *bill = self.dataArray[indexPath.row];
    cell.bill = bill;
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (IBAction)addnew:(UIButton *)sender {  
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    
    ViewController *vc = [board instantiateViewControllerWithIdentifier: @"ViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self query:nil];
    [self.tableView reloadData];
}

-(void)didEdit:(Bill *)bill{
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    
    ViewController *vc = [board instantiateViewControllerWithIdentifier: @"ViewController"];
    vc.bill = bill;
    [self presentViewController:vc animated:YES completion:nil];

}
- (IBAction)pick:(UIButton *)sender {
    //开始时间
    TimePick *pick = [TimePick new];
    pick.selectBlock = ^(NSString *str){
        if (str.length > 0) {
            NSLog(@"%@",str);
            self.pickdate = str;
        }
        if(str == nil) self.pickdate = str;
    };
    [[UIApplication sharedApplication].keyWindow addSubview:pick];
}

-(void)setPickdate:(NSString *)pickdate{
    _pickdate = pickdate;
    [self query:pickdate];
    self.timeLabel.text = pickdate==nil?@"我的账单（所有时间段）":[NSString stringWithFormat:@"我的账单（%@）",pickdate];
    [self.tableView reloadData];
}
- (IBAction)qingkong:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定清空所有数据吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.db executeUpdate:@"DROP TABLE IF EXISTS t_bill;"];
        [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_bill (id integer PRIMARY KEY AUTOINCREMENT, kind text NOT NULL, count Double NOT NULL, date datetime NOT NULL,detail text);"];
        [self query:nil];
        [self.tableView reloadData];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
