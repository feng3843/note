//
//  RegisterVC.m
//  Note
//
//  Created by 朱鑫华 on 2018/1/3.
//  Copyright © 2018年 朱鑫华. All rights reserved.
//

#import "RegisterVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD+MJ.h"

@interface RegisterVC ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *regBtn;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)register:(id)sender {
    AVUser *user = [AVUser user];// 新建 AVUser 对象实例
    user.username = self.name.text.length > 0 ?self.name.text:nil;// 设置用户名
    user.password =  self.password.text.length > 0 ?self.password.text:nil;// 设置密码

    if(user.username && user.password){
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // 注册成功
            [MBProgressHUD showSuccess:@"注册成功！请登陆！"];
            
        } else {
            // 失败的原因可能有多种，常见的是用户名已经存在。
            [MBProgressHUD showSuccess:@"注册失败！用户已存在！"];
        }
    }];
    }else{
        NSLog(@"用户名或者密码未填写！");
        [MBProgressHUD showError:@"用户名或者密码未填写！"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view resignFirstResponder];
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
