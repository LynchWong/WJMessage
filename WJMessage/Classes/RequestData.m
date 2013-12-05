//
//  RequestData.m
//  WJMessage
//
//  Created by Can Hang on 4/28/13.
//
//

#import "RequestData.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "Enterprise.h"

@implementation RequestData

//登录
+ (NSString *)loginWithName:(NSString *)userName
                AndPassWord:(NSString *)passWord
             AndDeviceToken:(NSString *) deviceToken
              AndDeviceType:(NSString *) deviceType;
{
    NSString *urlString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"http://authcodewcf.iphone.c8yun.com/Implementation/CodeWcf.svc/Login/%@/%@/%@/%@",userName,
                                                            passWord,deviceToken,deviceType]];
    NSLog(@"urlString : %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"url : %@",url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Authorization" value:@"57100001/1234567890"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
    {
        NSData *response = [request responseData];
        NSDictionary *result = [response objectFromJSONData];
        NSString *loginResult = [result objectForKey:@"LoginResult"];
        return loginResult;
    }
    else
    {
        return @"error";
    }
}

+ (NSString *)loginOutWithUserName:(NSString *)userName
{
    NSString *urlString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"http://authcodewcf.iphone.c8yun.com/Implementation/CodeWcf.svc/LogOut/%@",userName]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"url : %@",url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request addRequestHeader:@"Authorization" value:@"57100001/1234567890"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
    {
        NSData *response = [request responseData];
        NSDictionary *result = [response objectFromJSONData];
        NSString *loginResult = [result objectForKey:@"LogOutResult"];
        return loginResult;
    }
    else
    {
        return @"error";
    }
}

//列出关注的企业列表
+ (NSDictionary *)ListCompanyList:(NSString *)userName
{
    //获取用户的企业号
    NSString *companynumberUrlString =[[NSString alloc] initWithString:[NSString stringWithFormat:@"http://authcodewcf.iphone.c8yun.com/Implementation/CodeWcf.svc/UserInEnterpriseNumber/%@",userName]];
    NSURL *companynumberUrl = [NSURL URLWithString:companynumberUrlString];
    ASIHTTPRequest *companynumberRequest = [ASIHTTPRequest requestWithURL:companynumberUrl];
    [companynumberRequest addRequestHeader:@"Authorization" value:@"57100001/1234567890"];
    [companynumberRequest startSynchronous];
    //返回的结果
    NSString *companyNumberString = [companynumberRequest responseString];
    NSDictionary *companyNumberDictionary = [companyNumberString objectFromJSONString];
    NSLog(@"companyNumberDictionary :%@",companyNumberDictionary);
    NSString *companyNumber = [companyNumberDictionary objectForKey:@"UserInEnterpriseNumberResult"];
    NSLog(@"companyNumber :%@",companyNumber);
    NSArray *company =[companyNumber componentsSeparatedByString:@","];
    Enterprise *enterpriseInfo = [[Enterprise alloc] init];
    if([company count] >= 2)
    {
        enterpriseInfo.enterpriseNumber = [company objectAtIndex:0];
        enterpriseInfo.enterpriseName = [company objectAtIndex:1];
    }
    //App.enterprise = enterpriseInfo;
    
    //获取企业关注列表
//    NSString *companyListUrlString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"http://authcodewcf.iphone.c8yun.com/Implementation/CodeWcf.svc/ListCompanyList/%@",enterpriseInfo.enterpriseNumber]];
    NSString *companyListUrlString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"http://authcodewcf.iphone.c8yun.com/Implementation/CodeWcf.svc/ListCompanyList/%@",userName]];
    NSURL *companyListUrl = [NSURL URLWithString:companyListUrlString];
    ASIHTTPRequest *companyListRequest = [ASIHTTPRequest requestWithURL:companyListUrl];
    NSLog(@"companyListUrl : %@",companyListUrl);
    [companyListRequest addRequestHeader:@"Authorization" value:@"57100001/1234567890"];//添加头信息来通过服务验证
    [companyListRequest startSynchronous];
    //返回的结果
    NSString *companyListString = [companyListRequest responseString];
    NSDictionary *companyListDictionary = [companyListString objectFromJSONString];
    NSLog(@"companyListDictionary :%@",companyListDictionary);
    NSString *companyList = [companyListDictionary objectForKey:@"ListCompanyListResult"];
    NSLog(@"companyList :%@",companyList);
    NSDictionary *result = [companyList objectFromJSONString];
    NSLog(@"result :%@",result);
    return result;
}

