//
//  AllGoodViewController.h
//  WJMessage
//
//  Created by Can Hang on 6/9/13.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EGORefreshTableFooterView.h"

@interface AllGoodViewController : UITableViewController <
  UITableViewDataSource,
  UITableViewDelegate,
  MBProgressHUDDelegate,
  EGORefreshTableFooterDelegate,
  UISearchBarDelegate
> {
    EGORefreshTableFooterView *_refreshTableView;
    BOOL _reloading;
    int page;
    int searchPage;
}

@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *serviceUrl;
@property (strong, nonatomic) NSString *enterpriseName;
@property (strong, nonatomic) NSString *goodId;//选中商品的id
@property (strong, nonatomic) NSString *selectedPrice;//选中商品的价格
@property (strong, nonatomic) NSString *keyWord;//搜索的关键词
@property (strong, nonatomic) IBOutlet UISearchBar *search;

//开始重新加载时调用的方法
- (void)reloadTableViewDataSource;
//完成加载时调用的方法
- (void)doneLoadingTableViewData;

@end
