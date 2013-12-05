//
//  SettingViewController.m
//  WJMessage
//
//  Created by Can Hang on 4/16/13.
//
//

#import "SettingViewController.h"
#import "ViewController.h"
#import "GuideViewController.h"
#import "EditViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "PersonInfoViewController.h"
#import "RequestData.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigationbar.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    static NSString *SimpleTableIdentifier = @"SettingTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:SimpleTableIdentifier];
    }
    
    if (row == 0) {
        cell.textLabel.text = @"企业在线";
        cell.imageView.image = [UIImage imageNamed:@"home_24"];
    } else if(row == 1) {
        cell.textLabel.text = @"我的帐户";
        cell.imageView.image = [UIImage imageNamed:@"man_24"];
    } else if(row == 2) {
        cell.textLabel.text = @"企业信息";
        cell.imageView.image = [UIImage imageNamed:@"smallme"];
    } else //if(row == 3)
    {
        cell.textLabel.text = @"注销";
        cell.imageView.image = [UIImage imageNamed:@"smallcancel"];
    }
//    else
//    {
//        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.textLabel.text = @"显示引导界面";
//        cell.imageView.image = [UIImage imageNamed:@"smallabout"];
//    }
    
    return cell;
}
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView
                            accessoryType:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    AppDelegate *App = [[UIApplication sharedApplication] delegate];
    if (row == 0) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UINavigationController *firstView = [storyBoard instantiateViewControllerWithIdentifier:@"FirstNavigation"];
        [App.revealViewController setFrontViewController:firstView animated:YES];
    } else if(row == 1) {
        NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"LoginStatus"];
        if ([loginStatus isEqualToString:@"YES"]) {
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
        } else {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            ViewController *loginView = [storyBoard instantiateViewControllerWithIdentifier:@"LoginView"];
            [loginView setAlertStyle:@"SettingPerson"];
            UINavigationController *frontView = [[UINavigationController alloc] initWithRootViewController:loginView];
            [frontView.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigationbar.png"]
                                          forBarMetrics:UIBarMetricsDefault];
            
            //顶部左侧按钮
            UIImage *img_menu = [UIImage imageNamed:@"reveal-icon"];
            UIButton *btn_menu = [UIButton buttonWithType:UIButtonTypeCustom];
            btn_menu.frame = CGRectMake(15, 0, img_menu.size.width, img_menu.size.height);
            [btn_menu setImage:img_menu forState:UIControlStateNormal];
            [loginView.view addSubview:btn_menu];
            UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn_menu];
            loginView.navigationItem.leftBarButtonItem = barButton;
            
            //菜单按钮点击事件（展开隐藏菜单）
            [btn_menu addTarget:App.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            [loginView.view addGestureRecognizer:App.revealViewController.panGestureRecognizer];
            
            [App.revealViewController setFrontViewController:frontView animated:YES];
        }
    }
    else if(row == 2) {
        NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"LoginStatus"];
        if ([loginStatus isEqualToString:@"YES"]) {//如果已经登录
            
            AppDelegate *App = (AppDelegate *)[[UIApplication sharedApplication] delegate];//从应用程序委托中获取用户名称
            //判断是否是C类客户，若是就隐藏掉添加令牌的按钮
            NSString *companyNumber = [RequestData UserInEnterpriseNumber:App.userName];
            NSLog(@"companyNumber : %@",companyNumber);
            if ([companyNumber isEqualToString:@""]) {//是C类用户
                UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                  message:@"你不是企业用户，请升级为企业用户"
                                                                 delegate:self
                                                        cancelButtonTitle:@"确定"
                                                        otherButtonTitles:nil, nil];
                [uiAlert show];
            } else {
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
        } else {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            ViewController *loginView = [storyBoard instantiateViewControllerWithIdentifier:@"LoginView"];
            [loginView setAlertStyle:@"SettingEnterprise"];
            UINavigationController *frontView = [[UINavigationController alloc] initWithRootViewController:loginView];
            [frontView.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigationbar.png"]
                                          forBarMetrics:UIBarMetricsDefault];
            
            //顶部左侧按钮
            UIImage *img_menu = [UIImage imageNamed:@"reveal-icon"];
            UIButton *btn_menu = [UIButton buttonWithType:UIButtonTypeCustom];
            btn_menu.frame = CGRectMake(15, 0, img_menu.size.width, img_menu.size.height);
            [btn_menu setImage:img_menu forState:UIControlStateNormal];
            [loginView.view addSubview:btn_menu];
            UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn_menu];
            loginView.navigationItem.leftBarButtonItem = barButton;
            
            //菜单按钮点击事件（展开隐藏菜单）
            [btn_menu addTarget:App.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            [loginView.view addGestureRecognizer:App.revealViewController.panGestureRecognizer];
            
            [App.revealViewController setFrontViewController:frontView animated:YES];
        }
    } else //if(row == 3)
    {
        NSString *logOutResult = [RequestData loginOutWithUserName:App.userName];
        NSLog(@"logOutResult : %@",logOutResult);
        if ([logOutResult isEqualToString:@"success"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"注销成功！"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
            [alertView show];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginStatus"];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"注销失败！"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
            [alertView show];
        }
    }
//    else
//    {
//        [GuideViewController show];
//    }
}

@end
