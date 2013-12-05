//
//  GoodImageViewController.h
//  WJMessage
//
//  Created by Can Hang on 5/8/13.
//
//

#import <UIKit/UIKit.h>
#import "MRZoomScrollView.h"
#import "EGOImageView.h"

@interface GoodImageViewController : UIViewController<
  UIScrollViewDelegate,
  UIGestureRecognizerDelegate
>

@property (strong, nonatomic) EGOImageView *egoImageView;
@property (strong, nonatomic) UIScrollView *pageScroll;//滚动图片
@property (strong, nonatomic) MRZoomScrollView *zoomScrollView;
@property (strong, nonatomic) UIImageView *imageView; 
@property (strong, nonatomic) NSMutableArray *goodImagesUrl;//商品图片
@property (nonatomic) NSInteger indexth;

@end
