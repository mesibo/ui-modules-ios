/** Copyright (c) 2019 Mesibo
 * https://mesibo.com
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the terms and condition mentioned
 * on https://mesibo.com as well as following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions, the following disclaimer and links to documentation and
 * source code repository.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * Neither the name of Mesibo nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific prior
 * written permission.
 *
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * Documentation
 * https://mesibo.com/documentation/
 *
 * Source Code Repository
 * https://github.com/mesibo/ui-modules-ios
 *
 */
#import <MobileCoreServices/MobileCoreServices.h>
#import "PhotoSliderController.h"
#import "UIColors.h"
#import "ImagePicker.h"
#import "ImagePickerUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface PhotoSliderController ()

@property (strong, nonatomic) UIImageView *mViwerZoomVu;
@end

@implementation PhotoSliderController

{
    BOOL mShowStatusBar;
    BOOL mOnlyFirstTime;
    BOOL mHideStatusBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    if(nil != _mTitle){
        self.title = _mTitle;
    }
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[ImagePickerUtils imageNamed:@"ic_arrow_back_white.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(barButtonBackPressed:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 25, 25)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    
    [__mViwerScrollVu layoutIfNeeded];
     self.mViwerZoomVu = [[UIImageView alloc] initWithFrame:__mViwerScrollVu.frame];
    //[self.mViwerZoomVu layoutIfNeeded];
    
    /*
    if(_mSliderImageArray != nil) {
        self.mViwerZoomVu.image= [UIImage imageWithContentsOfFile:[_mSliderImageArray objectAtIndex:_mViwerZoomIndex]];
    } else {
        self.mViwerZoomVu.image= _mImageShow;
    }*/
       
    self.mViwerZoomVu.contentMode = UIViewContentModeScaleAspectFit;
    [__mViwerScrollVu addSubview:self.mViwerZoomVu];
    [self scrollViewDidZoom:__mViwerScrollVu];
    
    __mViwerScrollVu.delegate=self;
    __mViwerScrollVu.minimumZoomScale = 1.0;
    __mViwerScrollVu.maximumZoomScale = 5.0f;
    //__mViwerScrollVu.zoomScale = 1.0f;
    __mViwerScrollVu.contentSize = self.mViwerZoomVu.bounds.size;
    __mViwerScrollVu.delegate = self;
    __mViwerScrollVu.showsHorizontalScrollIndicator = NO;
    __mViwerScrollVu.showsVerticalScrollIndicator = NO;
    
    self.mViwerZoomVu.center = [__mViwerScrollVu convertPoint:__mViwerScrollVu.center fromView:__mViwerScrollVu.superview];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [__mViwerScrollVu addGestureRecognizer:doubleTap];
    
    if(_mSliderImageArray != nil) {
        // SwipeLeft
        UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
        swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
        [__mViwerScrollVu addGestureRecognizer:swipeleft];
        // SwipeRight
        UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
        swiperight.direction=UISwipeGestureRecognizerDirectionRight;
        [__mViwerScrollVu addGestureRecognizer:swiperight];
        // SwipeLeft
        UISwipeGestureRecognizer * swipeleftLayer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
        swipeleftLayer.direction=UISwipeGestureRecognizerDirectionLeft;
        [_mTopLayer addGestureRecognizer:swipeleftLayer];
        // SwipeRight
        UISwipeGestureRecognizer * swiperightLayer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
        swiperightLayer.direction=UISwipeGestureRecognizerDirectionRight;
        [_mTopLayer addGestureRecognizer:swiperightLayer];
                
        UITapGestureRecognizer *singleTapLayer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openVideoFile)];
        [_mTopLayer addGestureRecognizer:singleTapLayer];

    }
    
    __mViwerScrollVu.scrollEnabled = FALSE;
    [__mViwerScrollVu delaysContentTouches];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHideNavbar:)];
    [__mViwerScrollVu addGestureRecognizer:tapGesture];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    mShowStatusBar = NO;
    mOnlyFirstTime = YES;
    _mTopLayer.hidden = YES;


}



