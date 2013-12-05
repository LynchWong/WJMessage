//
//  PickCompanyViewController.m
//  WJMessage
//
//  Created by Can Hang on 5/20/13.
//
//

#import "PickCompanyViewController.h"
#import "RequestData.h"
#import "AppDelegate.h"
#import "PriceListViewController.h"
#import "TotalListViewController.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface PickCompanyViewController ()

@end

@implementation PickCompanyViewController

@synthesize selectPicker;
@synthesize selectButton;

@synthesize HUD;
@synthesize userName;
@synthesize listData;
@synthesize companyAndUrl;
@synthesize companyAndNumber;
@synthesize selectedcServiceUrl;
@synthesize selectedcNumber;
@synthesize selectedCompanyName;

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
    
    AppDelegate *App = (AppDelegate *)[[UIApplication sharedApplication] delegate];//从应用程序委托中获取用户名称
    self.userName = App.userName;
    
    //NSLog(@"back name %@",name);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableDictionary *companyWithUrl = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *companyWithNumber = [[NSMutableDictionary alloc] init];
    
    //获取数据
    NSDictionary *result = [RequestData ListCompanyList:self.userName];
    
    for (id dt in result) {
        NSString *cName = [dt objectForKey:@"EnterpriseName"];
        NSString *cServiceUrl = [dt objectForKey:@"IphoneServiceUrl"];
        NSString *cNumber = [dt objectForKey:@"EnterpriseNumber"];
        [companyWithUrl setObject:cServiceUrl forKey:cName];
        [companyWithNumber setObject:cNumber forKey:cName];
        [array addObject:cName];
    }
    NSLog(@"companyWithUrl :%@",companyWithUrl);
    self.listData = array;
    self.companyAndUrl = companyWithUrl;
    self.companyAndNumber = companyWithNumber;
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectButton:(id)sender {
    
    NSInteger row = [selectPicker selectedRowInComponent:0];
    //NSLog(@"[self.listData objectAtIndex:row] : %@",[self.listData objectAtIndex:row]);
    self.selectedCompanyName = [self.listData objectAtIndex:row];
    if ([self.listData count] != 0) {
        self.selectedcServiceUrl = [companyAndUrl objectForKey:[self.listData objectAtIndex:row]];
        //self.selectedcNumber = [companyAndNumber objectForKey:[self.listData objectAtIndex:row]];
    }
    NSString *result = [RequestData GetPushListCountWithUrl:self.selectedcServiceUrl AndUserName:self.userName];
    if ([result isEqualToString:@"0"] || result == NULL) {//没有数据跳转到汇总页面
        [self performSegueWithIdentifier:@"picktotallist" sender:self];
    } else {//有数据，跳转到更新页面
        [self performSegueWithIdentifier:@"pickpricelist" sender:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //刷新pickerview控件数据
    [self.selectPicker reloadAllComponents];
    //在旋转的时候点击需要再判断
    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.0f];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration{
    
    UIInterfaceOrientation toOrientation = self.interfaceOrientation;
    [UIView beginAnimations:@"move views" context:nil];
    
    if (toOrientation == UIInterfaceOrientationPortrait || toOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        self.selectPicker.frame = CGRectMake(0, 31, 320, 216);
        self.selectButton.frame = CGRectMake(105, 269, 105, 37);
        
    } else {
        
        if (iPhone5) {
            self.selectPicker.frame = CGRectMake(0, 0, 640, 216);
            self.selectButton.frame = CGRectMake(270, 220, 105, 37);
        } else {
            self.selectPicker.frame = CGRectMake(0, 0, 480, 216);
            self.selectButton.frame = CGRectMake(185, 220, 105, 37);
        }
        
    }
    
    [UIView commitAnimations];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pickpricelist"]) {
        PriceListViewController *priceListView = [segue destinationViewController];
        [priceListView setUserName:self.userName];
        [priceListView setEnterpriseName:self.selectedCompanyName];
        [priceListView setServiceUrl:self.selectedcServiceUrl];
    }
    if ([segue.identifier isEqualToString:@"picktotallist"]) {
        TotalListViewController *totalListView = [segue destinationViewController];
        [totalListView setUserName:self.userName];
        [totalListView setEnterpriseName:self.selectedCompanyName];
        [totalListView setServiceUrl:self.selectedcServiceUrl];
    }
    if ([segue.identifier isEqualToString:@"history"]) {
        
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return [self.listData count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component{
    
    NSString *cName = [listData objectAtIndex:row];
    NSString *cServiceUrl = [companyAndUrl objectForKey:cName];
    NSString *result = [RequestData GetPushListCountWithUrl:cServiceUrl AndUserName:self.userName];
    NSLog(@"result : %@",result);
    if ([result isEqualToString:@"0"] || result == NULL) {
        return [self.listData objectAtIndex:row];
    } else {
        return [[self.listData objectAtIndex:row] stringByAppendingFormat:@"(%@条更新)",result];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
