//
//  PersonInfoViewController.h
//  WJMessage
//
//  Created by Can Hang on 5/20/13.
//
//

#import <UIKit/UIKit.h>

@interface PersonInfoViewController : UIViewController<
  UIAlertViewDelegate
>

@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIButton *changePassWordButton;
@property (strong, nonatomic) IBOutlet UILabel *loginUserName;
@property (strong, nonatomic) UITextField *oldPasswordTextField;
@property (strong, nonatomic) UITextField *fnewPasswordTextField;
@property (strong, nonatomic) UITextField *snewPasswordTextField;

- (IBAction)alertAction:(id)sender;

@end
