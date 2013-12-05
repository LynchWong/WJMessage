//
//  GoodImageViewController.m
//  WJMessage
//
//  Created by Can Hang on 5/8/13.
//
//

#import "GoodImageViewController.h"
#import "EGOCache.h"
#import "EGOImageLoader.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface GoodImageViewController ()

@end

@implementation GoodImageViewController

@synthesize egoImageView;
@synthesize pageScroll;
@synthesize zoomScrollView;
@synthesize goodImagesUrl;
@synthesize imageView;
@synthesize indexth;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.pageScroll.backgroundColor = [UIColor blackColor];
    self.pageScroll.delegate = self;
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.userInteractionEnabled = YES;
    self.pageScroll.showsHorizontalScrollIndicator = NO;
    self.pageScroll.showsVerticalScrollIndicator = NO;
    self.pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * self.goodImagesUrl.count, 0);
    [self.view addSubview:self.pageScroll];
    
    for (int i = 0; i < self.goodImagesUrl.count; i++) {
        
        zoomScrollView = [[MRZoomScrollView alloc] init];
        CGRect frame = self.pageScroll.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        zoomScrollView.frame = frame;
        
        zoomScrollView.imageView.imageURL = [NSURL URLWithString:[self.goodImagesUrl objectAtIndex:i]];//这里修改了MRZoomScrollView这个项目原作者的代码，具体原因请看MRZoomScrollView.h文件。

        [self.pageScroll addSubview:zoomScrollView];
    }
    
    self.title = [NSString stringWithFormat:@"%d/%d",(self.indexth + 1),self.goodImagesUrl.count];
    self.pageScroll.contentOffset = CGPointMake(320 * self.indexth, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"LoginStatus"];
    if (![loginStatus isEqualToString:@"YES"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    //设置返回按钮
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(backButtonPressed)];
    barButton.tintColor = [UIColor colorWithRed:56/255.0 green:146/255.0 blue:227/255.0 alpha:1];
    self.navigationItem.leftBarButtonItem = barButton;
//    //在旋转的时候点击需要再判断
//    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.0f];
}

//监测是否在滚动，根据滚动的位置修改导航栏上的title，即是当前图片是所有图片的第几张
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (int i = 0; i < self.goodImagesUrl.count; i++) {
        if (self.pageScroll.contentOffset.x == 320 * i) {
            self.title = [NSString stringWithFormat:@"%d/%d",(i + 1),self.goodImagesUrl.count];
        }
    }
}

//旋转时调用的方法，将试图控件调整到合适的位置；
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration{
    
    UIInterfaceOrientation toOrientation = self.interfaceOrientation;
    [UIView beginAnimations:@"move views" context:nil];
    
    if (toOrientation == UIInterfaceOrientationPortrait || toOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        self.pageScroll.frame = CGRectMake(0, 0, 320, 460);
        
    } else {
        
        if (iPhone5) {
            self.pageScroll.frame = CGRectMake(0, 0, 640, 320);
        } else {
            self.pageScroll.frame = CGRectMake(0, 0, 480, 320);
        }
        
        
    }
    
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
