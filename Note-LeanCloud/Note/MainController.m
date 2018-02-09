//
//  MainController.m
//  Note
//
//  Created by 朱鑫华 on 2017/11/22.
//  Copyright © 2017年 朱鑫华. All rights reserved.
//

#import "MainController.h"
#import "FMDB.h"
#import "MBProgressHUD+MJ.h"
#import <sqlite3.h>
#import "Bill.h"
#import "BillCell.h"
#import "ViewController.h"
#import "TimePick.h"
#import "HexColors.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MJExtension.h"
#import "LoginVC.h"
#import "UIImage+Resize.h"
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
@property (nonatomic,strong) UIButton  * CurrentSelBtn;
@property (nonatomic,strong) NSArray  * cpyDataArray;
@end

@implementation MainController

- (IBAction)btnClick:(UIButton *)btn {
    /*
    0衣服  1饮食  2居住 3交通 4人情往来 5医疗 6娱乐 7其他
    **/
    btn.selected = !btn.selected;
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor hx_colorWithHexRGBAString:@"44ff88"] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
    if (btn == self.CurrentSelBtn) {
        self.CurrentSelBtn.selected = NO;
        self.CurrentSelBtn = nil;
    }else{
        self.CurrentSelBtn.selected = NO;
        self.CurrentSelBtn = btn;
    }
}

-(void)setCurrentSelBtn:(UIButton *)CurrentSelBtn{
    _CurrentSelBtn = CurrentSelBtn;
    NSString *kindStr;
    switch (CurrentSelBtn.tag) {
        case 0:{
        kindStr = @"衣服";
          break;
        }
        case 1:{
            kindStr = @"饮食";
            break;
        }
        case 2:{
            kindStr = @"居住";
            break;
        }
        case 3:{
            kindStr = @"交通";
            break;
        }
        case 4:{
            kindStr = @"人情往来";
            break;
        }
        case 5:{
            kindStr = @"医疗";
            break;
        }
        case 6:{
            kindStr = @"娱乐";
            break;
        }
        case 7:{
            kindStr = @"其他";
            break;
        }
        default:
            break;
    }
    if (CurrentSelBtn == nil) {
        kindStr = @"";
    }
    [self queryDataArrayByKind:kindStr];
}

-(void)queryDataArrayByKind:(NSString *)kindStr{
    if ([kindStr isEqualToString:@""]) {
        self.dataArray = [self.cpyDataArray mutableCopy];
        [self.tableView reloadData];
        return;
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i< self.cpyDataArray.count; i++) {
        Bill *bill = self.cpyDataArray[i];
        if ([bill.kind isEqualToString:kindStr]) {
            [tempArray addObject:bill];
        }
    }
    self.dataArray = tempArray;
    [self.tableView reloadData];
}

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
//    NSString *filepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *filename = [filepath stringByAppendingPathComponent:@"bill.sqlite"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BillCell" bundle:nil] forCellReuseIdentifier:@"BillCell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self queryDataArrayWithDate:self.pickdate];
 
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
    __weak typeof(self) wkself = self;
    vc.needRefreshData = ^(BOOL flag){
        if (flag) [wkself queryDataArrayWithDate:wkself.pickdate];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self queryDataArrayWithDate:self.pickdate];
}

-(void)didEdit:(Bill *)bill{
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    ViewController *vc = [board instantiateViewControllerWithIdentifier: @"ViewController"];
    __weak typeof(self) wkself = self;
    vc.needRefreshData = ^(BOOL flag){
        if (flag) [wkself queryDataArrayWithDate:wkself.pickdate];
    };
    vc.bill = bill;
    [self presentViewController:vc animated:YES completion:nil];

}



- (IBAction)pick:(UIButton *)sender {
    //开始时间
    TimePick *pick = [TimePick timePcikWithStyle:TimePickStyleOnlyShowYearAndMonth];
    pick.selectBlock = ^(NSString *str){
        if (str.length > 0) {
            NSLog(@"%@",str);
            self.pickdate = str;
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:pick];
}

-(void)setPickdate:(NSString *)pickdate{
    _pickdate = pickdate;
    [self queryDataArrayWithDate:pickdate];
    self.timeLabel.text = pickdate==nil?@"我的账单（所有时间段）":[NSString stringWithFormat:@"我的账单（%@）",pickdate];
    [self.tableView reloadData];
}

- (IBAction)loginOut:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定退出登录吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [AVUser logOut];  //清除缓存用户对象
        AVUser *currentUser = [AVUser currentUser];
        [self setOrUpdateUserOnLocal:currentUser];
        if (currentUser == nil) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginVC *loginVc = [sb instantiateViewControllerWithIdentifier:@"LoginVC"];
            [[UIApplication sharedApplication] keyWindow].rootViewController = loginVc;
        }
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)setOrUpdateUserOnLocal:(AVUser *)user{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user.username forKey:@"username"];
    [defaults setObject:user.password forKey:@"password"];
    [defaults setObject:user.sessionToken forKey:@"sessionToken"];
    [defaults setObject:user.objectId forKey:@"objectId"];
    [defaults synchronize];
}


- (IBAction)tongbu:(id)sender {
    [self queryDataArrayWithDate:self.pickdate];
}

-(void)queryDataArrayWithDate:(NSString *)date{
    self.CurrentSelBtn.selected = NO;
    self.CurrentSelBtn = nil;
    AVQuery *query = [AVQuery queryWithClassName:@"Bill"];
    [query whereKey:@"owner" equalTo:[AVUser currentUser]];
    if (date != nil) {
        [query whereKey:@"date" containsString:date];
    }
    query.limit = 1000;
    [query orderByDescending:@"date"];
    [MBProgressHUD showMessage:@"数据同步中..." toView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"chucuol %@",error);
            [MBProgressHUD showError:@"同步数据失败，请检查网络，稍后再试！"];
            return ;
        }
        [MBProgressHUD showSuccess:@"同步成功！"];
        self.dataArray = [NSMutableArray array];
        for (int i = 0; i<objects.count; i++) {
            AVObject *obj = objects[i];
            Bill *bill = [Bill mj_objectWithKeyValues:obj[@"localData"]];
            bill.objectId = obj[@"objectId"];
            [self.dataArray addObject:bill];
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
        self.cpyDataArray = [self.dataArray copy];
        [self.tableView reloadData];
    }];
}


-(void)uploadLocalSQLITE{
    for (int i = 0 ; i < self.dataArray.count; i++) {
        sleep(1);
        NSLog(@"上传中%d.....",i);
        Bill *bill = self.dataArray[i];
        AVUser *currentUser = [AVUser currentUser];
        
        AVObject *billOBJ = [AVObject objectWithClassName:@"Bill"];
        [billOBJ setObject:@(bill.ID) forKey:@"id"];
        [billOBJ setObject:bill.kind forKey:@"kind"];
        
        // owner 字段为 Pointer 类型，指向 _User 表
        [billOBJ setObject:currentUser forKey:@"owner"];
        // image 字段为 File 类型
        [billOBJ setObject:@(bill.count) forKey:@"count"];
        [billOBJ setObject:bill.date forKey:@"date"];
        [billOBJ setObject:bill.detail forKey:@"detail"];
        __block int c = i;
        [billOBJ saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"上传成功%d",c);
                //                [MBProgressHUD showSuccess:@"上传成功"];
                //                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSLog(@"保存新物品出错 %@", error);
                if(error.code == 137){
                    //                    [MBProgressHUD showError:@"请勿重复上传！"];
                }
            }
            //            [MBProgressHUD hideHUDForView:self.view];
        }];
        
    }
}


@end