//获取更新的报价
+ (NSDictionary *)GetPushListWithUrl:(NSString *)serviceUrl AndUserName:(NSString *)userName AndPage:(int)page
{
    //获取企业报价列表
    NSString *url = [serviceUrl stringByAppendingString:@"/GetPushList/"];
    NSString *priceListUrlString =[[NSString alloc] initWithString:[[url stringByAppendingString:userName] stringByAppendingFormat:@"/%d",page]];
    NSURL *priceListUrl = [NSURL URLWithString:priceListUrlString];
    NSLog(@"pricelisturl :%@",priceListUrl);
    ASIHTTPRequest *priceListUrlRequest = [ASIHTTPRequest requestWithURL:priceListUrl];
    [priceListUrlRequest addRequestHeader:@"Authorization" value:@"57100001/1234567890"];
    [priceListUrlRequest startSynchronous];
    //返回的结果
    NSString *priceListString = [priceListUrlRequest responseString];
    NSDictionary *priceListDictionary = [priceListString objectFromJSONString];
    NSLog(@"priceListDictionary :%@",priceListDictionary);
    NSString *priceLisr = [priceListDictionary objectForKey:@"GetPushListResult"];
    NSDictionary *result = [priceLisr objectFromJSONString];
    return result;
}

//添加令牌
+ (NSString *)EditTagWithUserName:(NSString *)UserName AndAuthCode:(NSString *)authcodeValue
{
    NSString *urlString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"http://authcodewcf.iphone.c8yun.com/Implementation/CodeWcf.svc/EditTag/%@/%@",UserName,authcodeValue]];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Authorization" value:@"57100001/1234567890"];
    [request startSynchronous];
    NSError *error = [request error];
    if(!error) {
        NSString *resultString = [request responseString];
        NSDictionary *resultDictionary = [resultString objectFromJSONString];
        NSString *result = [resultDictionary objectForKey:@"EditTagResult"];
        return result;
    } else {
        return @"error";
    }
}

//获取更新的报价的条数
+ (NSString *)GetPushListCountWithUrl:(NSString *)serviceUrl AndUserName:(NSString *)userName;
{
    NSLog(@"serviceUrl : %@",serviceUrl);
     NSLog(@"userName : %@",userName);
    NSString *url = [serviceUrl stringByAppendingString:@"/GetPushListCount/"];
    NSString *priceListNumberUrlString =[[NSString alloc] initWithString:[url stringByAppendingString:userName]];
    NSURL *priceListNumberUrl = [NSURL URLWithString:priceListNumberUrlString];
    NSLog(@"pricelisturl :%@",priceListNumberUrl);
    ASIHTTPRequest *priceListNumberUrlRequest = [ASIHTTPRequest requestWithURL:priceListNumberUrl];
    [priceListNumberUrlRequest addRequestHeader:@"Authorization" value:@"57100001/1234567890"];
    [priceListNumberUrlRequest startSynchronous];
    NSString *priceListNumberString = [priceListNumberUrlRequest responseString];
    NSDictionary *priceListNumberDictionary = [priceListNumberString objectFromJSONString];
    NSLog(@"priceListDictionary :%@",priceListNumberDictionary);
    return [priceListNumberDictionary objectForKey:@"GetPushListCountResult"];
}