- (BOOL) isImageFile:(NSString*) filePath {
    
    BOOL isimage = NO;
    CFStringRef fileExtension = (__bridge CFStringRef) [filePath pathExtension];
    CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
    
    if (UTTypeConformsTo(fileUTI, kUTTypeImage)) {
            isimage = YES;
    }
    CFRelease(fileUTI);
    return isimage;
}

-(void) openVideoFile {
    
    NSString *filePath = [_mSliderImageArray objectAtIndex:_mViwerZoomIndex];
    NSURL *videoURL = [NSURL fileURLWithPath:filePath];
    //filePath may be from the Bundle or from the Saved file Directory, it is just the path for the video
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    //[playerViewController.player play];//Used to Play On start
    [self presentViewController:playerViewController animated:YES completion:nil];
    
    
    
}
-(void)viewDidLayoutSubviews {
    
    
    if(mOnlyFirstTime) {
    mOnlyFirstTime = NO;
        UIImage * toImage;
        if(_mSliderImageArray != nil) {
            toImage = [self getBitmapImage:(int)_mViwerZoomIndex];
        }else {
            toImage = _mImageShow;
        }
    [__mViwerScrollVu layoutIfNeeded];
    [self.mViwerZoomVu layoutIfNeeded];
    self.mViwerZoomVu.image = toImage;
    self.mViwerZoomVu.contentMode = UIViewContentModeScaleAspectFit;
    self.mViwerZoomVu.center = [__mViwerScrollVu convertPoint:__mViwerScrollVu.center fromView:__mViwerScrollVu.superview];
    }

}

-(IBAction)barButtonBackPressed:(id)sender {
    
    if(_mControllerPushed)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) showHideNavbar:(id) sender
{
    // write code to show/hide nav bar here
    // check if the Navigation Bar is shown
    mHideStatusBar = !mHideStatusBar;
    [UIView animateWithDuration:(0.2) animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
    [self.navigationController setNavigationBarHidden:mHideStatusBar animated:YES];

}

- (BOOL)prefersStatusBarHidden {
    return mHideStatusBar;
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if(__mViwerScrollVu.zoomScale == __mViwerScrollVu.minimumZoomScale) {
        [self slideToFrontView:nil];
    }
    mHideStatusBar = YES;
    [self showHideNavbar:nil];
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if(__mViwerScrollVu.zoomScale == __mViwerScrollVu.minimumZoomScale) {
        [self slideToBackView:nil];
    }
    mHideStatusBar = YES;
    [self showHideNavbar:nil];

    
    
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    
    if(__mViwerScrollVu.zoomScale>__mViwerScrollVu.minimumZoomScale)
        [__mViwerScrollVu setZoomScale:__mViwerScrollVu.minimumZoomScale animated:YES];
    else
        [__mViwerScrollVu setZoomScale:__mViwerScrollVu.maximumZoomScale animated:YES];
    
}




- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.mViwerZoomVu;
}

-(void) viewWillAppear:(BOOL)animated {
    
    self.mViwerZoomVu.center = [__mViwerScrollVu convertPoint:__mViwerScrollVu.center fromView:__mViwerScrollVu.superview];
    _mViewerBackBtn.layer.cornerRadius = _mViewerBackBtn.frame.size.height/2;
    _mViewerBackBtn.layer.borderWidth = 0.5;
    _mViewerBackBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _mViewerBackBtn.layer.masksToBounds = YES;
    _mViewerBackBtn.alpha=0.3;
    
    __mViwerFrontBtn.layer.cornerRadius = _mViewerBackBtn.frame.size.height/2;
    __mViwerFrontBtn.layer.borderWidth = 0.5;
    __mViwerFrontBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    __mViwerFrontBtn.layer.masksToBounds = YES;
    __mViwerFrontBtn.alpha=0.3;
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle =UIBarStyleBlackTranslucent;

}

- (void) viewDidAppear:(BOOL)animated {
    
    

}

