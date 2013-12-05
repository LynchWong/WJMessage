//
//  FirstViewController.m
//  WJMessage
//
//  Created by Can Hang on 4/16/13.
//
//

#import "FirstViewController.h"
#import "ViewController.h"
#import "PriceListViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "RequestData.h"
#import "TotalListViewController.h"
#import "PriceListViewController.h"
#import "JSBadgeView.h"
#import "Reachability.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface FirstViewController ()

@end

@implementation FirstViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

@synthesize cName;
@synthesize cServiceUrl;
//@synthesize cNumber;
@synthesize userName;
@synthesize weijiaButton;
@synthesize HUD;

//- (IBAction)mallButtonPressed:(id)sender {
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                               message:@"功能暂未开放，敬请期待！"
//                                              delegate:self
//                                     cancelButtonTitle:@"确定"
//                                     otherButtonTitles: nil];
//    [alertView show];
//
//    NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"LoginStatus"];
//    if([loginStatus isEqualToString:@"YES"])
//    {
//        [self performSegueWithIdentifier:@"pushgetprice" sender:self];
//    }
//    else
//    {
//        getPriceAlert = [[UIAlertView alloc] initWithTitle:nil
//                                                   message:@"你还没有登录，请先登录！"
//                                                  delegate:self
//                                         cancelButtonTitle:@"取消"
//                                         otherButtonTitles:@"确定", nil];
//        [getPriceAlert show];
//    }
//}

- (IBAction)enterpriseCenterButtonPressed:(id)sender {
    NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"LoginStatus"];
    if ([loginStatus isEqualToString:@"YES"]) {
        [self performSegueWithIdentifier:@"pushenterprisecenter" sender:self];
    } else {
        enterpriseCenterAlert = [[UIAlertView alloc] initWithTitle:nil
                                                   message:@"你还没有登录，请先登录！"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
        [enterpriseCenterAlert show];
    }
}

//- (IBAction)serviceButtonPressed:(id)sender {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:@"功能暂未开放，敬请期待！"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles: nil];
//    [alertView show];
//    
//        NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"LoginStatus"];
//        if([loginStatus isEqualToString:@"YES"])
//        {
//            [self performSegueWithIdentifier:@"pushgetprice" sender:self];
//        }
//        else
//        {
//            getPriceAlert = [[UIAlertView alloc] initWithTitle:nil
//                                                       message:@"你还没有登录，请先登录！"
//                                                      delegate:self
//                                             cancelButtonTitle:@"取消"
//                                             otherButtonTitles:@"确定", nil];
//            [getPriceAlert show];
//        }
//}

- (IBAction)weijiaButtonPressed:(id)sender {
    NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"LoginStatus"];
    if (![loginStatus isEqualToString:@"YES"]) {
        weijiaAlert = [[UIAlertView alloc] initWithTitle:nil
                                                 message:@"你还没有登录，请先登录！"
                                                delegate:self
                                       cancelButtonTitle:@"取消"
                                       otherButtonTitles:@"确定", nil];
        [weijiaAlert show];
    } else {
        self.HUD = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.delegate = self;
        self.HUD.labelText = @"正在加载";
        //self.HUD.mode = MBProgressHUDModeAnnularDeterminate;
    
        //新开一个线程加载
        [self.HUD show:YES];
        [NSThread detachNewThreadSelector:@selector(getCompanyListCount) toTarget:self withObject:nil];
    }
}

- (void)getCompanyListCount {
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
        
        AppDelegate *App = (AppDelegate *)[[UIApplication sharedApplication] delegate];//从应用程序委托中获取用户名称
        self.userName = App.userName;
        
        //获取数据
        NSDictionary *result = [RequestData ListCompanyList:self.userName];
        if ([result count] == 0) {
            self.HUD.labelText = @"没有关注的企业！";
            [NSThread sleepForTimeInterval:1.0];
        } else if ([result count] == 1) {
            for (id dt in result) {
                self.cName = [dt objectForKey:@"EnterpriseName"];
                self.cServiceUrl = [dt objectForKey:@"IphoneServiceUrl"];
                //self.cNumber = [dt objectForKey:@"EnterpriseNumber"];
            }
            NSString *result = [RequestData GetPushListCountWithUrl:self.cServiceUrl AndUserName:self.userName];
            if ([result isEqualToString:@"0"] || result == NULL) {//没有数据跳转到汇总页面
                [self performSegueWithIdentifier:@"totallist" sender:self];
            } else {//有数据，跳转到更新页面
                [self performSegueWithIdentifier:@"pricelist" sender:self];
            }
        } else {
            [self performSegueWithIdentifier:@"pickcompany" sender:self];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pricelist"]) {
        PriceListViewController *priceListView = [segue destinationViewController];
        [priceListView setUserName:self.userName];
        [priceListView setEnterpriseName:self.cName];
        [priceListView setServiceUrl:self.cServiceUrl];
    }
    if ([segue.identifier isEqualToString:@"totallist"]) {
        TotalListViewController *totalListView = [segue destinationViewController];
        [totalListView setUserName:self.userName];
        [totalListView setEnterpriseName:self.cName];
        [totalListView setServiceUrl:self.cServiceUrl];
    }
    if ([segue.identifier isEqualToString:@"history"]) {
        
    }
}

