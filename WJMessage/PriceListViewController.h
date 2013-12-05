//
//  PriceListViewController.h
//  WJMessage
//
//  Created by can 杭伟 on 3/26/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "MBProgressHUD.h"

@interface PriceListViewController : UITableViewController<
  UITableViewDelegate,
  UITableViewDataSource,
  //EGORefreshTableHeaderDelegate,
  EGORefreshTableFooterDelegate,
  MBProgressHUDDelegate
> {
//    //下拉刷新
//    EGORefreshTableHeaderView *_refreshTableView;
//    BOOL _reloading;
    
    //上拉加载
    EGORefreshTableFooterView *_refreshFooterTableView;
    BOOL _footerReloading;
}

@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *serviceUrl;
@property (strong, nonatomic) NSString *enterpriseName;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSString *goodId;//选中商品的id
@property (strong, nonatomic) NSString *selectedPrice;//选中商品的价格

////开始重新加载时调用的方法
//- (void)reloadTableViewDataSource;
////完成加载时调用的方法
//- (void)doneLoadingTableViewData;

//开始重新加载时调用的方法
- (void)reloadFooterTableViewDataSource;
//完成加载时调用的方法
- (void)doneLoadingFooterTableViewData;

@end
