//
//  EnterpriseViewController.m
//  WJMessage
//
//  Created by Can Hang on 4/22/13.
//
//

#import "EnterpriseViewController.h"
#import "AppDelegate.h"
#import "PriceListViewController.h"
#import "TotalListViewController.h"
#import "HistoryViewController.h"
#import "RequestData.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface EnterpriseViewController ()

@end

@implementation EnterpriseViewController

@synthesize userName;
@synthesize serviceUrl;
@synthesize companyNumber;
@synthesize enterpriseName;
@synthesize enterpriseNumber;

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
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
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
    
    NSLog(@"companyNumber : %@",self.companyNumber);
    NSString *result = [RequestData EnterpriseInfo:self.companyNumber];
    NSLog(@"result :%@",result);
    NSArray *company =[result componentsSeparatedByString:@","];
    if ([company count] >= 2) {
        enterpriseNumber.text = [company objectAtIndex:0];
        enterpriseNumber.font = [ UIFont fontWithName: @"Arial-BoldMT" size: 17.0 ];
        enterpriseName.text = [company objectAtIndex:1];
        enterpriseName.font = [ UIFont fontWithName: @"Arial-BoldMT" size: 17.0 ];
    }
    //在旋转的时候点击需要再判断
    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.0f];
}

- (IBAction)weijiaButtonPressed:(id)sender
{
    NSString *result = [RequestData GetPushListCountWithUrl:self.serviceUrl AndUserName:self.userName];
    if ([result isEqualToString:@"0"] || result == NULL) {//没有数据跳转到汇总页面
        [self performSegueWithIdentifier:@"etotallist" sender:self];
    } else {//有数据，跳转到更新页面
        [self performSegueWithIdentifier:@"epricelist" sender:self];
    }
}

- (IBAction)mallButtonPressed:(id)sender {
    //[self performSegueWithIdentifier:@"pricelist" sender:self];
    UIAlertView *tipAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                           message:@"功能暂未开放，敬请期待！"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
    [tipAlertView show];
}

- (IBAction)serviceButtonPressed:(id)sender {
    //[self performSegueWithIdentifier:@"totallist" sender:self];
    UIAlertView *tipAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                           message:@"功能暂未开放，敬请期待！"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
    [tipAlertView show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"epricelist"]) {
        PriceListViewController *priceListView = [segue destinationViewController];
        [priceListView setUserName:self.userName];
        [priceListView setEnterpriseName:self.enterpriseName.text];
        [priceListView setServiceUrl:self.serviceUrl];
    }
    if ([segue.identifier isEqualToString:@"etotallist"]) {
        TotalListViewController *totalListView = [segue destinationViewController];
        [totalListView setUserName:self.userName];
        [totalListView setEnterpriseName:self.enterpriseName.text];
        [totalListView setServiceUrl:self.serviceUrl];
    }
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
        self.numberImage.frame = CGRectMake(20, 195, 30, 30);
        self.nameImage.frame = CGRectMake(20, 248, 30, 30);
        self.enterpriseNumber.frame = CGRectMake(59, 199, 181, 21);
        self.enterpriseName.frame = CGRectMake(59, 252, 241, 21);
        
        self.weijiaButton.frame = CGRectMake(187, 20, 105, 37);
        self.mallButton.frame = CGRectMake(187, 68, 105, 37);
        self.serviceButton.frame = CGRectMake(187, 115, 105, 37);
        
    } else {
        
        if (iPhone5) {
            self.backImage.frame = CGRectMake(0, 0, 640, 320);
            self.backImage.image = [UIImage imageNamed:@"rbackground-568h"];
        } else {
            self.backImage.frame = CGRectMake(0, 0, 480, 320);
            self.backImage.image = [UIImage imageNamed:@"rbackground"];
        }
        self.numberImage.frame = CGRectMake(20, 195, 30, 30);
        self.nameImage.frame = CGRectMake(20, 238, 30, 30);
        self.enterpriseNumber.frame = CGRectMake(59, 199, 181, 21);
        self.enterpriseName.frame = CGRectMake(59, 242, 241, 21);
        
        self.weijiaButton.frame = CGRectMake(340, 20, 105, 37);
        self.mallButton.frame = CGRectMake(340, 68, 105, 37);
        self.serviceButton.frame = CGRectMake(340, 115, 105, 37);
        
    }
    
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
