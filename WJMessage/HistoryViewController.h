//
//  HistoryViewController.h
//  WJMessage
//
//  Created by can 杭伟 on 3/27/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "MBProgressHUD.h"

@interface HistoryViewController : UITableViewController<
  UITableViewDelegate,
  UITableViewDataSource,
  EGORefreshTableFooterDelegate,
  MBProgressHUDDelegate
> {
    EGORefreshTableFooterView *_refreshTableView;
    BOOL _reloading;
    int page;
}

@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *serviceUrl;
@property (strong, nonatomic) NSString *enterpriseName;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSString *goodId;//传过来的商品的id
@property (strong, nonatomic) NSString *selectedPrice;//选中商品的价格

//开始重新加载时调用的方法
- (void)reloadTableViewDataSource;
//完成加载时调用的方法
- (void)doneLoadingTableViewData;

@end
