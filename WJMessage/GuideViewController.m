//
//  GuideViewController.m
//  WJMessage
//
//  Created by Can Hang on 4/23/13.
//
//

#import "GuideViewController.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface GuideViewController ()

@end

@implementation GuideViewController

@synthesize animating = _animating;
@synthesize pageScroll = _pageScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(CGRect)onscreenFrame
{
    return [UIScreen mainScreen].applicationFrame;
}

- (CGRect)offscreenFrame
{
	CGRect frame = [self onscreenFrame];
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			frame.origin.y = frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			frame.origin.y = -frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			frame.origin.x = frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			frame.origin.x = -frame.size.width;
			break;
	}
	return frame;
}

- (void)showGuide
{
	if (!_animating && self.view.superview == nil)
	{
		[GuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[[self mainWindow] addSubview:[GuideViewController sharedGuide].view];
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideShown)];
		[GuideViewController sharedGuide].view.frame = [self onscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideShown
{
	_animating = NO;
}

- (void)hideGuide
{
	if (!_animating && self.view.superview != nil)
	{
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideHidden)];
		[GuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideHidden
{
	_animating = NO;
	[[[GuideViewController sharedGuide] view] removeFromSuperview];
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

+ (void)show
{
    [[GuideViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
	[[GuideViewController sharedGuide] showGuide];
}

+ (void)hide
{
	[[GuideViewController sharedGuide] hideGuide];
}

#pragma mark -

+ (GuideViewController *)sharedGuide {
    @synchronized(self) {
        static GuideViewController *sharedGuide = nil;
        if (sharedGuide == nil) {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}

- (void)pressCheckButton:(UIButton *)checkButton {
    [checkButton setSelected:!checkButton.selected];
}

- (void)pressEnterButton:(UIButton *)enterButton {
    [self hideGuide];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (iPhone5) {
        NSArray *imageNameArray = [NSArray arrayWithObjects:@"1-568h", @"2-568h", @"3-568h", nil];
        
        _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.pageScroll.pagingEnabled = YES;
        self.pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * imageNameArray.count, self.view.frame.size.height);
        [self.view addSubview:self.pageScroll];
        
        NSString *imgName = nil;
        UIView *view;
        for (int i = 0; i < imageNameArray.count; i++) {
            NSLog(@"iphone5");
            imgName = [imageNameArray objectAtIndex:i];
            view = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i), 0.f, 320, 568)];
            view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imgName]];
            [self.pageScroll addSubview:view];
            
            if (i == imageNameArray.count - 1) {
                UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 175.f, 35.f)];
                [enterButton setTitle:@"开始使用" forState:UIControlStateNormal];
                [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [enterButton setCenter:CGPointMake(self.view.center.x, 438.f)];
                [enterButton setBackgroundImage:[UIImage imageNamed:@"btn_nor"] forState:UIControlStateNormal];
                [enterButton setBackgroundImage:[UIImage imageNamed:@"btn_press"] forState:UIControlStateHighlighted];
                [enterButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:enterButton];
            }
        }
    } else {
        NSArray *imageNameArray = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
        
        
        _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.pageScroll.pagingEnabled = YES;
        self.pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * imageNameArray.count, self.view.frame.size.height);
        [self.view addSubview:self.pageScroll];
        
        NSString *imgName = nil;
        UIView *view;
        for (int i = 0; i < imageNameArray.count; i++) {
            imgName = [imageNameArray objectAtIndex:i];
            view = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i), 0.f, self.view.frame.size.width, self.view.frame.size.height)];
            view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imgName]];
            [self.pageScroll addSubview:view];
            
            if (i == imageNameArray.count - 1) {
                UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 175.f, 35.f)];
                [enterButton setTitle:@"开始使用" forState:UIControlStateNormal];
                [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [enterButton setCenter:CGPointMake(self.view.center.x, 400.f)];
                [enterButton setBackgroundImage:[UIImage imageNamed:@"btn_nor"] forState:UIControlStateNormal];
                [enterButton setBackgroundImage:[UIImage imageNamed:@"btn_press"] forState:UIControlStateHighlighted];
                [enterButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:enterButton];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
