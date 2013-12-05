//
//  HistoryViewController.m
//  WJMessage
//
//  Created by can 杭伟 on 3/27/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController.h"
#import "GoodPrice.h"
#import "RequestData.h"
#import "GoodViewController.h"

@implementation HistoryViewController

@synthesize userName;
@synthesize listData;
@synthesize serviceUrl;
@synthesize enterpriseName;
@synthesize HUD;
@synthesize goodId;
@synthesize selectedPrice;

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
    
    if (_refreshTableView == nil) {
        //初始化下拉刷新控件
        EGORefreshTableFooterView *refreshView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectZero];
        refreshView.delegate = self;
        //将下拉刷新控件作为子控件添加到UITableView中
        [self.tableView addSubview:refreshView];
        _refreshTableView = refreshView;
        _reloading = NO;
    }
    
    self.HUD = [[MBProgressHUD alloc]initWithView:self.view];//在totallistcontroller中当把hud添加到self.view的时候会被tableviewcell挡住一些部分(而且当tableview的数据加载完成后，想给后退按钮添加活动指示器的时候，会完全被挡住)。添加到self.view.window会报view为nil的错误，又没有self.window这个属性，所以这里添加到AppDelegate的window当中，就不会被挡住。该controller中的代码以及storyboard里面的设计都和totallistcontroller是一样的，但是在这里就不存在这个问题。把hud添加到self.view中就不会被挡住以及给后退按钮添加活动指示器也不会被挡住。
    [self.view addSubview:self.HUD];
    self.HUD.delegate = self;
    self.HUD.labelText = @"正在加载";
    
    //新开一个线程加载
    [self.HUD show:YES];
    [NSThread detachNewThreadSelector:@selector(loadHistoryList) toTarget:self withObject:nil];
}

- (void)loadHistoryList {
    
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
    }
    self.listData = goodPrices;
    [self.tableView reloadData];
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

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)backButtonPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    //frame应在表格加载完数据源之后再设置
    [self setRefreshViewFrame];
    NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"LoginStatus"];
    if (![loginStatus isEqualToString:@"YES"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    //设置返回按钮
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"视图"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(backButtonPressed)];
    barButton.tintColor = [UIColor colorWithRed:56/255.0 green:146/255.0 blue:227/255.0 alpha:1];
    self.navigationItem.leftBarButtonItem = barButton;
}

-(void)setRefreshViewFrame {
    //如果contentsize的高度比表的高度小，那么就需要把刷新视图放在表的bounds的下面
    int height = MAX(self.tableView.bounds.size.height, self.tableView.contentSize.height);
    _refreshTableView.frame =CGRectMake(0.0f, height, self.view.frame.size.width, self.tableView.bounds.size.height);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
}

//开始重新加载时调用的方法
- (void)reloadTableViewDataSource {
    _reloading = YES;
    //开始刷新后执行后台线程，在此之前可以开启HUD或其他对UI进行阻塞
    [NSThread detachNewThreadSelector:@selector(doInBackground) toTarget:self withObject:nil];
}

#pragma mark -
#pragma mark Background operation
//这个方法运行于子线程中，完成获取刷新数据的操作
-(void)doInBackground {
    //NSLog(@"loadData");
    
    //NSLog(@"pricelistview userName :%@",userName);
    //NSLog(@"pricelistview serviceUrl :%@",serviceUrl);
    //NSLog(@"listData:%@",listData);
    page = page + 1;
    //获取企业历史报价列表
    NSDictionary *result = [RequestData MorePriceListWithUrl:serviceUrl AndUserName:userName AndPage:page AndGoodId:self.goodId];
    NSLog(@"result :%@",result);
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
        [self.listData addObject:good];
    }
    
    //后台操作线程执行完后，到主线程更新UI
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:YES];
}

