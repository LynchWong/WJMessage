//
//  WelcomeViewController.h
//  WJMessage
//
//  Created by can 杭伟 on 3/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enterprise.h"
#import "MBProgressHUD.h"
#import "UIPopoverListView.h"
#import "ZBarSDK.h"

@interface WelcomeViewController : UITableViewController<
  UITableViewDelegate,
  UITableViewDataSource,
  MBProgressHUDDelegate,
  UIPopoverListViewDataSource,
  UIPopoverListViewDelegate,
  ZBarReaderDelegate
>

//@property (nonatomic,retain) NSTimer *repeatingTimer;//定时器
@property (strong, nonatomic) NSString *name;//用户名
@property (strong, nonatomic) NSArray *listData;//页面要显示的数据
@property (strong, nonatomic) NSMutableDictionary *companyAndUrl;//公司名称和该公司的服务地址
@property (strong, nonatomic) NSMutableDictionary *companyAndNumber;//公司名称和该公司的企业号
@property (strong, nonatomic) NSString *selectedcServiceUrl;//被选中的公司的服务地址
@property (strong, nonatomic) NSString *selectedcNumber;//被选中的公司的企业号
@property (strong, nonatomic) MBProgressHUD *HUD;

- (IBAction)addAuthCodeButtonPressed:(id)sender;

@end
