//
//  LoginVC.m
//  Note
//
//  Created by 朱鑫华 on 2018/1/3.
//  Copyright © 2018年 朱鑫华. All rights reserved.
//

#import "LoginVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD+MJ.h"
#import "MainController.h"
#import <objc/runtime.h>
#import "Bill.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginbtn;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AVUser *user = [self getUserOnLocal];
    if (user) {
        self.name.text = user.username;
        self.password.text = user.password;
    }
}


- (IBAction)login:(id)sender {
    NSString *name = self.name.text.length > 0 ?self.name.text :nil;
    NSString *password = self.password.text.length > 0 ?self.password.text :nil;
    if ( !(name && password)) {
        [MBProgressHUD showError:@"用户名密码不能为空！"];
        return;
    }
    [AVUser logInWithUsernameInBackground:name password:password block:^(AVUser *user, NSError *error) {
        
        if(error) [MBProgressHUD showError:@"登录失败！"];
        if (user) {
            [[NSUserDefaults standardUserDefaults] setValue:name forKeyPath:@"name"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [MBProgressHUD showSuccess:@"登陆成功！"];
            [self setOrUpdateUserOnLocal:user];
//            [self getUserOnLocal];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MainController *mainController = [sb instantiateViewControllerWithIdentifier:@"MainController"];
            [[UIApplication sharedApplication] keyWindow].rootViewController = mainController;
        } else {
            [MBProgressHUD showError:@"登录失败！"];
        }
 
    }];
    


    
    
}

-(void)setOrUpdateUserOnLocal:(AVUser *)user{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user.username forKey:@"username"];
    [defaults setObject:user.password forKey:@"password"];
    [defaults setObject:user.sessionToken forKey:@"sessionToken"];
    [defaults setObject:user.objectId forKey:@"objectId"];
    [defaults synchronize];
}

-(NSString *)getUserObjectID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"objectId"];
}

-(AVUser *)getUserOnLocal{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AVUser *user = [AVUser new];
    user.username = [defaults objectForKey:@"username"];
    user.password = [defaults objectForKey:@"password"];
    user.sessionToken = [defaults objectForKey:@"sessionToken"];
    return user;
}


@end