//点击alertview按钮时回调的方法，在方法中判断是否执行，buttonIndex ＝ 0说明时取消按钮
- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == weijiaAlert) {
        if (buttonIndex != 0) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            ViewController *loginView = [storyBoard instantiateViewControllerWithIdentifier:@"LoginView"];
            [loginView setAlertStyle:@"weijiaAlert"];
            [self.navigationController pushViewController:loginView animated:YES];
        }
    }
    if (alertView == enterpriseCenterAlert) {
        if (buttonIndex != 0) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            ViewController *loginView = [storyBoard instantiateViewControllerWithIdentifier:@"LoginView"];
            [loginView setAlertStyle:@"enterpriseCenterAlert"];
            [self.navigationController pushViewController:loginView animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *App = [[UIApplication sharedApplication] delegate];
    if ([App.whereComeFrom isEqualToString:@"LocalNotification"]) {
        App.whereComeFrom = @"LocalNotificationFirstView";
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        PriceListViewController *priceListView = [storyBoard instantiateViewControllerWithIdentifier:@"PriceList"];
        [self.navigationController pushViewController:priceListView animated:YES];
    }
    //在旋转的时候点击需要再判断
    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.0f];
    [NSThread detachNewThreadSelector:@selector(getBadgeNumber) toTarget:self withObject:nil];//新开一个线程防止阻塞主线程，阻塞主线程会让程序界面卡住，让用户误以为程序崩溃
}

- (void)getBadgeNumber {
    AppDelegate *App = [[UIApplication sharedApplication] delegate];
    NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"LoginStatus"];
    NSLog(@"loginStatus : %@",loginStatus);
    NSLog(@"userName : %@",App.userName);
    if ([loginStatus isEqualToString:@"YES"] && App.userName != NULL) {
        NSLog(@"123");
        //添加BadgeViewNumber
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:self.weijiaButton alignment:JSBadgeViewAlignmentTopRight];
        
        //获取数据
        NSDictionary *result = [RequestData ListCompanyList:App.userName];
        int totalNumber = 0;
        for (id dt in result) {
            NSString *sUrl = [dt objectForKey:@"IphoneServiceUrl"];
            NSLog(@"sUrl : %@",sUrl);
            NSString *number = [RequestData GetPushListCountWithUrl:sUrl AndUserName:App.userName];
            if (result != NULL) {
                totalNumber = totalNumber + [number intValue];
            }
        }
        if (totalNumber != 0) {
            badgeView.badgeText = [NSString stringWithFormat:@"%d",totalNumber];
        } else {
            for(id view in [self.weijiaButton subviews]) {
                if ([view isKindOfClass:[JSBadgeView class]]) {
                    [view removeFromSuperview];
                }
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigationbar.png"]
                                                  forBarMetrics:UIBarMetricsDefault];

    //获取根视图控制器
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    SWRevealViewController *revealController = (SWRevealViewController *)delegate.window.rootViewController;
    
    //顶部左侧按钮
    UIImage *img_menu = [UIImage imageNamed:@"reveal-icon"];
    UIButton *btn_menu = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_menu.frame = CGRectMake(15, 0, img_menu.size.width, img_menu.size.height);
    [btn_menu setImage:img_menu forState:UIControlStateNormal];
    [self.view addSubview:btn_menu];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn_menu];
    self.navigationItem.leftBarButtonItem = barButton;
    
    //菜单按钮点击事件（展开隐藏菜单）
    [btn_menu addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加页面滑动事件（展开隐藏菜单）
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
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
        self.weijiaLabel.frame = CGRectMake(61, 171, 68, 21);
        self.enterpriseCenterLabel.frame = CGRectMake(180, 171, 68, 21);
//        self.mallLabel.frame = CGRectMake(61, 269, 68, 21);
//        self.serviceLabel.frame = CGRectMake(180, 269, 68, 21);
        
        self.weijiaButton.frame = CGRectMake(55, 76, 80, 80);
        self.enterpriseCenterButton.frame = CGRectMake(174, 76, 80, 80);
//        self.mallButton.frame = CGRectMake(55, 180, 80, 80);
//        self.serviceButton.frame = CGRectMake(174, 180, 80, 80);
        
    } else {
        
        if (iPhone5) {
            self.backImage.frame = CGRectMake(0, 0, 640, 320);
            self.backImage.image = [UIImage imageNamed:@"rbackground-568h"];
        } else {
            self.backImage.frame = CGRectMake(0, 0, 480, 320);
            self.backImage.image = [UIImage imageNamed:@"rbackground"];
        }
        self.weijiaLabel.frame = CGRectMake(86, 129, 68, 21);
        self.enterpriseCenterLabel.frame = CGRectMake(326, 129, 68, 21);
//        self.mallLabel.frame = CGRectMake(86, 239, 68, 21);
//        self.serviceLabel.frame = CGRectMake(326, 239, 68, 21);
        
        self.weijiaButton.frame = CGRectMake(80, 30, 80, 80);
        self.enterpriseCenterButton.frame = CGRectMake(320, 30, 80, 80);
//        self.mallButton.frame = CGRectMake(80, 150, 80, 80);
//        self.serviceButton.frame = CGRectMake(320, 150, 80, 80);
        
    }
    
    [UIView commitAnimations];
}

@end
