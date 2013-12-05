//
//  GoodViewController.h
//  WJMessage
//
//  Created by Can Hang on 5/2/13.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EGOImageButton.h"

@interface GoodViewController : UIViewController<
  MBProgressHUDDelegate,
  UIGestureRecognizerDelegate
>

@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UILabel *labelGoodName;
@property (strong, nonatomic) IBOutlet UILabel *labelGoodPrice;
@property (strong, nonatomic) IBOutlet UIImageView *priceImage;

@property (nonatomic) CGSize nameSize;
@property (strong, nonatomic) EGOImageButton *imageButton;
@property (strong, nonatomic) NSMutableArray *goodImagesUrl;//商品图片的url
@property (nonatomic) NSInteger indexth;//点击的图片在goodImagesUrl中的位置
@property (strong, nonatomic) UIScrollView *pageScroll;//滚动图片
@property (strong, nonatomic) MBProgressHUD *HUD;//等待加载
@property (strong, nonatomic) NSString *goodId;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *serviceUrl;
@property (strong, nonatomic) NSString *enterpriseName;//企业名称

@end
