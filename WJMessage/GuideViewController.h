//
//  GuideViewController.h
//  WJMessage
//
//  Created by Can Hang on 4/23/13.
//
//

#import <UIKit/UIKit.h>

@interface GuideViewController : UIViewController
{
    BOOL _animating;
    UIScrollView *_pageScroll;
}

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, strong) UIScrollView *pageScroll;

+ (GuideViewController *)sharedGuide;
+ (void)show;
+ (void)hide;

@end
