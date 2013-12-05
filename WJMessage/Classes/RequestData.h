//
//  RequestData.h
//  WJMessage
//
//  Created by Can Hang on 4/28/13.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface RequestData : NSObject<ASIHTTPRequestDelegate>

//登录
+ (NSString *)loginWithName:(NSString *)userName AndPassWord:(NSString *)passWord
             AndDeviceToken:(NSString *)deviceToken
              AndDeviceType:(NSString *)deviceType;

+ (NSString *)loginOutWithUserName:(NSString *)userName;

//列出关注的企业列表
+ (NSDictionary *)ListCompanyList:(NSString *)userName;

//获取更新的报价
+ (NSDictionary *)GetPushListWithUrl:(NSString *)serviceUrl AndUserName:(NSString *)userName
                             AndPage:(int)page;

//添加令牌
+ (NSString *)EditTagWithUserName:(NSString *)UserName AndAuthCode:(NSString *)authcodeValue;

//获取更新的报价的条数
+ (NSString *)GetPushListCountWithUrl:(NSString *)serviceUrl AndUserName:(NSString *)userName;

//查看历史报价，分页，每页5条
+ (NSDictionary *)MorePriceListWithUrl:(NSString *)serviceUrl AndUserName:(NSString *)userName
                               AndPage:(int)page
                             AndGoodId:(NSString *)goodId;

//获取用户所在企业的信息
+ (NSString *)UserInEnterpriseNumber:(NSString *)userName;

//编辑企业信息
+ (NSError *)EditEnterpriseInfoWithName:(NSString *)userName AndNumber:(NSString *)number;

//注册
+ (NSString *)RegisterWithName:(NSString *)userName AndPassWord:(NSString *)passWord
                       AndMail:(NSString *)mail;

//企业信息
+ (NSString *)EnterpriseInfo:(NSString *)companyNumber;

//报价汇总
+ (NSDictionary *)SingleGoodPriceListWithUrl:(NSString *)serviceUrl AndUserName:(NSString *)userName
                                 AndGoodName:(NSString *)goodName
                                     AndPage:(int)page;

//所有商品
+ (NSDictionary *)allGoodPriceListWithUrl:(NSString *)serviceUrl AndUserName:(NSString *)userName
                                 AndGoodName:(NSString *)goodName
                                     AndPage:(int)page;

//商品信息
+ (NSDictionary *)GoodInfo:(NSString *)GoodId WithServiceUrl:(NSString *)serviceUrl;

//修改密码
+ (NSString *)ChangePasswordWithUserName:(NSString *)userName AndOldPassword:(NSString *)oldPassword
                          AndNewPassword:(NSString *)newPassword;


//报价列表显示的时间处理
+ (NSString *)PriceListTimeDeal:(NSString *)time;




@end
