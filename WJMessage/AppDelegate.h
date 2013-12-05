//
//  AppDelegate.h
//  WJMessage
//
//  Created by can 杭伟 on 3/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceListViewController.h"
#import "Enterprise.h"
#import "SWRevealViewController.h"

@interface AppDelegate : UIResponder <
  UIApplicationDelegate
>

@property (strong, nonatomic) NSString *userName;//用户名
@property (strong, nonatomic) NSMutableArray *listData;//通知中的数据，pricelistviewcontroller用
@property (strong, nonatomic) NSString *serviceUrlForGood;//点击商品列表时要用的
@property (strong, nonatomic) NSString *whereComeFrom;//用户接受通知后跳转的判断字段，在firstviewcontroller中用
@property (strong, nonatomic) NSString *fromWhere;//是从哪个controller跳转过来，主要是用于添加令牌之后刷新页面用。
@property (strong, nonatomic) NSDictionary *companyAndUrl;//公司和公司的服务地址
@property (strong, nonatomic) NSString *enterpriseName;//产生通知的公司，在pricelist页面要显示公司的名称
@property (unsafe_unretained, nonatomic) UIBackgroundTaskIdentifier backgroundIdentifier;
@property (strong, nonatomic) NSTimer *myTimer;//定时器
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *revealViewController;

@end
