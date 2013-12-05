//
//  MyAlertView.h
//  WJMessage
//
//  Created by Can Hang on 5/21/13.
//
//

#import <UIKit/UIKit.h>

@interface MyAlertView : UIAlertView
{
    UITextField *passwdField;
    NSInteger textFieldCount;
}


- (void)addTextField:(UITextField *)aTextField placeHolder:(NSString *)placeHolder;


@end
