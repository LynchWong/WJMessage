//
//  HistoryGraphViewController.h
//  WJMessage
//
//  Created by Can Hang on 5/22/13.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface HistoryGraphViewController : UIViewController<
  UIWebViewDelegate,
  MBProgressHUDDelegate
> {
    int page;
}

@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *serviceUrl;
@property (strong, nonatomic) NSString *enterpriseName;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSString *goodId;//传过来的商品的id
@property (strong, nonatomic) NSString *selectedPrice;//选中商品的价格

@property (retain, nonatomic) UIButton* closeBtn;//返回按钮
@property (retain, nonatomic) UIButton* listBtn;//列表按钮
@property (retain, nonatomic) UIWebView* webViewForSelectDate;

@end
