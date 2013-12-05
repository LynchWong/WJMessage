//
//  HistoryGraphViewController.m
//  WJMessage
//
//  Created by Can Hang on 5/22/13.
//
//

#import "HistoryGraphViewController.h"
#import "GoodPrice.h"
#import "RequestData.h"
#import "GoodViewController.h"
#import "HistoryViewController.h"
#import "AppDelegate.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface HistoryGraphViewController ()

@end

@implementation HistoryGraphViewController

@synthesize userName;
@synthesize listData;
@synthesize serviceUrl;
@synthesize enterpriseName;
@synthesize HUD;
@synthesize goodId;
@synthesize selectedPrice;

@synthesize closeBtn;
@synthesize listBtn;
@synthesize webViewForSelectDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    CGRect webFrame = self.view.frame;
    webFrame.origin.x = 0;
    webFrame.origin.y = 0;
    
    webViewForSelectDate = [[UIWebView alloc] initWithFrame:webFrame];
    webViewForSelectDate.delegate = self;
    //webViewForSelectDate.scalesPageToFit = YES; //原始大小
    webViewForSelectDate.opaque = NO;
    webViewForSelectDate.backgroundColor = [UIColor clearColor];
    webViewForSelectDate.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:webViewForSelectDate];
    
    //所有的资源都在HistoryGraph.bundle这个文件夹里
    NSString* htmlPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"HistoryGraph.bundle/JqChart.html"];
    NSURL* url = [NSURL fileURLWithPath:htmlPath];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webViewForSelectDate loadRequest:request];
    
    //返回按钮
    CGRect closeBtnFrame = CGRectMake(10, 10, 70, 30);
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:closeBtnFrame];
    [closeBtn setTitle:@"返回" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePage) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setTitleColor:[UIColor colorWithRed:56/255.0 green:146/255.0 blue:227/255.0 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
    [self.view bringSubviewToFront:closeBtn];
    
    //列表按钮
    CGRect listBtnFrame = CGRectMake(250, 10, 70, 30);
    listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [listBtn setFrame:listBtnFrame];
    [listBtn setTitle:@"列表" forState:UIControlStateNormal];
    [listBtn addTarget:self action:@selector(listHistoryPage) forControlEvents:UIControlEventTouchUpInside];
    [listBtn setTitleColor:[UIColor colorWithRed:56/255.0 green:146/255.0 blue:227/255.0 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:listBtn];
    [self.view bringSubviewToFront:listBtn];
    
    //获取企业历史报价列表
    page = 1;
    NSDictionary *result = [RequestData MorePriceListWithUrl:serviceUrl AndUserName:userName AndPage:page AndGoodId:self.goodId];
    NSLog(@"result :%@",result);
    NSMutableArray *goodPrices = [[NSMutableArray alloc] init];
    for (id dt in result) {
        GoodPrice *good = [[GoodPrice alloc] init];
        NSString *goodName = [dt objectForKey:@"GoodName"];
        NSString *goodPrice = [dt objectForKey:@"CuPrice"];
        NSString *updateTime = [dt objectForKey:@"BillDateTime"];
        NSString *gId = [dt objectForKey:@"GoodId"];
        good.goodName = goodName;
        good.goodPrice = goodPrice;
        good.updateTime = updateTime;
        good.goodId = gId;
        [goodPrices addObject:good];
        //[good release];
    }
    self.listData = goodPrices;
    NSLog(@"self.listData : %d",[self.listData count]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    //在旋转的时候点击需要再判断
    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.0f];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration{
    
    UIInterfaceOrientation toOrientation = self.interfaceOrientation;
    [UIView beginAnimations:@"move views" context:nil];
    
    if (toOrientation == UIInterfaceOrientationPortrait || toOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        self.listBtn.frame = CGRectMake(240, 10, 70, 30);
        
    } else {
        
        if (iPhone5) {
            self.listBtn.frame = CGRectMake(500, 10, 70, 30);
        } else {
            self.listBtn.frame = CGRectMake(400, 10, 70, 30);
        }
        
    }
    
    [UIView commitAnimations];
}

- (void)closePage {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)listHistoryPage {
    
    [self performSegueWithIdentifier:@"listhistory" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"listhistory"]) {
        
        AppDelegate *App = [[UIApplication sharedApplication] delegate];
        HistoryViewController *historyView = [segue destinationViewController];
        [historyView setUserName:App.userName];
        [historyView setEnterpriseName:self.enterpriseName];
        [historyView setGoodId:self.goodId];
        [historyView setServiceUrl:self.serviceUrl];
    }
}

#pragma mark - delegate of webview
- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
    navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

-(void)webView:(UIWebView *)webView
    didFailLoadWithError:(NSError *)error {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSMutableString* jsStr = [[NSMutableString alloc] initWithCapacity:0];
//    for(GoodPrice *good in self.listData)
    NSString *onePoint = [[NSString alloc] init];
    for (int i = 0; i < [self.listData count]; i++) {
        GoodPrice *good = [self.listData objectAtIndex:i];
        NSString *time = good.updateTime;
        NSArray *displayTime = [time componentsSeparatedByString:@"T"];
        NSArray *ymd = [[displayTime objectAtIndex:0] componentsSeparatedByString:@"-"];
        NSString *year = [ymd objectAtIndex:0];
        NSString *month = [ymd objectAtIndex:1];
        NSString *day = [ymd objectAtIndex:2];
        NSString *price = good.goodPrice;
        if (i <([self.listData count] - 1)) {
            onePoint = [onePoint stringByAppendingString:[NSString stringWithFormat:@"[new Date(%@,%@,%@),%@],",year,month,day,price]];
        } else {
            onePoint = [onePoint stringByAppendingString:[NSString stringWithFormat:@"[new Date(%@,%@,%@),%@]]",year,month,day,price]];
        }
        NSLog(@"onePoint in for : %@",onePoint);
    }
    NSString *resultPoints = [@"[" stringByAppendingString:onePoint];
    NSLog(@"resultPoints : %@",resultPoints);
    [jsStr appendFormat:@"deliverData(%@)",resultPoints];
    [webViewForSelectDate stringByEvaluatingJavaScriptFromString:jsStr];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dealloc {
//    [super dealloc];
//}

@end
