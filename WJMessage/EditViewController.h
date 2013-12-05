//
//  EditViewController.h
//  WJMessage
//
//  Created by can 杭伟 on 3/28/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enterprise.h"

@interface EditViewController : UIViewController<
  UITextFieldDelegate
>

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *updateButton;
@property (strong, nonatomic) IBOutlet UIImageView *numberImage;
@property (strong, nonatomic) IBOutlet UIImageView *nameImage;
@property (strong, nonatomic) IBOutlet UILabel *enterpriseNumber;
@property (strong, nonatomic) IBOutlet UITextField *enterpriseName;

@property (strong, nonatomic) NSString *name;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundClick:(id)sender;
- (IBAction)buttonPressed:(id)sender;

@end
