//
//  MRZoomScrollView.h
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"


@interface MRZoomScrollView : UIScrollView <UIScrollViewDelegate>
{
//    UIImageView *imageView;
    EGOImageView *imageView;//修改了原作者的代码，ego是另一个开源项目，用于异步加载图片的，包含图片缓存之类的功能。mrzoomscroll该开源项目是图片缩放的。在GoodImageViewController里面，用egoimageview异步加载图片后，然后添加为MRZoomScrollView的子视图，图片能显示但并不能缩放。或者将图片异步加载后用zoomScrollView.imageView.image = egoImageView.image这样赋值也不行，切图片根本就不会显示，更别提缩放。由于以上两种方法都不成功。所以想到在这里修改原作者的代码，将系统的UIImageView替换成EGOImageView，这样就能实现图片异步加载，而且图片也能缩放。只需在GoodImageViewController里面用zoomScrollView.imageView.imageURL = [NSURL URLWithString:[self.goodImagesUrl objectAtIndex:i]];即可。
}

//@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) EGOImageView *imageView;

@end
