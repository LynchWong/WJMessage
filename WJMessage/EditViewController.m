//
//  EditViewController.m
//  WJMessage
//
//  Created by can 杭伟 on 3/28/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "EditViewController.h"
#import "WelcomeViewController.h"
#import "AppDelegate.h"
#import "RequestData.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@implementation EditViewController

@synthesize name;
@synthesize enterpriseNumber;
@synthesize enterpriseName;

//点击键盘Done隐藏键盘
- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
    
    [self resumeView];
}

//点击空白隐藏键盘
- (IBAction)backgroundClick:(id)sender {
    [enterpriseName resignFirstResponder];
    [enterpriseNumber resignFirstResponder];
    
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
    CGRect rect=CGRectMake(0.0f,-160,width,height);
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
    NSString *nameValue = [enterpriseName text];
    NSString *numberValue = [enterpriseNumber text]; 
    NSLog(@"%@",nameValue);
    NSLog(@"%@",numberValue);
    if (numberValue == NULL) {
        UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"企业号不能为空！"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
        [uiAlert show];
    } else if ([nameValue isEqualToString:@""]) {
        UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:nil 
                                                          message:@"企业名称不能为空！" 
                                                         delegate:self 
                                                cancelButtonTitle:@"确定" 
                                                otherButtonTitles:nil, nil];
        [uiAlert show];
        //[uiAlert release];
    } else {
        NSLog(@"ELSE");
        NSError *error = [RequestData EditEnterpriseInfoWithName:nameValue AndNumber:numberValue];
        
        if (!error) {
            NSLog(@"!error");
            //[self dismissViewControllerAnimated:YES completion:Nil];
//            AppDelegate *App = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            Enterprise *enterpriseInfo = [[Enterprise alloc] init];
//            enterpriseInfo.enterpriseName = nameValue;
//            enterpriseInfo.enterpriseNumber = numberValue;
//            App.enterprise = enterpriseInfo;
            UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:nil
                                                              message:@"修改成功！"
                                                             delegate:self
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil, nil];
            [uiAlert show];
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
    //设置返回按钮
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(backButtonPressed)];
    barButton.tintColor = [UIColor colorWithRed:56/255.0 green:146/255.0 blue:227/255.0 alpha:1];
    self.navigationItem.leftBarButtonItem = barButton;
    
    self.enterpriseName.delegate = self;
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"LoginStatus"];
    if (![loginStatus isEqualToString:@"YES"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    //获取用户的企业信息
    AppDelegate *App = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *companyNumber = [RequestData UserInEnterpriseNumber:App.userName];
    NSLog(@"companyNumber :%@",companyNumber);
    NSArray *company =[companyNumber componentsSeparatedByString:@","];
    if ([company count] >= 2) {
        enterpriseNumber.text = [company objectAtIndex:0];
        enterpriseNumber.textColor = [UIColor colorWithRed:56/255.0 green:146/255.0 blue:227/255.0 alpha:1];
        enterpriseName.text = [company objectAtIndex:1];
    }
    //在旋转的时候点击需要再判断
    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.0f];
}

//旋转时调用的方法，将试图控件调整到合适的位置；
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
        self.updateButton.frame = CGRectMake(187, 41, 105, 37);
        self.numberImage.frame = CGRectMake(20, 195, 30, 30);
        self.nameImage.frame = CGRectMake(20, 248, 30, 30);
        self.enterpriseNumber.frame = CGRectMake(59, 199, 125, 21);
        self.enterpriseName.frame = CGRectMake(59, 247, 192, 32);
        
    } else {
        
        //设置背景图片
        if (iPhone5) {
            self.backButton.frame = CGRectMake(0, 0, 640, 320);
            [self.backButton setBackgroundImage:[UIImage imageNamed:@"background-568h"] forState:UIControlStateNormal];
        } else {
            self.backButton.frame = CGRectMake(0, 0, 480, 320);
            [self.backButton setBackgroundImage:[UIImage imageNamed:@"background"] forState:UIControlStateNormal];
        }
        self.updateButton.frame = CGRectMake(340, 20, 105, 37);
        self.numberImage.frame = CGRectMake(20, 175, 30, 30);
        self.nameImage.frame = CGRectMake(20, 228, 30, 30);
        self.enterpriseNumber.frame = CGRectMake(59, 179, 125, 21);
        self.enterpriseName.frame = CGRectMake(59, 227, 192, 32);
        
    }
    
    [UIView commitAnimations];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
}

- (void)dealloc {
    //[super dealloc];
}
@end
