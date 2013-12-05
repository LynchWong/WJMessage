//
//  ViewController.h
//  WJMessage
//
//  Created by can 杭伟 on 3/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h" 
#import "WelcomeViewController.h"
#import "MBProgressHUD.h"

@interface ViewController : UIViewController <
  MBProgressHUDDelegate,
  UITextFieldDelegate
>

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *autoLogin;
@property (strong, nonatomic) IBOutlet UILabel *remberPassword;
@property (strong, nonatomic) IBOutlet UIImageView *loginImage;
@property (strong, nonatomic) IBOutlet UIButton *registButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) UIButton *checkBoxRemberPassWordButton;
@property (strong, nonatomic) UIButton *checkBoxAutoLoginButton;
@property (strong, nonatomic) NSString *alertStyle;
@property (strong, nonatomic) MBProgressHUD *HUD;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundClick:(id)sender;
- (IBAction)buttonPressed:(id)sender;
- (IBAction)registButtonPressed:(id)sender;

@end