//查看历史报价，分页，每页5条
+ (NSDictionary *)MorePriceListWithUrl:(NSString *)serviceUrl AndUserName:(NSString *)userName AndPage:(int)page AndGoodId:(NSString *)goodId
{
    NSNumber *numberGoodId = [NSNumber numberWithInt:[goodId intValue]];
    //获取企业历史报价列表
    NSString *url = [serviceUrl stringByAppendingString:@"/MorePriceList/"];
    NSString *priceListUrlString =[[NSString alloc] initWithString:[[[url stringByAppendingString:userName] stringByAppendingString:[NSString stringWithFormat:@"/%d",page]] stringByAppendingString:[NSString stringWithFormat:@"/%@",[numberGoodId stringValue]]]];
    NSURL *priceListUrl = [NSURL URLWithString:priceListUrlString];
    NSLog(@"pricelisturl :%@",priceListUrl);
    ASIHTTPRequest *priceListUrlRequest = [ASIHTTPRequest requestWithURL:priceListUrl];
    [priceListUrlRequest addRequestHeader:@"Authorization" value:@"57100001/1234567890"];
    [priceListUrlRequest startSynchronous];
    //返回的结果
    NSString *priceListString = [priceListUrlRequest responseString];
    NSDictionary *priceListDictionary = [priceListString objectFromJSONString];
    NSLog(@"priceListDictionary :%@",priceListDictionary);
    NSString *priceLisr = [priceListDictionary objectForKey:@"MorePriceListResult"];
    return [priceLisr objectFromJSONString];
}

//获取用户所在企业的信息
+ (NSString *)UserInEnterpriseNumber:(NSString *)userName
{
    NSString *companynumberUrlString =[[NSString alloc] initWithString:[NSString stringWithFormat:@"http://authcodewcf.iphone.c8yun.com/Implementation/CodeWcf.svc/UserInEnterpriseNumber/%@",userName]];
    NSURL *companynumberUrl = [NSURL URLWithString:companynumberUrlString];
    ASIHTTPRequest *companynumberRequest = [ASIHTTPRequest requestWithURL:companynumberUrl];
    [companynumberRequest addRequestHeader:@"Authorization" value:@"57100001/1234567890"];
    [companynumberRequest startSynchronous];
    //返回的结果
    NSString *companyNumberString = [companynumberRequest responseString];
    NSDictionary *companyNumberDictionary = [companyNumberString objectFromJSONString];
    NSLog(@"companyNumberDictionary :%@",companyNumberDictionary);
    return [companyNumberDictionary objectForKey:@"UserInEnterpriseNumberResult"];
}

//编辑企业信息
+ (NSError *)EditEnterpriseInfoWithName:(NSString *)userName AndNumber:(NSString *)number
{
    NSString *urlString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"http://authcodewcf.iphone.c8yun.com/Implementation/CodeWcf.svc/EditEnterpriseInfo/%@/%@",number,userName]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString:%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"url:%@",url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Authorization" value:@"57100001/1234567890"];
    [request startSynchronous];
    return [request error];
}

//注册
+ (NSString *)RegisterWithName:(NSString *)userName AndPassWord:(NSString *)passWord AndMail:(NSString *)mail
{
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers setValue:@"57100001/1234567890" forKey:@"Authorization"];
    NSString *urlString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"http://authcodewcf.iphone.c8yun.com/Implementation/CodeWcf.svc/Register/%@/%@/%@",userName,passWord,mail]];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestHeaders:headers];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
    {
        NSData *response = [request responseData];
        NSDictionary *result = [response objectFromJSONData];
        return [result objectForKey:@"RegisterResult"];
    }
    else
    {
        return @"error";
    }
}

//企业信息
+ (NSString *)EnterpriseInfo:(NSString *)companyNumber
{
    NSString *companynumberUrlString =[[NSString alloc] initWithString:[NSString stringWithFormat:@"http://authcodewcf.iphone.c8yun.com/Implementation/CodeWcf.svc/EnterpriseInfo/%@",companyNumber]];
    NSURL *companynumberUrl = [NSURL URLWithString:companynumberUrlString];
    NSLog(@"companynumberUrl : %@",companynumberUrl);
    ASIHTTPRequest *companynumberRequest = [ASIHTTPRequest requestWithURL:companynumberUrl];
    [companynumberRequest addRequestHeader:@"Authorization" value:@"57100001/1234567890"];
    [companynumberRequest startSynchronous];
    //返回的结果
    NSString *companyNumberString = [companynumberRequest responseString];
    NSDictionary *companyNumberDictionary = [companyNumberString objectFromJSONString];
    NSLog(@"companyNumberDictionary :%@",companyNumberDictionary);
    return [companyNumberDictionary objectForKey:@"EnterpriseInfoResult"];
}

