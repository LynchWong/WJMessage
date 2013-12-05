//
//  AuthCodeViewController.m
//  WJMessage
//
//  Created by can 杭伟 on 3/27/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AuthCodeViewController.h"
#import "WelcomeViewController.h"
#import "RequestData.h"
#import "AppDelegate.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@implementation AuthCodeViewController

@synthesize authcodeTextField;
@synthesize name;
@synthesize uiAlertView;

//点击键盘Done隐藏键盘
- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
    
    [self resumeView];
}

//点击空白隐藏键盘
- (IBAction)backgroundClick:(id)sender {
    [authcodeTextField resignFirstResponder];
    
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
    CGRect rect=CGRectMake(0.0f,-45,width,height);
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
    if ([[authcodeTextField text] isEqualToString:@""]) {
        UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:nil 
                                                          message:@"令牌不能为空！" 
                                                         delegate:self 
                                                cancelButtonTitle:@"确定" 
                                                otherButtonTitles:nil, nil];
        [uiAlert show];
    } else {
        NSString *result = [RequestData EditTagWithUserName:self.name AndAuthCode:[authcodeTextField text]];
        
        if ([result isEqualToString:@"success"]) {
            
            uiAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                              message:@"添加成功！"
                                                             delegate:self
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil, nil];
            [uiAlertView show];
        } else {
            
            UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:nil
                                                              message:@"添加失败！"
                                                             delegate:self
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil, nil];
            [uiAlert show];
        }
    }
}

//点击按钮回调的方法
- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView == uiAlertView) {
        if (buttonIndex == 0) {
            AppDelegate *App = [[UIApplication sharedApplication] delegate];
            [App setFromWhere:@"AuthCode"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.authcodeTextField.delegate = self;
}


- (void)viewDidUnload {
    [self setAuthcodeTextField:nil];
    [self setAuthcodeTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"LoginStatus"];
    if (![loginStatus isEqualToString:@"YES"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    //设置返回按钮
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(backButtonPressed)];
    barButton.tintColor = [UIColor colorWithRed:56/255.0 green:146/255.0 blue:227/255.0 alpha:1];
    self.navigationItem.leftBarButtonItem = barButton;
    //在旋转的时候点击需要再判断
    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.0f];
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
        self.authcodeTextField.frame = CGRectMake(80, 140, 160, 31);
        self.sureButton.frame = CGRectMake(108, 206, 105, 37);
        
    } else {
        
        //设置背景图片
        if (iPhone5) {
            self.backButton.frame = CGRectMake(0, 0, 640, 320);
            [self.backButton setBackgroundImage:[UIImage imageNamed:@"background-568h"] forState:UIControlStateNormal];
        } else {
            self.backButton.frame = CGRectMake(0, 0, 480, 320);
            [self.backButton setBackgroundImage:[UIImage imageNamed:@"background"] forState:UIControlStateNormal];
        }
        self.authcodeTextField.frame = CGRectMake(160, 50, 160, 31);
        self.sureButton.frame = CGRectMake(188, 106, 105, 37);
        
    }
    
    [UIView commitAnimations];
}

- (void)dealloc {
    //[super dealloc];
}
@end
