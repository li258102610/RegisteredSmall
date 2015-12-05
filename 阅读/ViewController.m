//
//  ViewController.m
//  阅读
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//

#import "ViewController.h"
#import "RegisteredViewController.h"
#import "DXAlertView.h"
#import "MBProgressHUD.h"
#import "UserService.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)LandingDefinition:(UIButton *)sender {
    NSString *userName = self.textUserName.text;
    NSString *userPassword = self.textPassword.text;
    if (!userName.length || !userPassword) {
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"警告" contentText:@"所有字段不能为空" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [alert show];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"发送";
    hud.detailsLabelText = @"请等待..";
    hud.userInteractionEnabled = NO;
    
    [UserService logInWithUsernameInBackground:userName
                                      password:userPassword
                                         block:^(BmobUser *user, NSError *error) {
                                             if (error) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     hud.labelText = [[error userInfo] objectForKey:@"error"];
                                                     hud.mode = MBProgressHUDModeText;
                                                     [hud show:YES];
                                                     [hud hide:YES afterDelay:0.7f];
                                                 });
                                                 
                                             }else{
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [hud hide:YES];
//                                                     [self dismissSelf];
                                                 });
                                                 //查找用户的好友
                                                 [UserService saveFriendsList];
                                             }
                                         }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
