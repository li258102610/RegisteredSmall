//
//  RegisteredViewController.m
//  阅读
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//

#import "RegisteredViewController.h"
#import "ViewController.h"
#import <BmobSDK/Bmob.h>
#import "DXAlertView.h"
#import "MBProgressHUD.h"

@interface RegisteredViewController ()
@property (weak, nonatomic) IBOutlet UITextField *RegisteredUsername;

@property (weak, nonatomic) IBOutlet UITextField *RegisteredPassword;
@property (weak, nonatomic) IBOutlet UITextField *RegisteredTOPassword;
@property (weak, nonatomic) IBOutlet UITextField *RegisteredEmail;

@end

@implementation RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)registeredInformation:(UIButton *)sender {
    NSString *userName = self.RegisteredUsername.text;
    NSString *userPassWord = self.RegisteredPassword.text;
    NSString *userPasswordRepeat = self.RegisteredTOPassword.text;
    NSString *userEmail = self.RegisteredEmail.text;
    if (!userName.length || !userPassWord.length || !userPasswordRepeat.length || !userEmail.length) {
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"警告" contentText:@"所有的字段不能为空" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [alert show];
        return;
    }
    if (![userPassWord isEqualToString:userPasswordRepeat]) {
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"警告" contentText:@"两次密码不相同" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [alert show];
        return;
    }
    
    BmobUser *bUser = [[BmobUser alloc] init];
    [bUser setUserName:userName];
    [bUser setPassword:userPassWord];
    [bUser setEmail:userEmail];
    [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
        if (isSuccessful){
            NSLog(@"Sign up successfully");
        } else {
            NSLog(@"%@",error);
        }
    }];
    __block NSString *userMessage = @"注册成功";
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"发送";
    hud.detailsLabelText = @"请等待..";
    hud.userInteractionEnabled = NO;
    
    [bUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!succeeded) {
            userMessage = error.localizedDescription;
        }
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:userMessage leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [alert show];
        alert.rightBlock = ^(){
            if (succeeded) {
                id vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
                CATransition *tran = [CATransition animation];
                tran.type = @"cube";
                tran.duration = 1;
                [self.navigationController.view.layer addAnimation:tran forKey:nil];
                [self.navigationController showViewController:navi sender:nil];
                
                
            }
            
        };
        
    }];
}

- (IBAction)dissmiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
