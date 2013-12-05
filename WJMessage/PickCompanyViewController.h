//
//  PickCompanyViewController.h
//  WJMessage
//
//  Created by Can Hang on 5/20/13.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface PickCompanyViewController : UIViewController<
  MBProgressHUDDelegate,
  UIPickerViewDataSource,
  UIPickerViewDelegate
>

@property (strong, nonatomic) IBOutlet UIPickerView *selectPicker;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;

@property (strong, nonatomic) MBProgressHUD *HUD;//等待加载框
@property (strong, nonatomic) NSString *userName;//用户名
@property (strong, nonatomic) NSArray *listData;//页面要显示的数据
@property (strong, nonatomic) NSMutableDictionary *companyAndUrl;//公司名称和该公司的服务地址
@property (strong, nonatomic) NSMutableDictionary *companyAndNumber;//公司名称和该公司的企业号
@property (strong, nonatomic) NSString *selectedcServiceUrl;//被选中的公司的服务地址
@property (strong, nonatomic) NSString *selectedcNumber;//被选中的公司的企业号
@property (strong, nonatomic) NSString *selectedCompanyName;//选择的公司的名称

- (IBAction)selectButton:(id)sender;

@end
