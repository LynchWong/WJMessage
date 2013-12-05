//
//  RegistViewController.m
//  WJMessage
//
//  Created by Can Hang on 4/17/13.
//
//

#import "RegistViewController.h"
#import "RequestData.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface RegistViewController ()

@end

@implementation RegistViewController

@synthesize userName;
@synthesize passWord;
@synthesize secondPassWord;
@synthesize mail;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//点击键盘Done隐藏键盘
- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
    
    [self resumeView];
}

//点击空白隐藏键盘
- (IBAction)backgroundClick:(id)sender {
    [userName resignFirstResponder];
    [passWord resignFirstResponder];
    [secondPassWord resignFirstResponder];
    [mail resignFirstResponder];
    
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

-(IBAction)submitButtonPressed:(id)sender {
    if ([[userName text] isEqualToString:@""]) {
        UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"用户名不能为空！"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
        [uiAlert show];
    } else if ([[passWord text] length] < 7) {
        UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"密码不能少于7位！"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
        [uiAlert show];
    } else if (![[passWord text] isEqualToString:[secondPassWord text]]) {
        UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"两次密码输入不一样！"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
        [uiAlert show];
    } else if ([[mail text] isEqualToString:@""]) {
        UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"邮箱不能为空！"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
        [uiAlert show];
    } else {
        NSString *result = [RequestData RegisterWithName:[userName text] AndPassWord:[passWord text] AndMail:[mail text]];
        if ([result isEqualToString:@"success"]) {
            UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:nil
                                                              message:@"注册成功！"
                                                             delegate:self
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil, nil];
            [uiAlert show];
        } else {
                UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                  message:@"注册失败！"
                                                                 delegate:self
                                                        cancelButtonTitle:@"确定"
                                                        otherButtonTitles:nil, nil];
            [uiAlert show];
        }
    }
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

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
    
    self.userName.delegate = self;
    self.passWord.delegate = self;
    self.secondPassWord.delegate = self;
    self.mail.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
        self.loginImage.frame = CGRectMake(30, 7, 240, 80);
        self.userName.frame = CGRectMake(40, 90, 240, 31);
        self.passWord.frame = CGRectMake(40, 130, 240, 31);
        self.secondPassWord.frame = CGRectMake(40, 170, 240, 31);
        self.mail.frame = CGRectMake(40, 210, 240, 31);
        self.registButton.frame = CGRectMake(108, 245, 105, 37);
        
    } else {
        
        //设置背景图片
        if (iPhone5) {
            self.backButton.frame = CGRectMake(0, 0, 640, 320);
            [self.backButton setBackgroundImage:[UIImage imageNamed:@"background-568h"] forState:UIControlStateNormal];
        } else {
            self.backButton.frame = CGRectMake(0, 0, 480, 320);
            [self.backButton setBackgroundImage:[UIImage imageNamed:@"background"] forState:UIControlStateNormal];
        }
        self.loginImage.frame = CGRectMake(120, 0, 240, 80);
        self.userName.frame = CGRectMake(120, 75, 240, 31);
        self.passWord.frame = CGRectMake(120, 115, 240, 31);
        self.secondPassWord.frame = CGRectMake(120, 155, 240, 31);
        self.mail.frame = CGRectMake(120, 195, 240, 31);
        self.registButton.frame = CGRectMake(188, 230, 105, 37);
        
    }
    
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
