//
//  EnterpriseViewController.h
//  WJMessage
//
//  Created by Can Hang on 4/22/13.
//
//

#import <UIKit/UIKit.h>

@interface EnterpriseViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *weijiaButton;
@property (strong, nonatomic) IBOutlet UIButton *mallButton;
@property (strong, nonatomic) IBOutlet UIButton *serviceButton;
@property (strong, nonatomic) IBOutlet UIImageView *numberImage;
@property (strong, nonatomic) IBOutlet UIImageView *nameImage;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UILabel *enterpriseNumber;
@property (strong, nonatomic) IBOutlet UILabel *enterpriseName;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *serviceUrl;
@property (strong, nonatomic) NSString *companyNumber;//被选中的公司的企业号

- (IBAction)weijiaButtonPressed:(id)sender;
- (IBAction)mallButtonPressed:(id)sender;
- (IBAction)serviceButtonPressed:(id)sender;

@end