//完成加载时调用的方法
- (void)doneLoadingTableViewData {
    //NSLog(@"doneLoadingTableViewData");
    
    _reloading = NO;
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    //刷新表格内容
    [self.tableView reloadData];
    [self setRefreshViewFrame];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
//上拉被触发调用的委托方法
-(void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView *)view {
    [self reloadTableViewDataSource];
}

//返回当前是刷新还是无刷新状态
-(BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView *)view {
    return _reloading;
}

//返回刷新时间的回调方法
-(NSDate *)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView *)view {
    return [NSDate date];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
//滚动控件的委托方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_refreshTableView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate {
    [_refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *HistoryListTableIdentifier = @"HistoryListTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HistoryListTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:HistoryListTableIdentifier] ;
    } else {
        for(UIView *temp in cell.contentView.subviews) {
            [temp removeFromSuperview];
        }
    }//tablecell有重用机制，所以需要清除cell里面的数据。cell的子视图包含cell之间的分界线，所以把不能直接remove掉cell的子视图，而是removec掉cell的contentView的子试图。contentView是cell一个默认的view，contenView负责容纳其他的subView，所以自定义的label，image等都放到contentView里面。
    
    NSUInteger row = [indexPath row];
    GoodPrice *good = [listData objectAtIndex:row];
    NSLog(@"goodId : %@",good.goodId);
    NSLog(@"row : %d",row);
    
    UIImageView *priceImage = [[UIImageView alloc] initWithFrame: CGRectMake(10.0, 52.0, 35.0, 21.0)];
    
    UILabel *labelNameValue = [[UILabel alloc] initWithFrame: CGRectMake(10.0, 10.0, 300.0, 21.0)];
    UILabel *labelPriceValue = [[UILabel alloc] initWithFrame: CGRectMake(47.0, 53.0, 100.0, 17.0)];
    UILabel *labelTimeValue = [[UILabel alloc] initWithFrame: CGRectMake(self.view.frame.size.width / 2, 56.0, 150.0, 14.0)];
    
    priceImage.image = [UIImage imageNamed:@"p.png"];
    
    NSString *name = good.goodName;
    //换行需要的高度size.height
    CGSize size = [name sizeWithFont:[ UIFont fontWithName: @"Arial-BoldMT" size: 14.0 ]
                   constrainedToSize:CGSizeMake(300, 5000)
                       lineBreakMode:labelNameValue.lineBreakMode];
    
    labelNameValue.text = name;
    labelNameValue.font = [ UIFont fontWithName: @"Arial-BoldMT" size: 14.0 ];
    labelNameValue.lineBreakMode = NSLineBreakByWordWrapping;
    labelNameValue.numberOfLines = 0;
    labelNameValue.frame = CGRectMake(10, 10, 300, size.height);
    
    //去掉价格的小数点
    NSString *price= good.goodPrice;
    if ([price rangeOfString:@"."].length == 1) {
        price = [price substringToIndex:[price rangeOfString:@"."].location + 3];
    } else {
        price = [price stringByAppendingFormat:@".00"];
    }
    labelPriceValue.text = [[NSString alloc] initWithString:[NSString stringWithFormat:@"¥ %@",price]];
    labelPriceValue.textAlignment = NSTextAlignmentLeft;
    labelPriceValue.textColor = [UIColor colorWithRed:56/255.0 green:146/255.0 blue:227/255.0 alpha:1.0];
    labelPriceValue.font = [ UIFont fontWithName: @"ArialRoundedMTBold" size: 15.0 ];
    
    if (self.enterpriseName.length > 6) {
        labelTimeValue.text = [[NSString stringWithFormat:@"%@ - ",[self.enterpriseName substringToIndex:6]] stringByAppendingString:[RequestData PriceListTimeDeal:[good.updateTime substringToIndex:[good.updateTime rangeOfString:@"."].location]]];
    } else {
        labelTimeValue.text = [[NSString stringWithFormat:@"%@ - ",self.enterpriseName] stringByAppendingString:[RequestData PriceListTimeDeal:[good.updateTime substringToIndex:[good.updateTime rangeOfString:@"."].location]]];
    }
    labelTimeValue.textAlignment = NSTextAlignmentRight;
    labelTimeValue.textColor = [UIColor grayColor];
    labelTimeValue.font = [ UIFont fontWithName: @"Arial-ItalicMT" size: 12.0 ];
    
    
    //contentView是cell一个默认的view，contenView负责容纳其他的subView，所以自定义的label，image等都放到contentView里面。
    [cell.contentView addSubview:priceImage];
    
    [cell.contentView addSubview:labelNameValue];
    [cell.contentView addSubview:labelPriceValue];
    [cell.contentView addSubview:labelTimeValue];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

//- (void)tableView:(UITableView *)tableView
//didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger row = [indexPath row];
//    NSLog(@"didSelectRowAtIndexPath : %d",row);
//    GoodPrice *good = [self.listData objectAtIndex:row];
//    self.goodId = good.goodId;
//    self.selectedPrice = good.goodPrice;
//    [self performSegueWithIdentifier:@"hgood" sender:self]; 
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"hgood"]) {
        GoodViewController *goodView = [segue destinationViewController];
        [goodView setGoodId:self.goodId];
        [goodView setPrice:self.selectedPrice];
        [goodView setServiceUrl:self.serviceUrl];
    }
}

- (void)dealloc {
    //[super dealloc];
}

@end
