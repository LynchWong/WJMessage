//
//  ViewController.m
//  WJMessage
//
//  Created by can 杭伟 on 3/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "WelcomeViewController.h"
#import "AppDelegate.h"
#import "EditViewController.h"
#import "RequestData.h"
#import "Reachability.h"
#import "PersonInfoViewController.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@implementation ViewController

@synthesize nameTextField;
@synthesize passwordTextField;
@synthesize checkBoxAutoLoginButton;
@synthesize checkBoxRemberPassWordButton;
@synthesize alertStyle;
@synthesize HUD;

//点击键盘Done隐藏键盘
- (IBAction)textFieldDoneEditing:(id)sender {
    
    [sender resignFirstResponder];
    
    [self resumeView];
}

//点击空白隐藏键盘
- (IBAction)backgroundClick:(id)sender {
    
    [nameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    [self resumeView];
}

//UITextField的协议方法，当开始编辑时监听
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-85,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

//恢复原始视图位置
-(void)resumeView {
    
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    //float Y = 20.0f;
    CGRect rect=CGRectMake(0.0f,0.0f,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

//点击登录按钮调用的操作方法
- (IBAction)buttonPressed:(id)sender {
    
    NSString *nameValue = [nameTextField text];
    NSString *passwordValue = [passwordTextField text];
    NSLog(@"%@",nameValue);
    NSLog(@"%@",passwordValue);

    if (checkBoxAutoLoginButton.selected) {
        NSLog(@"checkBoxAutoLoginButton : 选中");
    } else {
        NSLog(@"checkBoxAutoLoginButton : 没选中");
    }
    
    if (checkBoxRemberPassWordButton.selected) {
        NSLog(@"checkBoxRemberPassWordButton : 选中");
    } else {        
        NSLog(@"checkBoxRemberPassWordButton : 没选中");      
    }
    
    if ([nameValue isEqualToString:@""] || [passwordValue isEqualToString:@""]) {
        
        UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"用户名或密码不能为空"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
        [uiAlert show];
        
    } else {
        
        [nameTextField resignFirstResponder];
        [passwordTextField resignFirstResponder];
        self.HUD = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.delegate = self;
        self.HUD.labelText = @"登录中";
        
        //新开一个线程加载
        [self.HUD show:YES];
        [NSThread detachNewThreadSelector:@selector(login) toTarget:self withObject:nil];
        
    }
}

- (void)login {
    
    NSString *loginResult = [RequestData loginWithName:[nameTextField text]
                                           AndPassWord:[passwordTextField text]
                                        AndDeviceToken:[[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"]
                                         AndDeviceType:@"iphone"];
    if ([loginResult isEqualToString:@"success"]) {
        
        NSLog(@"alertStyle : %@",self.alertStyle);
        //记住用户名
        [[NSUserDefaults standardUserDefaults] setObject:[nameTextField text] forKey:@"UserName"];
        
        if (checkBoxAutoLoginButton.selected) {
            
            //记住密码
            [[NSUserDefaults standardUserDefaults] setObject:[passwordTextField text]
                                                      forKey:@"PassWord"];
            //记住密码标记
            [[NSUserDefaults standardUserDefaults] setObject:@"YES"
                                                      forKey:@"RemberPassWord"];
            //自动登录标记
            [[NSUserDefaults standardUserDefaults] setObject:@"YES"
                                                      forKey:@"AutoLogin"];
            
        }
        
        if (!checkBoxAutoLoginButton.selected && checkBoxRemberPassWordButton.selected) {
            
            //记住密码
            [[NSUserDefaults standardUserDefaults] setObject:[passwordTextField text]
                                                      forKey:@"PassWord"];
            //记住密码标记
            [[NSUserDefaults standardUserDefaults] setObject:@"YES"
                                                      forKey:@"RemberPassWord"];
            //删除自动登录标记
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AutoLogin"];
            
        }
        
        if (!checkBoxAutoLoginButton.selected && !checkBoxRemberPassWordButton.selected) {
            
            //删除记住密码
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PassWord"];
            //删除记住密码标记
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RemberPassWord"];
            //删除自动登录标记
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AutoLogin"];
            
        }
        
        //设置登录状态
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"LoginStatus"];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        AppDelegate *App = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        App.userName = self.nameTextField.text;
        
        if ([self.alertStyle isEqualToString:@"weijiaAlert"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        if ([self.alertStyle isEqualToString:@"enterpriseCenterAlert"]) {
            
            //[self performSegueWithIdentifier:@"enterprisecenter" sender:self];
            [self.navigationController popViewControllerAnimated:YES];
        
        }
        if ([self.alertStyle isEqualToString:@"personAlert"]) {
            
            [self performSegueWithIdentifier:@"person" sender:self];
            
        }
        
        if ([self.alertStyle isEqualToString:@"SettingEnterprise"]) {
            
            //判断是否是C类客户，若是就隐藏掉添加令牌的按钮
            NSString *companyNumber = [RequestData UserInEnterpriseNumber:App.userName];
            NSLog(@"companyNumber : %@",companyNumber);
            if ([companyNumber isEqualToString:@""]) {
                
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                UINavigationController *frontView = [storyBoard instantiateViewControllerWithIdentifier:@"FirstNavigation"];
                [App.revealViewController setFrontViewController:frontView animated:YES];
                
                
            } else {
//                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//                EditViewController *editView = [storyBoard instantiateViewControllerWithIdentifier:@"EditView"];
//                [self.navigationController pushViewController:editView animated:YES];
                
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                EditViewController *editView = [storyBoard instantiateViewControllerWithIdentifier:@"EditView"];
                UINavigationController *frontView = [[UINavigationController alloc] initWithRootViewController:editView];
                [frontView.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigationbar.png"]
                                              forBarMetrics:UIBarMetricsDefault];
                
                //顶部左侧按钮
                UIImage *img_menu = [UIImage imageNamed:@"reveal-icon"];
                UIButton *btn_menu = [UIButton buttonWithType:UIButtonTypeCustom];
                btn_menu.frame = CGRectMake(15, 0, img_menu.size.width, img_menu.size.height);
                [btn_menu setImage:img_menu forState:UIControlStateNormal];
                [editView.view addSubview:btn_menu];
                UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn_menu];
                editView.navigationItem.leftBarButtonItem = barButton;
                
                //菜单按钮点击事件（展开隐藏菜单）
                [btn_menu addTarget:App.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
                [editView.view addGestureRecognizer:App.revealViewController.panGestureRecognizer];
                
                [App.revealViewController setFrontViewController:frontView animated:YES];
            }
        }
        if ([self.alertStyle isEqualToString:@"SettingPerson"]) {
            
//            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//            PersonInfoViewController *personInfoView = [storyBoard instantiateViewControllerWithIdentifier:@"PersonView"];
//            [self.navigationController pushViewController:personInfoView animated:YES];
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            PersonInfoViewController *personInfoView = [storyBoard instantiateViewControllerWithIdentifier:@"PersonView"];
            UINavigationController *frontView = [[UINavigationController alloc] initWithRootViewController:personInfoView];
            [frontView.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigationbar.png"]
                                          forBarMetrics:UIBarMetricsDefault];
            
            //顶部左侧按钮
            UIImage *img_menu = [UIImage imageNamed:@"reveal-icon"];
            UIButton *btn_menu = [UIButton buttonWithType:UIButtonTypeCustom];
            btn_menu.frame = CGRectMake(15, 0, img_menu.size.width, img_menu.size.height);
            [btn_menu setImage:img_menu forState:UIControlStateNormal];
            [personInfoView.view addSubview:btn_menu];
            UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn_menu];
            personInfoView.navigationItem.leftBarButtonItem = barButton;
            
            //菜单按钮点击事件（展开隐藏菜单）
            [btn_menu addTarget:App.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            [personInfoView.view addGestureRecognizer:App.revealViewController.panGestureRecognizer];
            
            [App.revealViewController setFrontViewController:frontView animated:YES];
            
        }
        
    } else {
        
        BOOL isExistenceNetwork;
        Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
        
        switch ([r currentReachabilityStatus]) {
            case NotReachable:
                isExistenceNetwork=NO;
                NSLog(@"不可用");
                break;
            case ReachableViaWWAN:
                isExistenceNetwork=YES;
                NSLog(@"可用");
                break;
            case ReachableViaWiFi:
                isExistenceNetwork=YES;
                NSLog(@"Wi-Fi");
                break;
        }
        
        if (!isExistenceNetwork) {
            
            self.HUD.labelText = @"网络不可用";
            [NSThread sleepForTimeInterval:1.0];
            
        } else {
            
            self.HUD.labelText = @"用户名或密码错误";
            [NSThread sleepForTimeInterval:1.0];
            
        }
        
    }
    //在另一个线程更新主界面，因为在本函数里更新主界面是无效的
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
}

- (void)updateUI {
    
    //若self.HUD为真，则将self.HUD移除，设为nil
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
}

- (IBAction)registButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"regist" sender:self];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)backButtonPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //设置返回按钮
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(backButtonPressed)];
    barButton.tintColor = [UIColor colorWithRed:56/255.0 green:146/255.0 blue:227/255.0 alpha:1];
    self.navigationItem.leftBarButtonItem = barButton;
    
	
    checkBoxRemberPassWordButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 215, 25, 25)];
    [checkBoxRemberPassWordButton setImage:[UIImage imageNamed:@"checkBoxNoSelect.png"] forState:UIControlStateNormal];
    [checkBoxRemberPassWordButton setImage:[UIImage imageNamed:@"checkBoxSelect.png"] forState:UIControlStateSelected];    
    [checkBoxRemberPassWordButton addTarget:self
                                     action:@selector(checkboxClick:)
                           forControlEvents:UIControlEventTouchUpInside];
    
    checkBoxAutoLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(175, 215, 25, 25)];
    [checkBoxAutoLoginButton setImage:[UIImage imageNamed:@"checkBoxNoSelect.png"] forState:UIControlStateNormal];
    [checkBoxAutoLoginButton setImage:[UIImage imageNamed:@"checkBoxSelect.png"] forState:UIControlStateSelected];
    [checkBoxAutoLoginButton addTarget:self
                                action:@selector(checkboxClick:)
                      forControlEvents:UIControlEventTouchUpInside];

    
    nameTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"RemberPassWord"] isEqualToString:@"YES"]) {
        
        passwordTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"PassWord"];
        checkBoxRemberPassWordButton.selected = YES;
        
    }
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"AutoLogin"] isEqualToString:@"YES"]) {
        
        passwordTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"PassWord"];
        checkBoxAutoLoginButton.selected = YES;
        checkBoxRemberPassWordButton.selected = YES;
        
    }
      
    [self.view addSubview:checkBoxRemberPassWordButton];
    [self.view addSubview:checkBoxAutoLoginButton];
    
    self.nameTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration{
    
    UIInterfaceOrientation toOrientation = self.interfaceOrientation;
    [UIView beginAnimations:@"move views" context:nil];
    
    if (toOrientation == UIInterfaceOrientationPortrait || toOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        //设置背景图片
        if (iPhone5) {
            self.backButton.frame = CGRectMake(0, 0, 320, 640);
            [self.backButton setBackgroundImage:[UIImage imageNamed:@"background-568h"] forState:UIControlStateNormal];
        } else {
            self.backButton.frame = CGRectMake(0, 0, 320, 460);
            [self.backButton setBackgroundImage:[UIImage imageNamed:@"background"] forState:UIControlStateNormal];
        }
        self.loginImage.frame = CGRectMake(48, 18, 224, 80);
        self.nameTextField.frame = CGRectMake(40, 125, 240, 31);
        self.passwordTextField.frame = CGRectMake(40, 177, 240, 31);
        self.remberPassword.frame = CGRectMake(73, 216, 73, 21);
        self.autoLogin.frame = CGRectMake(207, 216, 73, 21);
        self.checkBoxRemberPassWordButton.frame = CGRectMake(40, 215, 25, 25);
        self.checkBoxAutoLoginButton.frame = CGRectMake(175, 215, 25, 25);
        self.registButton.frame = CGRectMake(40, 245, 105, 37);
        self.loginButton.frame = CGRectMake(92, 245, 136, 37);
        
    } else {
        
        //设置背景图片
        if (iPhone5) {
            self.backButton.frame = CGRectMake(0, 0, 640, 320);
            [self.backButton setBackgroundImage:[UIImage imageNamed:@"background-568h"] forState:UIControlStateNormal];
        } else {
            self.backButton.frame = CGRectMake(0, 0, 480, 320);
            [self.backButton setBackgroundImage:[UIImage imageNamed:@"background"] forState:UIControlStateNormal];
        }
        self.loginImage.frame = CGRectMake(128, 7, 224, 80);
        self.nameTextField.frame = CGRectMake(120, 100, 240, 31);
        self.passwordTextField.frame = CGRectMake(120, 152, 240, 31);
        self.remberPassword.frame = CGRectMake(153, 191, 73, 21);
        self.autoLogin.frame = CGRectMake(289, 192, 73, 21);
        self.checkBoxRemberPassWordButton.frame = CGRectMake(120, 191, 25, 25);
        self.checkBoxAutoLoginButton.frame = CGRectMake(257, 191, 25, 25);
        self.registButton.frame = CGRectMake(120, 220, 105, 37);
        self.loginButton.frame = CGRectMake(172, 220, 136, 37);
        
    }
    
    [UIView commitAnimations];
}


-(void)checkboxClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (checkBoxAutoLoginButton.selected) {
        
        checkBoxRemberPassWordButton.selected = YES;
    }
}

- (void)viewDidUnload {
    
    [self setNameTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //在旋转的时候点击需要再判断
    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.0f];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
}

@end
