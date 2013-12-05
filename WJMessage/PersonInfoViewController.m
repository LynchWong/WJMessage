//
//  PersonInfoViewController.m
//  WJMessage
//
//  Created by Can Hang on 5/20/13.
//
//

#import "PersonInfoViewController.h"
#import "AppDelegate.h"
#import "RequestData.h"
#import "MyAlertView.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface PersonInfoViewController ()

@end

@implementation PersonInfoViewController

@synthesize backImage;
@synthesize changePassWordButton;
@synthesize loginUserName;
@synthesize oldPasswordTextField;
@synthesize fnewPasswordTextField;
@synthesize snewPasswordTextField;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //设置返回按钮
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(backButtonPressed)];
    barButton.tintColor = [UIColor colorWithRed:56/255.0 green:146/255.0 blue:227/255.0 alpha:1];
    self.navigationItem.leftBarButtonItem = barButton;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"LoginStatus"];
    if (![loginStatus isEqualToString:@"YES"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    AppDelegate *App = [[UIApplication sharedApplication] delegate];
    self.loginUserName.text = App.userName;
    //在旋转的时候点击需要再判断
    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.0f];
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)alertAction:(id)sender {
    MyAlertView *myAlert = [[MyAlertView  alloc] initWithTitle:@"修改密码" message:nil delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"修改",nil];
    oldPasswordTextField = [[UITextField alloc] init];
    oldPasswordTextField.secureTextEntry = YES;
    [oldPasswordTextField becomeFirstResponder];
    fnewPasswordTextField = [[UITextField alloc] init];
    fnewPasswordTextField.secureTextEntry = YES;
    snewPasswordTextField = [[UITextField alloc] init];
    snewPasswordTextField.secureTextEntry = YES;
    [myAlert addTextField:oldPasswordTextField placeHolder:@"请输入旧密码"];
    [myAlert addTextField:fnewPasswordTextField placeHolder:@"请输入新密码"];
    [myAlert addTextField:snewPasswordTextField placeHolder:@"请确认新密码"];
    [myAlert show];
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {//按键响应函数
    if (buttonIndex != 0) {
        if (oldPasswordTextField.text == NULL || fnewPasswordTextField.text == NULL || snewPasswordTextField == NULL) {
            UIAlertView *tipAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                                   message:@"不能为空！"
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil, nil];
            [tipAlertView show];
        } else {
            if (oldPasswordTextField.text.length < 6 || fnewPasswordTextField.text.length < 6 || snewPasswordTextField.text.length < 6) {
                UIAlertView *tipAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                                       message:@"密码不能少于6位！"
                                                                      delegate:self
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil, nil];
                [tipAlertView show];
            } else {
                if ([fnewPasswordTextField.text isEqualToString:snewPasswordTextField.text]) {
                    NSString *ChangePasswordResult = [RequestData ChangePasswordWithUserName:self.loginUserName.text AndOldPassword:oldPasswordTextField.text AndNewPassword:fnewPasswordTextField.text];
                    if ([ChangePasswordResult isEqualToString:@"success"]) {
                        UIAlertView *tipAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                                               message:@"修改成功！"
                                                                              delegate:self
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil, nil];
                        [tipAlertView show];
                    } else {
                        UIAlertView *tipAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                                               message:@"修改失败！"
                                                                              delegate:self
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil, nil];
                        [tipAlertView show];
                    }
                } else {
                    UIAlertView *tipAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                                           message:@"两次密码输入不一样！"
                                                                          delegate:self
                                                                 cancelButtonTitle:@"确定"
                                                                 otherButtonTitles:nil, nil];
                    [tipAlertView show];
                }
            }
        }
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//旋转时调用的方法，将试图控件调整到合适的位置；
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration{
    
    UIInterfaceOrientation toOrientation = self.interfaceOrientation;
    [UIView beginAnimations:@"move views" context:nil];
    
    if (toOrientation == UIInterfaceOrientationPortrait || toOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        if (iPhone5) {
            self.backImage.frame = CGRectMake(0, 0, 320, 640);
            self.backImage.image = [UIImage imageNamed:@"background-568h"];
        } else {
            self.backImage.frame = CGRectMake(0, 0, 320, 460);
            self.backImage.image = [UIImage imageNamed:@"background"];
        }
        self.changePassWordButton.frame = CGRectMake(187, 41, 105, 37);
        
    } else {
        
        if (iPhone5) {
            self.backImage.frame = CGRectMake(0, 0, 640, 320);
            self.backImage.image = [UIImage imageNamed:@"rbackground-568h"];
        } else {
            self.backImage.frame = CGRectMake(0, 0, 480, 320);
            self.backImage.image = [UIImage imageNamed:@"rbackground"];
        }
        self.changePassWordButton.frame = CGRectMake(340, 20, 105, 37);
        
    }
    
    [UIView commitAnimations];
}

@end
