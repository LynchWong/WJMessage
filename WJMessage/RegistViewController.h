//
//  RegistViewController.h
//  WJMessage
//
//  Created by Can Hang on 4/17/13.
//
//

#import <UIKit/UIKit.h>

@interface RegistViewController : UIViewController<
  UITextFieldDelegate
>

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIImageView *loginImage;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *passWord;
@property (strong, nonatomic) IBOutlet UITextField *secondPassWord;
@property (strong, nonatomic) IBOutlet UITextField *mail;
@property (strong, nonatomic) IBOutlet UIButton *registButton;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundClick:(id)sender;
- (IBAction)submitButtonPressed:(id)sender;

@end
