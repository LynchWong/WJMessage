//
//  FirstViewController.h
//  WJMessage
//
//  Created by Can Hang on 4/16/13.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface FirstViewController : UIViewController<
  MBProgressHUDDelegate
> {
    
    UIAlertView *weijiaAlert;
    UIAlertView *enterpriseCenterAlert;
}

@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UILabel *weijiaLabel;
@property (strong, nonatomic) IBOutlet UILabel *enterpriseCenterLabel;
//@property (strong, nonatomic) IBOutlet UILabel *mallLabel;
//@property (strong, nonatomic) IBOutlet UILabel *serviceLabel;
@property (strong, nonatomic) IBOutlet UIButton *weijiaButton;
@property (strong, nonatomic) IBOutlet UIButton *enterpriseCenterButton;
//@property (strong, nonatomic) IBOutlet UIButton *mallButton;
//@property (strong, nonatomic) IBOutlet UIButton *serviceButton;

@property (strong, nonatomic) NSString *cName;
@property (strong, nonatomic) NSString *cServiceUrl;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) MBProgressHUD *HUD;

-(IBAction)weijiaButtonPressed:(id)sender;
//-(IBAction)mallButtonPressed:(id)sender;
//-(IBAction)serviceButtonPressed:(id)sender;
-(IBAction)enterpriseCenterButtonPressed:(id)sender;

@end
