//
//  AppDelegate.m
//  WJMessage
//
//  Created by can 杭伟 on 3/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "GoodPrice.h"
#import "ViewController.h"
#import "Enterprise.h"
#import "GuideViewController.h"
#import "SWRevealViewController.h"

@implementation AppDelegate

//@synthesize enterprise;
@synthesize userName;
@synthesize listData;
@synthesize serviceUrlForGood;
@synthesize whereComeFrom;
@synthesize fromWhere;
@synthesize companyAndUrl;
@synthesize enterpriseName;
@synthesize backgroundIdentifier;
@synthesize myTimer;
@synthesize window = _window;
@synthesize revealViewController;

- (BOOL)isMultitaskingSupported{
    
    BOOL result = NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
        result = [[UIDevice currentDevice] isMultitaskingSupported];
    }
    return result;
}

- (void)timerMethod:(NSTimer *)paramSender{
    
    NSLog(@"array:%@",companyAndUrl);
    NSLog(@"userName:%@",userName);
    NSArray *allKeys = [companyAndUrl allKeys];
    if(allKeys != nil){
        for(id key in allKeys){
            //获取企业报价列表
            NSString *value = [companyAndUrl objectForKey:key];
            NSString *url = [value stringByAppendingString:@"/GetPushList/"];
            NSString *priceListUrlString =[[NSString alloc] initWithString:[[url stringByAppendingString:userName] stringByAppendingFormat:@"/%d",1]];
            NSURL *priceListUrl = [NSURL URLWithString:priceListUrlString];
            NSLog(@"priceListUrl:%@",priceListUrl);
            ASIHTTPRequest *priceListUrlRequest = [ASIHTTPRequest requestWithURL:priceListUrl];
            [priceListUrlRequest startSynchronous];
            //返回的结果
            NSString *priceListString = [priceListUrlRequest responseString];
            NSDictionary *priceListDictionary = [priceListString objectFromJSONString];
            NSString *priceLisr = [priceListDictionary objectForKey:@"GetPushListResult"];
            NSDictionary *result = [priceLisr objectFromJSONString];
            NSLog(@"result :%@",result);
            NSMutableArray *goodPrices = [[NSMutableArray alloc] init];
            for (id dt in result) {
                
                GoodPrice *good = [[GoodPrice alloc] init];
                NSString *goodName = [dt objectForKey:@"GoodName"];
                NSString *goodPrice = [dt objectForKey:@"CuPrice"];
                NSString *updateTime = [dt objectForKey:@"BillDateTime"];
                NSString *goodId = [dt objectForKey:@"GoodId"];
                good.goodName = goodName;
                good.goodPrice = goodPrice;
                good.updateTime = updateTime;
                good.goodId = goodId;
                [goodPrices addObject:good];
            }
            //NSArray *resultArray = goodPrices;
            
            //获取企业更新的条数
            NSString *countUrl = [value stringByAppendingString:@"/GetPushListCount/"];
            NSString *priceListNumberUrlString =[[NSString alloc] initWithString:[countUrl stringByAppendingString:userName]];
            NSURL *priceListNumberUrl = [NSURL URLWithString:priceListNumberUrlString];
            NSLog(@"pricelisturl :%@",priceListNumberUrl);
            ASIHTTPRequest *priceListNumberUrlRequest = [ASIHTTPRequest requestWithURL:priceListNumberUrl];
            [priceListNumberUrlRequest addRequestHeader:@"Authorization" value:@"57100001/1234567890"];
            [priceListNumberUrlRequest startSynchronous];
            NSString *priceListNumberString = [priceListNumberUrlRequest responseString];
            NSDictionary *priceListNumberDictionary = [priceListNumberString objectFromJSONString];
            NSLog(@"priceListDictionary :%@",priceListNumberDictionary);
            NSLog(@"条数 : %@",[priceListNumberDictionary objectForKey:@"GetPushListCountResult"]);
            if([[priceListNumberDictionary objectForKey:@"GetPushListCountResult"] intValue] != 0){
                
                NSDictionary *results = [NSDictionary dictionaryWithObjectsAndKeys:result,@"PriceList",value,@"ServiceUrl",key,@"EnterpriseName", nil];
                NSLog(@"localNotificationTest");
                NSLog(@"key:%@",key);
                UILocalNotification *notif = [[UILocalNotification alloc] init];
                //设置应用程序通知数量，直接设置uiapplication的applicationIconBadgeNumber，不是设置UILocalNotification的applicationIconBadgeNumber，这里的通知是统一到didReceiveLocalNotification里处理，然后在里面直接减一就好了。
                [UIApplication sharedApplication].applicationIconBadgeNumber = ([UIApplication sharedApplication].applicationIconBadgeNumber + 1);
                notif.fireDate = [NSDate date];
                notif.timeZone = [NSTimeZone localTimeZone];
                notif.alertBody= [NSString stringWithFormat:@"%@有%@条报价更新。", key,[priceListNumberDictionary objectForKey:@"GetPushListCountResult"]];
                notif.alertAction = @"显示";
                notif.soundName= UILocalNotificationDefaultSoundName;
                notif.userInfo = results;
                [[UIApplication sharedApplication] scheduleLocalNotification:notif];
            }
        }
    }
    //获取后台任务可执行时间，单位秒，若应用未能在此时间内完成任务，则应用将被终止
    NSTimeInterval backgroundTimeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
    //应用处于前台时，backgroundTimeRemaining值weiDBL_MAX
    if (backgroundTimeRemaining == DBL_MAX) {
        NSLog(@"Background time remaining = Undetermined");
    } else {
        NSLog(@"Background time remaining = %.02f seconds", backgroundTimeRemaining);
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    application.applicationIconBadgeNumber = 0;
    
    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    self.userName = name;
    NSString *passWord = [[NSUserDefaults standardUserDefaults] stringForKey:@"PassWord"];
    NSString *autoLogin = [[NSUserDefaults standardUserDefaults] stringForKey:@"AutoLogin"];
    NSLog(@"userName : %@",name);
    NSLog(@"passWord : %@",passWord);
    NSLog(@"autoLogin : %@",autoLogin);
//    if ([autoLogin isEqualToString:@"YES"]) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"LoginStatus"];
//    }
//    if ([self isMultitaskingSupported]) {
//        NSLog(@"Multitasking is supported.");
//    } else {
//        NSLog(@"Multitasking is not supported.");
//    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //菜单栏
    UINavigationController *menuView = [storyBoard instantiateViewControllerWithIdentifier:@"SecondNavigation"];
    
    //首页
    UINavigationController *firstView = [storyBoard instantiateViewControllerWithIdentifier:@"FirstNavigation"];
    
    revealViewController = [[SWRevealViewController alloc] initWithRearViewController:menuView frontViewController:firstView];
    
    //右侧隐藏视图
    //RightViewController *rightViewController = [[RightViewController alloc] init];
    //revealViewController.rightViewController = rightViewController;
    
    //浮动层离左边距的宽度
    revealViewController.rearViewRevealWidth = 290;
    //    revealViewController.rightViewRevealWidth = 230;
    
    //是否让浮动层弹回原位
    //mainRevealController.bounceBackOnOverdraw = NO;
    [revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    
    self.window.rootViewController = revealViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //增加标识，用于判断是否是第一次启动应用...如果是就显示引导界面   
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
//        NSLog(@"everLaunched");
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//    }
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
//    {
//        [GuideViewController show];
//    }  由于图片难看，暂时先取消，功能保留，图片重新设计后再开放
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    return YES;
}

- (void)application:(UIApplication*)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    NSLog(@"My token is: %@", deviceToken);
    NSString *userDeviceToken = [[[[deviceToken description]
                                   stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                   stringByReplacingOccurrencesOfString:@">" withString:@""]
                                   stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:userDeviceToken
                                              forKey:@"DeviceToken"];
    NSLog(@"userDeviceToken is: %@", userDeviceToken);
    
    NSString* aStr;
    aStr = [[NSString alloc] initWithData:deviceToken encoding:NSASCIIStringEncoding];
    
    NSData* aData;
    aData = [aStr dataUsingEncoding: NSASCIIStringEncoding];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//    if ([self isMultitaskingSupported] == NO){
//        return; }
//    self.myTimer =
//    [NSTimer scheduledTimerWithTimeInterval:30.0f
//                                     target:self
//                                   selector:@selector(timerMethod:) userInfo:nil
//                                    repeats:YES];
//    self.backgroundIdentifier = [application beginBackgroundTaskWithExpirationHandler:^(void) {
//        [self endBackgroundTask];
//    }];
}

- (void) endBackgroundTask {
    
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    AppDelegate *weakSelf = self;
//    dispatch_async(mainQueue, ^(void) {
//        AppDelegate *strongSelf = weakSelf;
//        if (strongSelf != nil) {
//            [strongSelf.myTimer invalidate];
//            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundIdentifier];
//            strongSelf.backgroundIdentifier = UIBackgroundTaskInvalid;
//        }
//    });
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    application.applicationIconBadgeNumber = application.applicationIconBadgeNumber - 1;
    
    NSLog(@"ReceiveRemoteNotification");
    //获取企业报价列表
    NSString *eName = [userInfo objectForKey:@"EnterpriseName"];
    NSLog(@"eName : %@",eName);
    NSString *serviceUrlGood = [userInfo objectForKey:@"IphoneServiceUrl"];
    NSLog(@"serviceUrlGood : %@",serviceUrlGood);
    NSString *url = [serviceUrlGood stringByAppendingString:@"/GetPushList/"];
    NSString *priceListUrlString =[[NSString alloc] initWithString:[[url stringByAppendingString:self.userName] stringByAppendingFormat:@"/%d",1]];
    NSURL *priceListUrl = [NSURL URLWithString:priceListUrlString];
    NSLog(@"priceListUrl:%@",priceListUrl);
    ASIHTTPRequest *priceListUrlRequest = [ASIHTTPRequest requestWithURL:priceListUrl];
    [priceListUrlRequest startSynchronous];
    //返回的结果
    NSString *priceListString = [priceListUrlRequest responseString];
    NSDictionary *priceListDictionary = [priceListString objectFromJSONString];
    NSString *priceLisr = [priceListDictionary objectForKey:@"GetPushListResult"];
    NSDictionary *result = [priceLisr objectFromJSONString];
    NSLog(@"result :%@",result);
    NSMutableArray *goodPrices = [[NSMutableArray alloc] init];
    for (id dt in result) {
        
        GoodPrice *good = [[GoodPrice alloc] init];
        NSString *goodName = [dt objectForKey:@"GoodName"];
        NSString *goodPrice = [dt objectForKey:@"CuPrice"];
        NSString *updateTime = [dt objectForKey:@"BillDateTime"];
        NSString *goodId = [dt objectForKey:@"GoodId"];
        good.goodName = goodName;
        good.goodPrice = goodPrice;
        good.updateTime = updateTime;
        good.goodId = goodId;
        [goodPrices addObject:good];
    }
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.listData = goodPrices;
    self.serviceUrlForGood = serviceUrlGood;
    self.whereComeFrom = @"LocalNotification";
    self.enterpriseName = eName;
    UINavigationController *firstView = [storyBoard instantiateViewControllerWithIdentifier:@"FirstNavigation"];
    [self.revealViewController setFrontViewController:firstView animated:YES];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    application.applicationIconBadgeNumber = application.applicationIconBadgeNumber - 1;
    NSDictionary *result = [notification.userInfo objectForKey:@"PriceList"];
    NSString *serviceUrlGood = [notification.userInfo objectForKey:@"ServiceUrl"];
    NSString *eName = [notification.userInfo objectForKey:@"EnterpriseName"];
    NSMutableArray *goodPrices = [[NSMutableArray alloc] init];
    
    for (id dt in result) {
        
        GoodPrice *good = [[GoodPrice alloc] init];
        NSString *goodName = [dt objectForKey:@"GoodName"];
        NSString *goodPrice = [dt objectForKey:@"CuPrice"];
        NSString *updateTime = [dt objectForKey:@"BillDateTime"];
        NSString *goodId = [dt objectForKey:@"GoodId"];
        good.goodName = goodName;
        good.goodPrice = goodPrice;
        good.updateTime = updateTime;
        good.goodId = goodId;
        [goodPrices addObject:good];
        //[good release];
    }
    
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.listData = goodPrices;
    self.serviceUrlForGood = serviceUrlGood;
    self.whereComeFrom = @"LocalNotification";
    self.enterpriseName = eName;
    UINavigationController *firstView = [storyBoard instantiateViewControllerWithIdentifier:@"FirstNavigation"];
    [self.revealViewController setFrontViewController:firstView animated:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
//    if(myTimer) {
//        if([myTimer isValid]) {
//            [myTimer invalidate];
//        }
//    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