//报价汇总
+ (NSDictionary *)SingleGoodPriceListWithUrl:(NSString *)serviceUrl AndUserName:(NSString *)userName AndGoodName:(NSString *)goodName AndPage:(int)page
{
    //获取企业报价列表
    NSString *url = [serviceUrl stringByAppendingString:@"/SingleGoodPriceList/"];
    NSString *priceListUrlString =[[NSString alloc] initWithString:[[[url stringByAppendingString:userName] stringByAppendingString:[NSString stringWithFormat:@"/%@",goodName]] stringByAppendingFormat:@"/%d",page]];
    NSURL *priceListUrl = [NSURL URLWithString:priceListUrlString];
    NSLog(@"pricelisturl :%@",priceListUrl);
    ASIHTTPRequest *priceListUrlRequest = [ASIHTTPRequest requestWithURL:priceListUrl];
    [priceListUrlRequest addRequestHeader:@"Authorization" value:@"57100001/1234567890"];
    [priceListUrlRequest startSynchronous];
    //返回的结果
    NSString *priceListString = [priceListUrlRequest responseString];
    NSDictionary *priceListDictionary = [priceListString objectFromJSONString];
    NSLog(@"priceListDictionary :%@",priceListDictionary);
    NSString *priceLisr = [priceListDictionary objectForKey:@"SingleGoodPriceListResult"];
    return [priceLisr objectFromJSONString];
}

//所有商品
+ (NSDictionary *)allGoodPriceListWithUrl:(NSString *)serviceUrl AndUserName:(NSString *)userName
                              AndGoodName:(NSString *)goodName
                                  AndPage:(int)page
{
    //获取企业报价列表
    NSString *allGoodUrl = [serviceUrl stringByAppendingString:@"/GoodInfoList/"];
    NSString *allGoodListUrlString = [[NSString alloc] initWithString:[[[allGoodUrl stringByAppendingString:userName] stringByAppendingFormat:@"/%@",goodName] stringByAppendingFormat:@"/%d",page]];
    NSLog(@"priceListUrlString : %@",allGoodListUrlString);
    NSURL *allGoodListUrl = [NSURL URLWithString:allGoodListUrlString];
    NSLog(@"allpricelisturl : %@",allGoodListUrl);
    ASIHTTPRequest *allGoodListUrlRequest = [ASIHTTPRequest requestWithURL:allGoodListUrl];
    //[allGoodListUrlRequest addRequestHeader:@"Authorization" value:@"57100001/1234567890"];
    [allGoodListUrlRequest startSynchronous];
    //返回的结果
    NSString *response = [allGoodListUrlRequest responseStatusMessage];
    NSLog(@"response post==%@",response);
    NSString *allGoodListString = [allGoodListUrlRequest responseString];
    NSLog(@"allGoodListString : %@",allGoodListString);
    NSDictionary *allGoodListDictionary = [allGoodListString objectFromJSONString];
    NSLog(@"allpriceListDictionary : %@",allGoodListDictionary);
    NSString *allGoodList = [allGoodListDictionary objectForKey:@"GoodInfoListResult"];
    return [allGoodList objectFromJSONString];
}


