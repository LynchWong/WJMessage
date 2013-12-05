//
//  WelcomeViewController.m
//  WJMessage
//
//  Created by can 杭伟 on 3/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "WelcomeViewController.h"
#import "Enterprise.h"
#import "EditViewController.h"
#import "AuthCodeViewController.h"
#import "AppDelegate.h"
#import "EnterpriseViewController.h"
#import "RequestData.h"
#import "ZBarSDK.h"

@implementation WelcomeViewController

//@synthesize repeatingTimer;
@synthesize name;
@synthesize listData;
@synthesize companyAndUrl;
@synthesize companyAndNumber;
@synthesize selectedcServiceUrl;
@synthesize selectedcNumber;
@synthesize HUD;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (IBAction)addAuthCodeButtonPressed:(id)sender {
    
    CGFloat xWidth = self.view.bounds.size.width - 20.0f;
    CGFloat yHeight = 152.0f;//弹出框总的高度
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = FALSE;
    [poplistview setTitle:@"选择添加方式"];
    [poplistview show];
}

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
    // Do any additional setup after loading the view, typically from a nib.
    
    self.HUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.delegate = self;
    self.HUD.labelText = @"正在加载...";
    //self.HUD.mode = MBProgressHUDModeAnnularDeterminate;
    
    //新开一个线程加载
    [self.HUD show:YES];
    [NSThread detachNewThreadSelector:@selector(loadCompanyList) toTarget:self withObject:nil];
}

//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}

- (void)backButtonPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //判断是否在登录状态，不是就返回到根页面
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
    
//    //判断是否是C类客户，若是就隐藏掉添加令牌的按钮
//    NSString *companyNumber = [RequestData UserInEnterpriseNumber:self.name];
//    NSLog(@"companyNumber : %@",companyNumber);
//    if ([companyNumber isEqualToString:@""]) {
//        self.navigationItem.rightBarButtonItem = nil;//直接将右边的button设置为空
//    }
    
    AppDelegate *App = [[UIApplication sharedApplication] delegate];
    NSString *fromWhere = App.fromWhere;
    NSLog(@"fromWhere : %@",fromWhere);
    if (fromWhere != NULL) {
        
        App.fromWhere = nil;
        NSLog(@"if fromWhere : %@",fromWhere);
        self.HUD = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.delegate = self;
        self.HUD.labelText = @"正在加载...";
        //self.HUD.mode = MBProgressHUDModeAnnularDeterminate;
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        //新开一个线程加载
        [self.HUD show:YES];
        [NSThread detachNewThreadSelector:@selector(loadCompanyList) toTarget:self withObject:nil];
    }
}

- (void)loadCompanyList {
    
    AppDelegate *App = (AppDelegate *)[[UIApplication sharedApplication] delegate];//从应用程序委托中获取用户名称
    self.name = App.userName;
    
    NSLog(@"back name %@",name);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableDictionary *companyWithUrl = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *companyWithNumber = [[NSMutableDictionary alloc] init];
    
    //获取数据
    NSDictionary *result = [RequestData ListCompanyList:self.name];
    
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
    
    App.companyAndUrl = companyWithUrl;
    App.userName = self.name;
    [self.tableView reloadData];
    //在另一个线程更新主界面，因为在本函数里更新主界面是无效的
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
}

- (void)updateUI {
    
    //若self.HUD为真，则将self.HUD移除，设为nil
    if (self.HUD) {
        
        NSLog(@"123123123HUD");
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
}
#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    //self.tView = tableView;
    if ([self.listData count] == 0) {
        return 1;
    } else {
        return [self.listData count];
    }
}
 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {  
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
    if ([self.listData count] == 0) {
        return @"关注的企业";
    } else {
        NSString *count = [[NSString alloc] initWithString:[NSString stringWithFormat:@"关注的企业(%d)",[self.listData count]]];
        return count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:SimpleTableIdentifier];
    }

    if ([self.listData count] == 0) {
        cell.textLabel.text = @"没有可显示的结果";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        NSString *cName = [listData objectAtIndex:row];
        NSString *cServiceUrl = [companyAndUrl objectForKey:cName];
        NSString *result = [RequestData GetPushListCountWithUrl:cServiceUrl AndUserName:name];
        NSLog(@"result : %@",result);
        if ([result isEqualToString:@"0"] || result == NULL) {
            cell.textLabel.text = cName;
        } else {
            cell.textLabel.text = [cName stringByAppendingFormat:@"(%@条更新)",result];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return cell;
    }
}

//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView 
//                            accessoryType:(NSIndexPath *)indexPath
//{
//    return UITableViewCellAccessoryDetailDisclosureButton;
//}

- (void)tableView:(UITableView *)tableView 
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    if ([self.listData count] != 0) {
        self.selectedcServiceUrl = [companyAndUrl objectForKey:[self.listData objectAtIndex:row]];
        self.selectedcNumber = [companyAndNumber objectForKey:[self.listData objectAtIndex:row]];
        [self performSegueWithIdentifier:@"enterpriseinfo" sender:self]; 
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"enterpriseinfo"]) {
        EnterpriseViewController *enterpriseView = [segue destinationViewController];
        [enterpriseView setUserName:self.name];
        [enterpriseView setServiceUrl:self.selectedcServiceUrl];
        [enterpriseView setCompanyNumber:self.selectedcNumber];
    }
    if ([segue.identifier isEqualToString:@"authcode"]) {
        AuthCodeViewController *authcodeView = [segue destinationViewController];
        [authcodeView setName:self.name];
    }
}

#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:identifier];
    
    int row = indexPath.row;
    
    if (row == 0) {
        cell.textLabel.text = @"手动添加";
        cell.imageView.image = [UIImage imageNamed:@"handadd.png"];
    } else {
        cell.textLabel.text = @"二维码扫描";
        cell.imageView.image = [UIImage imageNamed:@"twocodeadd.png"];
    }
    
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s : %d", __func__, indexPath.row);
    NSInteger row = [indexPath row];
    if (row == 0) {
        [self performSegueWithIdentifier:@"authcode" sender:self];
    } else {
        /*扫描二维码部分：
         导入ZBarSDK文件并引入一下框架
         AVFoundation.framework
         CoreMedia.framework
         CoreVideo.framework
         QuartzCore.framework
         libiconv.dylib
         引入头文件#import “ZBarSDK.h” 即可使用
         当找到条形码时，会执行代理方法
         
         - (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
         
         最后读取并显示了条形码的图片和内容。*/
        
        ZBarReaderViewController *reader = [ZBarReaderViewController new];
        reader.readerDelegate = self;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        
        ZBarImageScanner *scanner = reader.scanner;
        
        [scanner setSymbology: ZBAR_I25
                       config: ZBAR_CFG_ENABLE
                           to: 0];
        
        [self presentViewController:reader animated:YES completion:nil];
    }
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    NSLog(@"symbol : %@",symbol.data);
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"symbol : %@",symbol.data);
    
    NSString *result = [RequestData EditTagWithUserName:self.name AndAuthCode:symbol.data];
    if ([result isEqualToString:@"success"]) {
        
        UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"添加成功！"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
        [uiAlert show];
    } else {
        
        UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"添加失败！"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
        [uiAlert show];
    }
    
    //新开一个线程刷新表格中关注企业的数据
    [NSThread detachNewThreadSelector:@selector(loadCompanyList) toTarget:self withObject:nil];
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

//- (void)dealloc {
//    [super dealloc];
//}

@end