-(void) viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBar.tintColor=nil;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [super viewWillDisappear:animated];
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollVu {
    if (__mViwerScrollVu.zoomScale!=__mViwerScrollVu.minimumZoomScale) {
        // Zooming, enable scrolling
        __mViwerScrollVu.scrollEnabled = TRUE;
    } else {
        // Not zoomed, disable scrolling use swiping
        __mViwerScrollVu.scrollEnabled = FALSE;
    }
 
    UIView* zoomView = [scrollVu.delegate viewForZoomingInScrollView:scrollVu];
    CGRect zoomVuframe = zoomView.frame;
    // Adjust frame when zooming is done
    if(zoomVuframe.size.width < scrollVu.bounds.size.width) {
        zoomVuframe.origin.x = (scrollVu.bounds.size.width - zoomVuframe.size.width) / 2.0;
    }else {
        zoomVuframe.origin.x = 0.0;
    }
    if(zoomVuframe.size.height < scrollVu.bounds.size.height) {
        zoomVuframe.origin.y = (scrollVu.bounds.size.height - zoomVuframe.size.height) / 2.0;
    } else {
        zoomVuframe.origin.y = 0.0;
    }
    zoomView.frame = zoomVuframe;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIImage*) getBitmapImage:(int) index {
    UIImage *image = nil;
    NSString*  checkFile = [_mSliderImageArray objectAtIndex:index];
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:checkFile];
    if(fileExist) {
        if([ImagePickerUtils isImageFile:checkFile]) {
            image =  [UIImage imageWithContentsOfFile:[_mSliderImageArray objectAtIndex:_mViwerZoomIndex]];
            [UIView animateWithDuration:0.6 delay:0.5
                                options: UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    
                                    _mTopLayer.hidden = YES;
                                    
                                } completion:nil];

        } else {
            NSURL *videoUrl = [NSURL fileURLWithPath:checkFile];
            image =[ImagePickerUtils thumbnailImageFromURL:videoUrl];
            [UIView animateWithDuration:0.6 delay:2.5
                                options: UIViewAnimationOptionTransitionCrossDissolve
                             animations:^{
                                 
                                    _mTopLayer.hidden = NO;

                                } completion:nil];
            
        }}
    
    return image;
    
}
- (IBAction)slideToBackView:(id)sender {
    if(_mViwerZoomIndex != 0) {
        
        if(_mViwerZoomIndex >=1)
            _mViwerZoomIndex -=1;
        UIImage * toImage =[self getBitmapImage:(int)_mViwerZoomIndex];
        [__mViwerScrollVu setZoomScale:__mViwerScrollVu.minimumZoomScale];
        [self swipingAnimation:toImage withAnimationSubType:kCATransitionFromLeft];
    }
}

- (IBAction)slideToFrontView:(id)sender {
    
    if(_mViwerZoomIndex < (_mSliderImageArray.count-1)) {
        
        if(_mViwerZoomIndex < (_mSliderImageArray.count-1))
            _mViwerZoomIndex +=1;
        UIImage *toImage = [self getBitmapImage:(int)_mViwerZoomIndex];
        [__mViwerScrollVu setZoomScale:__mViwerScrollVu.minimumZoomScale];
        [self swipingAnimation:toImage withAnimationSubType:kCATransitionFromRight];
    }
    
}

- (void) swipingAnimation:(UIImage *) toImage  withAnimationSubType:(NSString *) animationDirection {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.3];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setType:kCATransitionPush];
        [animation setSubtype:animationDirection];
        [[self.mViwerZoomVu layer] addAnimation:animation forKey:@"TransitionViews"];
    } completion:^(BOOL finished) {
        self.mViwerZoomVu.image = toImage;
        self.mViwerZoomVu.contentMode = UIViewContentModeScaleAspectFit;
        self.mViwerZoomVu.center = [__mViwerScrollVu convertPoint:__mViwerScrollVu.center fromView:__mViwerScrollVu.superview];
        
    }];

    
}

@end
