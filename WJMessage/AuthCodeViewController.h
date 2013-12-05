//
//  AuthCodeViewController.h
//  WJMessage
//
//  Created by can 杭伟 on 3/27/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthCodeViewController : UIViewController<
  UITextFieldDelegate
>

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *sureButton;
@property (strong, nonatomic) IBOutlet UITextField *authcodeTextField;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIAlertView *uiAlertView;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundClick:(id)sender;
- (IBAction)buttonPressed:(id)sender;

@end
