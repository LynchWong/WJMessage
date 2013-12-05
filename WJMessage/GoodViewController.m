//
//  GoodViewController.m
//  WJMessage
//
//  Created by Can Hang on 5/2/13.
//
//

#import "GoodViewController.h"
#import "RequestData.h"
#import "JSONKit.h"
#import "GoodImageViewController.h"
#import "EGOCache.h"
#import "EGOImageButton.h"
#import "AppDelegate.h"
#import "HistoryGraphViewController.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface GoodViewController ()

@end

@implementation GoodViewController

@synthesize imageButton;
@synthesize pageScroll;
@synthesize goodImagesUrl;
@synthesize indexth;
@synthesize goodId;
@synthesize price;
@synthesize HUD;
@synthesize serviceUrl;
@synthesize labelGoodPrice;
@synthesize labelGoodName;
@synthesize priceImage;
@synthesize enterpriseName;

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
    
    self.HUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.delegate = self;
    self.HUD.labelText = @"正在加载";
    
    
    //新开一个线程加载
    [self.HUD show:YES];
    [NSThread detachNewThreadSelector:@selector(getGoodInfo) toTarget:self withObject:nil];
}

- (void)getGoodInfo
{
    NSLog(@"serviceUrl : %@",serviceUrl);
    NSLog(@"goodId : %@",goodId);
    NSLog(@"price : %@",price);
    
    //获取商品信息
    NSDictionary *result = [RequestData GoodInfo:goodId WithServiceUrl:self.serviceUrl];
    
    NSString *name = [result objectForKey:@"Name"];
    //需要的高度size.height
    CGSize size = [name sizeWithFont:[ UIFont fontWithName: @"Arial-BoldMT" size: 15.0 ]
                   constrainedToSize:CGSizeMake(300, 5000)
                       lineBreakMode:labelGoodName.lineBreakMode];
    
    self.nameSize = size;
    labelGoodName.text = name;
    labelGoodName.font = [ UIFont fontWithName: @"Arial-BoldMT" size: 15.0 ];
    labelGoodName.lineBreakMode = NSLineBreakByWordWrapping;
    labelGoodName.numberOfLines = 0;
    labelGoodName.frame = CGRectMake(10, 190, 300, size.height);
    
    //去掉价格的小数点
    NSString *finalPrice= self.price;
    if ([finalPrice rangeOfString:@"."].length == 1) {
        finalPrice = [finalPrice substringToIndex:[finalPrice rangeOfString:@"."].location + 3];
    } else {
        finalPrice = [finalPrice stringByAppendingFormat:@".00"];
    }
    labelGoodPrice.text = [NSString stringWithFormat:@"¥ %@",finalPrice];
    labelGoodPrice.font = [ UIFont fontWithName: @"Arial-BoldMT" size: 15.0 ];
    labelGoodPrice.textColor = [UIColor redColor];
    
    //设置价格标签位置，自己的y坐标加上增加的高度，增加的高度等于需要的高度减去原默认的高度，默认高度是21
    labelGoodPrice.frame = CGRectMake(69,labelGoodPrice.frame.origin.y + size.height - 21,labelGoodPrice.frame.size.width,labelGoodPrice.frame.size.height);
    
    //设置图片位置，自己的y坐标加上增加的高度，增加的高度等于需要的高度减去原默认的高度，默认高度是21
    priceImage.frame = CGRectMake(10,priceImage.frame.origin.y + size.height - 21,priceImage.frame.size.width,priceImage.frame.size.height);
    
    //获取商品图片的url，至少一张图片
    NSString *url = [[result objectForKey:@"Images"] JSONString];
    NSDictionary *dUrl = [url objectFromJSONString];
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    for (id imageUrl in dUrl) {
        [urls addObject:imageUrl];
    }
    self.goodImagesUrl = urls;
    
    //在另一个线程更新主界面，因为在本函数里更新主界面是无效的
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
}

- (void)updateUI {
    
    pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 00, self.view.frame.size.width, 172)];
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.showsHorizontalScrollIndicator = NO;
    self.pageScroll.contentSize = CGSizeMake(182 * self.goodImagesUrl.count + 10, 172);
    [self.view addSubview:self.pageScroll];
    
    for (int i = 0; i < self.goodImagesUrl.count; i++) {
        imageButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"p.png"]];
        imageButton.frame = CGRectMake((182 * i) + 10, 10, 172, 172);
        imageButton.imageURL = [NSURL URLWithString:[self.goodImagesUrl objectAtIndex:i]];
        [imageButton addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
        imageButton.tag = i;
        [self.pageScroll addSubview:imageButton];
    }
    
    //若self.HUD为真，则将self.HUD移除，设为nil
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
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
    
    UIBarButtonItem *historyButton = [[UIBarButtonItem alloc] initWithTitle:@"查看历史"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(historyButton)];
    historyButton.tintColor = [UIColor colorWithRed:56/255.0 green:146/255.0 blue:227/255.0 alpha:1];
    self.navigationItem.rightBarButtonItem = historyButton;
    //在旋转的时候点击需要再判断
    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.0f];
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
        self.pageScroll.frame = CGRectMake(0, 0, 320, 172);
        
    } else {
        
        if (iPhone5) {
            self.backImage.frame = CGRectMake(0, 0, 640, 320);
            self.backImage.image = [UIImage imageNamed:@"rbackground-568h"];
            self.pageScroll.frame = CGRectMake(0, 0, 640, 320);
        } else {
            self.backImage.frame = CGRectMake(0, 0, 480, 320);
            self.backImage.image = [UIImage imageNamed:@"rbackground"];
            self.pageScroll.frame = CGRectMake(0, 0, 480, 320);
        }
        
    }
    
    [UIView commitAnimations];
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)historyButton {
    [self performSegueWithIdentifier:@"historygraph" sender:self];
}

- (IBAction)clickImage:(UIButton *)button {
    NSLog(@"button.tag : %d",button.tag);
    self.indexth = button.tag;
    [self performSegueWithIdentifier:@"goodimage" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"goodimage"]) {
        GoodImageViewController *goodImageView = [segue destinationViewController];
        [goodImageView setGoodImagesUrl:self.goodImagesUrl];
        [goodImageView setIndexth:self.indexth];
    }
    if ([segue.identifier isEqualToString:@"historygraph"]) {
        AppDelegate *App = [[UIApplication sharedApplication] delegate];
        HistoryGraphViewController *historyGraphView = [segue destinationViewController];
        [historyGraphView setUserName:App.userName];
        [historyGraphView setEnterpriseName:self.enterpriseName];
        [historyGraphView setGoodId:self.goodId];
        [historyGraphView setServiceUrl:self.serviceUrl];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