//商品信息
+ (NSDictionary *)GoodInfo:(NSString *)GoodId WithServiceUrl:(NSString *)serviceUrl
{
    //GoodId是string类型的，但是调式的时候发现变为了NSCFNumber类型，导致[url stringByAppendingString:GoodId]报错，因为该方法调用了legth方法，而Number类型没有legth导致错误，所以先转换成int和number，再转换成string类型。
    NSNumber *numberGoodId = [NSNumber numberWithInt:[GoodId intValue]];
    //获取企业报价列表
    NSString *url = [serviceUrl stringByAppendingString:@"/GoodInfo/"];
    NSString *priceListUrlString =[[NSString alloc] initWithString:[url stringByAppendingString:[numberGoodId stringValue]]];
    NSURL *priceListUrl = [NSURL URLWithString:priceListUrlString];
    NSLog(@"pricelisturl :%@",priceListUrl);
    ASIHTTPRequest *priceListUrlRequest = [ASIHTTPRequest requestWithURL:priceListUrl];
    [priceListUrlRequest addRequestHeader:@"Authorization" value:@"57100001/1234567890"];
    [priceListUrlRequest startSynchronous];
    //返回的结果
    NSString *priceListString = [priceListUrlRequest responseString];
    NSDictionary *priceListDictionary = [priceListString objectFromJSONString];
    NSLog(@"priceListDictionary :%@",priceListDictionary);
    NSString *priceLisr = [priceListDictionary objectForKey:@"GoodInfoResult"];
    return [priceLisr objectFromJSONString];
}

//修改密码
+ (NSString *)ChangePasswordWithUserName:(NSString *)userName AndOldPassword:(NSString *)oldPassword AndNewPassword:(NSString *)newPassword
{
    NSString *urlString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"http://authcodewcf.iphone.c8yun.com/Implementation/CodeWcf.svc/ChangePassword/%@/%@/%@",userName,oldPassword,newPassword]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"url : %@",url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Authorization" value:@"57100001/1234567890"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
    {
        NSData *response = [request responseData];
        NSDictionary *result = [response objectFromJSONData];
        NSString *loginResult = [result objectForKey:@"ChangePasswordResult"];
        return loginResult;
    }
    else
    {
        return @"error";
    }
}

//报价列表显示的时间处理
+ (NSString *)PriceListTimeDeal:(NSString *)time
{
    //从服务器获取的时间
    NSArray *displayTime = [time componentsSeparatedByString:@"T"];
    NSArray *ymd = [[displayTime objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *hms = [[displayTime objectAtIndex:1] componentsSeparatedByString:@":"];
    int year = [[ymd objectAtIndex:0] intValue];
    int month = [[ymd objectAtIndex:1] intValue];
    int day = [[ymd objectAtIndex:2] intValue];
    int hour = [[hms objectAtIndex:0] intValue];
    int minute = [[hms objectAtIndex:1] intValue];
    int seconds = [[hms objectAtIndex:2] intValue];
    
    //当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *cuTimeString = [dateFormatter stringFromDate:[NSDate date]];
    NSArray *cuTime = [cuTimeString componentsSeparatedByString:@" "];
    NSArray *cuymd = [[cuTime objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *cuhms = [[cuTime objectAtIndex:1] componentsSeparatedByString:@":"];
    int cuYear = [[cuymd objectAtIndex:0] intValue];
    int cuMonth = [[cuymd objectAtIndex:1] intValue];
    int cuDay = [[cuymd objectAtIndex:2] intValue];
    int cuHour = [[cuhms objectAtIndex:0] intValue];
    int cuMinute = [[cuhms objectAtIndex:1] intValue];
    int cuSeconds = [[cuhms objectAtIndex:2] intValue];
    
    if(cuYear - year > 0)
    {
        return [NSString stringWithFormat:@"%d年前",cuYear - year];
    }
    else if(cuMonth - month)
    {
        return [NSString stringWithFormat:@"%d月前",cuMonth - month];
    }
    else if(cuDay - day)
    {
        return [NSString stringWithFormat:@"%d天前",cuDay - day];
    }
    else if(cuHour - hour)
    {
        return [NSString stringWithFormat:@"%d小时前",cuHour - hour];
    }
    else if(cuMinute - minute)
    {
        return [NSString stringWithFormat:@"%d分钟前",cuMinute - minute];
    }
    else
    {
        return [NSString stringWithFormat:@"%d秒前",cuSeconds - seconds];
    }
}

@end
